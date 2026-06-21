// SPDX-License-Identifier: MIT

#include "core/fpga/xdma_runtime.h"

#include <fcntl.h>
#include <sys/file.h>
#include <sys/types.h>
#include <unistd.h>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <mutex>
#include <sstream>
#include <thread>

#include "fpga/host/xdma_smoke/ax7z100_plddr_layout.h"

namespace lightning::fpga {
namespace {

constexpr uint32_t kShimMagic = 0x58444D41u;
constexpr uint32_t kShimVersion = 0x00010000u;
constexpr uint32_t kShimMagicOffset = 0x000u;
constexpr uint32_t kShimVersionOffset = 0x004u;
constexpr uint32_t kShimScratch0Offset = 0x008u;
constexpr uint32_t kShimScratch1Offset = 0x00Cu;

constexpr uint32_t kStatusDone = 1u << 2u;
constexpr uint32_t kStatusError = 1u << 3u;
std::mutex g_observation_transaction_mutex;
using Clock = std::chrono::steady_clock;

struct Region {
    const char* name;
    uint32_t base;
    uint32_t size;
};

constexpr std::array<Region, 7> kRegions = {{
    {"scan_points", LIGHTNING_SCAN_POINTS_BASE, 0x01000000u},
    {"pose", LIGHTNING_POSE_BASE, 0x00001000u},
    {"map_header", LIGHTNING_MAP_HEADER_BASE, 0x00001000u},
    {"params", LIGHTNING_PARAMS_BASE, 0x00001000u},
    {"active_blocks", LIGHTNING_ACTIVE_BLOCKS_BASE, 0x01000000u},
    {"obs_cells", LIGHTNING_OBS_CELLS_BASE, 0x20000000u},
    {"output", LIGHTNING_OUTPUT_BASE, 0x00100000u},
}};

void SetError(std::string* error, const std::string& message) {
    if (error != nullptr) {
        *error = message;
    }
}

double SecondsSince(const Clock::time_point& start) {
    return std::chrono::duration<double>(Clock::now() - start).count();
}

class Fd {
   public:
    Fd() = default;
    Fd(const std::string& path, int flags) { Open(path, flags); }
    ~Fd() { Close(); }

    Fd(const Fd&) = delete;
    Fd& operator=(const Fd&) = delete;

    bool Open(const std::string& path, int flags) {
        Close();
        fd_ = ::open(path.c_str(), flags | O_SYNC);
        return fd_ >= 0;
    }

    void Close() {
        if (fd_ >= 0) {
            ::close(fd_);
            fd_ = -1;
        }
    }

    int get() const { return fd_; }
    bool valid() const { return fd_ >= 0; }

   private:
    int fd_ = -1;
};

class FileLock {
   public:
    FileLock() = default;
    ~FileLock() { Unlock(); }

    FileLock(const FileLock&) = delete;
    FileLock& operator=(const FileLock&) = delete;

    bool Lock(const char* path, std::string* error) {
        fd_ = ::open(path, O_CREAT | O_RDWR | O_CLOEXEC, 0666);
        if (fd_ < 0) {
            SetError(error, std::string("failed to open XDMA lock file ") + path + ": " + std::strerror(errno));
            return false;
        }
        if (::flock(fd_, LOCK_EX) != 0) {
            SetError(error, std::string("failed to lock XDMA lock file ") + path + ": " + std::strerror(errno));
            Unlock();
            return false;
        }
        locked_ = true;
        return true;
    }

    void Unlock() {
        if (fd_ >= 0) {
            if (locked_) {
                ::flock(fd_, LOCK_UN);
                locked_ = false;
            }
            ::close(fd_);
            fd_ = -1;
        }
    }

   private:
    int fd_ = -1;
    bool locked_ = false;
};

bool ReadExact(int fd, void* data, size_t size, uint64_t offset, std::string* error, const std::string& label) {
    auto* out = static_cast<uint8_t*>(data);
    size_t done = 0;
    while (done < size) {
        const ssize_t n = ::pread(fd, out + done, size - done, static_cast<off_t>(offset + done));
        if (n <= 0) {
            std::ostringstream ss;
            ss << label << " short read at 0x" << std::hex << (offset + done) << ": " << std::dec << n;
            SetError(error, ss.str());
            return false;
        }
        done += static_cast<size_t>(n);
    }
    return true;
}

bool WriteExact(int fd, const void* data, size_t size, uint64_t offset, std::string* error, const std::string& label) {
    const auto* in = static_cast<const uint8_t*>(data);
    size_t done = 0;
    while (done < size) {
        const ssize_t n = ::pwrite(fd, in + done, size - done, static_cast<off_t>(offset + done));
        if (n <= 0) {
            std::ostringstream ss;
            ss << label << " short write at 0x" << std::hex << (offset + done) << ": " << std::dec << n;
            SetError(error, ss.str());
            return false;
        }
        done += static_cast<size_t>(n);
    }
    return true;
}

bool Read32(int fd, uint32_t offset, uint32_t& value, std::string* error) {
    return ReadExact(fd, &value, sizeof(value), offset, error, "reg32");
}

bool Write32(int fd, uint32_t offset, uint32_t value, std::string* error) {
    return WriteExact(fd, &value, sizeof(value), offset, error, "reg32");
}

bool OpenFd(Fd& fd, const std::string& path, int flags, std::string* error) {
    if (!fd.Open(path, flags)) {
        SetError(error, "failed to open " + path + ": " + std::strerror(errno));
        return false;
    }
    return true;
}

std::vector<uint8_t> Pattern(size_t size, uint8_t seed) {
    std::vector<uint8_t> data(size);
    for (size_t i = 0; i < size; ++i) {
        data[i] = static_cast<uint8_t>((i * 37u + seed) & 0xFFu);
    }
    return data;
}

template <typename T>
bool WriteObject(int fd, uint32_t base, const T& value, std::string* error, const std::string& label) {
    return WriteExact(fd, &value, sizeof(T), base, error, label);
}

template <typename T>
bool WriteVector(int fd, uint32_t base, const std::vector<T>& values, std::string* error, const std::string& label) {
    if (values.empty()) {
        return true;
    }
    return WriteExact(fd, values.data(), values.size() * sizeof(T), base, error, label);
}

bool VerifyBytes(int fd, uint32_t base, const void* expected, size_t size, std::string* error,
                 const std::string& label) {
    std::vector<uint8_t> actual(size);
    if (!ReadExact(fd, actual.data(), actual.size(), base, error, label + " readback")) {
        return false;
    }
    if (std::memcmp(actual.data(), expected, size) != 0) {
        SetError(error, label + " readback mismatch");
        return false;
    }
    return true;
}

bool ConfigureRegisters(int user_fd, uint32_t ctrl_base, uint32_t mode, uint32_t scan_count, std::string* error) {
    const std::array<std::pair<uint32_t, uint32_t>, 16> writes = {{
        {LIGHTNING_CTRL_KERNEL_SEL, LIGHTNING_KERNEL_UNIFIED_OBSERVATION},
        {LIGHTNING_CTRL_MODE, mode},
        {LIGHTNING_CTRL_SCAN_ADDR_LO, LIGHTNING_SCAN_POINTS_BASE},
        {LIGHTNING_CTRL_SCAN_ADDR_HI, 0},
        {LIGHTNING_CTRL_POSE_ADDR_LO, LIGHTNING_POSE_BASE},
        {LIGHTNING_CTRL_POSE_ADDR_HI, 0},
        {LIGHTNING_CTRL_MAP_HEADER_ADDR_LO, LIGHTNING_MAP_HEADER_BASE},
        {LIGHTNING_CTRL_MAP_HEADER_ADDR_HI, 0},
        {LIGHTNING_CTRL_PARAMS_ADDR_LO, LIGHTNING_PARAMS_BASE},
        {LIGHTNING_CTRL_PARAMS_ADDR_HI, 0},
        {LIGHTNING_CTRL_ACTIVE_BLOCKS_ADDR_LO, LIGHTNING_ACTIVE_BLOCKS_BASE},
        {LIGHTNING_CTRL_ACTIVE_BLOCKS_ADDR_HI, 0},
        {LIGHTNING_CTRL_OBS_CELLS_ADDR_LO, LIGHTNING_OBS_CELLS_BASE},
        {LIGHTNING_CTRL_OBS_CELLS_ADDR_HI, 0},
        {LIGHTNING_CTRL_OUT_ADDR_LO, LIGHTNING_OUTPUT_BASE},
        {LIGHTNING_CTRL_OUT_ADDR_HI, 0},
    }};

    if (!Write32(user_fd, ctrl_base + LIGHTNING_CTRL_CONTROL, 0x2u, error)) {
        return false;
    }
    for (const auto& [offset, value] : writes) {
        if (!Write32(user_fd, ctrl_base + offset, value, error)) {
            return false;
        }
    }
    return Write32(user_fd, ctrl_base + LIGHTNING_CTRL_SCAN_COUNT, scan_count, error);
}

}  // namespace

XdmaRuntime::XdmaRuntime(Options options) : options_(std::move(options)) {}

bool XdmaRuntime::ShimSmoke(std::string* error) const {
    Fd user;
    if (!OpenFd(user, options_.user_dev, O_RDWR, error)) {
        return false;
    }

    uint32_t magic = 0;
    uint32_t version = 0;
    if (!Read32(user.get(), kShimMagicOffset, magic, error) || !Read32(user.get(), kShimVersionOffset, version, error)) {
        return false;
    }
    if (magic != kShimMagic || version != kShimVersion) {
        std::ostringstream ss;
        ss << "bad shim identity magic=0x" << std::hex << magic << " version=0x" << version;
        SetError(error, ss.str());
        return false;
    }

    for (const auto& [offset, value] :
         {std::pair<uint32_t, uint32_t>{kShimScratch0Offset, 0x13579BDFu},
          std::pair<uint32_t, uint32_t>{kShimScratch1Offset, 0x2468ACE0u}}) {
        uint32_t got = 0;
        if (!Write32(user.get(), offset, value, error) || !Read32(user.get(), offset, got, error)) {
            return false;
        }
        if (got != value) {
            SetError(error, "shim scratch readback mismatch");
            return false;
        }
    }
    return true;
}

bool XdmaRuntime::RegSmoke(uint32_t scan_count, std::string* error) const {
    Fd user;
    if (!OpenFd(user, options_.user_dev, O_RDWR, error)) {
        return false;
    }

    uint32_t version = 0;
    if (!Read32(user.get(), options_.ctrl_base + LIGHTNING_CTRL_VERSION, version, error)) {
        return false;
    }
    if (version != LIGHTNING_CTRL_VERSION_VALUE) {
        std::ostringstream ss;
        ss << "bad ctrl version: got 0x" << std::hex << version << " expected 0x" << LIGHTNING_CTRL_VERSION_VALUE;
        SetError(error, ss.str());
        return false;
    }
    if (!ConfigureRegisters(user.get(), options_.ctrl_base, LIGHTNING_MODE_LOCALIZATION, scan_count, error)) {
        return false;
    }

    const std::array<std::pair<uint32_t, uint32_t>, 3> checks = {{
        {LIGHTNING_CTRL_KERNEL_SEL, LIGHTNING_KERNEL_UNIFIED_OBSERVATION},
        {LIGHTNING_CTRL_MODE, LIGHTNING_MODE_LOCALIZATION},
        {LIGHTNING_CTRL_SCAN_COUNT, scan_count},
    }};
    for (const auto& [offset, expected] : checks) {
        uint32_t got = 0;
        if (!Read32(user.get(), options_.ctrl_base + offset, got, error)) {
            return false;
        }
        if (got != expected) {
            SetError(error, "control register readback mismatch");
            return false;
        }
    }
    return true;
}

bool XdmaRuntime::DdrSmoke(size_t pattern_size, std::string* error) const {
    Fd h2c;
    Fd c2h;
    if (!OpenFd(h2c, options_.h2c_dev, O_WRONLY, error) || !OpenFd(c2h, options_.c2h_dev, O_RDONLY, error)) {
        return false;
    }

    for (size_t i = 0; i < kRegions.size(); ++i) {
        const Region& region = kRegions[i];
        if (pattern_size > region.size) {
            SetError(error, std::string(region.name) + " smoke pattern exceeds region");
            return false;
        }
        const auto payload = Pattern(pattern_size, static_cast<uint8_t>(17u + i));
        if (!WriteExact(h2c.get(), payload.data(), payload.size(), region.base, error, region.name) ||
            !VerifyBytes(c2h.get(), region.base, payload.data(), payload.size(), error, region.name)) {
            return false;
        }
    }
    return true;
}

namespace {

bool RunObservationImpl(const XdmaRuntime::Options& options, uint32_t mode,
                        const std::vector<SlamAccelScanPoint>& scan_points, const SlamAccelPose& pose,
                        const loc::ActiveMapBuffer& active_map, const SlamAccelObservationParams& params,
                        bool write_full_image, bool verify_readback, XdmaRuntime::RunResult& result,
                        std::string* error) {
    const auto total_start = Clock::now();
    const auto mutex_start = Clock::now();
    std::unique_lock<std::mutex> lock(g_observation_transaction_mutex);
    result.timing.mutex_wait_sec = SecondsSince(mutex_start);

    FileLock file_lock;
    auto stage_start = Clock::now();
    if (!file_lock.Lock("/tmp/lightning_xdma_observation.lock", error)) {
        result.timing.lock_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.lock_sec = SecondsSince(stage_start);

    Fd user;
    Fd h2c;
    Fd c2h;
    stage_start = Clock::now();
    if (!OpenFd(user, options.user_dev, O_RDWR, error) || !OpenFd(h2c, options.h2c_dev, O_WRONLY, error) ||
        !OpenFd(c2h, options.c2h_dev, O_RDONLY, error)) {
        result.timing.open_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.open_sec = SecondsSince(stage_start);

    const ActiveMapHeader map_header = MakeActiveMapHeader(active_map, mode);
    SlamNormalEquation output_zero;

    if (write_full_image) {
        stage_start = Clock::now();
        if (!WriteVector(h2c.get(), LIGHTNING_SCAN_POINTS_BASE, scan_points, error, "scan_points")) {
            result.timing.h2c_scan_sec = SecondsSince(stage_start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        result.timing.h2c_scan_sec = SecondsSince(stage_start);

        stage_start = Clock::now();
        if (!WriteObject(h2c.get(), LIGHTNING_POSE_BASE, pose, error, "pose") ||
            !WriteObject(h2c.get(), LIGHTNING_MAP_HEADER_BASE, map_header, error, "map_header") ||
            !WriteObject(h2c.get(), LIGHTNING_PARAMS_BASE, params, error, "params")) {
            result.timing.h2c_pose_header_params_sec = SecondsSince(stage_start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        result.timing.h2c_pose_header_params_sec = SecondsSince(stage_start);

        stage_start = Clock::now();
        if (!WriteVector(h2c.get(), LIGHTNING_ACTIVE_BLOCKS_BASE, active_map.blocks, error, "active_blocks") ||
            !WriteVector(h2c.get(), LIGHTNING_OBS_CELLS_BASE, active_map.cells, error, "obs_cells")) {
            result.timing.h2c_map_sec = SecondsSince(stage_start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        result.timing.h2c_map_sec = SecondsSince(stage_start);

        if (verify_readback) {
            stage_start = Clock::now();
            if (!VerifyBytes(c2h.get(), LIGHTNING_SCAN_POINTS_BASE, scan_points.data(),
                             scan_points.size() * sizeof(SlamAccelScanPoint), error, "scan_points") ||
                !VerifyBytes(c2h.get(), LIGHTNING_POSE_BASE, &pose, sizeof(pose), error, "pose") ||
                !VerifyBytes(c2h.get(), LIGHTNING_MAP_HEADER_BASE, &map_header, sizeof(map_header), error,
                             "map_header") ||
                !VerifyBytes(c2h.get(), LIGHTNING_PARAMS_BASE, &params, sizeof(params), error, "params") ||
                !VerifyBytes(c2h.get(), LIGHTNING_ACTIVE_BLOCKS_BASE, active_map.blocks.data(),
                             active_map.blocks.size() * sizeof(ActiveBlockRecord), error, "active_blocks") ||
                !VerifyBytes(c2h.get(), LIGHTNING_OBS_CELLS_BASE, active_map.cells.data(),
                             active_map.cells.size() * sizeof(ObsCellFloat64), error, "obs_cells")) {
                result.timing.verify_readback_sec = SecondsSince(stage_start);
                result.timing.total_sec = SecondsSince(total_start);
                return false;
            }
            result.timing.verify_readback_sec = SecondsSince(stage_start);
        }
    }

    stage_start = Clock::now();
    if (!WriteObject(h2c.get(), LIGHTNING_OUTPUT_BASE, output_zero, error, "output_zero")) {
        result.timing.output_zero_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.output_zero_sec = SecondsSince(stage_start);

    stage_start = Clock::now();
    if (!ConfigureRegisters(user.get(), options.ctrl_base, mode, static_cast<uint32_t>(scan_points.size()), error)) {
        result.timing.reg_config_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    if (!Read32(user.get(), options.ctrl_base + LIGHTNING_CTRL_SCAN_COUNT, result.scan_count_readback, error) ||
        !Read32(user.get(), options.ctrl_base + LIGHTNING_CTRL_RUN_COUNT, result.run_count_before, error)) {
        result.timing.reg_config_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.reg_config_sec = SecondsSince(stage_start);

    const auto start = Clock::now();
    if (!Write32(user.get(), options.ctrl_base + LIGHTNING_CTRL_CONTROL, 0x1u, error)) {
        result.timing.hls_wait_sec = SecondsSince(start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }

    const auto deadline = start + std::chrono::duration<double>(options.timeout_sec);
    while (Clock::now() < deadline) {
        if (!Read32(user.get(), options.ctrl_base + LIGHTNING_CTRL_STATUS, result.status, error) ||
            !Read32(user.get(), options.ctrl_base + LIGHTNING_CTRL_ERROR, result.error, error)) {
            result.timing.hls_wait_sec = SecondsSince(start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        if ((result.status & kStatusError) != 0 || result.error != 0) {
            SetError(error, "HLS entered error status");
            result.timing.hls_wait_sec = SecondsSince(start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        if ((result.status & kStatusDone) != 0) {
            break;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }

    if ((result.status & kStatusDone) == 0) {
        SetError(error, "HLS timeout");
        result.timing.hls_wait_sec = SecondsSince(start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    const auto end = Clock::now();
    result.elapsed_sec = std::chrono::duration<double>(end - start).count();
    result.timing.hls_wait_sec = result.elapsed_sec;

    if (!Read32(user.get(), options.ctrl_base + LIGHTNING_CTRL_RUN_COUNT, result.run_count_after, error)) {
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    if (result.run_count_after <= result.run_count_before) {
        SetError(error, "RUN_COUNT did not increment");
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }

    std::array<uint8_t, sizeof(SlamNormalEquation)> output_bytes = {};
    stage_start = Clock::now();
    if (!ReadExact(c2h.get(), output_bytes.data(), output_bytes.size(), LIGHTNING_OUTPUT_BASE, error, "output")) {
        result.timing.c2h_output_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.c2h_output_sec = SecondsSince(stage_start);
    std::memcpy(&result.output, output_bytes.data(), sizeof(result.output));
    std::memcpy(result.raw_output_words.data(), output_bytes.data(), sizeof(result.raw_output_words));
    result.timing.total_sec = SecondsSince(total_start);
    return true;
}

}  // namespace

bool XdmaRuntime::RunLocalizationObservation(const std::vector<SlamAccelScanPoint>& scan_points,
                                             const SlamAccelPose& pose, const loc::ActiveMapBuffer& active_map,
                                             bool write_full_image, bool verify_readback, RunResult& result,
                                             std::string* error) const {
    const SlamAccelObservationParams params = MakeLocalizationObservationParams();
    return RunObservationImpl(options_, LOCALIZATION_OBSERVATION, scan_points, pose, active_map, params,
                              write_full_image, verify_readback, result, error);
}

bool XdmaRuntime::RunMappingObservation(const std::vector<SlamAccelScanPoint>& scan_points,
                                        const SlamAccelPose& pose, const loc::ActiveMapBuffer& active_map,
                                        const SlamAccelObservationParams& params, bool write_full_image,
                                        bool verify_readback, RunResult& result, std::string* error) const {
    return RunObservationImpl(options_, MAPPING_OBSERVATION, scan_points, pose, active_map, params, write_full_image,
                              verify_readback, result, error);
}

std::vector<SlamAccelScanPoint> ToAbiScanPoints(const CloudPtr& cloud) {
    std::vector<SlamAccelScanPoint> out;
    if (cloud == nullptr) {
        return out;
    }
    out.reserve(cloud->size());
    for (const auto& point : cloud->points) {
        SlamAccelScanPoint abi_point;
        abi_point.x = point.x;
        abi_point.y = point.y;
        abi_point.z = point.z;
        abi_point.intensity = point.intensity;
        out.emplace_back(abi_point);
    }
    return out;
}

ActiveMapHeader MakeActiveMapHeader(const loc::ActiveMapBuffer& active_map, uint32_t mode) {
    ActiveMapHeader header;
    header.mode = mode;
    header.cells_per_block = active_map.cells_per_block;
    header.cell_resolution = active_map.cell_resolution;
    header.inv_cell_resolution = active_map.inv_cell_resolution;
    header.window_id = active_map.window_id;
    header.window_version = active_map.version;
    header.num_blocks = static_cast<uint32_t>(active_map.blocks.size());
    header.num_cells = static_cast<uint32_t>(active_map.cells.size());
    header.lookup_nearby_type = active_map.lookup_nearby_type;
    return header;
}

SlamAccelObservationParams MakeLocalizationObservationParams() {
    SlamAccelObservationParams params;
    params.mode = LOCALIZATION_OBSERVATION;
    params.plane_icp_weight = 1.0f;
    params.residual_outlier_th = 0.3f;
    params.mapping_gate_scale = 81.0f;
    return params;
}

SlamAccelObservationParams MakeMappingObservationParams(float plane_icp_weight,
                                                        const std::array<float, 9>& extrinsic_R,
                                                        const std::array<float, 3>& extrinsic_T) {
    SlamAccelObservationParams params;
    params.mode = MAPPING_OBSERVATION;
    params.plane_icp_weight = plane_icp_weight;
    params.residual_outlier_th = 0.3f;
    params.mapping_gate_scale = 81.0f;
    std::copy(extrinsic_R.begin(), extrinsic_R.end(), params.extrinsic_R);
    std::copy(extrinsic_T.begin(), extrinsic_T.end(), params.extrinsic_T);
    return params;
}

}  // namespace lightning::fpga
