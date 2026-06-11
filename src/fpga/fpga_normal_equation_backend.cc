#include "fpga/fpga_normal_equation_backend.h"

#include <fcntl.h>
#include <unistd.h>

#include <chrono>
#include <cerrno>
#include <cstring>
#include <limits>
#include <sstream>
#include <thread>
#include <utility>
#include <vector>

#include <glog/logging.h>

namespace lightning::fpga {

namespace {

static_assert(sizeof(FpgaStateInput) == 128, "FpgaStateInput must be 128 bytes");
static_assert(sizeof(FpgaNormalEqOutput) == 192, "FpgaNormalEqOutput must be 192 bytes");

constexpr uint32_t kRegControl = 0x00;
constexpr uint32_t kRegInput = 0x10;
constexpr uint32_t kRegOutput = 0x18;
constexpr uint32_t kRegNumPoints = 0x20;
constexpr uint32_t kApStart = 0x01;
constexpr uint32_t kApDone = 0x02;
constexpr uint32_t kApIdle = 0x04;

uint32_t FloatToWord(float value) {
    uint32_t word = 0;
    static_assert(sizeof(word) == sizeof(value), "float must be 32-bit");
    std::memcpy(&word, &value, sizeof(word));
    return word;
}

bool PWriteAll(int fd, const void* data, size_t size, uint64_t offset, const std::string& what) {
    const auto* bytes = static_cast<const uint8_t*>(data);
    size_t done = 0;
    while (done < size) {
        const ssize_t n = ::pwrite(fd, bytes + done, size - done, static_cast<off_t>(offset + done));
        if (n < 0) {
            if (errno == EINTR) {
                continue;
            }
            LOG(WARNING) << "[fpga] pwrite " << what << " failed: " << std::strerror(errno)
                         << " errno=" << errno;
            return false;
        }
        if (n == 0) {
            LOG(WARNING) << "[fpga] pwrite " << what << " returned 0";
            return false;
        }
        done += static_cast<size_t>(n);
    }
    return true;
}

bool PReadAll(int fd, void* data, size_t size, uint64_t offset, const std::string& what) {
    auto* bytes = static_cast<uint8_t*>(data);
    size_t done = 0;
    while (done < size) {
        const ssize_t n = ::pread(fd, bytes + done, size - done, static_cast<off_t>(offset + done));
        if (n < 0) {
            if (errno == EINTR) {
                continue;
            }
            LOG(WARNING) << "[fpga] pread " << what << " failed: " << std::strerror(errno)
                         << " errno=" << errno;
            return false;
        }
        if (n == 0) {
            LOG(WARNING) << "[fpga] pread " << what << " returned 0";
            return false;
        }
        done += static_cast<size_t>(n);
    }
    return true;
}

std::vector<uint32_t> PackInput(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state) {
    constexpr size_t kStateWords = sizeof(FpgaStateInput) / sizeof(uint32_t);
    constexpr size_t kCorrWords = sizeof(FpgaCorrInput) / sizeof(uint32_t);
    std::vector<uint32_t> words(kStateWords + corr.size() * kCorrWords, 0);

    words[0] = kFpgaMagic;
    words[1] = kFpgaInterfaceVersion;
    words[2] = static_cast<uint32_t>(corr.size());
    words[3] = 0;

    int k = 0;
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            words[4 + k++] = FloatToWord(state.R_wi(r, c));
        }
    }
    for (int i = 0; i < 3; ++i) {
        words[13 + i] = FloatToWord(state.t_wi(i));
    }

    size_t offset = kStateWords;
    for (const auto& c : corr) {
        words[offset + 0] = FloatToWord(c.px);
        words[offset + 1] = FloatToWord(c.py);
        words[offset + 2] = FloatToWord(c.pz);
        words[offset + 3] = FloatToWord(c.nx);
        words[offset + 4] = FloatToWord(c.ny);
        words[offset + 5] = FloatToWord(c.nz);
        words[offset + 6] = FloatToWord(c.d);
        words[offset + 7] = FloatToWord(c.weight);
        offset += kCorrWords;
    }

    return words;
}

}  // namespace

struct FpgaNormalEquationBackend::Impl {
    explicit Impl(Options options_in) : options(std::move(options_in)) {
        h2c_fd = OpenDevice(options.xdma_h2c, O_WRONLY);
        c2h_fd = OpenDevice(options.xdma_c2h, O_RDONLY);
        user_fd = OpenDevice(options.xdma_user, O_RDWR);
        available = h2c_fd >= 0 && c2h_fd >= 0 && user_fd >= 0;
        if (available) {
            LOG(INFO) << "[fpga] XDMA backend ready: h2c=" << options.xdma_h2c
                      << " c2h=" << options.xdma_c2h << " user=" << options.xdma_user
                      << " ctrl=0x" << std::hex << options.normal_eq_ctrl_addr
                      << " input=0x" << options.input_addr << " output=0x" << options.output_addr
                      << std::dec << " timeout_ms=" << options.timeout_ms;
        } else {
            LOG(WARNING) << "[fpga] XDMA backend unavailable; SLAM should fallback to CPU.";
        }
    }

    ~Impl() {
        CloseDevice(h2c_fd);
        CloseDevice(c2h_fd);
        CloseDevice(user_fd);
    }

    static int OpenDevice(const std::string& path, int flags) {
        const int fd = ::open(path.c_str(), flags);
        if (fd < 0) {
            LOG(WARNING) << "[fpga] open " << path << " failed: " << std::strerror(errno)
                         << " errno=" << errno;
        }
        return fd;
    }

    static void CloseDevice(int fd) {
        if (fd >= 0) {
            ::close(fd);
        }
    }

    bool WriteReg(uint32_t reg_offset, uint32_t value) const {
        return PWriteAll(user_fd, &value, sizeof(value), options.normal_eq_ctrl_addr + reg_offset, "axi-lite register");
    }

    bool ReadReg(uint32_t reg_offset, uint32_t* value) const {
        return PReadAll(user_fd, value, sizeof(*value), options.normal_eq_ctrl_addr + reg_offset, "axi-lite register");
    }

    bool Run(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state, FpgaNormalEqOutput* output) const {
        if (!available) {
            return false;
        }
        if (corr.size() > static_cast<size_t>(std::numeric_limits<uint32_t>::max())) {
            LOG(WARNING) << "[fpga] too many corr points: " << corr.size();
            return false;
        }

        const std::vector<uint32_t> input_words = PackInput(corr, state);
        const std::vector<uint8_t> output_zero(sizeof(FpgaNormalEqOutput), 0);
        if (!PWriteAll(h2c_fd, input_words.data(), input_words.size() * sizeof(uint32_t),
                       options.input_addr, "input DDR")) {
            return false;
        }
        if (!PWriteAll(h2c_fd, output_zero.data(), output_zero.size(), options.output_addr, "output DDR zero")) {
            return false;
        }

        if (!WriteReg(kRegInput, static_cast<uint32_t>(options.input_addr)) ||
            !WriteReg(kRegOutput, static_cast<uint32_t>(options.output_addr)) ||
            !WriteReg(kRegNumPoints, static_cast<uint32_t>(corr.size())) ||
            !WriteReg(kRegControl, kApStart)) {
            return false;
        }

        const auto start = std::chrono::steady_clock::now();
        uint32_t control = 0;
        while (true) {
            if (!ReadReg(kRegControl, &control)) {
                return false;
            }
            if ((control & kApDone) != 0U) {
                break;
            }
            const auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
                std::chrono::steady_clock::now() - start);
            if (elapsed.count() > options.timeout_ms) {
                LOG(WARNING) << "[fpga] timeout after " << options.timeout_ms
                             << " ms, control=0x" << std::hex << control << std::dec
                             << " ap_idle=" << (((control & kApIdle) != 0U) ? 1 : 0);
                return false;
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(1));
        }

        return PReadAll(c2h_fd, output, sizeof(*output), options.output_addr, "output DDR");
    }

    Options options;
    int h2c_fd = -1;
    int c2h_fd = -1;
    int user_fd = -1;
    bool available = false;
};

FpgaNormalEquationBackend::FpgaNormalEquationBackend() : FpgaNormalEquationBackend(Options()) {}

FpgaNormalEquationBackend::FpgaNormalEquationBackend(Options options)
    : impl_(std::make_unique<Impl>(std::move(options))) {}

FpgaNormalEquationBackend::~FpgaNormalEquationBackend() = default;

bool FpgaNormalEquationBackend::Accumulate(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state,
                                           NormalEquationResult* result) {
    if (result == nullptr) {
        return false;
    }

    result->H.setZero();
    result->b.setZero();
    result->residual_sum = 0.0f;
    result->residual_abs_sum = 0.0f;
    result->valid_count = 0;

    if (corr.empty()) {
        return true;
    }

    FpgaNormalEqOutput output;
    if (!impl_->Run(corr, state, &output)) {
        return false;
    }
    if (output.magic != kFpgaMagic) {
        LOG(WARNING) << "[fpga] bad output magic: 0x" << std::hex << output.magic << std::dec;
        return false;
    }
    if (output.version != kFpgaInterfaceVersion) {
        LOG(WARNING) << "[fpga] bad output version: " << output.version;
        return false;
    }
    if (output.valid_count != corr.size()) {
        LOG(WARNING) << "[fpga] valid_count mismatch: actual=" << output.valid_count
                     << " expected=" << corr.size();
        return false;
    }

    Upper21ToMatrix(output.H_upper, &result->H);
    for (int i = 0; i < 6; ++i) {
        result->b(i) = output.b[i];
    }
    result->residual_sum = output.residual_sum;
    result->residual_abs_sum = output.residual_abs_sum;
    result->valid_count = static_cast<int>(output.valid_count);
    return true;
}

}  // namespace lightning::fpga
