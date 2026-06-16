// SPDX-License-Identifier: MIT

#include "unified_surfel_observation_core.h"

#include <cmath>
#include <cstdint>
#include <algorithm>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace {

using namespace lightning::fpga;
using namespace lightning::fpga::hls;

std::string JoinPath(const std::string& dir, const std::string& name) {
    const char last = dir.empty() ? '/' : dir[dir.size() - 1];
    return (last == '/' || last == '\\') ? dir + name : dir + "/" + name;
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

bool ReadPose(const std::string& dir, SlamAccelPose& pose, std::string& error) {
    std::vector<SlamAccelPose> poses;
    if (!ReadVectorFile(JoinPath(dir, "loc_pose.bin"), GOLDEN_POSE, poses, error) || poses.size() != 1) {
        if (error.empty()) {
            error = "loc_pose.bin must contain exactly one pose";
        }
        return false;
    }
    pose = poses[0];
    return true;
}

bool ReadExpected(const std::string& dir, SlamNormalEquation& expected, std::string& error) {
    std::vector<SlamNormalEquation> equations;
    if (!ReadVectorFile(JoinPath(dir, "loc_expected_obs.bin"), GOLDEN_NORMAL_EQUATION, equations, error) ||
        equations.size() != 1) {
        if (error.empty()) {
            error = "loc_expected_obs.bin must contain exactly one equation";
        }
        return false;
    }
    expected = equations[0];
    return true;
}

bool ReadActiveMap(const std::string& dir, ActiveMapHeader& map_header, std::vector<ActiveBlockRecord>& blocks,
                   std::vector<ObsCellFloat64>& cells, std::string& error) {
    const std::string path = JoinPath(dir, "loc_active_map.bin");
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

}  // namespace

int main(int argc, char** argv) {
    const std::string golden_dir = argc > 1 ? argv[1] : "../../../golden/localization/frame_000001";
    std::string error;

    std::vector<SlamAccelScanPoint> scan;
    SlamAccelPose pose;
    ActiveMapHeader map_header;
    std::vector<ActiveBlockRecord> blocks;
    std::vector<ObsCellFloat64> cells;
    SlamNormalEquation expected;

    if (!ReadVectorFile(JoinPath(golden_dir, "loc_scan.bin"), GOLDEN_SCAN_POINTS, scan, error) ||
        !ReadPose(golden_dir, pose, error) || !ReadActiveMap(golden_dir, map_header, blocks, cells, error) ||
        !ReadExpected(golden_dir, expected, error)) {
        std::cerr << "[obs_tb] " << error << std::endl;
        return 1;
    }

    SlamNormalEquation actual;
    unified_surfel_observation_core(scan.data(), static_cast<uint32_t>(scan.size()), &pose, &map_header, blocks.data(),
                                    cells.data(), &actual);

    std::string report;
    const bool pass = CompareEquation(actual, expected, 1e-4, 1e-3, report);
    std::cout << "[obs_tb] " << report << std::endl;
    if (!pass) {
        return 2;
    }
    std::cout << "[obs_tb] PASS " << golden_dir << std::endl;
    return 0;
}
