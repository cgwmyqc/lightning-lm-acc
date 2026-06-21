// SPDX-License-Identifier: MIT
#pragma once

#include <Eigen/Core>
#include <atomic>
#include <cstdint>
#include <memory>
#include <unordered_map>
#include <vector>

#include "common/eigen_types.h"
#include "common/point_def.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"

namespace lightning {

struct BlockGeom {
    static constexpr int BX = 8;
    static constexpr int BY = 8;
    static constexpr int BZ = 4;
    static constexpr int CELLS_PER_BLOCK = BX * BY * BZ;

    static inline int LocalCellIndex(int lx, int ly, int lz) noexcept {
        return (lz * BY + ly) * BX + lx;
    }
};

enum CellFlag : uint32_t {
    FLAG_DIRTY = 1u << 0,
    FLAG_VALID_SURFEL = 1u << 1,
};

struct alignas(64) VoxelCell {
    uint32_t count = 0;
    uint32_t flags = 0;
    float sum[3] = {0, 0, 0};
    float scatter[6] = {0, 0, 0, 0, 0, 0};
    float nx = 0, ny = 0, nz = 0;
    float d = 0;
    float quality = 0;
    uint32_t last_update_frame = 0;
    float _pad[15] = {0};
};
static_assert(sizeof(VoxelCell) == 128, "VoxelCell must be exactly 128B");

struct alignas(64) VoxelBlock {
    int64_t morton_key = 0;
    uint32_t version = 0;
    uint32_t valid_cell_count = 0;
    VoxelCell cells[BlockGeom::CELLS_PER_BLOCK];
};

struct BlockKey {
    int32_t x = 0, y = 0, z = 0;
    bool operator==(const BlockKey& rhs) const noexcept { return x == rhs.x && y == rhs.y && z == rhs.z; }
};

struct BlockKeyHash {
    size_t operator()(const BlockKey& k) const noexcept {
        uint64_t h = static_cast<uint64_t>(k.x) * 73856093u;
        h ^= static_cast<uint64_t>(k.y) * 19349663u;
        h ^= static_cast<uint64_t>(k.z) * 83492791u;
        return static_cast<size_t>(h);
    }
};

enum class SurfelMissReason : uint8_t {
    NONE = 0,
    NO_BLOCK,
    EMPTY_CELL,
    SUPPORT_LOW,
    QUALITY_BAD,
};

struct SurfelLookupStats {
    uint64_t miss_no_block = 0;
    uint64_t miss_empty_cell = 0;
    uint64_t miss_support_low = 0;
    uint64_t miss_quality_bad = 0;
    uint64_t hit_exact = 0;
    uint64_t hit_neighbor = 0;

    void Add(const SurfelLookupStats& rhs) {
        miss_no_block += rhs.miss_no_block;
        miss_empty_cell += rhs.miss_empty_cell;
        miss_support_low += rhs.miss_support_low;
        miss_quality_bad += rhs.miss_quality_bad;
        hit_exact += rhs.hit_exact;
        hit_neighbor += rhs.hit_neighbor;
    }
};

struct SurfelCorrespondence {
    bool valid = false;
    bool fallback = false;
    bool hit_neighbor = false;
    int neighbor_level = 0;
    SurfelMissReason miss_reason = SurfelMissReason::NONE;
    Vec4f plane = Vec4f::Zero();
    Vec3f centroid = Vec3f::Zero();
    float quality = 0;
    uint32_t count = 0;
};

struct BlockSurfelMapOptions {
    float cell_resolution = 0.5f;
    int min_support = 5;
    float quality_max = 0.05f;
    size_t block_capacity = 65536;
    int lookup_nearby_type = 26;
};

class BlockSurfelMap {
   public:
    explicit BlockSurfelMap(const BlockSurfelMapOptions& options);

    void BatchUpdate(const PointVector& points_world);
    void Initialize(const PointVector& points_world) { BatchUpdate(points_world); }
    bool LookupSurfel(const PointType& pt_world, SurfelCorrespondence& out) const;
    void RecomputeDirtySurfels();

    void EnqueueFallback(const PointType& pt_world);
    size_t FallbackCount() const { return fallback_count_.load(std::memory_order_relaxed); }
    void ResetFallbackCount() { fallback_count_.store(0, std::memory_order_relaxed); }

    size_t NumBlocks() const { return blocks_.size(); }
    size_t NumValidCells() const;
    size_t NumValidSurfels() const;
    const BlockSurfelMapOptions& Options() const { return options_; }
    void ExportCentroidCloud(PointVector& out) const;
    bool ExportActiveMap(loc::ActiveMapBuffer& out) const;

   private:
    void EncodeGrid(const Vec3f& p, int& gx, int& gy, int& gz) const noexcept;
    void GridToBlockCell(int gx, int gy, int gz, BlockKey& block_key, int& cell_idx) const noexcept;
    void Encode(const Vec3f& p, BlockKey& block_key, int& cell_idx) const noexcept;
    bool TryCell(const PointType& pt_world, const BlockKey& block_key, int cell_idx, int neighbor_level,
                 SurfelCorrespondence& candidate, SurfelMissReason& miss_reason) const;
    VoxelBlock& GetOrCreateBlock(const BlockKey& key);
    static void FitSurfel(VoxelCell& cell, float quality_max);

    BlockSurfelMapOptions options_;
    float inv_resolution_ = 0.0f;
    std::unordered_map<BlockKey, std::unique_ptr<VoxelBlock>, BlockKeyHash> blocks_;
    uint32_t current_frame_ = 0;
    mutable std::atomic<size_t> fallback_count_{0};
};

}  // namespace lightning
