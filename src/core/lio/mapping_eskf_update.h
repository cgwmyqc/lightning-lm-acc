// SPDX-License-Identifier: MIT
#pragma once

#include <functional>
#include <string>

#include "common/nav_state.h"
#include "core/lio/eskf.hpp"

namespace lightning::mapping_update {

struct UpdateParams {
    double R = 1.0;
    double degeneracy_threshold_ratio = 1e-3;
    double degeneracy_cov_inflation = 1.02;
    double min_cov_diag = 1e-9;
    double max_update_translation_step = 0.5;
    double max_update_rotation_step_deg = 5.0;
    ESKF::StateVecType limit = ESKF::StateVecType::Zero();
};

struct UpdateInput {
    NavState start_state;
    NavState current_state;
    ESKF::CovType propagated_cov = ESKF::CovType::Identity();
    Mat6d HTH = Mat6d::Zero();
    Vec6d HTr = Vec6d::Zero();
    ESKF::StateVecType dx_from_start = ESKF::StateVecType::Zero();
    UpdateParams params;
    int frame_index = 0;
    int iteration_index = 0;
    bool finish_update = true;
};

struct UpdateOutput {
    bool success = false;
    bool rejected = false;
    bool converged = false;
    bool covariance_finalized = false;
    int nullity = 0;
    std::string status;
    ESKF::StateVecType dx_current = ESKF::StateVecType::Zero();
    ESKF::StateVecType K_r = ESKF::StateVecType::Zero();
    ESKF::CovType K_H = ESKF::CovType::Zero();
    Mat6d HTH_eff = Mat6d::Zero();
    Vec6d HTr_eff = Vec6d::Zero();
    NavState updated_state;
    ESKF::CovType working_cov = ESKF::CovType::Identity();
    ESKF::CovType updated_cov = ESKF::CovType::Identity();
    double dx_translation = 0.0;
    double dx_rotation_deg = 0.0;
    double dx_norm = 0.0;
};

struct GoldenFrame {
    UpdateInput input;
    UpdateOutput expected;
};

using CaptureCallback = std::function<bool(const GoldenFrame&)>;

bool RunUpdateStep(const UpdateInput& input, UpdateOutput& output);

bool WriteGoldenFrame(const std::string& output_dir, const GoldenFrame& frame, const std::string& bag,
                      const std::string& config, std::string* error);
bool ReadGoldenFrame(const std::string& golden_dir, GoldenFrame& frame, std::string* error);
bool CompareUpdateOutput(const UpdateOutput& actual, const UpdateOutput& expected, double dx_abs_tol,
                         double cov_abs_tol, double state_abs_tol, std::string* report);

}  // namespace lightning::mapping_update
