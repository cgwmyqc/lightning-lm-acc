// SPDX-License-Identifier: MIT
#pragma once

#include <string>

#include "common/point_def.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"

namespace lightning::loc::golden {

struct LocalizationGolden {
    CloudPtr scan_body;
    SE3 pose_guess;
    ActiveMapBuffer active_map;
    LocNormalEquation expected_obs;
};

fpga::SlamAccelPose ToAbiPose(const SE3& pose);
SE3 FromAbiPose(const fpga::SlamAccelPose& pose);
fpga::SlamNormalEquation ToAbiNormalEquation(const LocNormalEquation& equation);
LocNormalEquation FromAbiNormalEquation(const fpga::SlamNormalEquation& equation);

bool WriteLocalizationGolden(const std::string& dir, const CloudPtr& scan_body, const SE3& pose_guess,
                             const ActiveMapBuffer& active_map, const LocNormalEquation& expected_obs,
                             const SurfelLocOptions& options, std::string* error = nullptr);

bool ReadLocalizationGolden(const std::string& dir, LocalizationGolden& golden, std::string* error = nullptr);

bool CompareNormalEquation(const LocNormalEquation& actual, const LocNormalEquation& expected, double abs_tol,
                           double rel_tol, std::string* report = nullptr);

}  // namespace lightning::loc::golden
