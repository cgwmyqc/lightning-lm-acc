#include "fpga/fpga_types.h"

#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#include <cerrno>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <limits>
#include <sstream>
#include <stdexcept>
#include <string>
#include <thread>
#include <vector>

namespace {

using lightning::fpga::FpgaCorrInput;
using lightning::fpga::FpgaNormalEqOutput;
using lightning::fpga::FpgaStateInput;
using lightning::fpga::GoldenHeader;
using lightning::fpga::kFpgaInterfaceVersion;
using lightning::fpga::kFpgaMagic;
using lightning::fpga::kGoldenMagic;

static_assert(sizeof(FpgaStateInput) == 128, "FpgaStateInput must be 128 bytes");
static_assert(sizeof(FpgaNormalEqOutput) == 192, "FpgaNormalEqOutput must be 192 bytes");
static_assert(sizeof(GoldenHeader) == 256, "GoldenHeader must be 256 bytes");

constexpr uint32_t kRegControl = 0x00;
constexpr uint32_t kRegInput = 0x10;
constexpr uint32_t kRegOutput = 0x18;
constexpr uint32_t kRegNumPoints = 0x20;
constexpr uint32_t kApStart = 0x01;
constexpr uint32_t kApDone = 0x02;
constexpr uint32_t kApIdle = 0x04;

struct Options {
    std::vector<std::string> golden_paths = {
        "fpga/golden_small/frame_000100.bin",
        "fpga/golden_small/frame_000200.bin",
        "fpga/golden_small/frame_000300.bin",
    };
    std::string h2c = "/dev/xdma0_h2c_0";
    std::string c2h = "/dev/xdma0_c2h_0";
    std::string user = "/dev/xdma0_user";
    uint64_t ctrl_base = 0x1000;
    uint64_t input_addr = 0x02000000;
    uint64_t output_addr = 0x02100000;
    int timeout_ms = 1000;
    float abs_tol = 1.0e-3f;
    float rel_tol = 1.0e-5f;
};

struct GoldenFrame {
    std::string path;
    GoldenHeader header;
    std::vector<FpgaCorrInput> corr;
};

struct CompareStats {
    float max_abs_error = 0.0f;
    float max_rel_error = 0.0f;
    std::string max_name;
};

class Fd {
public:
    Fd(const std::string& path, int flags) : path_(path), fd_(::open(path.c_str(), flags)) {
        if (fd_ < 0) {
            throw std::runtime_error("open " + path + " failed: " + std::strerror(errno));
        }
    }

    ~Fd() {
        if (fd_ >= 0) {
            ::close(fd_);
        }
    }

    Fd(const Fd&) = delete;
    Fd& operator=(const Fd&) = delete;

    int get() const { return fd_; }
    const std::string& path() const { return path_; }

private:
    std::string path_;
    int fd_ = -1;
};

uint32_t float_to_word(float value) {
    uint32_t word = 0;
    static_assert(sizeof(word) == sizeof(value), "float must be 32-bit");
    std::memcpy(&word, &value, sizeof(word));
    return word;
}

uint64_t parse_u64(const std::string& text) {
    std::size_t pos = 0;
    const uint64_t value = std::stoull(text, &pos, 0);
    if (pos != text.size()) {
        throw std::runtime_error("invalid integer: " + text);
    }
    return value;
}

float parse_float(const std::string& text) {
    std::size_t pos = 0;
    const float value = std::stof(text, &pos);
    if (pos != text.size()) {
        throw std::runtime_error("invalid float: " + text);
    }
    return value;
}

std::string take_arg_value(int& i, int argc, char** argv, const std::string& arg) {
    const std::string prefix = arg + "=";
    const std::string current = argv[i];
    if (current.rfind(prefix, 0) == 0) {
        return current.substr(prefix.size());
    }
    if (i + 1 >= argc) {
        throw std::runtime_error("missing value for " + arg);
    }
    ++i;
    return argv[i];
}

void print_usage(const char* argv0) {
    std::cout
        << "Usage: " << argv0 << " [options]\n\n"
        << "Options:\n"
        << "  --golden PATH          Golden file. Can be repeated. Defaults to fpga/golden_small/*.bin\n"
        << "  --h2c PATH             XDMA H2C device. Default: /dev/xdma0_h2c_0\n"
        << "  --c2h PATH             XDMA C2H device. Default: /dev/xdma0_c2h_0\n"
        << "  --user PATH            XDMA user BAR device. Default: /dev/xdma0_user\n"
        << "  --ctrl ADDR            AXI-Lite control base. Default: 0x1000\n"
        << "  --input ADDR           HLS input DDR address. Default: 0x02000000\n"
        << "  --output ADDR          HLS output DDR address. Default: 0x02100000\n"
        << "  --timeout_ms N         Timeout in ms. Default: 1000\n"
        << "  --abs_tol VALUE        Max absolute error tolerance. Default: 1e-3\n"
        << "  --rel_tol VALUE        Max relative error tolerance. Default: 1e-5\n"
        << "  --help                 Show this help\n";
}

Options parse_options(int argc, char** argv) {
    Options opts;
    bool golden_overridden = false;

    for (int i = 1; i < argc; ++i) {
        const std::string arg = argv[i];
        if (arg == "--help" || arg == "-h") {
            print_usage(argv[0]);
            std::exit(0);
        } else if (arg == "--golden" || arg.rfind("--golden=", 0) == 0) {
            if (!golden_overridden) {
                opts.golden_paths.clear();
                golden_overridden = true;
            }
            opts.golden_paths.push_back(take_arg_value(i, argc, argv, "--golden"));
        } else if (arg == "--h2c" || arg.rfind("--h2c=", 0) == 0) {
            opts.h2c = take_arg_value(i, argc, argv, "--h2c");
        } else if (arg == "--c2h" || arg.rfind("--c2h=", 0) == 0) {
            opts.c2h = take_arg_value(i, argc, argv, "--c2h");
        } else if (arg == "--user" || arg.rfind("--user=", 0) == 0) {
            opts.user = take_arg_value(i, argc, argv, "--user");
        } else if (arg == "--ctrl" || arg.rfind("--ctrl=", 0) == 0) {
            opts.ctrl_base = parse_u64(take_arg_value(i, argc, argv, "--ctrl"));
        } else if (arg == "--input" || arg.rfind("--input=", 0) == 0) {
            opts.input_addr = parse_u64(take_arg_value(i, argc, argv, "--input"));
        } else if (arg == "--output" || arg.rfind("--output=", 0) == 0) {
            opts.output_addr = parse_u64(take_arg_value(i, argc, argv, "--output"));
        } else if (arg == "--timeout_ms" || arg.rfind("--timeout_ms=", 0) == 0) {
            opts.timeout_ms = static_cast<int>(parse_u64(take_arg_value(i, argc, argv, "--timeout_ms")));
        } else if (arg == "--abs_tol" || arg.rfind("--abs_tol=", 0) == 0) {
            opts.abs_tol = parse_float(take_arg_value(i, argc, argv, "--abs_tol"));
        } else if (arg == "--rel_tol" || arg.rfind("--rel_tol=", 0) == 0) {
            opts.rel_tol = parse_float(take_arg_value(i, argc, argv, "--rel_tol"));
        } else {
            throw std::runtime_error("unknown option: " + arg);
        }
    }

    if (opts.golden_paths.empty()) {
        throw std::runtime_error("no golden files specified");
    }
    if (opts.timeout_ms <= 0) {
        throw std::runtime_error("--timeout_ms must be positive");
    }
    if (!(opts.abs_tol >= 0.0f)) {
        throw std::runtime_error("--abs_tol must be non-negative");
    }
    if (!(opts.rel_tol >= 0.0f)) {
        throw std::runtime_error("--rel_tol must be non-negative");
    }
    return opts;
}

void read_exact_file(std::ifstream& in, void* data, std::size_t size, const std::string& path) {
    in.read(static_cast<char*>(data), static_cast<std::streamsize>(size));
    if (!in) {
        throw std::runtime_error("short read from " + path);
    }
}

GoldenFrame load_golden(const std::string& path) {
    GoldenFrame frame;
    frame.path = path;

    const auto file_size = std::filesystem::file_size(path);
    if (file_size < sizeof(GoldenHeader)) {
        throw std::runtime_error(path + " is smaller than GoldenHeader");
    }

    std::ifstream in(path, std::ios::binary);
    if (!in) {
        throw std::runtime_error("open " + path + " failed");
    }

    read_exact_file(in, &frame.header, sizeof(frame.header), path);
    if (frame.header.magic != kGoldenMagic) {
        std::ostringstream oss;
        oss << path << " has bad golden magic 0x" << std::hex << frame.header.magic;
        throw std::runtime_error(oss.str());
    }
    if (frame.header.version != kFpgaInterfaceVersion) {
        throw std::runtime_error(path + " has unsupported interface version");
    }

    const std::uintmax_t expected_size =
        sizeof(GoldenHeader) + static_cast<std::uintmax_t>(frame.header.num_points) * sizeof(FpgaCorrInput);
    if (file_size != expected_size) {
        std::ostringstream oss;
        oss << path << " size mismatch: actual=" << file_size << " expected=" << expected_size;
        throw std::runtime_error(oss.str());
    }

    frame.corr.resize(frame.header.num_points);
    if (!frame.corr.empty()) {
        read_exact_file(in, frame.corr.data(), frame.corr.size() * sizeof(FpgaCorrInput), path);
    }
    return frame;
}

std::vector<uint32_t> pack_input(const GoldenFrame& frame) {
    const std::size_t state_words = sizeof(FpgaStateInput) / sizeof(uint32_t);
    const std::size_t corr_words = sizeof(FpgaCorrInput) / sizeof(uint32_t);
    std::vector<uint32_t> words(state_words + frame.corr.size() * corr_words, 0);

    words[0] = kFpgaMagic;
    words[1] = kFpgaInterfaceVersion;
    words[2] = frame.header.num_points;
    words[3] = 0;
    for (int i = 0; i < 9; ++i) {
        words[4 + i] = float_to_word(frame.header.R[i]);
    }
    for (int i = 0; i < 3; ++i) {
        words[13 + i] = float_to_word(frame.header.t[i]);
    }

    std::size_t offset = state_words;
    for (const auto& corr : frame.corr) {
        words[offset + 0] = float_to_word(corr.px);
        words[offset + 1] = float_to_word(corr.py);
        words[offset + 2] = float_to_word(corr.pz);
        words[offset + 3] = float_to_word(corr.nx);
        words[offset + 4] = float_to_word(corr.ny);
        words[offset + 5] = float_to_word(corr.nz);
        words[offset + 6] = float_to_word(corr.d);
        words[offset + 7] = float_to_word(corr.weight);
        offset += corr_words;
    }

    return words;
}

void pwrite_all(int fd, const void* data, std::size_t size, uint64_t offset, const std::string& what) {
    const auto* bytes = static_cast<const uint8_t*>(data);
    std::size_t done = 0;
    while (done < size) {
        const ssize_t n =
            ::pwrite(fd, bytes + done, size - done, static_cast<off_t>(offset + done));
        if (n < 0) {
            if (errno == EINTR) {
                continue;
            }
            throw std::runtime_error("pwrite " + what + " failed: " + std::strerror(errno));
        }
        if (n == 0) {
            throw std::runtime_error("pwrite " + what + " returned 0");
        }
        done += static_cast<std::size_t>(n);
    }
}

void pread_all(int fd, void* data, std::size_t size, uint64_t offset, const std::string& what) {
    auto* bytes = static_cast<uint8_t*>(data);
    std::size_t done = 0;
    while (done < size) {
        const ssize_t n = ::pread(fd, bytes + done, size - done, static_cast<off_t>(offset + done));
        if (n < 0) {
            if (errno == EINTR) {
                continue;
            }
            throw std::runtime_error("pread " + what + " failed: " + std::strerror(errno));
        }
        if (n == 0) {
            throw std::runtime_error("pread " + what + " returned 0");
        }
        done += static_cast<std::size_t>(n);
    }
}

void write_reg(const Fd& user, uint64_t ctrl_base, uint32_t reg_offset, uint32_t value) {
    pwrite_all(user.get(), &value, sizeof(value), ctrl_base + reg_offset, user.path());
}

uint32_t read_reg(const Fd& user, uint64_t ctrl_base, uint32_t reg_offset) {
    uint32_t value = 0;
    pread_all(user.get(), &value, sizeof(value), ctrl_base + reg_offset, user.path());
    return value;
}

FpgaNormalEqOutput run_fpga_frame(const Options& opts,
                                 const GoldenFrame& frame,
                                 const Fd& h2c,
                                 const Fd& c2h,
                                 const Fd& user) {
    const std::vector<uint32_t> input_words = pack_input(frame);
    std::vector<uint8_t> output_zero(sizeof(FpgaNormalEqOutput), 0);
    FpgaNormalEqOutput output{};

    pwrite_all(h2c.get(),
               input_words.data(),
               input_words.size() * sizeof(uint32_t),
               opts.input_addr,
               "input DDR");
    pwrite_all(h2c.get(), output_zero.data(), output_zero.size(), opts.output_addr, "output DDR zero");

    write_reg(user, opts.ctrl_base, kRegInput, static_cast<uint32_t>(opts.input_addr));
    write_reg(user, opts.ctrl_base, kRegOutput, static_cast<uint32_t>(opts.output_addr));
    write_reg(user, opts.ctrl_base, kRegNumPoints, frame.header.num_points);
    write_reg(user, opts.ctrl_base, kRegControl, kApStart);

    const auto start = std::chrono::steady_clock::now();
    uint32_t control = 0;
    while (true) {
        control = read_reg(user, opts.ctrl_base, kRegControl);
        if ((control & kApDone) != 0U) {
            break;
        }
        const auto elapsed = std::chrono::duration_cast<std::chrono::milliseconds>(
            std::chrono::steady_clock::now() - start);
        if (elapsed.count() > opts.timeout_ms) {
            std::ostringstream oss;
            oss << "FPGA timeout after " << opts.timeout_ms << " ms, control=0x"
                << std::hex << control << " ap_idle=" << ((control & kApIdle) ? 1 : 0);
            throw std::runtime_error(oss.str());
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    pread_all(c2h.get(), &output, sizeof(output), opts.output_addr, "output DDR");
    return output;
}

void update_stats(CompareStats& stats, const std::string& name, float actual, float expected) {
    const float abs_error = std::fabs(actual - expected);
    const float denom = std::max(1.0f, std::fabs(expected));
    const float rel_error = abs_error / denom;
    if (abs_error > stats.max_abs_error) {
        stats.max_abs_error = abs_error;
        stats.max_rel_error = rel_error;
        stats.max_name = name;
    }
}

bool compare_output(const GoldenFrame& frame,
                    const FpgaNormalEqOutput& output,
                    float abs_tol,
                    float rel_tol,
                    CompareStats& stats,
                    std::string& reason) {
    if (output.magic != kFpgaMagic) {
        std::ostringstream oss;
        oss << "bad output magic 0x" << std::hex << output.magic;
        reason = oss.str();
        return false;
    }
    if (output.version != kFpgaInterfaceVersion) {
        reason = "bad output version " + std::to_string(output.version);
        return false;
    }
    if (output.valid_count != frame.header.num_points) {
        std::ostringstream oss;
        oss << "valid_count mismatch: actual=" << output.valid_count
            << " expected=" << frame.header.num_points;
        reason = oss.str();
        return false;
    }

    for (int i = 0; i < 21; ++i) {
        update_stats(stats, "H_upper[" + std::to_string(i) + "]", output.H_upper[i], frame.header.H_upper_cpu[i]);
    }
    for (int i = 0; i < 6; ++i) {
        update_stats(stats, "b[" + std::to_string(i) + "]", output.b[i], frame.header.b_cpu[i]);
    }
    update_stats(stats, "residual_sum", output.residual_sum, frame.header.residual_sum_cpu);
    update_stats(stats, "residual_abs_sum", output.residual_abs_sum, frame.header.residual_abs_sum_cpu);

    if (stats.max_abs_error > abs_tol && stats.max_rel_error > rel_tol) {
        std::ostringstream oss;
        oss << "max_abs_error " << stats.max_abs_error << " at " << stats.max_name
            << " exceeds abs_tol " << abs_tol << " and max_rel_error "
            << stats.max_rel_error << " exceeds rel_tol " << rel_tol;
        reason = oss.str();
        return false;
    }
    return true;
}

std::string hex_addr(uint64_t value) {
    std::ostringstream oss;
    oss << "0x" << std::hex << std::setw(8) << std::setfill('0') << value;
    return oss.str();
}

}  // namespace

int main(int argc, char** argv) {
    try {
        const Options opts = parse_options(argc, argv);

        std::cout << "normal_eq_replay\n"
                  << "  h2c: " << opts.h2c << "\n"
                  << "  c2h: " << opts.c2h << "\n"
                  << "  user: " << opts.user << "\n"
                  << "  ctrl: " << hex_addr(opts.ctrl_base) << "\n"
                  << "  input: " << hex_addr(opts.input_addr) << "\n"
                  << "  output: " << hex_addr(opts.output_addr) << "\n"
                  << "  timeout_ms: " << opts.timeout_ms << "\n"
                  << "  abs_tol: " << opts.abs_tol << "\n"
                  << "  rel_tol: " << opts.rel_tol << "\n\n";

        Fd h2c(opts.h2c, O_WRONLY);
        Fd c2h(opts.c2h, O_RDONLY);
        Fd user(opts.user, O_RDWR);

        bool all_passed = true;
        for (const auto& path : opts.golden_paths) {
            const GoldenFrame frame = load_golden(path);
            std::cout << "Replay " << path << " frame_id=" << frame.header.frame_id
                      << " num_points=" << frame.header.num_points << " ... " << std::flush;

            const FpgaNormalEqOutput output = run_fpga_frame(opts, frame, h2c, c2h, user);
            CompareStats stats;
            std::string reason;
            const bool passed = compare_output(frame, output, opts.abs_tol, opts.rel_tol, stats, reason);
            all_passed = all_passed && passed;

            if (passed) {
                std::cout << "PASS";
            } else {
                std::cout << "FAIL: " << reason;
            }
            std::cout << " (max_abs_error=" << stats.max_abs_error;
            if (!stats.max_name.empty()) {
                std::cout << " at " << stats.max_name << ", max_rel_error=" << stats.max_rel_error;
            }
            std::cout << ")\n";
        }

        return all_passed ? 0 : 1;
    } catch (const std::exception& e) {
        std::cerr << "ERROR: " << e.what() << "\n";
        return 2;
    }
}
