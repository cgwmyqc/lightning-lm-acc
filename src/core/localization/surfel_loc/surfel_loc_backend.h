// SPDX-License-Identifier: MIT
#pragma once

#include "common/point_def.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"

namespace lightning::loc {

class SurfelLocBackend {
   public:
    explicit SurfelLocBackend(SurfelLocOptions options = SurfelLocOptions());

    void SetOptions(const SurfelLocOptions& options) { options_ = options; }

    bool ComputeObservation(const CloudPtr& scan_body, const SE3& pose_guess, const ActiveMapBuffer& map,
                            LocNormalEquation& out) const;

    bool Align(const CloudPtr& scan_body, const SE3& init_pose, const ActiveMapBuffer& map, SE3& pose_out,
               LocQuality& quality_out) const;

   private:
    struct EncodedCell {
        int32_t block_x = 0;
        int32_t block_y = 0;
        int32_t block_z = 0;
        int32_t cell_idx = 0;
    };

    EncodedCell Encode(const Vec3d& point_world, const ActiveMapBuffer& map) const;
    const ObsCellFloat64* LookupCell(const ActiveMapBuffer& map, const EncodedCell& encoded) const;
    bool TryLookupNearest(const ActiveMapBuffer& map, const Vec3d& point_world, const ObsCellFloat64*& cell) const;

    SurfelLocOptions options_;
};

}  // namespace lightning::loc
