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

void ResetOutput(SlamNormalEquation* output) {
    for (int i = 0; i < 21; ++i) {
        output->h_upper[i] = 0.0;
    }
    for (int i = 0; i < 6; ++i) {
        output->b[i] = 0.0;
    }
    output->valid_count = 0;
    output->reject_count = 0;
    output->miss_count = 0;
    output->flags = 0;
    output->residual_sum = 0.0;
    output->residual_abs_sum = 0.0;
    output->residual_max_abs = 0.0;
    for (int i = 0; i < 4; ++i) {
        output->reserved[i] = 0;
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

bool LookupCell(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                const ObsCellFloat64* obs_cells, int32_t block_x, int32_t block_y, int32_t block_z, int32_t cell_idx,
                ObsCellFloat64& out_cell) {
    int lo = 0;
    int hi = static_cast<int>(map_header.num_blocks);
    while (lo < hi) {
        const int mid = (lo + hi) / 2;
        if (BlockLess(active_blocks[mid], block_x, block_y, block_z)) {
            lo = mid + 1;
        } else {
            hi = mid;
        }
    }
    if (lo >= static_cast<int>(map_header.num_blocks) || KeyLess(block_x, block_y, block_z, active_blocks[lo])) {
        return false;
    }
    const uint32_t offset = active_blocks[lo].first_cell + static_cast<uint32_t>(cell_idx);
    if (offset >= map_header.num_cells) {
        return false;
    }
    const ObsCellFloat64& cell = obs_cells[offset];
    if (!CellValid(cell)) {
        return false;
    }
    CopyCell(cell, out_cell);
    return true;
}

bool LookupNearest(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                   const ObsCellFloat64* obs_cells, const Vec3& point, ObsCellFloat64& out_cell) {
    int32_t center_bx = 0;
    int32_t center_by = 0;
    int32_t center_bz = 0;
    int32_t center_cell = 0;
    Encode(point, map_header, center_bx, center_by, center_bz, center_cell);

    if (LookupCell(map_header, active_blocks, obs_cells, center_bx, center_by, center_bz, center_cell, out_cell)) {
        return true;
    }
    if (map_header.lookup_nearby_type == 0) {
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
                if (!LookupCell(map_header, active_blocks, obs_cells, nbx, nby, nbz, ncell, candidate)) {
                    continue;
                }
                const double ddx = point.x - candidate.centroid_x;
                const double ddy = point.y - candidate.centroid_y;
                const double ddz = point.z - candidate.centroid_z;
                const double dist2 = ddx * ddx + ddy * ddy + ddz * ddz;
                if (!found || dist2 < best_dist2) {
                    best_dist2 = dist2;
                    CopyCell(candidate, best);
                    found = true;
                }
            }
        }
    }
    if (found) {
        CopyCell(best, out_cell);
    }
    return found;
}

void AccumulateUpper(double h[6][6], double b[6], const double j[6], double residual) {
    for (int r = 0; r < 6; ++r) {
        b[r] += j[r] * residual;
        for (int c = r; c < 6; ++c) {
            h[r][c] += j[r] * j[c];
        }
    }
}

void StoreOutput(const double h[6][6], const double b[6], SlamNormalEquation* output) {
    int idx = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            output->h_upper[idx++] = h[r][c];
        }
        output->b[r] = b[r];
    }
}

}  // namespace

void unified_surfel_observation_core(const SlamAccelScanPoint* scan_points, uint32_t num_points,
                                     const SlamAccelPose* pose, const ActiveMapHeader* map_header,
                                     const ActiveBlockRecord* active_blocks, const ObsCellFloat64* obs_cells,
                                     SlamNormalEquation* output) {
    ResetOutput(output);

    double h[6][6] = {{0.0}};
    double b[6] = {0.0};
    uint32_t valid_count = 0;
    uint32_t reject_count = 0;
    uint32_t miss_count = 0;
    double residual_sum = 0.0;
    double residual_abs_sum = 0.0;
    double residual_max_abs = 0.0;
    for (uint32_t i = 0; i < num_points; ++i) {
#pragma HLS LOOP_TRIPCOUNT min = 1 max = 8192 avg = 4096
        const SlamAccelScanPoint& scan = scan_points[i];
        if (!std::isfinite(scan.x) || !std::isfinite(scan.y) || !std::isfinite(scan.z)) {
            ++reject_count;
            continue;
        }

        const Vec3 p = RotatePoint(*pose, scan);
        ObsCellFloat64 cell;
        if (!LookupNearest(*map_header, active_blocks, obs_cells, p, cell)) {
            ++miss_count;
            continue;
        }

        const double nx = cell.normal_x;
        const double ny = cell.normal_y;
        const double nz = cell.normal_z;
        const double residual = nx * p.x + ny * p.y + nz * p.z + cell.plane_d;
        const double abs_residual = std::fabs(residual);
        if (!std::isfinite(residual) || abs_residual > 0.3) {
            ++reject_count;
            continue;
        }

        double j[6];
        j[0] = nx;
        j[1] = ny;
        j[2] = nz;
        j[3] = nz * p.y - ny * p.z;
        j[4] = nx * p.z - nz * p.x;
        j[5] = ny * p.x - nx * p.y;
        AccumulateUpper(h, b, j, residual);

        ++valid_count;
        residual_sum += residual;
        residual_abs_sum += abs_residual;
        if (abs_residual > residual_max_abs) {
            residual_max_abs = abs_residual;
        }
    }
    StoreOutput(h, b, output);
    output->valid_count = valid_count;
    output->reject_count = reject_count;
    output->miss_count = miss_count;
    output->residual_sum = residual_sum;
    output->residual_abs_sum = residual_abs_sum;
    output->residual_max_abs = residual_max_abs;
}

}  // namespace hls
}  // namespace fpga
}  // namespace lightning

void unified_surfel_observation_core(const lightning::fpga::SlamAccelScanPoint* scan_points, uint32_t num_points,
                                     const lightning::fpga::SlamAccelPose* pose,
                                     const lightning::fpga::ActiveMapHeader* map_header,
                                     const lightning::fpga::ActiveBlockRecord* active_blocks,
                                     const lightning::fpga::ObsCellFloat64* obs_cells,
                                     lightning::fpga::SlamNormalEquation* output) {
#pragma HLS INTERFACE ap_ctrl_hs port = return
#pragma HLS INTERFACE m_axi port = scan_points offset = direct bundle = gmem0 depth = 8192
#pragma HLS INTERFACE m_axi port = pose offset = direct bundle = gmem1 depth = 1
#pragma HLS INTERFACE m_axi port = map_header offset = direct bundle = gmem1 depth = 1
#pragma HLS INTERFACE m_axi port = active_blocks offset = direct bundle = gmem2 depth = 8192
#pragma HLS INTERFACE m_axi port = obs_cells offset = direct bundle = gmem3 depth = 1048576
#pragma HLS INTERFACE m_axi port = output offset = direct bundle = gmem4 depth = 1
#pragma HLS DATA_PACK variable = scan_points
#pragma HLS DATA_PACK variable = pose
#pragma HLS DATA_PACK variable = map_header
#pragma HLS DATA_PACK variable = active_blocks
#pragma HLS DATA_PACK variable = obs_cells
    lightning::fpga::hls::unified_surfel_observation_core(scan_points, num_points, pose, map_header, active_blocks,
                                                          obs_cells, output);
}
