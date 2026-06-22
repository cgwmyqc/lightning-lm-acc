// SPDX-License-Identifier: MIT

#include "unified_surfel_observation_core.h"

#include <cmath>

namespace lightning {
namespace fpga {
namespace hls {
namespace {

struct Vec3 {
    double x = 0.0;
    double y = 0.0;
    double z = 0.0;
};

int FloorDiv(int value, int divisor) {
    int q = value / divisor;
    int r = value % divisor;
    if (r != 0 && ((r < 0) != (divisor < 0))) {
        --q;
    }
    return q;
}

int PositiveMod(int value, int divisor) {
    int r = value % divisor;
    return r < 0 ? r + divisor : r;
}

int AbsInt(int value) { return value < 0 ? -value : value; }

int MaxInt(int lhs, int rhs) { return lhs > rhs ? lhs : rhs; }

bool BlockLess(const ActiveBlockRecord& lhs, int32_t x, int32_t y, int32_t z) {
    if (lhs.x != x) return lhs.x < x;
    if (lhs.y != y) return lhs.y < y;
    return lhs.z < z;
}

bool KeyLess(int32_t x, int32_t y, int32_t z, const ActiveBlockRecord& rhs) {
    if (x != rhs.x) return x < rhs.x;
    if (y != rhs.y) return y < rhs.y;
    return z < rhs.z;
}

bool CellValid(const ObsCellFloat64& cell) { return (cell.flags & OBS_CELL_VALID) != 0; }

constexpr int kNormalEquationWords = sizeof(SlamNormalEquation) / sizeof(uint64_t);
constexpr int kMaxActiveBlocks = 8192;
constexpr uint32_t kStage58DebugMagic = 0x53543538u;  // "ST58"
constexpr uint32_t kStage58DebugVersion = 1u;
constexpr uint32_t kStage61DebugMagic = 0x53543631u;  // "ST61"
constexpr uint32_t kStage61DebugVersion = 1u;

struct LookupDebugCounters {
    uint32_t point_count = 0;
    uint32_t exact_hit_count = 0;
    uint32_t neighbor_hit_count = 0;
    uint32_t lookup_miss_count = 0;
    uint32_t neighbor_probe_count = 0;
    uint32_t block_lookup_count = 0;
    uint32_t block_search_step_count = 0;
    uint32_t obs_cell_read_count = 0;
    uint32_t valid_candidate_count = 0;
    uint32_t invalid_candidate_count = 0;
    uint32_t max_probe_per_point = 0;
    uint32_t block_cache_count = 0;
    uint32_t flags = 0;
    uint32_t debug_magic = kStage58DebugMagic;
    uint32_t debug_version = kStage58DebugVersion;
};

struct BlockLookupEntry {
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;
    int32_t index = -1;
    bool valid = false;
};

uint64_t DoubleToBits(double value) {
    union DoubleWord {
        double d;
        uint64_t u;
    } word;
    word.d = value;
    return word.u;
}

float BitsToFloat(uint32_t value) {
    union FloatWord {
        uint32_t u;
        float f;
    } word;
    word.u = value;
    return word.f;
}

uint32_t Low32(uint64_t value) { return static_cast<uint32_t>(value & 0xFFFFffffULL); }

uint32_t High32(uint64_t value) { return static_cast<uint32_t>(value >> 32); }

uint64_t Pack32(uint32_t low, uint32_t high) { return (static_cast<uint64_t>(high) << 32) | low; }

SlamAccelObservationParams LoadParams(const uint64_t* params_words) {
    SlamAccelObservationParams params;
    const uint64_t w0 = params_words[0];
    const uint64_t w1 = params_words[1];
    const uint64_t w2 = params_words[2];
    const uint64_t w3 = params_words[3];
    params.magic = Low32(w0);
    params.version = High32(w0);
    params.mode = Low32(w1);
    params.flags = High32(w1);
    params.plane_icp_weight = BitsToFloat(Low32(w2));
    params.residual_outlier_th = BitsToFloat(High32(w2));
    params.mapping_gate_scale = BitsToFloat(Low32(w3));
    params.reserved_scalar = BitsToFloat(High32(w3));

    for (int i = 0; i < 4; ++i) {
#pragma HLS UNROLL
        const uint64_t word = params_words[4 + i];
        params.extrinsic_R[2 * i] = BitsToFloat(Low32(word));
        params.extrinsic_R[2 * i + 1] = BitsToFloat(High32(word));
    }
    const uint64_t w8 = params_words[8];
    const uint64_t w9 = params_words[9];
    params.extrinsic_R[8] = BitsToFloat(Low32(w8));
    params.extrinsic_T[0] = BitsToFloat(High32(w8));
    params.extrinsic_T[1] = BitsToFloat(Low32(w9));
    params.extrinsic_T[2] = BitsToFloat(High32(w9));
    return params;
}

void CopyCell(const ObsCellFloat64& src, ObsCellFloat64& dst) {
    dst.centroid_x = src.centroid_x;
    dst.centroid_y = src.centroid_y;
    dst.centroid_z = src.centroid_z;
    dst.normal_x = src.normal_x;
    dst.normal_y = src.normal_y;
    dst.normal_z = src.normal_z;
    dst.plane_d = src.plane_d;
    dst.quality = src.quality;
    dst.count = src.count;
    dst.flags = src.flags;
    for (int i = 0; i < 6; ++i) {
        dst.reserved[i] = src.reserved[i];
    }
}

Vec3 RotatePoint(const SlamAccelPose& pose, const SlamAccelScanPoint& point) {
    const double qx = pose.qx;
    const double qy = pose.qy;
    const double qz = pose.qz;
    const double qw = pose.qw;
    const double x = point.x;
    const double y = point.y;
    const double z = point.z;

    const double tx = 2.0 * (qy * z - qz * y);
    const double ty = 2.0 * (qz * x - qx * z);
    const double tz = 2.0 * (qx * y - qy * x);

    Vec3 out;
    out.x = x + qw * tx + (qy * tz - qz * ty) + pose.tx;
    out.y = y + qw * ty + (qz * tx - qx * tz) + pose.ty;
    out.z = z + qw * tz + (qx * ty - qy * tx) + pose.tz;
    return out;
}

Vec3 RotateVectorInverse(const SlamAccelPose& pose, const Vec3& vector) {
    const double qx = -pose.qx;
    const double qy = -pose.qy;
    const double qz = -pose.qz;
    const double qw = pose.qw;
    const double x = vector.x;
    const double y = vector.y;
    const double z = vector.z;

    const double tx = 2.0 * (qy * z - qz * y);
    const double ty = 2.0 * (qz * x - qx * z);
    const double tz = 2.0 * (qx * y - qy * x);

    Vec3 out;
    out.x = x + qw * tx + (qy * tz - qz * ty);
    out.y = y + qw * ty + (qz * tx - qx * tz);
    out.z = z + qw * tz + (qx * ty - qy * tx);
    return out;
}

void Encode(const Vec3& point, const ActiveMapHeader& map_header, int32_t& block_x, int32_t& block_y,
            int32_t& block_z, int32_t& cell_idx) {
    const int gx = static_cast<int>(std::floor(point.x * map_header.inv_cell_resolution));
    const int gy = static_cast<int>(std::floor(point.y * map_header.inv_cell_resolution));
    const int gz = static_cast<int>(std::floor(point.z * map_header.inv_cell_resolution));

    block_x = FloorDiv(gx, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X));
    block_y = FloorDiv(gy, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y));
    block_z = FloorDiv(gz, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z));

    const int lx = PositiveMod(gx, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X));
    const int ly = PositiveMod(gy, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y));
    const int lz = PositiveMod(gz, static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z));
    cell_idx = (lz * static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y) + ly) * static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X) + lx;
}

int FindBlockIndex(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks, int32_t block_x,
                   int32_t block_y, int32_t block_z, LookupDebugCounters& counters) {
    ++counters.block_lookup_count;
    int lo = 0;
    int hi = static_cast<int>(map_header.num_blocks);
    while (lo < hi) {
        ++counters.block_search_step_count;
        const int mid = (lo + hi) / 2;
        if (BlockLess(active_blocks[mid], block_x, block_y, block_z)) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    if (lo >= static_cast<int>(map_header.num_blocks) || KeyLess(block_x, block_y, block_z, active_blocks[lo])) {
        return -1;
    }
    return lo;
}

int GetBlockIndexCached(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks, int32_t block_x,
                        int32_t block_y, int32_t block_z, BlockLookupEntry cache[27], int& cache_size,
                        LookupDebugCounters& counters) {
    for (int i = 0; i < cache_size; ++i) {
        if (cache[i].valid && cache[i].x == block_x && cache[i].y == block_y && cache[i].z == block_z) {
            return cache[i].index;
        }
    }

    const int index = FindBlockIndex(map_header, active_blocks, block_x, block_y, block_z, counters);
    if (cache_size < 27) {
        cache[cache_size].x = block_x;
        cache[cache_size].y = block_y;
        cache[cache_size].z = block_z;
        cache[cache_size].index = index;
        cache[cache_size].valid = true;
        ++cache_size;
    }
    return index;
}

bool LookupCellByBlockIndex(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                            const ObsCellFloat64* obs_cells, int block_index, int32_t cell_idx,
                            ObsCellFloat64& out_cell, LookupDebugCounters& counters) {
    if (block_index < 0 || block_index >= static_cast<int>(map_header.num_blocks)) {
        ++counters.invalid_candidate_count;
        return false;
    }
    const uint32_t offset = active_blocks[block_index].first_cell + static_cast<uint32_t>(cell_idx);
    if (offset >= map_header.num_cells) {
        ++counters.invalid_candidate_count;
        return false;
    }
    ++counters.obs_cell_read_count;
    const ObsCellFloat64& cell = obs_cells[offset];
    if (!CellValid(cell)) {
        ++counters.invalid_candidate_count;
        return false;
    }
    ++counters.valid_candidate_count;
    CopyCell(cell, out_cell);
    return true;
}

bool LookupCell(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                const ObsCellFloat64* obs_cells, int32_t block_x, int32_t block_y, int32_t block_z, int32_t cell_idx,
                ObsCellFloat64& out_cell, LookupDebugCounters& counters) {
    const int block_index = FindBlockIndex(map_header, active_blocks, block_x, block_y, block_z, counters);
    return LookupCellByBlockIndex(map_header, active_blocks, obs_cells, block_index, cell_idx, out_cell, counters);
}

bool LookupNearest(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                   const ObsCellFloat64* obs_cells, const Vec3& point, bool mapping_mode, ObsCellFloat64& out_cell,
                   LookupDebugCounters& counters) {
    int32_t center_bx = 0;
    int32_t center_by = 0;
    int32_t center_bz = 0;
    int32_t center_cell = 0;
    Encode(point, map_header, center_bx, center_by, center_bz, center_cell);

    uint32_t probes_this_point = 1;
    BlockLookupEntry block_cache[27];
#pragma HLS ARRAY_PARTITION variable = block_cache complete dim = 1
    int block_cache_size = 0;
    const int center_block_index =
        GetBlockIndexCached(map_header, active_blocks, center_bx, center_by, center_bz, block_cache, block_cache_size,
                            counters);
    if (LookupCellByBlockIndex(map_header, active_blocks, obs_cells, center_block_index, center_cell, out_cell,
                               counters)) {
        ++counters.exact_hit_count;
        if (probes_this_point > counters.max_probe_per_point) {
            counters.max_probe_per_point = probes_this_point;
        }
        return true;
    }
    if (map_header.lookup_nearby_type == 0) {
        ++counters.lookup_miss_count;
        if (probes_this_point > counters.max_probe_per_point) {
            counters.max_probe_per_point = probes_this_point;
        }
        return false;
    }

    const int neighbor_limit =
        map_header.lookup_nearby_type <= 6 ? 6 : (map_header.lookup_nearby_type <= 18 ? 18 : 26);
    const int bx_dim = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_X);
    const int by_dim = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Y);
    const int bz_dim = static_cast<int>(SLAM_ACCEL_BLOCK_DIM_Z);

    int local = center_cell;
    const int center_lx = local % bx_dim;
    local /= bx_dim;
    const int center_ly = local % by_dim;
    const int center_lz = local / by_dim;

    ObsCellFloat64 best;
    bool found = false;
    double best_dist2 = 1.0e100;
    double best_abs_residual = 1.0e100;
    for (int dz = -1; dz <= 1; ++dz) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dx = -1; dx <= 1; ++dx) {
                const int abs_dx = AbsInt(dx);
                const int abs_dy = AbsInt(dy);
                const int abs_dz = AbsInt(dz);
                const int manhattan = abs_dx + abs_dy + abs_dz;
                const int chessboard = MaxInt(MaxInt(abs_dx, abs_dy), abs_dz);
                if (manhattan == 0) {
                    continue;
                }
                if ((neighbor_limit == 6 && manhattan != 1) || (neighbor_limit == 18 && chessboard > 1) ||
                    (neighbor_limit == 18 && manhattan > 2)) {
                    continue;
                }

                int lx = center_lx + dx;
                int ly = center_ly + dy;
                int lz = center_lz + dz;
                int32_t nbx = center_bx;
                int32_t nby = center_by;
                int32_t nbz = center_bz;
                if (lx < 0) {
                    lx += bx_dim;
                    --nbx;
                } else if (lx >= bx_dim) {
                    lx -= bx_dim;
                    ++nbx;
                }
                if (ly < 0) {
                    ly += by_dim;
                    --nby;
                } else if (ly >= by_dim) {
                    ly -= by_dim;
                    ++nby;
                }
                if (lz < 0) {
                    lz += bz_dim;
                    --nbz;
                } else if (lz >= bz_dim) {
                    lz -= bz_dim;
                    ++nbz;
                }

                const int32_t ncell = (lz * by_dim + ly) * bx_dim + lx;
                ObsCellFloat64 candidate;
                ++probes_this_point;
                ++counters.neighbor_probe_count;
                const int block_index =
                    GetBlockIndexCached(map_header, active_blocks, nbx, nby, nbz, block_cache, block_cache_size,
                                        counters);
                if (!LookupCellByBlockIndex(map_header, active_blocks, obs_cells, block_index, ncell, candidate,
                                            counters)) {
                    continue;
                }
                const double ddx = point.x - candidate.centroid_x;
                const double ddy = point.y - candidate.centroid_y;
                const double ddz = point.z - candidate.centroid_z;
                const double dist2 = ddx * ddx + ddy * ddy + ddz * ddz;
                const double candidate_residual = candidate.normal_x * point.x + candidate.normal_y * point.y +
                                                  candidate.normal_z * point.z + candidate.plane_d;
                const double abs_candidate_residual = std::fabs(candidate_residual);

                bool better = false;
                if (!found) {
                    better = true;
                } else if (mapping_mode) {
                    const double residual_delta = abs_candidate_residual - best_abs_residual;
                    if (residual_delta < -1.0e-4) {
                        better = true;
                    } else if (std::fabs(residual_delta) <= 1.0e-4) {
                        const double dist_delta = dist2 - best_dist2;
                        if (dist_delta < -1.0e-4) {
                            better = true;
                        } else if (std::fabs(dist_delta) <= 1.0e-4 && candidate.quality < best.quality) {
                            better = true;
                        }
                    }
                } else if (dist2 < best_dist2) {
                    better = true;
                }

                if (better) {
                    best_dist2 = dist2;
                    best_abs_residual = abs_candidate_residual;
                    CopyCell(candidate, best);
                    found = true;
                }
            }
        }
    }
    if (found) {
        ++counters.neighbor_hit_count;
        CopyCell(best, out_cell);
    } else {
        ++counters.lookup_miss_count;
    }
    if (probes_this_point > counters.max_probe_per_point) {
        counters.max_probe_per_point = probes_this_point;
    }
    return found;
}

void AccumulateUpper(double h[6][6], double b[6], const double j[6], double residual, double weight) {
    for (int r = 0; r < 6; ++r) {
        b[r] += j[r] * residual * weight;
        for (int c = r; c < 6; ++c) {
            h[r][c] += j[r] * j[c] * weight;
        }
    }
}

void StoreOutputWords(const double h[6][6], const double b[6], uint32_t valid_count, uint32_t reject_count,
                      uint32_t miss_count, double residual_sum, double residual_abs_sum, double residual_max_abs,
                      const LookupDebugCounters& counters, uint64_t* output_words) {
    for (int i = 0; i < kNormalEquationWords; ++i) {
#pragma HLS UNROLL
        output_words[i] = 0;
    }

    int idx = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            output_words[idx++] = DoubleToBits(h[r][c]);
        }
    }
    for (int r = 0; r < 6; ++r) {
        output_words[21 + r] = DoubleToBits(b[r]);
    }

    output_words[27] = (static_cast<uint64_t>(reject_count) << 32) | static_cast<uint64_t>(valid_count);
    output_words[28] = static_cast<uint64_t>(miss_count);
    output_words[29] = DoubleToBits(residual_sum);
    output_words[30] = DoubleToBits(residual_abs_sum);
    output_words[31] = DoubleToBits(residual_max_abs);
    output_words[32] = Pack32(counters.debug_magic, counters.debug_version);
    output_words[33] = Pack32(counters.point_count, counters.exact_hit_count);
    output_words[34] = Pack32(counters.neighbor_hit_count, counters.lookup_miss_count);
    output_words[35] = Pack32(counters.neighbor_probe_count, counters.block_lookup_count);
    output_words[36] = Pack32(counters.block_search_step_count, counters.obs_cell_read_count);
    output_words[37] = Pack32(counters.valid_candidate_count, counters.invalid_candidate_count);
    output_words[38] = Pack32(counters.max_probe_per_point, counters.block_cache_count);
    output_words[39] = Pack32(counters.flags, 0);
}

}  // namespace

void unified_surfel_observation_core(const SlamAccelScanPoint* scan_points, uint32_t num_points,
                                     const SlamAccelPose* pose, const ActiveMapHeader* map_header,
                                     const uint64_t* params,
                                     const ActiveBlockRecord* active_blocks, const ObsCellFloat64* obs_cells,
                                     uint64_t* output_words) {
    ActiveBlockRecord active_block_cache[kMaxActiveBlocks];
#pragma HLS RESOURCE variable = active_block_cache core = RAM_2P_BRAM

    double h[6][6] = {{0.0}};
    double b[6] = {0.0};
    uint32_t valid_count = 0;
    uint32_t reject_count = 0;
    uint32_t miss_count = 0;
    double residual_sum = 0.0;
    double residual_abs_sum = 0.0;
    double residual_max_abs = 0.0;

    const SlamAccelObservationParams obs_params = LoadParams(params);
    const bool params_valid =
        obs_params.magic == SLAM_ACCEL_ABI_MAGIC && obs_params.version == SLAM_ACCEL_GOLDEN_VERSION;
    const uint32_t obs_mode = params_valid ? obs_params.mode : map_header->mode;
    const bool use_candidate_v2 =
        params_valid && ((obs_params.flags & SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2) != 0u);
    const double residual_outlier_th = params_valid ? obs_params.residual_outlier_th : 0.3;
    const double mapping_gate_scale = params_valid ? obs_params.mapping_gate_scale : 81.0;
    const double plane_icp_weight = params_valid ? obs_params.plane_icp_weight : 1.0;
    ActiveMapHeader local_map_header = *map_header;
    LookupDebugCounters counters;
    if (use_candidate_v2) {
        counters.debug_magic = kStage61DebugMagic;
        counters.debug_version = kStage61DebugVersion;
        counters.flags |= SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    }
    if (!use_candidate_v2 && local_map_header.num_blocks > static_cast<uint32_t>(kMaxActiveBlocks)) {
        local_map_header.num_blocks = static_cast<uint32_t>(kMaxActiveBlocks);
        counters.flags |= 1u;
    }
    counters.block_cache_count = local_map_header.num_blocks;

    for (uint32_t i = 0; i < static_cast<uint32_t>(kMaxActiveBlocks); ++i) {
#pragma HLS LOOP_TRIPCOUNT min = 1 max = 8192 avg = 4096
        if (!use_candidate_v2 && i < local_map_header.num_blocks) {
            active_block_cache[i] = active_blocks[i];
        }
    }

    for (uint32_t i = 0; i < num_points; ++i) {
#pragma HLS LOOP_TRIPCOUNT min = 1 max = 8192 avg = 4096
        ++counters.point_count;
        const SlamAccelScanPoint& scan = scan_points[i];
        if (!std::isfinite(scan.x) || !std::isfinite(scan.y) || !std::isfinite(scan.z)) {
            ++reject_count;
            continue;
        }

        const Vec3 p = RotatePoint(*pose, scan);
        ObsCellFloat64 cell;
        if (use_candidate_v2) {
            const ObsCellFloat64& candidate = obs_cells[i];
            if (!CellValid(candidate)) {
                ++miss_count;
                ++counters.invalid_candidate_count;
                ++counters.lookup_miss_count;
                continue;
            }
            CopyCell(candidate, cell);
            ++counters.valid_candidate_count;
            ++counters.exact_hit_count;
        } else {
            if (!LookupNearest(local_map_header, active_block_cache, obs_cells, p, obs_mode == MAPPING_OBSERVATION,
                               cell, counters)) {
                ++miss_count;
                continue;
            }
        }

        const double nx = cell.normal_x;
        const double ny = cell.normal_y;
        const double nz = cell.normal_z;
        const double residual = nx * p.x + ny * p.y + nz * p.z + cell.plane_d;
        const double abs_residual = std::fabs(residual);
        if (!std::isfinite(residual)) {
            ++reject_count;
            continue;
        }

        double j[6];
        double solve_residual = residual;
        double weight = 1.0;
        if (obs_mode == MAPPING_OBSERVATION) {
            const double body_norm =
                std::sqrt(static_cast<double>(scan.x) * static_cast<double>(scan.x) +
                          static_cast<double>(scan.y) * static_cast<double>(scan.y) +
                          static_cast<double>(scan.z) * static_cast<double>(scan.z));
            if (body_norm <= mapping_gate_scale * residual * residual) {
                ++miss_count;
                continue;
            }

            Vec3 normal_world;
            normal_world.x = nx;
            normal_world.y = ny;
            normal_world.z = nz;
            const Vec3 pose_rt_normal = RotateVectorInverse(*pose, normal_world);
            const double cx = obs_params.extrinsic_R[0] * pose_rt_normal.x +
                              obs_params.extrinsic_R[1] * pose_rt_normal.y +
                              obs_params.extrinsic_R[2] * pose_rt_normal.z;
            const double cy = obs_params.extrinsic_R[3] * pose_rt_normal.x +
                              obs_params.extrinsic_R[4] * pose_rt_normal.y +
                              obs_params.extrinsic_R[5] * pose_rt_normal.z;
            const double cz = obs_params.extrinsic_R[6] * pose_rt_normal.x +
                              obs_params.extrinsic_R[7] * pose_rt_normal.y +
                              obs_params.extrinsic_R[8] * pose_rt_normal.z;

            const double point_this_x = obs_params.extrinsic_R[0] * static_cast<double>(scan.x) +
                                        obs_params.extrinsic_R[1] * static_cast<double>(scan.y) +
                                        obs_params.extrinsic_R[2] * static_cast<double>(scan.z) +
                                        obs_params.extrinsic_T[0];
            const double point_this_y = obs_params.extrinsic_R[3] * static_cast<double>(scan.x) +
                                        obs_params.extrinsic_R[4] * static_cast<double>(scan.y) +
                                        obs_params.extrinsic_R[5] * static_cast<double>(scan.z) +
                                        obs_params.extrinsic_T[1];
            const double point_this_z = obs_params.extrinsic_R[6] * static_cast<double>(scan.x) +
                                        obs_params.extrinsic_R[7] * static_cast<double>(scan.y) +
                                        obs_params.extrinsic_R[8] * static_cast<double>(scan.z) +
                                        obs_params.extrinsic_T[2];

            j[0] = nx;
            j[1] = ny;
            j[2] = nz;
            j[3] = point_this_y * cz - point_this_z * cy;
            j[4] = point_this_z * cx - point_this_x * cz;
            j[5] = point_this_x * cy - point_this_y * cx;
            solve_residual = -residual;
            weight = plane_icp_weight;
        } else {
            if (abs_residual > residual_outlier_th) {
                ++reject_count;
                continue;
            }
            j[0] = nx;
            j[1] = ny;
            j[2] = nz;
            j[3] = nz * p.y - ny * p.z;
            j[4] = nx * p.z - nz * p.x;
            j[5] = ny * p.x - nx * p.y;
        }
        AccumulateUpper(h, b, j, solve_residual, weight);

        ++valid_count;
        residual_sum += residual;
        residual_abs_sum += abs_residual;
        if (abs_residual > residual_max_abs) {
            residual_max_abs = abs_residual;
        }
    }
    StoreOutputWords(h, b, valid_count, reject_count, miss_count, residual_sum, residual_abs_sum, residual_max_abs,
                     counters, output_words);
}

}  // namespace hls
}  // namespace fpga
}  // namespace lightning

void unified_surfel_observation_core(const lightning::fpga::SlamAccelScanPoint* scan_points, uint32_t num_points,
                                     const lightning::fpga::SlamAccelPose* pose,
                                     const lightning::fpga::ActiveMapHeader* map_header,
                                     const uint64_t* params,
                                     const lightning::fpga::ActiveBlockRecord* active_blocks,
                                     const lightning::fpga::ObsCellFloat64* obs_cells,
                                     uint64_t* output_words) {
#pragma HLS INTERFACE ap_ctrl_hs port = return
#pragma HLS INTERFACE m_axi port = scan_points offset = direct bundle = gmem0 depth = 8192
#pragma HLS INTERFACE m_axi port = pose offset = direct bundle = gmem1 depth = 1
#pragma HLS INTERFACE m_axi port = map_header offset = direct bundle = gmem1 depth = 1
#pragma HLS INTERFACE m_axi port = params offset = direct bundle = gmem1 depth = 16
#pragma HLS INTERFACE m_axi port = active_blocks offset = direct bundle = gmem2 depth = 8192
#pragma HLS INTERFACE m_axi port = obs_cells offset = direct bundle = gmem3 depth = 1048576
#pragma HLS INTERFACE m_axi port = output_words offset = direct bundle = gmem4 depth = 40
#pragma HLS DATA_PACK variable = scan_points
#pragma HLS DATA_PACK variable = pose
#pragma HLS DATA_PACK variable = map_header
#pragma HLS DATA_PACK variable = active_blocks
#pragma HLS DATA_PACK variable = obs_cells
    lightning::fpga::hls::unified_surfel_observation_core(scan_points, num_points, pose, map_header, params,
                                                          active_blocks, obs_cells, output_words);
}
