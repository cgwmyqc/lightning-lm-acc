// SPDX-License-Identifier: MIT
#pragma once

#include <string>

#include "common/nav_state.h"
#include "common/point_def.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"

namespace lightning::mapping_golden {

struct MappingGoldenFrame {
    CloudPtr scan_body;
    NavState state;
    Mat3d extrinsic_R = Mat3d::Identity();
    Vec3d extrinsic_t = Vec3d::Zero();
    loc::ActiveMapBuffer active_map;
    loc::LocNormalEquation expected_obs;
    int frame_index = 0;
    double timestamp = 0.0;
    int effect_feat_surf = 0;
    double plane_icp_weight = 1.0;
};

bool WriteSourceFrame(const std::string& output_dir, const MappingGoldenFrame& frame, const std::string& bag,
                      const std::string& config, std::string* error);
bool ReadSourceFrame(const std::string& source_dir, MappingGoldenFrame& frame, std::string* error);
bool WriteGoldenFrame(const std::string& output_dir, const MappingGoldenFrame& frame, std::string* error);
bool ReadGoldenFrame(const std::string& golden_dir, MappingGoldenFrame& frame, std::string* error);

bool ComputeMappingObservation(const CloudPtr& scan_body, const NavState& state, const Mat3d& extrinsic_R,
                               const Vec3d& extrinsic_t, const loc::ActiveMapBuffer& active_map,
                               double plane_icp_weight, loc::LocNormalEquation& out);

bool CompareNormalEquation(const loc::LocNormalEquation& actual, const loc::LocNormalEquation& expected,
                           double abs_tol, double rel_tol, std::string* report);

SE3 LidarPoseFromState(const NavState& state, const Mat3d& extrinsic_R, const Vec3d& extrinsic_t);

}  // namespace lightning::mapping_golden
