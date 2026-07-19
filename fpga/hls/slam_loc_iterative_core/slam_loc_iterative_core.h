// SPDX-License-Identifier: MIT
#pragma once

#include <cstdint>

#include "fpga/abi/slam_accel_abi.h"

namespace lightning {
namespace fpga {

constexpr uint32_t SLAM_LOC_ITER_MAGIC = 0x4C495431u;  // "LIT1"
constexpr uint32_t SLAM_LOC_ITER_VERSION = 1u;

enum SlamLocIterStatus : uint32_t {
    SLAM_LOC_ITER_SUCCESS = 1u,
    SLAM_LOC_ITER_BAD_MAGIC = 2u,
    SLAM_LOC_ITER_INVALID_COUNT = 3u,
    SLAM_LOC_ITER_NO_VALID_OBSERVATION = 4u,
    SLAM_LOC_ITER_SOLVE_FAILED = 5u,
    SLAM_LOC_ITER_NON_FINITE = 6u,
};

enum SlamLocIterInputWord : uint32_t {
    LOC_ITER_IN_MAGIC_VERSION = 0u,
    LOC_ITER_IN_NUM_POINTS_MAX_ITERS = 1u,
    LOC_ITER_IN_RESIDUAL_OUTLIER_TH = 2u,
    LOC_ITER_IN_CONVERGENCE_TRANSLATION = 3u,
    LOC_ITER_IN_CONVERGENCE_ROTATION = 4u,
    LOC_ITER_IN_MIN_VALID_COUNT_RESERVED = 5u,
    LOC_ITER_IN_INITIAL_POSE_QX = 8u,
    LOC_ITER_IN_INITIAL_POSE_QY = 9u,
    LOC_ITER_IN_INITIAL_POSE_QZ = 10u,
    LOC_ITER_IN_INITIAL_POSE_QW = 11u,
    LOC_ITER_IN_INITIAL_POSE_TX = 12u,
    LOC_ITER_IN_INITIAL_POSE_TY = 13u,
    LOC_ITER_IN_INITIAL_POSE_TZ = 14u,
    LOC_ITER_INPUT_WORDS = 16u,
};

enum SlamLocIterOutputWord : uint32_t {
    LOC_ITER_OUT_MAGIC_VERSION = 0u,
    LOC_ITER_OUT_STATUS_FLAGS = 1u,
    LOC_ITER_OUT_ITERATIONS_COUNTS0 = 2u,
    LOC_ITER_OUT_COUNTS1 = 3u,
    LOC_ITER_OUT_FINAL_POSE_QX = 4u,
    LOC_ITER_OUT_FINAL_POSE_QY = 5u,
    LOC_ITER_OUT_FINAL_POSE_QZ = 6u,
    LOC_ITER_OUT_FINAL_POSE_QW = 7u,
    LOC_ITER_OUT_FINAL_POSE_TX = 8u,
    LOC_ITER_OUT_FINAL_POSE_TY = 9u,
    LOC_ITER_OUT_FINAL_POSE_TZ = 10u,
    LOC_ITER_OUT_LAST_DX0 = 11u,
    LOC_ITER_OUT_LAST_DX1 = 12u,
    LOC_ITER_OUT_LAST_DX2 = 13u,
    LOC_ITER_OUT_LAST_DX3 = 14u,
    LOC_ITER_OUT_LAST_DX4 = 15u,
    LOC_ITER_OUT_LAST_DX5 = 16u,
    LOC_ITER_OUT_RESIDUAL_SUM = 17u,
    LOC_ITER_OUT_RESIDUAL_ABS_SUM = 18u,
    LOC_ITER_OUT_RESIDUAL_MAX_ABS = 19u,
    LOC_ITER_OUT_SCORE = 20u,
    LOC_ITER_OUT_DEBUG0 = 21u,
    LOC_ITER_OUTPUT_WORDS = 32u,
};

}  // namespace fpga
}  // namespace lightning

extern "C" void slam_loc_iterative_core(const lightning::fpga::SlamAccelScanPoint* scan_points,
                                         const lightning::fpga::ObsCellFloat64* candidate_cells,
                                         const uint64_t* input_words, uint64_t* output_words);
