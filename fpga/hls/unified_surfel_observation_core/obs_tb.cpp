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

SlamNormalEquation DecodeOutputWords(const uint64_t words[kNormalEquationWords]) {
    SlamNormalEquation out;
    std::memcpy(&out, words, sizeof(out));
    return out;
}

uint32_t DebugLow32(uint64_t value) { return static_cast<uint32_t>(value & 0xFFFFffffULL); }

uint32_t DebugHigh32(uint64_t value) { return static_cast<uint32_t>(value >> 32); }

std::string FormatDebugCounters(const uint64_t words[kNormalEquationWords]) {
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

    uint64_t actual_words[kNormalEquationWords] = {};
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

    uint64_t actual_words[kNormalEquationWords] = {};
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

    uint64_t actual_words[kNormalEquationWords] = {};
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
            uint64_t actual_words[kNormalEquationWords] = {};
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
