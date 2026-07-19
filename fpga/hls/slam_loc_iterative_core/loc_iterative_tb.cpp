// SPDX-License-Identifier: MIT

#include "slam_loc_iterative_core.h"

#include <cmath>
#include <cstdint>
#include <iostream>
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

}  // namespace

int main(int argc, char** argv) {
    (void)argc;
    (void)argv;
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
        std::cerr << "LOC_ITER_CSIM_FAIL"
                  << " magic=0x" << std::hex << out_magic
                  << " version=" << std::dec << out_version
                  << " status=" << status
                  << " iterations=" << iterations
                  << " counts=" << valid << "/" << reject << "/" << miss
                  << " pose_t=" << tx << "," << ty << "," << tz << "\n";
        return 1;
    }

    std::cout << "LOC_ITER_FINAL_POSE_MATCH tx=" << tx << " ty=" << ty << " tz=" << tz << "\n";
    std::cout << "LOC_ITER_ITERATIONS_MATCH iterations=" << iterations << "\n";
    std::cout << "LOC_ITER_COUNTS_MATCH counts=" << valid << "/" << reject << "/" << miss << "\n";
    std::cout << "LOC_ITER_GPP_CSIM_PASS\n";
    return 0;
}
