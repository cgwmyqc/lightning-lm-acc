#include "fpga/cpu_surfel_lookup_backend.h"

#include <cmath>
#include <cstdint>
#include <unordered_map>

#include <glog/logging.h>

#include "core/block_surfel_map/block_surfel_map.h"

namespace lightning::fpga {
namespace {

struct Key {
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;

    bool operator==(const Key& rhs) const noexcept { return x == rhs.x && y == rhs.y && z == rhs.z; }
};

struct KeyHash {
    size_t operator()(const Key& k) const noexcept {
        uint64_t h = static_cast<uint64_t>(k.x) * 73856093u;
        h ^= static_cast<uint64_t>(k.y) * 19349663u;
        h ^= static_cast<uint64_t>(k.z) * 83492791u;
        return static_cast<size_t>(h);
    }
};

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

int LocalCellIndex(int lx, int ly, int lz) {
    return (lz * BlockGeom::BY + ly) * BlockGeom::BX + lx;
}

void GridToBlockCell(int gx, int gy, int gz, Key* block_key, int* cell_idx) {
    block_key->x = DivFloor(gx, BlockGeom::BX);
    block_key->y = DivFloor(gy, BlockGeom::BY);
    block_key->z = DivFloor(gz, BlockGeom::BZ);
    *cell_idx = LocalCellIndex(ModFloor(gx, BlockGeom::BX), ModFloor(gy, BlockGeom::BY),
                               ModFloor(gz, BlockGeom::BZ));
}

int MissReasonRank(uint32_t reason) {
    switch (static_cast<SurfelMissReason>(reason)) {
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

bool BetterCandidate(const FpgaLookupResult& lhs, const FpgaLookupResult& rhs,
                     const FpgaLookupPointInput& point) {
    const float lhs_res = std::fabs(lhs.plane[0] * point.x + lhs.plane[1] * point.y + lhs.plane[2] * point.z +
                                    lhs.plane[3]);
    const float rhs_res = std::fabs(rhs.plane[0] * point.x + rhs.plane[1] * point.y + rhs.plane[2] * point.z +
                                    rhs.plane[3]);
    if (std::fabs(lhs_res - rhs_res) > 1e-4f) {
        return lhs_res < rhs_res;
    }

    const float lhs_dx = lhs.centroid[0] - point.x;
    const float lhs_dy = lhs.centroid[1] - point.y;
    const float lhs_dz = lhs.centroid[2] - point.z;
    const float rhs_dx = rhs.centroid[0] - point.x;
    const float rhs_dy = rhs.centroid[1] - point.y;
    const float rhs_dz = rhs.centroid[2] - point.z;
    const float lhs_dist = lhs_dx * lhs_dx + lhs_dy * lhs_dy + lhs_dz * lhs_dz;
    const float rhs_dist = rhs_dx * rhs_dx + rhs_dy * rhs_dy + rhs_dz * rhs_dz;
    if (std::fabs(lhs_dist - rhs_dist) > 1e-4f) {
        return lhs_dist < rhs_dist;
    }

    return lhs.quality < rhs.quality;
}

bool TryCell(const std::unordered_map<Key, const FpgaLookupBlock*, KeyHash>& block_index, const Key& block_key,
             int cell_idx, int neighbor_level, uint32_t min_support, FpgaLookupResult* candidate,
             uint32_t* miss_reason) {
    auto it = block_index.find(block_key);
    if (it == block_index.end()) {
        *miss_reason = static_cast<uint32_t>(SurfelMissReason::NO_BLOCK);
        return false;
    }

    const FpgaLookupCell& cell = it->second->cells[cell_idx];
    if (cell.count == 0) {
        *miss_reason = static_cast<uint32_t>(SurfelMissReason::EMPTY_CELL);
        return false;
    }
    if (cell.count < min_support) {
        *miss_reason = static_cast<uint32_t>(SurfelMissReason::SUPPORT_LOW);
        return false;
    }
    if (!(cell.flags & FLAG_VALID_SURFEL)) {
        *miss_reason = static_cast<uint32_t>(SurfelMissReason::QUALITY_BAD);
        return false;
    }

    const float inv_n = 1.0f / static_cast<float>(cell.count);
    candidate->valid = 1;
    candidate->fallback = 0;
    candidate->hit_neighbor = neighbor_level != 0 ? 1u : 0u;
    candidate->neighbor_level = static_cast<uint32_t>(neighbor_level);
    candidate->miss_reason = static_cast<uint32_t>(SurfelMissReason::NONE);
    candidate->count = cell.count;
    candidate->quality = cell.quality;
    candidate->plane[0] = cell.nx;
    candidate->plane[1] = cell.ny;
    candidate->plane[2] = cell.nz;
    candidate->plane[3] = cell.d;
    candidate->centroid[0] = cell.sum[0] * inv_n;
    candidate->centroid[1] = cell.sum[1] * inv_n;
    candidate->centroid[2] = cell.sum[2] * inv_n;
    return true;
}

}  // namespace

bool CpuSurfelLookupBackend::Lookup(const LookupBatchInput& input, LookupBatchOutput* output) {
    if (!output) {
        return false;
    }
    if (input.params.version != kLookupInterfaceVersion || input.params.num_points != input.points.size() ||
        input.params.num_blocks != input.blocks.size()) {
        LOG(ERROR) << "[fpga lookup] invalid input metadata: version=" << input.params.version
                   << " points=" << input.params.num_points << "/" << input.points.size()
                   << " blocks=" << input.params.num_blocks << "/" << input.blocks.size();
        return false;
    }

    std::unordered_map<Key, const FpgaLookupBlock*, KeyHash> block_index;
    block_index.reserve(input.blocks.size() * 2 + 1);
    for (const auto& block : input.blocks) {
        block_index.emplace(Key{block.bx, block.by, block.bz}, &block);
    }

    output->results.clear();
    output->results.resize(input.points.size());
    const int lookup_nearby_type = static_cast<int>(input.params.lookup_nearby_type);
    const uint32_t min_support = input.params.min_support;

    for (size_t i = 0; i < input.points.size(); ++i) {
        const FpgaLookupPointInput& point = input.points[i];
        const int gx = static_cast<int>(std::floor(point.x * input.params.inv_cell_resolution));
        const int gy = static_cast<int>(std::floor(point.y * input.params.inv_cell_resolution));
        const int gz = static_cast<int>(std::floor(point.z * input.params.inv_cell_resolution));

        Key block_key;
        int cell_idx = 0;
        GridToBlockCell(gx, gy, gz, &block_key, &cell_idx);

        uint32_t best_miss = static_cast<uint32_t>(SurfelMissReason::NONE);
        FpgaLookupResult exact;
        uint32_t exact_miss = static_cast<uint32_t>(SurfelMissReason::NONE);
        if (TryCell(block_index, block_key, cell_idx, 0, min_support, &exact, &exact_miss)) {
            output->results[i] = exact;
            continue;
        }
        best_miss = exact_miss;

        if (lookup_nearby_type == 0) {
            output->results[i].valid = 0;
            output->results[i].miss_reason = best_miss;
            continue;
        }

        bool has_candidate = false;
        FpgaLookupResult best;
        for (int dx = -1; dx <= 1; ++dx) {
            for (int dy = -1; dy <= 1; ++dy) {
                for (int dz = -1; dz <= 1; ++dz) {
                    if (dx == 0 && dy == 0 && dz == 0) {
                        continue;
                    }
                    const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                    if (lookup_nearby_type == 6 && manhattan > 1) {
                        continue;
                    }
                    if (lookup_nearby_type == 18 && manhattan > 2) {
                        continue;
                    }

                    Key nb_key;
                    int nb_cell_idx = 0;
                    GridToBlockCell(gx + dx, gy + dy, gz + dz, &nb_key, &nb_cell_idx);

                    FpgaLookupResult candidate;
                    uint32_t miss = static_cast<uint32_t>(SurfelMissReason::NONE);
                    const int neighbor_level = manhattan == 1 ? 6 : (manhattan == 2 ? 18 : 26);
                    if (TryCell(block_index, nb_key, nb_cell_idx, neighbor_level, min_support, &candidate, &miss)) {
                        candidate.hit_neighbor = 1;
                        if (!has_candidate || BetterCandidate(candidate, best, point)) {
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
            output->results[i] = best;
        } else {
            output->results[i].valid = 0;
            output->results[i].miss_reason = best_miss;
        }
    }

    return true;
}

}  // namespace lightning::fpga
