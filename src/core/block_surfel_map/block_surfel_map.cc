// SPDX-License-Identifier: MIT

#include "core/block_surfel_map/block_surfel_map.h"

#include <algorithm>
#include <cmath>
#include <execution>

#include <glog/logging.h>

namespace lightning {
namespace {

int DivFloor(int a, int b) {
    int q = a / b;
    int r = a - q * b;
    if ((r != 0) && ((r < 0) != (b < 0))) {
        --q;
    }
    return q;
}

int ModFloor(int a, int b) {
    int r = a % b;
    if ((r != 0) && ((r < 0) != (b < 0))) {
        r += b;
    }
    return r;
}

int MissReasonRank(SurfelMissReason reason) {
    switch (reason) {
        case SurfelMissReason::QUALITY_BAD:
            return 4;
        case SurfelMissReason::SUPPORT_LOW:
            return 3;
        case SurfelMissReason::EMPTY_CELL:
            return 2;
        case SurfelMissReason::NO_BLOCK:
            return 1;
        case SurfelMissReason::NONE:
        default:
            return 0;
    }
}

bool BetterCandidate(const SurfelCorrespondence& lhs, const SurfelCorrespondence& rhs, const PointType& pt_world) {
    const Vec4f p4(pt_world.x, pt_world.y, pt_world.z, 1.0f);
    const float lhs_res = std::fabs(lhs.plane.dot(p4));
    const float rhs_res = std::fabs(rhs.plane.dot(p4));
    if (std::fabs(lhs_res - rhs_res) > 1e-4f) {
        return lhs_res < rhs_res;
    }

    const Vec3f p3 = pt_world.getVector3fMap();
    const float lhs_dist = (lhs.centroid - p3).squaredNorm();
    const float rhs_dist = (rhs.centroid - p3).squaredNorm();
    if (std::fabs(lhs_dist - rhs_dist) > 1e-4f) {
        return lhs_dist < rhs_dist;
    }

    return lhs.quality < rhs.quality;
}

}  // namespace

BlockSurfelMap::BlockSurfelMap(const BlockSurfelMapOptions& options) : options_(options) {
    CHECK_GT(options_.cell_resolution, 0.0f);
    if (options_.lookup_nearby_type != 0 && options_.lookup_nearby_type != 6 && options_.lookup_nearby_type != 18 &&
        options_.lookup_nearby_type != 26) {
        LOG(WARNING) << "Unknown surfel lookup_nearby_type " << options_.lookup_nearby_type << ", fallback to 26";
        options_.lookup_nearby_type = 26;
    }
    inv_resolution_ = 1.0f / options_.cell_resolution;
    LOG(INFO) << "[BlockSurfelMap] cell_resolution=" << options_.cell_resolution
              << " cells_per_block=" << BlockGeom::CELLS_PER_BLOCK << " min_support=" << options_.min_support
              << " quality_max=" << options_.quality_max << " block_capacity=" << options_.block_capacity
              << " lookup_nearby_type=" << options_.lookup_nearby_type;
}

void BlockSurfelMap::EncodeGrid(const Vec3f& p, int& gx, int& gy, int& gz) const noexcept {
    gx = static_cast<int>(std::floor(p.x() * inv_resolution_));
    gy = static_cast<int>(std::floor(p.y() * inv_resolution_));
    gz = static_cast<int>(std::floor(p.z() * inv_resolution_));
}

void BlockSurfelMap::GridToBlockCell(int gx, int gy, int gz, BlockKey& block_key, int& cell_idx) const noexcept {
    block_key.x = DivFloor(gx, BlockGeom::BX);
    block_key.y = DivFloor(gy, BlockGeom::BY);
    block_key.z = DivFloor(gz, BlockGeom::BZ);

    cell_idx = BlockGeom::LocalCellIndex(ModFloor(gx, BlockGeom::BX), ModFloor(gy, BlockGeom::BY),
                                         ModFloor(gz, BlockGeom::BZ));
}

void BlockSurfelMap::Encode(const Vec3f& p, BlockKey& block_key, int& cell_idx) const noexcept {
    int gx = 0, gy = 0, gz = 0;
    EncodeGrid(p, gx, gy, gz);
    GridToBlockCell(gx, gy, gz, block_key, cell_idx);
}

VoxelBlock& BlockSurfelMap::GetOrCreateBlock(const BlockKey& key) {
    auto it = blocks_.find(key);
    if (it != blocks_.end()) {
        return *it->second;
    }
    if (blocks_.size() >= options_.block_capacity && !blocks_.empty()) {
        blocks_.erase(blocks_.begin());
    }

    auto block = std::make_unique<VoxelBlock>();
    block->morton_key = (static_cast<int64_t>(key.z) << 42) |
                        (static_cast<int64_t>(key.y & 0x1FFFFF) << 21) |
                        static_cast<int64_t>(key.x & 0x1FFFFF);
    auto* ptr = block.get();
    blocks_.emplace(key, std::move(block));
    return *ptr;
}

void BlockSurfelMap::FitSurfel(VoxelCell& c, float quality_max) {
    if (c.count < 3) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        return;
    }

    const float inv_n = 1.0f / static_cast<float>(c.count);
    const float cx = c.sum[0] * inv_n;
    const float cy = c.sum[1] * inv_n;
    const float cz = c.sum[2] * inv_n;

    float A[3][3];
    A[0][0] = c.scatter[0] * inv_n - cx * cx;
    A[0][1] = c.scatter[1] * inv_n - cx * cy;
    A[0][2] = c.scatter[2] * inv_n - cx * cz;
    A[1][0] = A[0][1];
    A[1][1] = c.scatter[3] * inv_n - cy * cy;
    A[1][2] = c.scatter[4] * inv_n - cy * cz;
    A[2][0] = A[0][2];
    A[2][1] = A[1][2];
    A[2][2] = c.scatter[5] * inv_n - cz * cz;

    float V[3][3] = {{1, 0, 0}, {0, 1, 0}, {0, 0, 1}};
    for (int sweep = 0; sweep < 8; ++sweep) {
        for (int pq = 0; pq < 3; ++pq) {
            int p = pq == 2 ? 1 : 0;
            int q = pq == 0 ? 1 : 2;
            float apq = A[p][q];
            if (std::fabs(apq) < 1e-20f) {
                continue;
            }
            const float app = A[p][p];
            const float aqq = A[q][q];
            const float diff = aqq - app;
            float t = 0.0f;
            if (std::fabs(diff) > 1e6f * std::fabs(apq)) {
                t = apq / diff;
            } else {
                float theta = 0.5f * diff / apq;
                t = 1.0f / (std::fabs(theta) + std::sqrt(1.0f + theta * theta));
                if (theta < 0.0f) {
                    t = -t;
                }
            }
            const float cs = 1.0f / std::sqrt(1.0f + t * t);
            const float sn = t * cs;

            A[p][p] = app - t * apq;
            A[q][q] = aqq + t * apq;
            A[p][q] = 0;
            A[q][p] = 0;
            for (int i = 0; i < 3; ++i) {
                if (i == p || i == q) {
                    continue;
                }
                const float aip = A[i][p];
                const float aiq = A[i][q];
                A[i][p] = cs * aip - sn * aiq;
                A[i][q] = sn * aip + cs * aiq;
                A[p][i] = A[i][p];
                A[q][i] = A[i][q];
            }
            for (int i = 0; i < 3; ++i) {
                const float vip = V[i][p];
                const float viq = V[i][q];
                V[i][p] = cs * vip - sn * viq;
                V[i][q] = sn * vip + cs * viq;
            }
        }
    }

    float eigen_values[3] = {A[0][0], A[1][1], A[2][2]};
    int min_idx = 0;
    if (eigen_values[1] < eigen_values[min_idx]) min_idx = 1;
    if (eigen_values[2] < eigen_values[min_idx]) min_idx = 2;

    const float trace = eigen_values[0] + eigen_values[1] + eigen_values[2];
    if (trace < 1e-12f) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        return;
    }
    const float quality = eigen_values[min_idx] / trace;
    if (quality > quality_max) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        c.quality = quality;
        return;
    }

    float nx = V[0][min_idx];
    float ny = V[1][min_idx];
    float nz = V[2][min_idx];
    const float nrm = std::sqrt(nx * nx + ny * ny + nz * nz);
    if (nrm < 1e-12f) {
        c.flags &= ~FLAG_VALID_SURFEL;
        c.flags &= ~FLAG_DIRTY;
        return;
    }
    nx /= nrm;
    ny /= nrm;
    nz /= nrm;

    c.nx = nx;
    c.ny = ny;
    c.nz = nz;
    c.d = -(nx * cx + ny * cy + nz * cz);
    c.quality = quality;
    c.flags |= FLAG_VALID_SURFEL;
    c.flags &= ~FLAG_DIRTY;
}

void BlockSurfelMap::BatchUpdate(const PointVector& points_world) {
    if (points_world.empty()) {
        return;
    }
    ++current_frame_;

    struct Entry {
        BlockKey block_key;
        int cell_idx = 0;
        size_t point_idx = 0;
        size_t block_hash = 0;
    };

    BlockKeyHash hasher;
    std::vector<Entry> entries(points_world.size());
    for (size_t i = 0; i < points_world.size(); ++i) {
        entries[i].point_idx = i;
        Encode(points_world[i].getVector3fMap(), entries[i].block_key, entries[i].cell_idx);
        entries[i].block_hash = hasher(entries[i].block_key);
    }

    std::sort(entries.begin(), entries.end(), [](const Entry& a, const Entry& b) {
        if (a.block_hash != b.block_hash) return a.block_hash < b.block_hash;
        if (!(a.block_key == b.block_key)) {
            if (a.block_key.x != b.block_key.x) return a.block_key.x < b.block_key.x;
            if (a.block_key.y != b.block_key.y) return a.block_key.y < b.block_key.y;
            return a.block_key.z < b.block_key.z;
        }
        return a.cell_idx < b.cell_idx;
    });

    size_t i = 0;
    while (i < entries.size()) {
        const BlockKey block_key = entries[i].block_key;
        VoxelBlock& block = GetOrCreateBlock(block_key);
        while (i < entries.size() && entries[i].block_key == block_key) {
            const PointType& p = points_world[entries[i].point_idx];
            VoxelCell& c = block.cells[entries[i].cell_idx];
            if (c.count == 0) {
                ++block.valid_cell_count;
            }
            ++c.count;
            c.sum[0] += p.x;
            c.sum[1] += p.y;
            c.sum[2] += p.z;
            c.scatter[0] += p.x * p.x;
            c.scatter[1] += p.x * p.y;
            c.scatter[2] += p.x * p.z;
            c.scatter[3] += p.y * p.y;
            c.scatter[4] += p.y * p.z;
            c.scatter[5] += p.z * p.z;
            c.flags |= FLAG_DIRTY;
            c.last_update_frame = current_frame_;
            ++i;
        }
        ++block.version;
    }

    RecomputeDirtySurfels();
}

void BlockSurfelMap::RecomputeDirtySurfels() {
    std::vector<VoxelBlock*> blocks;
    blocks.reserve(blocks_.size());
    for (auto& kv : blocks_) {
        blocks.push_back(kv.second.get());
    }

    const int min_support = options_.min_support;
    const float quality_max = options_.quality_max;
    std::for_each(std::execution::par_unseq, blocks.begin(), blocks.end(), [min_support, quality_max](VoxelBlock* b) {
        for (int i = 0; i < BlockGeom::CELLS_PER_BLOCK; ++i) {
            VoxelCell& c = b->cells[i];
            if (!(c.flags & FLAG_DIRTY)) {
                continue;
            }
            if (c.count < static_cast<uint32_t>(min_support)) {
                c.flags &= ~FLAG_DIRTY;
                c.flags &= ~FLAG_VALID_SURFEL;
                continue;
            }
            FitSurfel(c, quality_max);
        }
    });
}

bool BlockSurfelMap::LookupSurfel(const PointType& pt_world, SurfelCorrespondence& out) const {
    int gx = 0, gy = 0, gz = 0;
    EncodeGrid(pt_world.getVector3fMap(), gx, gy, gz);

    BlockKey block_key;
    int cell_idx = 0;
    GridToBlockCell(gx, gy, gz, block_key, cell_idx);

    SurfelMissReason best_miss = SurfelMissReason::NONE;
    SurfelCorrespondence exact;
    SurfelMissReason exact_miss = SurfelMissReason::NONE;
    if (TryCell(pt_world, block_key, cell_idx, 0, exact, exact_miss)) {
        out = exact;
        out.hit_neighbor = false;
        out.neighbor_level = 0;
        return true;
    }
    best_miss = exact_miss;

    if (options_.lookup_nearby_type == 0) {
        out.valid = false;
        out.miss_reason = best_miss;
        return false;
    }

    bool has_candidate = false;
    SurfelCorrespondence best;
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dz = -1; dz <= 1; ++dz) {
                if (dx == 0 && dy == 0 && dz == 0) {
                    continue;
                }
                const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                if (options_.lookup_nearby_type == 6 && manhattan > 1) {
                    continue;
                }
                if (options_.lookup_nearby_type == 18 && manhattan > 2) {
                    continue;
                }

                BlockKey nb_key;
                int nb_cell_idx = 0;
                GridToBlockCell(gx + dx, gy + dy, gz + dz, nb_key, nb_cell_idx);

                SurfelCorrespondence candidate;
                SurfelMissReason miss = SurfelMissReason::NONE;
                if (TryCell(pt_world, nb_key, nb_cell_idx, manhattan == 1 ? 6 : (manhattan == 2 ? 18 : 26), candidate,
                            miss)) {
                    candidate.hit_neighbor = true;
                    if (!has_candidate || BetterCandidate(candidate, best, pt_world)) {
                        best = candidate;
                        has_candidate = true;
                    }
                } else if (MissReasonRank(miss) > MissReasonRank(best_miss)) {
                    best_miss = miss;
                }
            }
        }
    }

    if (has_candidate) {
        out = best;
        return true;
    }

    out.valid = false;
    out.miss_reason = best_miss;
    return false;
}

bool BlockSurfelMap::TryCell(const PointType&, const BlockKey& block_key, int cell_idx, int neighbor_level,
                             SurfelCorrespondence& candidate, SurfelMissReason& miss_reason) const {
    auto it = blocks_.find(block_key);
    if (it == blocks_.end()) {
        miss_reason = SurfelMissReason::NO_BLOCK;
        return false;
    }
    const VoxelCell& c = it->second->cells[cell_idx];
    if (c.count == 0) {
        miss_reason = SurfelMissReason::EMPTY_CELL;
        return false;
    }
    if (c.count < static_cast<uint32_t>(options_.min_support)) {
        miss_reason = SurfelMissReason::SUPPORT_LOW;
        return false;
    }
    if (!(c.flags & FLAG_VALID_SURFEL)) {
        miss_reason = SurfelMissReason::QUALITY_BAD;
        return false;
    }
    const float inv_n = 1.0f / static_cast<float>(c.count);
    candidate.valid = true;
    candidate.fallback = false;
    candidate.hit_neighbor = neighbor_level != 0;
    candidate.neighbor_level = neighbor_level;
    candidate.miss_reason = SurfelMissReason::NONE;
    candidate.plane = Vec4f(c.nx, c.ny, c.nz, c.d);
    candidate.centroid = Vec3f(c.sum[0] * inv_n, c.sum[1] * inv_n, c.sum[2] * inv_n);
    candidate.quality = c.quality;
    candidate.count = c.count;
    return true;
}

void BlockSurfelMap::EnqueueFallback(const PointType&) {
    fallback_count_.fetch_add(1, std::memory_order_relaxed);
}

size_t BlockSurfelMap::NumValidCells() const {
    size_t n = 0;
    for (const auto& kv : blocks_) {
        n += kv.second->valid_cell_count;
    }
    return n;
}

size_t BlockSurfelMap::NumValidSurfels() const {
    size_t n = 0;
    for (const auto& kv : blocks_) {
        for (int i = 0; i < BlockGeom::CELLS_PER_BLOCK; ++i) {
            n += (kv.second->cells[i].flags & FLAG_VALID_SURFEL) ? 1 : 0;
        }
    }
    return n;
}

void BlockSurfelMap::ExportCentroidCloud(PointVector& out) const {
    out.clear();
    out.reserve(NumValidSurfels());
    for (const auto& kv : blocks_) {
        for (int i = 0; i < BlockGeom::CELLS_PER_BLOCK; ++i) {
            const VoxelCell& c = kv.second->cells[i];
            if (!(c.flags & FLAG_VALID_SURFEL) || c.count == 0) {
                continue;
            }
            const float inv_n = 1.0f / static_cast<float>(c.count);
            PointType p;
            p.x = c.sum[0] * inv_n;
            p.y = c.sum[1] * inv_n;
            p.z = c.sum[2] * inv_n;
            p.intensity = c.quality;
            out.emplace_back(p);
        }
    }
}

}  // namespace lightning
