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
#include <cmath>
#include <mutex>
#include <sstream>
#include <thread>

#include "fpga/host/xdma_smoke/ax7z100_plddr_layout.h"
#include "core/localization/surfel_loc/surfel_loc_backend.h"

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
constexpr uint32_t kEkfInMagic = 0x45554650u;   // EUFP
constexpr uint32_t kEkfOutMagic = 0x4555464Fu;  // EUFO
constexpr uint32_t kEkfVersion = 1u;
constexpr int kEkfStateDim = 12;
constexpr int kEkfObsDim = 6;
constexpr int kEkfMat12Words = kEkfStateDim * kEkfStateDim;
constexpr int kEkfMat6Words = kEkfObsDim * kEkfObsDim;

enum EkfInputWordOffset {
    kEkfInMagicVersion = 0,
    kEkfInFlags = 1,
    kEkfInFrameIter = 2,
    kEkfInCurrentState = 3,
    kEkfInPropagatedCov = kEkfInCurrentState + 17,
    kEkfInHth = kEkfInPropagatedCov + kEkfMat12Words,
    kEkfInHtr = kEkfInHth + kEkfMat6Words,
    kEkfInDxFromStart = kEkfInHtr + kEkfObsDim,
    kEkfInParams = kEkfInDxFromStart + kEkfStateDim,
    kEkfInLimit = kEkfInParams + 6,
    kEkfInWords = kEkfInLimit + kEkfStateDim
};

enum EkfOutputWordOffset {
    kEkfOutMagicVersion = 0,
    kEkfOutStatus = 1,
    kEkfOutNullity = 2,
    kEkfOutDxCurrent = 3,
    kEkfOutKR = kEkfOutDxCurrent + kEkfStateDim,
    kEkfOutKH = kEkfOutKR + kEkfStateDim,
    kEkfOutHthEff = kEkfOutKH + kEkfMat12Words,
    kEkfOutHtrEff = kEkfOutHthEff + kEkfMat6Words,
    kEkfOutUpdatedState = kEkfOutHtrEff + kEkfObsDim,
    kEkfOutWorkingCov = kEkfOutUpdatedState + 17,
    kEkfOutUpdatedCov = kEkfOutWorkingCov + kEkfMat12Words,
    kEkfOutDiagnostics = kEkfOutUpdatedCov + kEkfMat12Words,
    kEkfOutWords = kEkfOutDiagnostics + 4
};

enum EkfStatusBits {
    kEkfStatusSuccess = 1u << 0u,
    kEkfStatusRejected = 1u << 1u,
    kEkfStatusConverged = 1u << 2u,
    kEkfStatusCovarianceFinalized = 1u << 3u,
    kEkfStatusEigenFailed = 1u << 8u,
    kEkfStatusInverseFailed = 1u << 9u,
    kEkfStatusNanDx = 1u << 10u,
    kEkfStatusStepRejected = 1u << 11u
};
std::mutex g_observation_transaction_mutex;
using Clock = std::chrono::steady_clock;

struct Region {
    const char* name;
    uint32_t base;
    uint32_t size;
};

constexpr std::array<Region, 9> kRegions = {{
    {"scan_points", LIGHTNING_SCAN_POINTS_BASE, 0x01000000u},
    {"pose", LIGHTNING_POSE_BASE, 0x00001000u},
    {"map_header", LIGHTNING_MAP_HEADER_BASE, 0x00001000u},
    {"params", LIGHTNING_PARAMS_BASE, 0x00001000u},
    {"active_blocks", LIGHTNING_ACTIVE_BLOCKS_BASE, 0x01000000u},
    {"obs_cells", LIGHTNING_OBS_CELLS_BASE, 0x20000000u},
    {"output", LIGHTNING_OUTPUT_BASE, 0x00010000u},
    {"ekf_update_input", LIGHTNING_EKF_UPDATE_INPUT_BASE, 0x00010000u},
    {"ekf_update_output", LIGHTNING_EKF_UPDATE_OUTPUT_BASE, 0x00010000u},
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

Vec3d ToVec3d(const SlamAccelScanPoint& point) {
    return Vec3d(static_cast<double>(point.x), static_cast<double>(point.y), static_cast<double>(point.z));
}

SE3 FromAbiPose(const SlamAccelPose& pose) {
    Eigen::Quaterniond q(static_cast<double>(pose.qw), static_cast<double>(pose.qx), static_cast<double>(pose.qy),
                         static_cast<double>(pose.qz));
    q.normalize();
    return SE3(q, Vec3d(static_cast<double>(pose.tx), static_cast<double>(pose.ty), static_cast<double>(pose.tz)));
}

double PlaneResidual(const loc::ObsCellFloat64& cell, const Vec3d& point_world) {
    return static_cast<double>(cell.normal_x) * point_world.x() +
           static_cast<double>(cell.normal_y) * point_world.y() +
           static_cast<double>(cell.normal_z) * point_world.z() + static_cast<double>(cell.plane_d);
}

bool BetterMappingCell(const loc::ObsCellFloat64& lhs, const loc::ObsCellFloat64& rhs, const Vec3d& point_world) {
    const double lhs_res = std::fabs(PlaneResidual(lhs, point_world));
    const double rhs_res = std::fabs(PlaneResidual(rhs, point_world));
    if (std::fabs(lhs_res - rhs_res) > 1.0e-4) {
        return lhs_res < rhs_res;
    }

    const Vec3d lhs_centroid(lhs.centroid_x, lhs.centroid_y, lhs.centroid_z);
    const Vec3d rhs_centroid(rhs.centroid_x, rhs.centroid_y, rhs.centroid_z);
    const double lhs_dist = (lhs_centroid - point_world).squaredNorm();
    const double rhs_dist = (rhs_centroid - point_world).squaredNorm();
    if (std::fabs(lhs_dist - rhs_dist) > 1.0e-4) {
        return lhs_dist < rhs_dist;
    }
    return lhs.quality < rhs.quality;
}

int DivFloor(int value, int divisor) {
    int q = value / divisor;
    int r = value % divisor;
    if (r != 0 && ((r < 0) != (divisor < 0))) {
        --q;
    }
    return q;
}

int ModFloor(int value, int divisor) {
    int r = value % divisor;
    return r < 0 ? r + divisor : r;
}

bool LookupMappingCandidate(const loc::SurfelLocBackend& lookup_backend, const loc::ActiveMapBuffer& active_map,
                            const Vec3d& point_world, const loc::ObsCellFloat64*& out_cell) {
    const auto center = lookup_backend.Encode(point_world, active_map);
    out_cell = lookup_backend.LookupCell(active_map, center);
    if (out_cell != nullptr) {
        return true;
    }
    if (active_map.lookup_nearby_type == 0) {
        return false;
    }

    const int block_dim_x = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X);
    const int block_dim_y = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y);
    const int block_dim_z = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z);
    const int base_lz = center.cell_idx / (block_dim_x * block_dim_y);
    const int rem = center.cell_idx - base_lz * block_dim_x * block_dim_y;
    const int base_ly = rem / block_dim_x;
    const int base_lx = rem - base_ly * block_dim_x;
    const int gx = center.block_x * block_dim_x + base_lx;
    const int gy = center.block_y * block_dim_y + base_ly;
    const int gz = center.block_z * block_dim_z + base_lz;

    bool found = false;
    const loc::ObsCellFloat64* best = nullptr;
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dz = -1; dz <= 1; ++dz) {
                if (dx == 0 && dy == 0 && dz == 0) {
                    continue;
                }
                const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                if (active_map.lookup_nearby_type == 6 && manhattan > 1) {
                    continue;
                }
                if (active_map.lookup_nearby_type == 18 && manhattan > 2) {
                    continue;
                }

                const int ngx = gx + dx;
                const int ngy = gy + dy;
                const int ngz = gz + dz;
                loc::SurfelLocBackend::EncodedCell neighbor;
                neighbor.block_x = DivFloor(ngx, block_dim_x);
                neighbor.block_y = DivFloor(ngy, block_dim_y);
                neighbor.block_z = DivFloor(ngz, block_dim_z);
                const int nlx = ModFloor(ngx, block_dim_x);
                const int nly = ModFloor(ngy, block_dim_y);
                const int nlz = ModFloor(ngz, block_dim_z);
                neighbor.cell_idx = (nlz * block_dim_y + nly) * block_dim_x + nlx;

                const loc::ObsCellFloat64* candidate = lookup_backend.LookupCell(active_map, neighbor);
                if (candidate != nullptr && (!found || BetterMappingCell(*candidate, *best, point_world))) {
                    best = candidate;
                    found = true;
                }
            }
        }
    }
    out_cell = best;
    return found;
}

std::vector<ObsCellFloat64> BuildCandidateCells(const std::vector<SlamAccelScanPoint>& scan_points,
                                                const SlamAccelPose& pose,
                                                const loc::ActiveMapBuffer& active_map, uint32_t mode,
                                                uint32_t& valid_count, uint32_t& miss_count) {
    std::vector<ObsCellFloat64> candidates(scan_points.size());
    valid_count = 0;
    miss_count = 0;
    const SE3 pose_se3 = FromAbiPose(pose);
    const loc::SurfelLocBackend lookup_backend;
    for (size_t i = 0; i < scan_points.size(); ++i) {
        const Vec3d point_world = pose_se3 * ToVec3d(scan_points[i]);
        const loc::ObsCellFloat64* cell = nullptr;
        const bool hit = mode == MAPPING_OBSERVATION ? LookupMappingCandidate(lookup_backend, active_map, point_world, cell)
                                                     : lookup_backend.TryLookupNearest(active_map, point_world, cell);
        if (hit && cell != nullptr) {
            candidates[i] = *cell;
            ++valid_count;
        } else {
            candidates[i] = ObsCellFloat64();
            ++miss_count;
        }
    }
    return candidates;
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

uint64_t PackU32Pair(uint32_t lo, uint32_t hi) {
    return (static_cast<uint64_t>(hi) << 32) | static_cast<uint64_t>(lo);
}

uint64_t DoubleToU64(double value) {
    uint64_t bits = 0;
    static_assert(sizeof(bits) == sizeof(value), "double must be 64-bit");
    std::memcpy(&bits, &value, sizeof(bits));
    return bits;
}

double U64ToDouble(uint64_t bits) {
    double value = 0.0;
    static_assert(sizeof(bits) == sizeof(value), "double must be 64-bit");
    std::memcpy(&value, &bits, sizeof(value));
    return value;
}

void PackEkfNavState(const NavState& state, std::vector<uint64_t>& words, int base) {
    const Quatd q = state.rot_.unit_quaternion();
    words[base + 0] = DoubleToU64(state.timestamp_);
    for (int i = 0; i < 3; ++i) {
        words[base + 1 + i] = DoubleToU64(state.pos_[i]);
    }
    const auto coeffs = q.coeffs();
    for (int i = 0; i < 4; ++i) {
        words[base + 4 + i] = DoubleToU64(coeffs[i]);
    }
    for (int i = 0; i < 3; ++i) {
        words[base + 8 + i] = DoubleToU64(state.vel_[i]);
        words[base + 11 + i] = DoubleToU64(state.bg_[i]);
        words[base + 14 + i] = DoubleToU64(state.grav_[i]);
    }
}

NavState UnpackEkfNavState(const std::vector<uint64_t>& words, int base) {
    NavState state;
    state.timestamp_ = U64ToDouble(words[base + 0]);
    for (int i = 0; i < 3; ++i) {
        state.pos_[i] = U64ToDouble(words[base + 1 + i]);
    }
    Eigen::Matrix<double, 4, 1> coeffs;
    for (int i = 0; i < 4; ++i) {
        coeffs[i] = U64ToDouble(words[base + 4 + i]);
    }
    state.rot_ = SO3(Quatd(coeffs[3], coeffs[0], coeffs[1], coeffs[2]).normalized());
    for (int i = 0; i < 3; ++i) {
        state.vel_[i] = U64ToDouble(words[base + 8 + i]);
        state.bg_[i] = U64ToDouble(words[base + 11 + i]);
        state.grav_[i] = U64ToDouble(words[base + 14 + i]);
    }
    return state;
}

std::vector<uint64_t> PackEkfUpdateInputWords(const mapping_update::UpdateInput& input) {
    std::vector<uint64_t> words(kEkfInWords, 0);
    words[kEkfInMagicVersion] = PackU32Pair(kEkfInMagic, kEkfVersion);
    words[kEkfInFlags] = input.finish_update ? 1u : 0u;
    words[kEkfInFrameIter] = PackU32Pair(static_cast<uint32_t>(input.frame_index),
                                         static_cast<uint32_t>(input.iteration_index));
    PackEkfNavState(input.current_state, words, kEkfInCurrentState);
    for (int i = 0; i < kEkfMat12Words; ++i) {
        words[kEkfInPropagatedCov + i] = DoubleToU64(input.propagated_cov.data()[i]);
    }
    for (int i = 0; i < kEkfMat6Words; ++i) {
        words[kEkfInHth + i] = DoubleToU64(input.HTH.data()[i]);
    }
    for (int i = 0; i < kEkfObsDim; ++i) {
        words[kEkfInHtr + i] = DoubleToU64(input.HTr[i]);
    }
    for (int i = 0; i < kEkfStateDim; ++i) {
        words[kEkfInDxFromStart + i] = DoubleToU64(input.dx_from_start[i]);
        words[kEkfInLimit + i] = DoubleToU64(input.params.limit[i]);
    }
    words[kEkfInParams + 0] = DoubleToU64(input.params.R);
    words[kEkfInParams + 1] = DoubleToU64(input.params.degeneracy_threshold_ratio);
    words[kEkfInParams + 2] = DoubleToU64(input.params.degeneracy_cov_inflation);
    words[kEkfInParams + 3] = DoubleToU64(input.params.min_cov_diag);
    words[kEkfInParams + 4] = DoubleToU64(input.params.max_update_translation_step);
    words[kEkfInParams + 5] = DoubleToU64(input.params.max_update_rotation_step_deg);
    return words;
}

std::string EkfStatusString(uint32_t status) {
    if ((status & kEkfStatusSuccess) != 0u) {
        return "ok";
    }
    if ((status & kEkfStatusRejected) != 0u) {
        return "rejected";
    }
    if ((status & kEkfStatusEigenFailed) != 0u) {
        return "eigen_failed";
    }
    if ((status & kEkfStatusInverseFailed) != 0u) {
        return "inverse_failed";
    }
    if ((status & kEkfStatusNanDx) != 0u) {
        return "nan_dx";
    }
    if ((status & kEkfStatusStepRejected) != 0u) {
        return "step_rejected";
    }
    return "failed";
}

mapping_update::UpdateOutput UnpackEkfUpdateOutputWords(const std::vector<uint64_t>& words) {
    mapping_update::UpdateOutput output;
    const uint32_t status = static_cast<uint32_t>(words[kEkfOutStatus] & 0xFFFFFFFFu);
    output.success = (status & kEkfStatusSuccess) != 0u;
    output.rejected = (status & kEkfStatusRejected) != 0u;
    output.converged = (status & kEkfStatusConverged) != 0u;
    output.covariance_finalized = (status & kEkfStatusCovarianceFinalized) != 0u;
    output.nullity = static_cast<int>(words[kEkfOutNullity]);
    output.status = EkfStatusString(status);
    for (int i = 0; i < kEkfStateDim; ++i) {
        output.dx_current[i] = U64ToDouble(words[kEkfOutDxCurrent + i]);
        output.K_r[i] = U64ToDouble(words[kEkfOutKR + i]);
    }
    for (int i = 0; i < kEkfMat12Words; ++i) {
        output.K_H.data()[i] = U64ToDouble(words[kEkfOutKH + i]);
        output.working_cov.data()[i] = U64ToDouble(words[kEkfOutWorkingCov + i]);
        output.updated_cov.data()[i] = U64ToDouble(words[kEkfOutUpdatedCov + i]);
    }
    for (int i = 0; i < kEkfMat6Words; ++i) {
        output.HTH_eff.data()[i] = U64ToDouble(words[kEkfOutHthEff + i]);
    }
    for (int i = 0; i < kEkfObsDim; ++i) {
        output.HTr_eff[i] = U64ToDouble(words[kEkfOutHtrEff + i]);
    }
    output.updated_state = UnpackEkfNavState(words, kEkfOutUpdatedState);
    output.dx_translation = U64ToDouble(words[kEkfOutDiagnostics + 0]);
    output.dx_rotation_deg = U64ToDouble(words[kEkfOutDiagnostics + 1]);
    output.dx_norm = U64ToDouble(words[kEkfOutDiagnostics + 2]);
    return output;
}

bool ConfigureEkfRegisters(int user_fd, uint32_t ctrl_base, std::string* error) {
    if (!Write32(user_fd, ctrl_base + LIGHTNING_CTRL_CONTROL, 0x2u, error)) {
        return false;
    }
    const std::array<std::pair<uint32_t, uint32_t>, 14> writes = {{
        {LIGHTNING_CTRL_KERNEL_SEL, LIGHTNING_KERNEL_EKF_UPDATE},
        {LIGHTNING_CTRL_SCAN_ADDR_HI, 0},
        {LIGHTNING_CTRL_POSE_ADDR_HI, 0},
        {LIGHTNING_CTRL_MAP_HEADER_ADDR_HI, 0},
        {LIGHTNING_CTRL_ACTIVE_BLOCKS_ADDR_HI, 0},
        {LIGHTNING_CTRL_OBS_CELLS_ADDR_HI, 0},
        {LIGHTNING_CTRL_OUT_ADDR_HI, 0},
        {LIGHTNING_CTRL_PARAMS_ADDR_HI, 0},
        {LIGHTNING_CTRL_EKF_INPUT_ADDR_LO, LIGHTNING_EKF_UPDATE_INPUT_BASE},
        {LIGHTNING_CTRL_EKF_INPUT_ADDR_HI, 0},
        {LIGHTNING_CTRL_EKF_OUTPUT_ADDR_LO, LIGHTNING_EKF_UPDATE_OUTPUT_BASE},
        {LIGHTNING_CTRL_EKF_OUTPUT_ADDR_HI, 0},
        {LIGHTNING_CTRL_SCAN_COUNT, 0},
        {LIGHTNING_CTRL_MODE, LIGHTNING_MODE_MAPPING},
    }};
    for (const auto& [offset, value] : writes) {
        if (!Write32(user_fd, ctrl_base + offset, value, error)) {
            return false;
        }
    }
    return true;
}

bool RunObservationImpl(const XdmaRuntime::Options& options, uint32_t mode,
                        const std::vector<SlamAccelScanPoint>& scan_points, const SlamAccelPose& pose,
                        const loc::ActiveMapBuffer& active_map, const SlamAccelObservationParams& params,
                        const std::vector<ObsCellFloat64>* candidate_cells,
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

    constexpr size_t kOutputBytes = sizeof(SlamNormalEquation) + sizeof(SlamSolve6x6Result);
    const ActiveMapHeader map_header = MakeActiveMapHeader(active_map, mode);
    std::array<uint8_t, kOutputBytes> output_zero = {};
    const bool use_candidate_v2 = candidate_cells != nullptr;

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
        bool map_write_ok = true;
        if (use_candidate_v2) {
            map_write_ok =
                WriteVector(h2c.get(), LIGHTNING_OBS_CELLS_BASE, *candidate_cells, error, "candidate_cells");
        } else {
            map_write_ok = WriteVector(h2c.get(), LIGHTNING_ACTIVE_BLOCKS_BASE, active_map.blocks, error,
                                       "active_blocks") &&
                           WriteVector(h2c.get(), LIGHTNING_OBS_CELLS_BASE, active_map.cells, error, "obs_cells");
        }
        if (!map_write_ok) {
            result.timing.h2c_map_sec = SecondsSince(stage_start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        result.timing.h2c_map_sec = SecondsSince(stage_start);
        if (use_candidate_v2) {
            result.timing.h2c_candidate_sec = result.timing.h2c_map_sec;
        }

        if (verify_readback) {
            stage_start = Clock::now();
            bool verify_ok = VerifyBytes(c2h.get(), LIGHTNING_SCAN_POINTS_BASE, scan_points.data(),
                                         scan_points.size() * sizeof(SlamAccelScanPoint), error, "scan_points") &&
                             VerifyBytes(c2h.get(), LIGHTNING_POSE_BASE, &pose, sizeof(pose), error, "pose") &&
                             VerifyBytes(c2h.get(), LIGHTNING_MAP_HEADER_BASE, &map_header, sizeof(map_header), error,
                                         "map_header") &&
                             VerifyBytes(c2h.get(), LIGHTNING_PARAMS_BASE, &params, sizeof(params), error, "params");
            if (verify_ok) {
                if (use_candidate_v2) {
                    verify_ok = VerifyBytes(c2h.get(), LIGHTNING_OBS_CELLS_BASE, candidate_cells->data(),
                                            candidate_cells->size() * sizeof(ObsCellFloat64), error,
                                            "candidate_cells");
                } else {
                    verify_ok = VerifyBytes(c2h.get(), LIGHTNING_ACTIVE_BLOCKS_BASE, active_map.blocks.data(),
                                            active_map.blocks.size() * sizeof(ActiveBlockRecord), error,
                                            "active_blocks") &&
                                VerifyBytes(c2h.get(), LIGHTNING_OBS_CELLS_BASE, active_map.cells.data(),
                                            active_map.cells.size() * sizeof(ObsCellFloat64), error, "obs_cells");
                }
            }
            if (!verify_ok) {
                result.timing.verify_readback_sec = SecondsSince(stage_start);
                result.timing.total_sec = SecondsSince(total_start);
                return false;
            }
            result.timing.verify_readback_sec = SecondsSince(stage_start);
        }
    }

    stage_start = Clock::now();
    if (!WriteExact(h2c.get(), output_zero.data(), output_zero.size(), LIGHTNING_OUTPUT_BASE, error, "output_zero")) {
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

    std::array<uint8_t, kOutputBytes> output_bytes = {};
    stage_start = Clock::now();
    if (!ReadExact(c2h.get(), output_bytes.data(), output_bytes.size(), LIGHTNING_OUTPUT_BASE, error, "output")) {
        result.timing.c2h_output_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.c2h_output_sec = SecondsSince(stage_start);
    std::memcpy(&result.output, output_bytes.data(), sizeof(result.output));
    std::memcpy(&result.solve, output_bytes.data() + sizeof(SlamNormalEquation), sizeof(result.solve));
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
                              nullptr, write_full_image, verify_readback, result, error);
}

bool XdmaRuntime::RunLocalizationObservationV2(const std::vector<SlamAccelScanPoint>& scan_points,
                                               const SlamAccelPose& pose, const loc::ActiveMapBuffer& active_map,
                                               bool write_full_image, bool verify_readback, RunResult& result,
                                               std::string* error) const {
    SlamAccelObservationParams params = MakeLocalizationObservationParams();
    params.flags |= SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    uint32_t candidate_valid = 0;
    uint32_t candidate_miss = 0;
    const auto candidates =
        BuildCandidateCells(scan_points, pose, active_map, LOCALIZATION_OBSERVATION, candidate_valid, candidate_miss);
    result.candidate_count = static_cast<uint32_t>(candidates.size());
    result.candidate_valid_count = candidate_valid;
    result.candidate_miss_count = candidate_miss;
    result.candidate_bytes = candidates.size() * sizeof(ObsCellFloat64);
    return RunObservationImpl(options_, LOCALIZATION_OBSERVATION, scan_points, pose, active_map, params,
                              &candidates, write_full_image, verify_readback, result, error);
}

bool XdmaRuntime::RunLocalizationObservationV2Solve6x6(const std::vector<SlamAccelScanPoint>& scan_points,
                                                       const SlamAccelPose& pose,
                                                       const loc::ActiveMapBuffer& active_map,
                                                       bool write_full_image, bool verify_readback,
                                                       RunResult& result, std::string* error) const {
    SlamAccelObservationParams params = MakeLocalizationObservationParams();
    params.flags |= SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    params.flags |= SLAM_ACCEL_OBS_FLAG_SOLVE6X6;
    uint32_t candidate_valid = 0;
    uint32_t candidate_miss = 0;
    const auto candidates =
        BuildCandidateCells(scan_points, pose, active_map, LOCALIZATION_OBSERVATION, candidate_valid, candidate_miss);
    result.candidate_count = static_cast<uint32_t>(candidates.size());
    result.candidate_valid_count = candidate_valid;
    result.candidate_miss_count = candidate_miss;
    result.candidate_bytes = candidates.size() * sizeof(ObsCellFloat64);
    return RunObservationImpl(options_, LOCALIZATION_OBSERVATION, scan_points, pose, active_map, params,
                              &candidates, write_full_image, verify_readback, result, error);
}

bool XdmaRuntime::RunMappingObservation(const std::vector<SlamAccelScanPoint>& scan_points,
                                        const SlamAccelPose& pose, const loc::ActiveMapBuffer& active_map,
                                        const SlamAccelObservationParams& params, bool write_full_image,
                                        bool verify_readback, RunResult& result, std::string* error) const {
    return RunObservationImpl(options_, MAPPING_OBSERVATION, scan_points, pose, active_map, params, nullptr,
                              write_full_image, verify_readback, result, error);
}

bool XdmaRuntime::RunMappingObservationV2(const std::vector<SlamAccelScanPoint>& scan_points,
                                          const SlamAccelPose& pose, const loc::ActiveMapBuffer& active_map,
                                          const SlamAccelObservationParams& input_params, bool write_full_image,
                                          bool verify_readback, RunResult& result, std::string* error) const {
    SlamAccelObservationParams params = input_params;
    params.flags |= SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    uint32_t candidate_valid = 0;
    uint32_t candidate_miss = 0;
    const auto candidates =
        BuildCandidateCells(scan_points, pose, active_map, MAPPING_OBSERVATION, candidate_valid, candidate_miss);
    result.candidate_count = static_cast<uint32_t>(candidates.size());
    result.candidate_valid_count = candidate_valid;
    result.candidate_miss_count = candidate_miss;
    result.candidate_bytes = candidates.size() * sizeof(ObsCellFloat64);
    return RunObservationImpl(options_, MAPPING_OBSERVATION, scan_points, pose, active_map, params,
                              &candidates, write_full_image, verify_readback, result, error);
}

bool XdmaRuntime::RunMappingEkfUpdate(const mapping_update::UpdateInput& input, bool write_full_image,
                                      bool verify_readback, EkfUpdateRunResult& result,
                                      std::string* error) const {
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
    if (!OpenFd(user, options_.user_dev, O_RDWR, error) || !OpenFd(h2c, options_.h2c_dev, O_WRONLY, error) ||
        !OpenFd(c2h, options_.c2h_dev, O_RDONLY, error)) {
        result.timing.open_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.open_sec = SecondsSince(stage_start);

    result.raw_input_words = PackEkfUpdateInputWords(input);
    result.raw_output_words.assign(kEkfOutWords, 0);
    const std::vector<uint64_t> output_zero(kEkfOutWords, 0);

    if (write_full_image) {
        stage_start = Clock::now();
        if (!WriteExact(h2c.get(), result.raw_input_words.data(),
                        result.raw_input_words.size() * sizeof(uint64_t), LIGHTNING_EKF_UPDATE_INPUT_BASE, error,
                        "ekf_update_input")) {
            result.timing.h2c_input_sec = SecondsSince(stage_start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        result.timing.h2c_input_sec = SecondsSince(stage_start);

        if (verify_readback) {
            stage_start = Clock::now();
            if (!VerifyBytes(c2h.get(), LIGHTNING_EKF_UPDATE_INPUT_BASE, result.raw_input_words.data(),
                             result.raw_input_words.size() * sizeof(uint64_t), error, "ekf_update_input")) {
                result.timing.verify_readback_sec = SecondsSince(stage_start);
                result.timing.total_sec = SecondsSince(total_start);
                return false;
            }
            result.timing.verify_readback_sec = SecondsSince(stage_start);
        }
    }

    stage_start = Clock::now();
    if (!WriteExact(h2c.get(), output_zero.data(), output_zero.size() * sizeof(uint64_t),
                    LIGHTNING_EKF_UPDATE_OUTPUT_BASE, error, "ekf_update_output_zero")) {
        result.timing.output_zero_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.output_zero_sec = SecondsSince(stage_start);

    stage_start = Clock::now();
    if (!ConfigureEkfRegisters(user.get(), options_.ctrl_base, error) ||
        !Read32(user.get(), options_.ctrl_base + LIGHTNING_CTRL_RUN_COUNT, result.run_count_before, error)) {
        result.timing.reg_config_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.reg_config_sec = SecondsSince(stage_start);

    const auto start = Clock::now();
    if (!Write32(user.get(), options_.ctrl_base + LIGHTNING_CTRL_CONTROL, 0x1u, error)) {
        result.timing.hls_wait_sec = SecondsSince(start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    const auto deadline = start + std::chrono::duration<double>(options_.timeout_sec);
    while (Clock::now() < deadline) {
        if (!Read32(user.get(), options_.ctrl_base + LIGHTNING_CTRL_STATUS, result.status, error) ||
            !Read32(user.get(), options_.ctrl_base + LIGHTNING_CTRL_ERROR, result.error, error)) {
            result.timing.hls_wait_sec = SecondsSince(start);
            result.timing.total_sec = SecondsSince(total_start);
            return false;
        }
        if ((result.status & kStatusError) != 0 || result.error != 0) {
            SetError(error, "EKF update entered error status");
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
        SetError(error, "EKF update timeout");
        result.timing.hls_wait_sec = SecondsSince(start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    const auto end = Clock::now();
    result.elapsed_sec = std::chrono::duration<double>(end - start).count();
    result.timing.hls_wait_sec = result.elapsed_sec;

    if (!Read32(user.get(), options_.ctrl_base + LIGHTNING_CTRL_RUN_COUNT, result.run_count_after, error)) {
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    if (result.run_count_after <= result.run_count_before) {
        SetError(error, "RUN_COUNT did not increment");
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }

    stage_start = Clock::now();
    if (!ReadExact(c2h.get(), result.raw_output_words.data(), result.raw_output_words.size() * sizeof(uint64_t),
                   LIGHTNING_EKF_UPDATE_OUTPUT_BASE, error, "ekf_update_output")) {
        result.timing.c2h_output_sec = SecondsSince(stage_start);
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.timing.c2h_output_sec = SecondsSince(stage_start);

    const uint64_t expected_magic = PackU32Pair(kEkfOutMagic, kEkfVersion);
    if (result.raw_output_words[kEkfOutMagicVersion] != expected_magic) {
        std::ostringstream ss;
        ss << "bad EKF output magic/version word=0x" << std::hex
           << result.raw_output_words[kEkfOutMagicVersion] << " expected=0x" << expected_magic;
        SetError(error, ss.str());
        result.timing.total_sec = SecondsSince(total_start);
        return false;
    }
    result.output = UnpackEkfUpdateOutputWords(result.raw_output_words);
    result.timing.total_sec = SecondsSince(total_start);
    return true;
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
