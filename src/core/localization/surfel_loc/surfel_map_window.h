// SPDX-License-Identifier: MIT
#pragma once

#include <memory>

#include "common/point_def.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"

namespace lightning::loc {

class SurfelMapWindow {
   public:
    explicit SurfelMapWindow(SurfelLocOptions options = SurfelLocOptions());

    void SetOptions(const SurfelLocOptions& options);
    bool BuildFromCloud(const CloudPtr& cloud);
    const ActiveMapBuffer& Buffer() const { return buffer_; }

   private:
    struct BlockKey {
        int32_t x = 0;
        int32_t y = 0;
        int32_t z = 0;

        bool operator==(const BlockKey& rhs) const { return x == rhs.x && y == rhs.y && z == rhs.z; }
    };

    struct BlockKeyHash {
        size_t operator()(const BlockKey& key) const;
    };

    struct CellAccum {
        uint32_t count = 0;
        double sum[3] = {0.0, 0.0, 0.0};
        double scatter[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    };

    struct TempBlock {
        CellAccum cells[256];
    };

    void Encode(const Vec3f& point, BlockKey& block_key, int& cell_idx) const;
    bool FitCell(const CellAccum& accum, ObsCellFloat64& out) const;

    SurfelLocOptions options_;
    ActiveMapBuffer buffer_;
    uint32_t next_window_id_ = 1;
};

}  // namespace lightning::loc
