// SPDX-License-Identifier: MIT

#include "unified_surfel_observation_core.h"

#include <cmath>
#include <cstdint>
#include <cstring>
#include <cstdlib>
#include <algorithm>
#include <chrono>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace {

using namespace lightning::fpga;
using namespace lightning::fpga::hls;

constexpr size_t kNormalEquationWords = sizeof(SlamNormalEquation) / sizeof(uint64_t);
constexpr size_t kSolve6x6Words = sizeof(SlamSolve6x6Result) / sizeof(uint64_t);
constexpr size_t kOutputWords = kNormalEquationWords + kSolve6x6Words;
constexpr double kSolve6x6Damping = 1.0e-6;

struct GoldenCase {
    std::string mode_name;
    std::vector<SlamAccelScanPoint> scan;
    SlamAccelPose pose;
    ActiveMapHeader map_header;
    std::vector<ActiveBlockRecord> blocks;
    std::vector<ObsCellFloat64> cells;
    SlamNormalEquation expected;
    SlamAccelObservationParams params;
};

std::string JoinPath(const std::string& dir, const std::string& name) {
    const char last = dir.empty() ? '/' : dir[dir.size() - 1];
    return (last == '/' || last == '\\') ? dir + name : dir + "/" + name;
}

bool FileExists(const std::string& path) {
    std::ifstream ifs(path.c_str(), std::ios::binary);
    return static_cast<bool>(ifs);
}

template <typename T>
bool ReadPod(std::ifstream& ifs, T& out) {
    ifs.read(reinterpret_cast<char*>(&out), sizeof(T));
    return static_cast<bool>(ifs);
}

bool ValidateHeader(const GoldenFileHeader& header, uint32_t type, uint32_t bytes, std::string& error) {
    if (header.magic != SLAM_ACCEL_ABI_MAGIC || header.version != SLAM_ACCEL_GOLDEN_VERSION) {
        error = "bad golden magic/version";
        return false;
    }
    if (header.record_type != type || header.record_bytes != bytes) {
        error = "bad golden type/record size";
        return false;
    }
    return true;
}

template <typename T>
bool ReadVectorFile(const std::string& path, uint32_t type, std::vector<T>& out, std::string& error) {
    std::ifstream ifs(path.c_str(), std::ios::binary);
    if (!ifs) {
        error = "failed to open " + path;
        return false;
    }
    GoldenFileHeader header;
    if (!ReadPod(ifs, header) || !ValidateHeader(header, type, sizeof(T), error)) {
        return false;
    }
    out.resize(header.record_count);
    ifs.read(reinterpret_cast<char*>(out.data()), static_cast<std::streamsize>(out.size() * sizeof(T)));
    if (!ifs) {
        error = "failed to read " + path;
        return false;
    }
    return true;
}

bool ReadPoseBinary(const std::string& path, SlamAccelPose& pose, std::string& error) {
    std::vector<SlamAccelPose> poses;
    if (!ReadVectorFile(path, GOLDEN_POSE, poses, error) || poses.size() != 1) {
        if (error.empty()) {
            error = path + " must contain exactly one pose";
        }
        return false;
    }
    pose = poses[0];
    return true;
}

bool ReadPoseText(const std::string& path, SlamAccelPose& pose, std::string& error) {
    std::ifstream ifs(path.c_str());
    if (!ifs) {
        error = "failed to open " + path;
        return false;
    }
    if (!(ifs >> pose.tx >> pose.ty >> pose.tz >> pose.qx >> pose.qy >> pose.qz >> pose.qw)) {
        error = "failed to parse " + path;
        return false;
    }
    pose.flags = 0;
    return true;
}

bool ReadExpected(const std::string& path, SlamNormalEquation& expected, std::string& error) {
    std::vector<SlamNormalEquation> equations;
    if (!ReadVectorFile(path, GOLDEN_NORMAL_EQUATION, equations, error) || equations.size() != 1) {
        if (error.empty()) {
            error = path + " must contain exactly one equation";
        }
        return false;
    }
    expected = equations[0];
    return true;
}

bool ReadActiveMap(const std::string& path, ActiveMapHeader& map_header, std::vector<ActiveBlockRecord>& blocks,
                   std::vector<ObsCellFloat64>& cells, std::string& error) {
    std::ifstream ifs(path.c_str(), std::ios::binary);
    if (!ifs) {
        error = "failed to open " + path;
        return false;
    }
    GoldenFileHeader file_header;
    if (!ReadPod(ifs, file_header) ||
        !ValidateHeader(file_header, GOLDEN_ACTIVE_MAP, sizeof(ActiveMapHeader), error) ||
        !ReadPod(ifs, map_header)) {
        return false;
    }
    blocks.resize(map_header.num_blocks);
    cells.resize(map_header.num_cells);
    ifs.read(reinterpret_cast<char*>(blocks.data()),
             static_cast<std::streamsize>(blocks.size() * sizeof(ActiveBlockRecord)));
    ifs.read(reinterpret_cast<char*>(cells.data()), static_cast<std::streamsize>(cells.size() * sizeof(ObsCellFloat64)));
    if (!ifs) {
        error = "failed to read active map body";
        return false;
    }
    return true;
}

std::vector<double> ExtractNumbers(const std::string& line) {
    std::vector<double> values;
    const char* cursor = line.c_str();
    char* end = nullptr;
    while (*cursor != '\0') {
        const double value = std::strtod(cursor, &end);
        if (end != cursor) {
            values.push_back(value);
            cursor = end;
        } else {
            ++cursor;
        }
    }
    return values;
}

void QuatToMatrix(const SlamAccelPose& pose, double r[9]) {
    const double x = pose.qx;
    const double y = pose.qy;
    const double z = pose.qz;
    const double w = pose.qw;
    const double xx = x * x;
    const double yy = y * y;
    const double zz = z * z;
    const double xy = x * y;
    const double xz = x * z;
    const double yz = y * z;
    const double wx = w * x;
    const double wy = w * y;
    const double wz = w * z;
    r[0] = 1.0 - 2.0 * (yy + zz);
    r[1] = 2.0 * (xy - wz);
    r[2] = 2.0 * (xz + wy);
    r[3] = 2.0 * (xy + wz);
    r[4] = 1.0 - 2.0 * (xx + zz);
    r[5] = 2.0 * (yz - wx);
    r[6] = 2.0 * (xz - wy);
    r[7] = 2.0 * (yz + wx);
    r[8] = 1.0 - 2.0 * (xx + yy);
}

void MatrixToQuat(const double r[9], SlamAccelPose& pose) {
    const double trace = r[0] + r[4] + r[8];
    double qx = 0.0;
    double qy = 0.0;
    double qz = 0.0;
    double qw = 1.0;
    if (trace > 0.0) {
        const double s = std::sqrt(trace + 1.0) * 2.0;
        qw = 0.25 * s;
        qx = (r[7] - r[5]) / s;
        qy = (r[2] - r[6]) / s;
        qz = (r[3] - r[1]) / s;
    } else if (r[0] > r[4] && r[0] > r[8]) {
        const double s = std::sqrt(1.0 + r[0] - r[4] - r[8]) * 2.0;
        qw = (r[7] - r[5]) / s;
        qx = 0.25 * s;
        qy = (r[1] + r[3]) / s;
        qz = (r[2] + r[6]) / s;
    } else if (r[4] > r[8]) {
        const double s = std::sqrt(1.0 + r[4] - r[0] - r[8]) * 2.0;
        qw = (r[2] - r[6]) / s;
        qx = (r[1] + r[3]) / s;
        qy = 0.25 * s;
        qz = (r[5] + r[7]) / s;
    } else {
        const double s = std::sqrt(1.0 + r[8] - r[0] - r[4]) * 2.0;
        qw = (r[3] - r[1]) / s;
        qx = (r[2] + r[6]) / s;
        qy = (r[5] + r[7]) / s;
        qz = 0.25 * s;
    }
    const double norm = std::sqrt(qx * qx + qy * qy + qz * qz + qw * qw);
    pose.qx = static_cast<float>(qx / norm);
    pose.qy = static_cast<float>(qy / norm);
    pose.qz = static_cast<float>(qz / norm);
    pose.qw = static_cast<float>(qw / norm);
}

void ComposeLidarPose(const SlamAccelPose& state_pose, const SlamAccelObservationParams& params,
                      SlamAccelPose& lidar_pose) {
    double state_r[9];
    QuatToMatrix(state_pose, state_r);
    double lidar_r[9];
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            double sum = 0.0;
            for (int k = 0; k < 3; ++k) {
                sum += state_r[r * 3 + k] * static_cast<double>(params.extrinsic_R[k * 3 + c]);
            }
            lidar_r[r * 3 + c] = sum;
        }
    }
    lidar_pose.tx = static_cast<float>(state_pose.tx + state_r[0] * params.extrinsic_T[0] +
                                       state_r[1] * params.extrinsic_T[1] + state_r[2] * params.extrinsic_T[2]);
    lidar_pose.ty = static_cast<float>(state_pose.ty + state_r[3] * params.extrinsic_T[0] +
                                       state_r[4] * params.extrinsic_T[1] + state_r[5] * params.extrinsic_T[2]);
    lidar_pose.tz = static_cast<float>(state_pose.tz + state_r[6] * params.extrinsic_T[0] +
                                       state_r[7] * params.extrinsic_T[1] + state_r[8] * params.extrinsic_T[2]);
    lidar_pose.flags = 0;
    MatrixToQuat(lidar_r, lidar_pose);
}

bool ReadMappingMeta(const std::string& path, SlamAccelObservationParams& params, std::string& error) {
    params = SlamAccelObservationParams();
    params.mode = MAPPING_OBSERVATION;
    std::ifstream ifs(path.c_str());
    if (!ifs) {
        error = "failed to open " + path;
        return false;
    }
    std::string line;
    while (std::getline(ifs, line)) {
        if (line.find("plane_icp_weight") != std::string::npos) {
            const std::vector<double> values = ExtractNumbers(line);
            if (!values.empty()) {
                params.plane_icp_weight = static_cast<float>(values[0]);
            }
        } else if (line.find("extrinsic_T") != std::string::npos) {
            const std::vector<double> values = ExtractNumbers(line);
            if (values.size() >= 3) {
                params.extrinsic_T[0] = static_cast<float>(values[0]);
                params.extrinsic_T[1] = static_cast<float>(values[1]);
                params.extrinsic_T[2] = static_cast<float>(values[2]);
            }
        } else if (line.find("extrinsic_R") != std::string::npos) {
            const std::vector<double> values = ExtractNumbers(line);
            if (values.size() >= 9) {
                for (int i = 0; i < 9; ++i) {
                    params.extrinsic_R[i] = static_cast<float>(values[i]);
                }
            }
        }
    }
    return true;
}

SlamNormalEquation DecodeOutputWords(const uint64_t words[kOutputWords]) {
    SlamNormalEquation out;
    std::memcpy(&out, words, sizeof(out));
    return out;
}

SlamSolve6x6Result DecodeSolveWords(const uint64_t words[kOutputWords]) {
    SlamSolve6x6Result out;
    std::memcpy(&out, words + kNormalEquationWords, sizeof(out));
    return out;
}

uint32_t DebugLow32(uint64_t value) { return static_cast<uint32_t>(value & 0xFFFFffffULL); }

uint32_t DebugHigh32(uint64_t value) { return static_cast<uint32_t>(value >> 32); }

std::string FormatDebugCounters(const uint64_t words[kOutputWords]) {
    std::ostringstream ss;
    ss << "debug_magic=0x" << std::hex << DebugLow32(words[32]) << std::dec
       << " debug_version=" << DebugHigh32(words[32])
       << " point_count=" << DebugLow32(words[33])
       << " exact_hit=" << DebugHigh32(words[33])
       << " neighbor_hit=" << DebugLow32(words[34])
       << " lookup_miss=" << DebugHigh32(words[34])
       << " neighbor_probe=" << DebugLow32(words[35])
       << " block_lookup=" << DebugHigh32(words[35])
       << " block_search_steps=" << DebugLow32(words[36])
       << " obs_cell_read=" << DebugHigh32(words[36])
       << " valid_candidate=" << DebugLow32(words[37])
       << " invalid_candidate=" << DebugHigh32(words[37])
       << " max_probe_per_point=" << DebugLow32(words[38])
       << " block_cache_count=" << DebugHigh32(words[38])
       << " debug_flags=0x" << std::hex << DebugLow32(words[39]) << std::dec;
    return ss.str();
}

struct EncodedCell {
    int32_t block_x = 0;
    int32_t block_y = 0;
    int32_t block_z = 0;
    int32_t cell_idx = 0;
};

int FloorDivHost(int value, int divisor) {
    int q = value / divisor;
    int r = value % divisor;
    if (r != 0 && ((r < 0) != (divisor < 0))) {
        --q;
    }
    return q;
}

int ModFloorHost(int value, int divisor) {
    int r = value % divisor;
    return r < 0 ? r + divisor : r;
}

void RotatePointHost(const SlamAccelPose& pose, const SlamAccelScanPoint& point, double& x, double& y, double& z) {
    const double qx = pose.qx;
    const double qy = pose.qy;
    const double qz = pose.qz;
    const double qw = pose.qw;
    const double px = point.x;
    const double py = point.y;
    const double pz = point.z;
    const double tx = 2.0 * (qy * pz - qz * py);
    const double ty = 2.0 * (qz * px - qx * pz);
    const double tz = 2.0 * (qx * py - qy * px);
    x = px + qw * tx + (qy * tz - qz * ty) + pose.tx;
    y = py + qw * ty + (qz * tx - qx * tz) + pose.ty;
    z = pz + qw * tz + (qx * ty - qy * tx) + pose.tz;
}

EncodedCell EncodeHost(double x, double y, double z, const ActiveMapHeader& map_header) {
    const int gx = static_cast<int>(std::floor(x * map_header.inv_cell_resolution));
    const int gy = static_cast<int>(std::floor(y * map_header.inv_cell_resolution));
    const int gz = static_cast<int>(std::floor(z * map_header.inv_cell_resolution));
    EncodedCell encoded;
    encoded.block_x = FloorDivHost(gx, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X));
    encoded.block_y = FloorDivHost(gy, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y));
    encoded.block_z = FloorDivHost(gz, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z));
    const int lx = ModFloorHost(gx, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X));
    const int ly = ModFloorHost(gy, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y));
    const int lz = ModFloorHost(gz, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z));
    encoded.cell_idx = (lz * static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y) + ly) *
                           static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X) +
                       lx;
    return encoded;
}

bool BlockLessHost(const ActiveBlockRecord& lhs, const EncodedCell& rhs) {
    if (lhs.x != rhs.block_x) return lhs.x < rhs.block_x;
    if (lhs.y != rhs.block_y) return lhs.y < rhs.block_y;
    return lhs.z < rhs.block_z;
}

bool KeyLessHost(const EncodedCell& lhs, const ActiveBlockRecord& rhs) {
    if (lhs.block_x != rhs.x) return lhs.block_x < rhs.x;
    if (lhs.block_y != rhs.y) return lhs.block_y < rhs.y;
    return lhs.block_z < rhs.z;
}

const ObsCellFloat64* LookupCellHost(const GoldenCase& golden, const EncodedCell& encoded) {
    const auto iter = std::lower_bound(
        golden.blocks.begin(), golden.blocks.end(), encoded,
        [](const ActiveBlockRecord& lhs, const EncodedCell& rhs) { return BlockLessHost(lhs, rhs); });
    if (iter == golden.blocks.end() || KeyLessHost(encoded, *iter)) {
        return nullptr;
    }
    const size_t offset = static_cast<size_t>(iter->first_cell) + static_cast<size_t>(encoded.cell_idx);
    if (offset >= golden.cells.size()) {
        return nullptr;
    }
    const ObsCellFloat64& cell = golden.cells[offset];
    return (cell.flags & OBS_CELL_VALID) != 0 ? &cell : nullptr;
}

double CandidateResidualHost(const ObsCellFloat64& cell, double x, double y, double z) {
    return static_cast<double>(cell.normal_x) * x + static_cast<double>(cell.normal_y) * y +
           static_cast<double>(cell.normal_z) * z + static_cast<double>(cell.plane_d);
}

bool BetterMappingCandidateHost(const ObsCellFloat64& lhs, const ObsCellFloat64& rhs, double x, double y, double z) {
    const double lhs_res = std::fabs(CandidateResidualHost(lhs, x, y, z));
    const double rhs_res = std::fabs(CandidateResidualHost(rhs, x, y, z));
    if (std::fabs(lhs_res - rhs_res) > 1.0e-4) {
        return lhs_res < rhs_res;
    }
    const double lhs_dx = x - lhs.centroid_x;
    const double lhs_dy = y - lhs.centroid_y;
    const double lhs_dz = z - lhs.centroid_z;
    const double rhs_dx = x - rhs.centroid_x;
    const double rhs_dy = y - rhs.centroid_y;
    const double rhs_dz = z - rhs.centroid_z;
    const double lhs_dist = lhs_dx * lhs_dx + lhs_dy * lhs_dy + lhs_dz * lhs_dz;
    const double rhs_dist = rhs_dx * rhs_dx + rhs_dy * rhs_dy + rhs_dz * rhs_dz;
    if (std::fabs(lhs_dist - rhs_dist) > 1.0e-4) {
        return lhs_dist < rhs_dist;
    }
    return lhs.quality < rhs.quality;
}

bool LookupCandidateHost(const GoldenCase& golden, double x, double y, double z, ObsCellFloat64& out) {
    const EncodedCell center = EncodeHost(x, y, z, golden.map_header);
    const ObsCellFloat64* center_cell = LookupCellHost(golden, center);
    if (center_cell != nullptr) {
        out = *center_cell;
        return true;
    }
    if (golden.map_header.lookup_nearby_type == 0) {
        return false;
    }
    const int bx_dim = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X);
    const int by_dim = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y);
    const int bz_dim = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z);
    const int base_lz = center.cell_idx / (bx_dim * by_dim);
    const int rem = center.cell_idx - base_lz * bx_dim * by_dim;
    const int base_ly = rem / bx_dim;
    const int base_lx = rem - base_ly * bx_dim;
    const int gx = center.block_x * bx_dim + base_lx;
    const int gy = center.block_y * by_dim + base_ly;
    const int gz = center.block_z * bz_dim + base_lz;
    bool found = false;
    ObsCellFloat64 best;
    double best_dist2 = 1.0e100;
    for (int dz = -1; dz <= 1; ++dz) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dx = -1; dx <= 1; ++dx) {
                const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                const int chessboard = std::max(std::max(std::abs(dx), std::abs(dy)), std::abs(dz));
                if (manhattan == 0) {
                    continue;
                }
                if ((golden.map_header.lookup_nearby_type <= 6 && manhattan != 1) ||
                    (golden.map_header.lookup_nearby_type > 6 && golden.map_header.lookup_nearby_type <= 18 &&
                     (chessboard > 1 || manhattan > 2))) {
                    continue;
                }
                const int ngx = gx + dx;
                const int ngy = gy + dy;
                const int ngz = gz + dz;
                EncodedCell neighbor;
                neighbor.block_x = FloorDivHost(ngx, bx_dim);
                neighbor.block_y = FloorDivHost(ngy, by_dim);
                neighbor.block_z = FloorDivHost(ngz, bz_dim);
                const int lx = ModFloorHost(ngx, bx_dim);
                const int ly = ModFloorHost(ngy, by_dim);
                const int lz = ModFloorHost(ngz, bz_dim);
                neighbor.cell_idx = (lz * by_dim + ly) * bx_dim + lx;
                const ObsCellFloat64* candidate = LookupCellHost(golden, neighbor);
                if (candidate == nullptr) {
                    continue;
                }
                bool better = false;
                if (!found) {
                    better = true;
                } else if (golden.params.mode == MAPPING_OBSERVATION) {
                    better = BetterMappingCandidateHost(*candidate, best, x, y, z);
                } else {
                    const double ddx = x - candidate->centroid_x;
                    const double ddy = y - candidate->centroid_y;
                    const double ddz = z - candidate->centroid_z;
                    const double dist2 = ddx * ddx + ddy * ddy + ddz * ddz;
                    better = dist2 < best_dist2;
                    if (better) {
                        best_dist2 = dist2;
                    }
                }
                if (better) {
                    best = *candidate;
                    found = true;
                    if (golden.params.mode != MAPPING_OBSERVATION) {
                        const double ddx = x - candidate->centroid_x;
                        const double ddy = y - candidate->centroid_y;
                        const double ddz = z - candidate->centroid_z;
                        best_dist2 = ddx * ddx + ddy * ddy + ddz * ddz;
                    }
                }
            }
        }
    }
    if (found) {
        out = best;
    }
    return found;
}

std::vector<ObsCellFloat64> BuildCandidateCellsHost(const GoldenCase& golden) {
    std::vector<ObsCellFloat64> candidates(golden.scan.size());
    for (size_t i = 0; i < golden.scan.size(); ++i) {
        double x = 0.0;
        double y = 0.0;
        double z = 0.0;
        RotatePointHost(golden.pose, golden.scan[i], x, y, z);
        ObsCellFloat64 candidate;
        if (LookupCandidateHost(golden, x, y, z, candidate)) {
            candidates[i] = candidate;
        }
    }
    return candidates;
}

bool CompareEquation(const SlamNormalEquation& actual, const SlamNormalEquation& expected, double abs_tol,
                     double rel_tol, std::string& report) {
    double max_abs = 0.0;
    double max_rel = 0.0;
    int worst_idx = -1;

    auto check_value = [&](int idx, double a, double e) {
        const double abs_err = std::fabs(a - e);
        const double rel_err = abs_err / std::max(1.0, std::fabs(e));
        if (abs_err > max_abs) {
            max_abs = abs_err;
            worst_idx = idx;
        }
        if (rel_err > max_rel) {
            max_rel = rel_err;
        }
    };

    for (int i = 0; i < 21; ++i) {
        check_value(i, actual.h_upper[i], expected.h_upper[i]);
    }
    for (int i = 0; i < 6; ++i) {
        check_value(100 + i, actual.b[i], expected.b[i]);
    }
    check_value(200, actual.residual_sum, expected.residual_sum);
    check_value(201, actual.residual_abs_sum, expected.residual_abs_sum);
    check_value(202, actual.residual_max_abs, expected.residual_max_abs);

    const bool counts_ok = actual.valid_count == expected.valid_count && actual.reject_count == expected.reject_count &&
                           actual.miss_count == expected.miss_count;
    const bool values_ok = max_abs <= abs_tol || max_rel <= rel_tol;

    std::ostringstream ss;
    ss << "counts_ok=" << counts_ok << " values_ok=" << values_ok << " max_abs=" << max_abs
       << " max_rel=" << max_rel << " worst_idx=" << worst_idx << " actual_counts=" << actual.valid_count << "/"
       << actual.reject_count << "/" << actual.miss_count << " expected_counts=" << expected.valid_count << "/"
       << expected.reject_count << "/" << expected.miss_count;
    report = ss.str();
    return counts_ok && values_ok;
}

bool ReferenceSolve6x6(const SlamNormalEquation& equation, double dx[6], std::string& error) {
    double a[6][6] = {};
    double l[6][6] = {};
    double d[6] = {};
    double rhs[6] = {};
    int idx = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            a[r][c] = equation.h_upper[idx];
            a[c][r] = equation.h_upper[idx];
            ++idx;
        }
        a[r][r] += kSolve6x6Damping;
        rhs[r] = -equation.b[r];
        dx[r] = 0.0;
    }

    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < i; ++j) {
            double sum = a[i][j];
            for (int k = 0; k < j; ++k) {
                sum -= l[i][k] * d[k] * l[j][k];
            }
            if (std::fabs(d[j]) <= 1e-12) {
                error = "reference solve zero pivot";
                return false;
            }
            l[i][j] = sum / d[j];
        }
        double diag = a[i][i];
        for (int k = 0; k < i; ++k) {
            diag -= l[i][k] * l[i][k] * d[k];
        }
        if (!std::isfinite(diag) || diag <= 1e-12) {
            error = "reference solve non-positive pivot";
            return false;
        }
        d[i] = diag;
        l[i][i] = 1.0;
    }

    double y[6] = {};
    double z[6] = {};
    for (int i = 0; i < 6; ++i) {
        double sum = rhs[i];
        for (int k = 0; k < i; ++k) {
            sum -= l[i][k] * y[k];
        }
        y[i] = sum;
        z[i] = y[i] / d[i];
    }
    for (int i = 5; i >= 0; --i) {
        double sum = z[i];
        for (int k = i + 1; k < 6; ++k) {
            sum -= l[k][i] * dx[k];
        }
        dx[i] = sum;
    }
    return true;
}

bool CompareSolve6x6(const SlamSolve6x6Result& actual, const SlamNormalEquation& equation, std::string& report) {
    double expected_dx[6] = {};
    std::string error;
    if (!ReferenceSolve6x6(equation, expected_dx, error)) {
        report = error;
        return false;
    }
    double max_abs = 0.0;
    double max_rel = 0.0;
    for (int i = 0; i < 6; ++i) {
        const double abs_err = std::fabs(actual.dx[i] - expected_dx[i]);
        const double rel_err = abs_err / std::max(1.0, std::fabs(expected_dx[i]));
        max_abs = std::max(max_abs, abs_err);
        max_rel = std::max(max_rel, rel_err);
    }
    const bool pass = actual.magic == SLAM_ACCEL_SOLVE6X6_MAGIC &&
                      actual.version == SLAM_ACCEL_SOLVE6X6_VERSION &&
                      actual.status == SLAM_SOLVE6X6_SUCCESS &&
                      (max_abs <= 1e-9 || max_rel <= 1e-7);
    std::ostringstream ss;
    ss << "solve_status=" << actual.status << " max_abs=" << max_abs << " max_rel=" << max_rel
       << " residual_norm=" << actual.residual_norm << " dx0=" << actual.dx[0] << " expected_dx0="
       << expected_dx[0];
    report = ss.str();
    return pass;
}

bool ReadGoldenCase(const std::string& golden_dir, GoldenCase& golden, std::string& error) {
    if (FileExists(JoinPath(golden_dir, "loc_scan.bin"))) {
        golden.mode_name = "localization";
        golden.params = SlamAccelObservationParams();
        golden.params.mode = LOCALIZATION_OBSERVATION;
        return ReadVectorFile(JoinPath(golden_dir, "loc_scan.bin"), GOLDEN_SCAN_POINTS, golden.scan, error) &&
               ReadPoseBinary(JoinPath(golden_dir, "loc_pose.bin"), golden.pose, error) &&
               ReadActiveMap(JoinPath(golden_dir, "loc_active_map.bin"), golden.map_header, golden.blocks,
                             golden.cells, error) &&
               ReadExpected(JoinPath(golden_dir, "loc_expected_obs.bin"), golden.expected, error);
    }
    if (FileExists(JoinPath(golden_dir, "map_scan.bin"))) {
        golden.mode_name = "mapping";
        SlamAccelPose state_pose;
        if (!ReadVectorFile(JoinPath(golden_dir, "map_scan.bin"), GOLDEN_SCAN_POINTS, golden.scan, error) ||
            !ReadPoseText(JoinPath(golden_dir, "map_pose.txt"), state_pose, error) ||
            !ReadActiveMap(JoinPath(golden_dir, "map_active_map.bin"), golden.map_header, golden.blocks,
                           golden.cells, error) ||
            !ReadExpected(JoinPath(golden_dir, "map_expected_obs.bin"), golden.expected, error) ||
            !ReadMappingMeta(JoinPath(golden_dir, "map_meta.yaml"), golden.params, error)) {
            return false;
        }
        golden.map_header.mode = MAPPING_OBSERVATION;
        ComposeLidarPose(state_pose, golden.params, golden.pose);
        return true;
    }
    error = "unsupported golden directory: " + golden_dir;
    return false;
}

int RunGoldenCase(const std::string& golden_dir) {
    std::string error;
    GoldenCase golden;
    if (!ReadGoldenCase(golden_dir, golden, error)) {
        std::cerr << "[obs_tb] " << error << std::endl;
        return 1;
    }

    uint64_t actual_words[kOutputWords] = {};
    unified_surfel_observation_core(golden.scan.data(), static_cast<uint32_t>(golden.scan.size()), &golden.pose,
                                    &golden.map_header, reinterpret_cast<const uint64_t*>(&golden.params),
                                    golden.blocks.data(), golden.cells.data(), actual_words);
    const SlamNormalEquation actual = DecodeOutputWords(actual_words);

    std::string report;
    const bool pass = CompareEquation(actual, golden.expected, 1e-4, 1e-3, report);
    std::cout << "[obs_tb] " << golden.mode_name << " " << report << std::endl;
    std::cout << "[obs_tb] " << golden.mode_name << " " << FormatDebugCounters(actual_words) << std::endl;
    if (!pass) {
        return 2;
    }
    std::vector<ObsCellFloat64> candidate_cells = BuildCandidateCellsHost(golden);
    SlamAccelObservationParams v2_params = golden.params;
    v2_params.flags |= SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    uint64_t v2_words[kOutputWords] = {};
    unified_surfel_observation_core(golden.scan.data(), static_cast<uint32_t>(golden.scan.size()), &golden.pose,
                                    &golden.map_header, reinterpret_cast<const uint64_t*>(&v2_params),
                                    golden.blocks.data(), candidate_cells.data(), v2_words);
    const SlamNormalEquation v2_actual = DecodeOutputWords(v2_words);
    std::string v2_report;
    const bool v2_pass = CompareEquation(v2_actual, golden.expected, 1e-4, 1e-3, v2_report);
    std::cout << "[obs_tb] " << golden.mode_name << "_v2 " << v2_report << std::endl;
    std::cout << "[obs_tb] " << golden.mode_name << "_v2 " << FormatDebugCounters(v2_words) << std::endl;
    if (!v2_pass) {
        return 6;
    }
    if (golden.params.mode == LOCALIZATION_OBSERVATION) {
        SlamAccelObservationParams solve_params = v2_params;
        solve_params.flags |= SLAM_ACCEL_OBS_FLAG_SOLVE6X6;
        uint64_t solve_words[kOutputWords] = {};
        unified_surfel_observation_core(golden.scan.data(), static_cast<uint32_t>(golden.scan.size()), &golden.pose,
                                        &golden.map_header, reinterpret_cast<const uint64_t*>(&solve_params),
                                        golden.blocks.data(), candidate_cells.data(), solve_words);
        const SlamNormalEquation solve_equation = DecodeOutputWords(solve_words);
        const SlamSolve6x6Result solve = DecodeSolveWords(solve_words);
        std::string solve_eq_report;
        const bool solve_eq_pass = CompareEquation(solve_equation, golden.expected, 1e-4, 1e-3, solve_eq_report);
        std::string solve_report;
        const bool solve_pass = CompareSolve6x6(solve, solve_equation, solve_report);
        std::cout << "[obs_tb] " << golden.mode_name << "_v2_solve6x6 equation " << solve_eq_report << std::endl;
        std::cout << "[obs_tb] " << golden.mode_name << "_v2_solve6x6 " << solve_report << std::endl;
        if (!solve_eq_pass || !solve_pass) {
            return 7;
        }
    }
    return 0;
}

bool ReplaceFirst(std::string& value, const std::string& from, const std::string& to) {
    const size_t pos = value.find(from);
    if (pos == std::string::npos) {
        return false;
    }
    value.replace(pos, from.size(), to);
    return true;
}

void FillRejectProbe(SlamAccelScanPoint& scan, SlamAccelPose& pose, ActiveMapHeader& map_header,
                     ActiveBlockRecord& block, std::vector<ObsCellFloat64>& cells) {
    scan.x = 1.25f;
    scan.y = 2.25f;
    scan.z = 1.25f;
    scan.intensity = 1.0f;

    pose.qx = 0.0f;
    pose.qy = 0.0f;
    pose.qz = 0.0f;
    pose.qw = 1.0f;
    pose.tx = 0.0f;
    pose.ty = 0.0f;
    pose.tz = 0.0f;
    pose.flags = 0;

    map_header.magic = SLAM_ACCEL_ABI_MAGIC;
    map_header.version = SLAM_ACCEL_GOLDEN_VERSION;
    map_header.mode = LOCALIZATION_OBSERVATION;
    map_header.cells_per_block = SLAM_ACCEL_CELLS_PER_BLOCK;
    map_header.cell_resolution = 1.0f;
    map_header.inv_cell_resolution = 1.0f;
    map_header.window_id = 1;
    map_header.window_version = 1;
    map_header.num_blocks = 1;
    map_header.num_cells = SLAM_ACCEL_CELLS_PER_BLOCK;
    map_header.lookup_nearby_type = 0;
    map_header.flags = 0;

    block.x = 0;
    block.y = 0;
    block.z = 0;
    block.first_cell = 0;
    block.valid_cell_count = 1;
    block.flags = 0;

    cells.assign(SLAM_ACCEL_CELLS_PER_BLOCK, ObsCellFloat64());
    const uint32_t cell_idx = (1u * SLAM_ACCEL_BLOCK_DIM_Y + 2u) * SLAM_ACCEL_BLOCK_DIM_X + 1u;
    ObsCellFloat64& cell = cells[cell_idx];
    cell.centroid_x = 1.25f;
    cell.centroid_y = 2.25f;
    cell.centroid_z = 0.80f;
    cell.normal_x = 0.0f;
    cell.normal_y = 0.0f;
    cell.normal_z = 1.0f;
    cell.plane_d = -0.80f;
    cell.quality = 1.0f;
    cell.count = 1;
    cell.flags = OBS_CELL_VALID;
}

bool RunRejectProbe(std::string& report) {
    SlamAccelScanPoint scan;
    SlamAccelPose pose;
    ActiveMapHeader map_header;
    ActiveBlockRecord block;
    std::vector<ObsCellFloat64> cells;
    FillRejectProbe(scan, pose, map_header, block, cells);

    uint64_t actual_words[kOutputWords] = {};
    SlamAccelObservationParams params;
    params.mode = LOCALIZATION_OBSERVATION;
    unified_surfel_observation_core(&scan, 1, &pose, &map_header, reinterpret_cast<const uint64_t*>(&params), &block,
                                    cells.data(), actual_words);
    const SlamNormalEquation actual = DecodeOutputWords(actual_words);

    const bool counts_ok = actual.valid_count == 0 && actual.reject_count == 1 && actual.miss_count == 0;
    const bool values_ok = actual.h_upper[0] == 0.0 && actual.b[0] == 0.0 && actual.residual_sum == 0.0 &&
                           actual.residual_abs_sum == 0.0 && actual.residual_max_abs == 0.0;
    std::ostringstream ss;
    ss << "reject_probe counts=" << actual.valid_count << "/" << actual.reject_count << "/" << actual.miss_count
       << " residual_abs_sum=" << actual.residual_abs_sum;
    report = ss.str();
    return counts_ok && values_ok;
}

void FillMappingLookupProbe(SlamAccelScanPoint& scan, SlamAccelPose& pose, ActiveMapHeader& map_header,
                            ActiveBlockRecord& block, std::vector<ObsCellFloat64>& cells) {
    scan.x = 1.20f;
    scan.y = 1.20f;
    scan.z = 1.20f;
    scan.intensity = 1.0f;

    pose.qx = 0.0f;
    pose.qy = 0.0f;
    pose.qz = 0.0f;
    pose.qw = 1.0f;
    pose.tx = 0.0f;
    pose.ty = 0.0f;
    pose.tz = 0.0f;
    pose.flags = 0;

    map_header.magic = SLAM_ACCEL_ABI_MAGIC;
    map_header.version = SLAM_ACCEL_GOLDEN_VERSION;
    map_header.mode = MAPPING_OBSERVATION;
    map_header.cells_per_block = SLAM_ACCEL_CELLS_PER_BLOCK;
    map_header.cell_resolution = 1.0f;
    map_header.inv_cell_resolution = 1.0f;
    map_header.window_id = 1;
    map_header.window_version = 1;
    map_header.num_blocks = 1;
    map_header.num_cells = SLAM_ACCEL_CELLS_PER_BLOCK;
    map_header.lookup_nearby_type = 26;
    map_header.flags = 0;

    block.x = 0;
    block.y = 0;
    block.z = 0;
    block.first_cell = 0;
    block.valid_cell_count = 2;
    block.flags = 0;

    cells.assign(SLAM_ACCEL_CELLS_PER_BLOCK, ObsCellFloat64());
    const uint32_t near_bad_idx = (1u * SLAM_ACCEL_BLOCK_DIM_Y + 1u) * SLAM_ACCEL_BLOCK_DIM_X + 2u;
    ObsCellFloat64& near_bad = cells[near_bad_idx];
    near_bad.centroid_x = 1.21f;
    near_bad.centroid_y = 1.20f;
    near_bad.centroid_z = 1.20f;
    near_bad.normal_x = 0.0f;
    near_bad.normal_y = 0.0f;
    near_bad.normal_z = 1.0f;
    near_bad.plane_d = -0.20f;
    near_bad.quality = 0.01f;
    near_bad.count = 8;
    near_bad.flags = OBS_CELL_VALID;

    const uint32_t far_good_idx = (1u * SLAM_ACCEL_BLOCK_DIM_Y + 1u) * SLAM_ACCEL_BLOCK_DIM_X + 0u;
    ObsCellFloat64& far_good = cells[far_good_idx];
    far_good.centroid_x = 5.0f;
    far_good.centroid_y = 5.0f;
    far_good.centroid_z = 5.0f;
    far_good.normal_x = 0.0f;
    far_good.normal_y = 0.0f;
    far_good.normal_z = 1.0f;
    far_good.plane_d = -1.19f;
    far_good.quality = 1.0f;
    far_good.count = 8;
    far_good.flags = OBS_CELL_VALID;
}

bool RunMappingLookupProbe(std::string& report) {
    SlamAccelScanPoint scan;
    SlamAccelPose pose;
    ActiveMapHeader map_header;
    ActiveBlockRecord block;
    std::vector<ObsCellFloat64> cells;
    FillMappingLookupProbe(scan, pose, map_header, block, cells);

    uint64_t actual_words[kOutputWords] = {};
    SlamAccelObservationParams params;
    params.mode = MAPPING_OBSERVATION;
    params.plane_icp_weight = 1.0f;
    params.mapping_gate_scale = 81.0f;
    unified_surfel_observation_core(&scan, 1, &pose, &map_header, reinterpret_cast<const uint64_t*>(&params), &block,
                                    cells.data(), actual_words);
    const SlamNormalEquation actual = DecodeOutputWords(actual_words);

    const bool counts_ok = actual.valid_count == 1 && actual.reject_count == 0 && actual.miss_count == 0;
    const bool residual_ok = std::fabs(actual.residual_sum - 0.01000004768371582) < 1e-5 &&
                             std::fabs(actual.residual_abs_sum - 0.01000004768371582) < 1e-5;
    std::ostringstream ss;
    ss << "mapping_lookup_probe counts=" << actual.valid_count << "/" << actual.reject_count << "/"
       << actual.miss_count << " residual_sum=" << actual.residual_sum;
    report = ss.str();
    return counts_ok && residual_ok;
}

void FillSyntheticSweepCase(uint32_t num_points, uint32_t active_cells, GoldenCase& golden) {
    const uint32_t cells_per_block = SLAM_ACCEL_CELLS_PER_BLOCK;
    const uint32_t num_blocks = std::max(1u, (active_cells + cells_per_block - 1u) / cells_per_block);
    const uint32_t num_cells = num_blocks * cells_per_block;

    golden.mode_name = "synthetic";
    golden.scan.assign(num_points, SlamAccelScanPoint());
    golden.pose = SlamAccelPose();
    golden.params = SlamAccelObservationParams();
    golden.params.mode = LOCALIZATION_OBSERVATION;

    golden.map_header = ActiveMapHeader();
    golden.map_header.mode = LOCALIZATION_OBSERVATION;
    golden.map_header.cell_resolution = 1.0f;
    golden.map_header.inv_cell_resolution = 1.0f;
    golden.map_header.num_blocks = num_blocks;
    golden.map_header.num_cells = num_cells;
    golden.map_header.lookup_nearby_type = 26;

    golden.blocks.assign(num_blocks, ActiveBlockRecord());
    golden.cells.assign(num_cells, ObsCellFloat64());
    for (uint32_t block_idx = 0; block_idx < num_blocks; ++block_idx) {
        golden.blocks[block_idx].x = static_cast<int32_t>(block_idx);
        golden.blocks[block_idx].y = 0;
        golden.blocks[block_idx].z = 0;
        golden.blocks[block_idx].first_cell = block_idx * cells_per_block;
        golden.blocks[block_idx].valid_cell_count = cells_per_block;
    }

    for (uint32_t i = 0; i < num_points; ++i) {
        const uint32_t block_idx = i % num_blocks;
        const uint32_t local = i % cells_per_block;
        const uint32_t lx = local % SLAM_ACCEL_BLOCK_DIM_X;
        const uint32_t ly = (local / SLAM_ACCEL_BLOCK_DIM_X) % SLAM_ACCEL_BLOCK_DIM_Y;
        const uint32_t lz = local / (SLAM_ACCEL_BLOCK_DIM_X * SLAM_ACCEL_BLOCK_DIM_Y);
        const float x = static_cast<float>(block_idx * SLAM_ACCEL_BLOCK_DIM_X + lx) + 0.25f;
        const float y = static_cast<float>(ly) + 0.25f;
        const float z = static_cast<float>(lz) + 0.25f;
        golden.scan[i].x = x;
        golden.scan[i].y = y;
        golden.scan[i].z = z;
        golden.scan[i].intensity = 1.0f;

        ObsCellFloat64& cell = golden.cells[golden.blocks[block_idx].first_cell + local];
        cell.centroid_x = x;
        cell.centroid_y = y;
        cell.centroid_z = z;
        cell.normal_x = 0.0f;
        cell.normal_y = 0.0f;
        cell.normal_z = 1.0f;
        cell.plane_d = -z;
        cell.quality = 1.0f;
        cell.count = 8;
        cell.flags = OBS_CELL_VALID;
    }
}

bool RunSyntheticSweep() {
    const uint32_t point_counts[] = {256u, 512u, 1024u, 2048u, 4096u, 6963u};
    const uint32_t cell_counts[] = {16u * 1024u,  32u * 1024u,  64u * 1024u,  128u * 1024u,
                                    256u * 1024u, 512u * 1024u, 952064u};
    for (size_t p = 0; p < sizeof(point_counts) / sizeof(point_counts[0]); ++p) {
        for (size_t c = 0; c < sizeof(cell_counts) / sizeof(cell_counts[0]); ++c) {
            GoldenCase golden;
            FillSyntheticSweepCase(point_counts[p], cell_counts[c], golden);
            uint64_t actual_words[kOutputWords] = {};
            const auto start = std::chrono::steady_clock::now();
            unified_surfel_observation_core(golden.scan.data(), static_cast<uint32_t>(golden.scan.size()),
                                            &golden.pose, &golden.map_header,
                                            reinterpret_cast<const uint64_t*>(&golden.params), golden.blocks.data(),
                                            golden.cells.data(), actual_words);
            const auto end = std::chrono::steady_clock::now();
            const double elapsed_ms =
                std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start).count();
            const SlamNormalEquation actual = DecodeOutputWords(actual_words);
            const bool pass = actual.valid_count == point_counts[p] && actual.reject_count == 0 &&
                              actual.miss_count == 0;
            std::cout << "[obs_tb] synthetic_sweep scan_points=" << point_counts[p]
                      << " active_cells=" << cell_counts[c] << " elapsed_ms=" << elapsed_ms << " counts="
                      << actual.valid_count << "/" << actual.reject_count << "/" << actual.miss_count << " "
                      << FormatDebugCounters(actual_words) << std::endl;
            if (!pass) {
                return false;
            }
        }
    }
    std::cout << "[obs_tb] SYNTHETIC_SWEEP_PASS" << std::endl;
    return true;
}

}  // namespace

int main(int argc, char** argv) {
    const std::string golden_dir = argc > 1 ? argv[1] : "../../../golden/localization/frame_000001";
    bool run_synthetic_sweep = false;
    for (int i = 1; i < argc; ++i) {
        if (std::string(argv[i]) == "--synthetic-sweep") {
            run_synthetic_sweep = true;
        }
    }
    const int primary_result = RunGoldenCase(golden_dir);
    if (primary_result != 0) {
        return primary_result;
    }

    std::string mapping_dir = golden_dir;
    if (ReplaceFirst(mapping_dir, "\\localization\\", "\\mapping\\") ||
        ReplaceFirst(mapping_dir, "/localization/", "/mapping/")) {
        if (FileExists(JoinPath(mapping_dir, "map_scan.bin"))) {
            const int mapping_result = RunGoldenCase(mapping_dir);
            if (mapping_result != 0) {
                return mapping_result;
            }
        }
    }

    std::string reject_report;
    if (!RunRejectProbe(reject_report)) {
        std::cerr << "[obs_tb] " << reject_report << std::endl;
        return 3;
    }
    std::cout << "[obs_tb] " << reject_report << std::endl;
    std::string mapping_lookup_report;
    if (!RunMappingLookupProbe(mapping_lookup_report)) {
        std::cerr << "[obs_tb] " << mapping_lookup_report << std::endl;
        return 4;
    }
    std::cout << "[obs_tb] " << mapping_lookup_report << std::endl;
    if (run_synthetic_sweep && !RunSyntheticSweep()) {
        return 5;
    }
    std::cout << "[obs_tb] PASS " << golden_dir << std::endl;
    return 0;
}
