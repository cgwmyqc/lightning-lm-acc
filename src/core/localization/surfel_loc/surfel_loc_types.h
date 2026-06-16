// SPDX-License-Identifier: MIT
#pragma once

#include <cstdint>
#include <vector>

#include "common/eigen_types.h"
#include "fpga/abi/slam_accel_abi.h"

namespace lightning::loc {

enum class LocBackendType {
    NDT_OMP = 0,
    SURFEL_CPU_SIM,
    SURFEL_FPGA_OBS,
    SURFEL_FPGA_OBS_SOLVE,
    SURFEL_FPGA_WITH_NDT_FALLBACK,
};

using ObsCellFloat64 = fpga::ObsCellFloat64;
using ActiveBlockRecord = fpga::ActiveBlockRecord;

struct ActiveMapBuffer {
    float cell_resolution = 0.5f;
    float inv_cell_resolution = 2.0f;
    uint32_t window_id = 0;
    uint32_t version = 0;
    uint32_t cells_per_block = fpga::SLAM_ACCEL_CELLS_PER_BLOCK;
    uint32_t lookup_nearby_type = 26;
    std::vector<ActiveBlockRecord> blocks;
    std::vector<ObsCellFloat64> cells;

    void Clear() {
        blocks.clear();
        cells.clear();
    }

    bool Empty() const { return blocks.empty() || cells.empty(); }
};

struct LocNormalEquation {
    Mat6d hessian = Mat6d::Zero();
    Vec6d gradient = Vec6d::Zero();
    uint32_t valid_count = 0;
    uint32_t reject_count = 0;
    uint32_t miss_count = 0;
    double residual_sum = 0.0;
    double residual_abs_sum = 0.0;
    double residual_max_abs = 0.0;

    void Reset() {
        hessian.setZero();
        gradient.setZero();
        valid_count = 0;
        reject_count = 0;
        miss_count = 0;
        residual_sum = 0.0;
        residual_abs_sum = 0.0;
        residual_max_abs = 0.0;
    }
};

struct LocQuality {
    bool converged = false;
    bool matrix_ok = false;
    uint32_t iterations = 0;
    uint32_t valid_count = 0;
    uint32_t reject_count = 0;
    uint32_t miss_count = 0;
    double mean_residual = 0.0;
    double mean_abs_residual = 0.0;
    double max_abs_residual = 0.0;
    double score = 0.0;
    uint32_t active_window_id = 0;
    uint32_t active_window_version = 0;
};

struct SurfelLocOptions {
    float cell_resolution = 0.8f;
    int min_support = 3;
    float quality_max = 0.05f;
    int lookup_nearby_type = 26;
    int max_iterations = 4;
    int min_valid_count = 300;
    double max_mean_residual = 0.2;
    double residual_outlier_th = 0.3;
    double convergence_translation = 0.005;
    double convergence_rotation = 0.001;
};

}  // namespace lightning::loc
