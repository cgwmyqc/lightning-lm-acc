// SPDX-License-Identifier: MIT

#include "slam_loc_iterative_core.h"

#include <cmath>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

namespace {

uint64_t Pack32(uint32_t lo, uint32_t hi) {
    return static_cast<uint64_t>(lo) | (static_cast<uint64_t>(hi) << 32);
}

uint64_t DoubleToBits(double value) {
    union {
        uint64_t u;
        double d;
    } v;
    v.d = value;
    return v.u;
}

double BitsToDouble(uint64_t bits) {
    union {
        uint64_t u;
        double d;
    } v;
    v.u = bits;
    return v.d;
}

uint32_t Low32(uint64_t v) {
    return static_cast<uint32_t>(v & 0xffffffffULL);
}

uint32_t High32(uint64_t v) {
    return static_cast<uint32_t>((v >> 32) & 0xffffffffULL);
}

bool Near(double a, double b, double abs_tol, double rel_tol) {
    const double diff = std::fabs(a - b);
    if (diff <= abs_tol) {
        return true;
    }
    return diff <= rel_tol * std::max(std::fabs(a), std::fabs(b));
}

bool FileExists(const std::string& path) {
    std::ifstream in(path.c_str(), std::ios::binary);
    return in.good();
}

std::string JoinPath(const std::string& dir, const std::string& name) {
    if (dir.empty()) {
        return name;
    }
    const char tail = dir[dir.size() - 1];
    if (tail == '/' || tail == '\\') {
        return dir + name;
    }
    return dir + "/" + name;
}

template <typename T>
bool ReadGoldenVector(const std::string& path, uint32_t expected_type, std::vector<T>& values,
                      std::string& error) {
    using namespace lightning::fpga;
    std::ifstream in(path.c_str(), std::ios::binary);
    if (!in) {
        error = "failed to open " + path;
        return false;
    }
    GoldenFileHeader header;
    in.read(reinterpret_cast<char*>(&header), sizeof(header));
    if (!in) {
        error = "failed to read header " + path;
        return false;
    }
    if (header.magic != SLAM_ACCEL_ABI_MAGIC || header.version != SLAM_ACCEL_GOLDEN_VERSION ||
        header.record_type != expected_type || header.record_bytes != sizeof(T)) {
        std::ostringstream ss;
        ss << "bad header " << path << " magic=0x" << std::hex << header.magic << std::dec
           << " version=" << header.version << " type=" << header.record_type
           << " record_bytes=" << header.record_bytes << " expected_type=" << expected_type
           << " expected_bytes=" << sizeof(T);
        error = ss.str();
        return false;
    }
    values.assign(header.record_count, T{});
    if (!values.empty()) {
        in.read(reinterpret_cast<char*>(values.data()), static_cast<std::streamsize>(values.size() * sizeof(T)));
        if (!in) {
            error = "failed to read payload " + path;
            return false;
        }
    }
    return true;
}

template <size_t N>
bool ReadGoldenWords(const std::string& path, uint32_t expected_type, uint64_t (&words)[N], std::string& error) {
    std::vector<uint64_t> values;
    if (!ReadGoldenVector(path, expected_type, values, error)) {
        return false;
    }
    if (values.size() != N) {
        std::ostringstream ss;
        ss << "bad word count " << path << " actual=" << values.size() << " expected=" << N;
        error = ss.str();
        return false;
    }
    for (size_t i = 0; i < N; ++i) {
        words[i] = values[i];
    }
    return true;
}

bool CheckCommonOutput(const uint64_t* output, const uint64_t* expected, double abs_tol, double rel_tol,
                       std::string& report) {
    using namespace lightning::fpga;
    double max_abs = 0.0;
    double max_rel = 0.0;
    std::string worst = "none";
    bool values_ok = true;

    auto check_double = [&](const std::string& name, uint32_t word) {
        const double actual = BitsToDouble(output[word]);
        const double exp = BitsToDouble(expected[word]);
        const double abs_err = std::fabs(actual - exp);
        const double rel_err = abs_err / std::max(1.0, std::fabs(exp));
        if (abs_err > max_abs) {
            max_abs = abs_err;
            worst = name;
        }
        if (rel_err > max_rel) {
            max_rel = rel_err;
        }
        if (!(abs_err <= abs_tol || rel_err <= rel_tol)) {
            values_ok = false;
        }
    };

    const bool status_ok = output[LOC_ITER_OUT_MAGIC_VERSION] == expected[LOC_ITER_OUT_MAGIC_VERSION] &&
                           output[LOC_ITER_OUT_STATUS_FLAGS] == expected[LOC_ITER_OUT_STATUS_FLAGS] &&
                           output[LOC_ITER_OUT_ITERATIONS_COUNTS0] == expected[LOC_ITER_OUT_ITERATIONS_COUNTS0] &&
                           output[LOC_ITER_OUT_COUNTS1] == expected[LOC_ITER_OUT_COUNTS1];

    check_double("pose_qx", LOC_ITER_OUT_FINAL_POSE_QX);
    check_double("pose_qy", LOC_ITER_OUT_FINAL_POSE_QY);
    check_double("pose_qz", LOC_ITER_OUT_FINAL_POSE_QZ);
    check_double("pose_qw", LOC_ITER_OUT_FINAL_POSE_QW);
    check_double("pose_tx", LOC_ITER_OUT_FINAL_POSE_TX);
    check_double("pose_ty", LOC_ITER_OUT_FINAL_POSE_TY);
    check_double("pose_tz", LOC_ITER_OUT_FINAL_POSE_TZ);
    for (uint32_t i = 0; i < 6u; ++i) {
        std::ostringstream name;
        name << "dx" << i;
        check_double(name.str(), LOC_ITER_OUT_LAST_DX0 + i);
    }
    check_double("residual_sum", LOC_ITER_OUT_RESIDUAL_SUM);
    check_double("residual_abs_sum", LOC_ITER_OUT_RESIDUAL_ABS_SUM);
    check_double("residual_max_abs", LOC_ITER_OUT_RESIDUAL_MAX_ABS);
    check_double("score", LOC_ITER_OUT_SCORE);

    const uint32_t actual_status = Low32(output[LOC_ITER_OUT_STATUS_FLAGS]);
    const uint32_t expected_status = Low32(expected[LOC_ITER_OUT_STATUS_FLAGS]);
    const uint32_t actual_flags = High32(output[LOC_ITER_OUT_STATUS_FLAGS]);
    const uint32_t expected_flags = High32(expected[LOC_ITER_OUT_STATUS_FLAGS]);
    const uint32_t actual_iterations = Low32(output[LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    const uint32_t expected_iterations = Low32(expected[LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    const uint32_t actual_valid = High32(output[LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    const uint32_t expected_valid = High32(expected[LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    const uint32_t actual_reject = Low32(output[LOC_ITER_OUT_COUNTS1]);
    const uint32_t expected_reject = Low32(expected[LOC_ITER_OUT_COUNTS1]);
    const uint32_t actual_miss = High32(output[LOC_ITER_OUT_COUNTS1]);
    const uint32_t expected_miss = High32(expected[LOC_ITER_OUT_COUNTS1]);

    std::ostringstream ss;
    ss << "status_ok=" << status_ok << " values_ok=" << values_ok << " max_abs=" << max_abs
       << " max_rel=" << max_rel << " worst_field=" << worst << " actual_status=" << actual_status
       << " expected_status=" << expected_status << " actual_flags=" << actual_flags
       << " expected_flags=" << expected_flags << " actual_iterations=" << actual_iterations
       << " expected_iterations=" << expected_iterations << " actual_counts=" << actual_valid << "/"
       << actual_reject << "/" << actual_miss << " expected_counts=" << expected_valid << "/"
       << expected_reject << "/" << expected_miss;
    report = ss.str();
    return status_ok && values_ok;
}

bool RunSyntheticSmoke() {
    using namespace lightning::fpga;

    std::vector<SlamAccelScanPoint> scan(2);
    scan[0].x = 0.0f;
    scan[0].y = 0.0f;
    scan[0].z = 0.0f;
    scan[1].x = 0.0f;
    scan[1].y = 0.0f;
    scan[1].z = 0.0f;

    std::vector<ObsCellFloat64> candidates(2);
    candidates[0].normal_x = 1.0f;
    candidates[0].plane_d = -1.0f;
    candidates[0].flags = OBS_CELL_VALID;
    candidates[1].normal_y = 1.0f;
    candidates[1].plane_d = 2.0f;
    candidates[1].flags = OBS_CELL_VALID;

    uint64_t input[LOC_ITER_INPUT_WORDS] = {0};
    uint64_t output[LOC_ITER_OUTPUT_WORDS] = {0};
    input[LOC_ITER_IN_MAGIC_VERSION] = Pack32(SLAM_LOC_ITER_MAGIC, SLAM_LOC_ITER_VERSION);
    input[LOC_ITER_IN_NUM_POINTS_MAX_ITERS] = Pack32(static_cast<uint32_t>(scan.size()), 4u);
    input[LOC_ITER_IN_RESIDUAL_OUTLIER_TH] = DoubleToBits(10.0);
    input[LOC_ITER_IN_CONVERGENCE_TRANSLATION] = DoubleToBits(1e-6);
    input[LOC_ITER_IN_CONVERGENCE_ROTATION] = DoubleToBits(1e-6);
    input[LOC_ITER_IN_MIN_VALID_COUNT_RESERVED] = Pack32(1u, 0u);
    input[LOC_ITER_IN_INITIAL_POSE_QX] = DoubleToBits(0.0);
    input[LOC_ITER_IN_INITIAL_POSE_QY] = DoubleToBits(0.0);
    input[LOC_ITER_IN_INITIAL_POSE_QZ] = DoubleToBits(0.0);
    input[LOC_ITER_IN_INITIAL_POSE_QW] = DoubleToBits(1.0);
    input[LOC_ITER_IN_INITIAL_POSE_TX] = DoubleToBits(0.0);
    input[LOC_ITER_IN_INITIAL_POSE_TY] = DoubleToBits(0.0);
    input[LOC_ITER_IN_INITIAL_POSE_TZ] = DoubleToBits(0.0);

    slam_loc_iterative_core(scan.data(), candidates.data(), input, output);

    const uint32_t out_magic = Low32(output[LOC_ITER_OUT_MAGIC_VERSION]);
    const uint32_t out_version = High32(output[LOC_ITER_OUT_MAGIC_VERSION]);
    const uint32_t status = Low32(output[LOC_ITER_OUT_STATUS_FLAGS]);
    const uint32_t iterations = Low32(output[LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    const uint32_t valid = High32(output[LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    const uint32_t reject = Low32(output[LOC_ITER_OUT_COUNTS1]);
    const uint32_t miss = High32(output[LOC_ITER_OUT_COUNTS1]);
    const double tx = BitsToDouble(output[LOC_ITER_OUT_FINAL_POSE_TX]);
    const double ty = BitsToDouble(output[LOC_ITER_OUT_FINAL_POSE_TY]);
    const double tz = BitsToDouble(output[LOC_ITER_OUT_FINAL_POSE_TZ]);

    bool ok = true;
    ok = ok && out_magic == SLAM_LOC_ITER_MAGIC && out_version == SLAM_LOC_ITER_VERSION;
    ok = ok && status == SLAM_LOC_ITER_SUCCESS;
    ok = ok && iterations <= 4u && iterations >= 2u;
    ok = ok && valid == 2u && reject == 0u && miss == 0u;
    ok = ok && Near(tx, 1.0, 1e-5, 1e-6);
    ok = ok && Near(ty, -2.0, 1e-5, 1e-6);
    ok = ok && Near(tz, 0.0, 1e-9, 1e-6);

    if (!ok) {
        std::cerr << "LOC_ITER_SYNTHETIC_CSIM_FAIL"
                  << " magic=0x" << std::hex << out_magic
                  << " version=" << std::dec << out_version
                  << " status=" << status
                  << " iterations=" << iterations
                  << " counts=" << valid << "/" << reject << "/" << miss
                  << " pose_t=" << tx << "," << ty << "," << tz << "\n";
        return false;
    }

    std::cout << "LOC_ITER_FINAL_POSE_MATCH tx=" << tx << " ty=" << ty << " tz=" << tz << "\n";
    std::cout << "LOC_ITER_ITERATIONS_MATCH iterations=" << iterations << "\n";
    std::cout << "LOC_ITER_COUNTS_MATCH counts=" << valid << "/" << reject << "/" << miss << "\n";
    std::cout << "LOC_ITER_SYNTHETIC_CSIM_PASS\n";
    return true;
}

bool RunRealGolden(const std::string& golden_dir) {
    using namespace lightning::fpga;

    std::string error;
    std::vector<SlamAccelScanPoint> scan;
    std::vector<ObsCellFloat64> candidates;
    uint64_t input[LOC_ITER_INPUT_WORDS] = {0};
    uint64_t expected[LOC_ITER_OUTPUT_WORDS] = {0};
    uint64_t output[LOC_ITER_OUTPUT_WORDS] = {0};

    if (!ReadGoldenVector(JoinPath(golden_dir, "loc_iter_scan.bin"), GOLDEN_SCAN_POINTS, scan, error) ||
        !ReadGoldenVector(JoinPath(golden_dir, "loc_iter_candidates.bin"), GOLDEN_LOC_ITER_CANDIDATE_CELLS, candidates,
                          error) ||
        !ReadGoldenWords(JoinPath(golden_dir, "loc_iter_input.bin"), GOLDEN_LOC_ITER_INPUT_WORDS, input, error) ||
        !ReadGoldenWords(JoinPath(golden_dir, "loc_iter_expected.bin"), GOLDEN_LOC_ITER_OUTPUT_WORDS, expected, error)) {
        std::cerr << "LOC_ITER_REAL_GOLDEN_LOAD_FAIL " << error << "\n";
        return false;
    }

    const uint32_t num_points = Low32(input[LOC_ITER_IN_NUM_POINTS_MAX_ITERS]);
    if (scan.size() != candidates.size() || scan.size() != num_points) {
        std::cerr << "LOC_ITER_REAL_GOLDEN_LOAD_FAIL size_mismatch"
                  << " scan=" << scan.size() << " candidates=" << candidates.size()
                  << " input_num_points=" << num_points << "\n";
        return false;
    }

    std::cout << "LOC_ITER_REAL_GOLDEN_LOAD_PASS scan_count=" << scan.size()
              << " candidate_count=" << candidates.size() << "\n";

    slam_loc_iterative_core(scan.data(), candidates.data(), input, output);

    std::string report;
    if (!CheckCommonOutput(output, expected, 1e-7, 1e-5, report)) {
        std::cerr << "LOC_ITER_REAL_GOLDEN_NUMERIC_FAIL " << report << "\n";
        return false;
    }

    std::cout << "LOC_ITER_REAL_GOLDEN_NUMERIC_PASS " << report << "\n";
    return true;
}

}  // namespace

int main(int argc, char** argv) {
    using namespace lightning::fpga;

    if (!RunSyntheticSmoke()) {
        return 1;
    }

    if (argc >= 2) {
        const std::string golden_dir = argv[1];
        if (FileExists(JoinPath(golden_dir, "loc_iter_meta.yaml")) && !RunRealGolden(golden_dir)) {
            return 1;
        }
    }

    std::cout << "LOC_ITER_GPP_CSIM_PASS\n";
    return 0;
}
