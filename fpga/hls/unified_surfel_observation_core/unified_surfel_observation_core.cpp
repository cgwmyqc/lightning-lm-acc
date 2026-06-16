// SPDX-License-Identifier: MIT

#include "unified_surfel_observation_core.h"

#include <algorithm>
#include <cmath>

namespace lightning::fpga::hls {
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

const ObsCellFloat64* LookupCell(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                                 const ObsCellFloat64* obs_cells, int32_t block_x, int32_t block_y, int32_t block_z,
                                 int32_t cell_idx) {
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
        return nullptr;
    }
    const uint32_t offset = active_blocks[lo].first_cell + static_cast<uint32_t>(cell_idx);
    if (offset >= map_header.num_cells) {
        return nullptr;
    }
    const ObsCellFloat64* cell = &obs_cells[offset];
    return (cell->flags & OBS_CELL_VALID) != 0 ? cell : nullptr;
}

const ObsCellFloat64* LookupNearest(const ActiveMapHeader& map_header, const ActiveBlockRecord* active_blocks,
                                    const ObsCellFloat64* obs_cells, const Vec3& point) {
    int32_t center_bx = 0;
    int32_t center_by = 0;
    int32_t center_bz = 0;
    int32_t center_cell = 0;
    Encode(point, map_header, center_bx, center_by, center_bz, center_cell);

    const ObsCellFloat64* center = LookupCell(map_header, active_blocks, obs_cells, center_bx, center_by, center_bz,
                                              center_cell);
    if (center != nullptr || map_header.lookup_nearby_type == 0) {
        return center;
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

    const ObsCellFloat64* best = nullptr;
    double best_dist2 = 1.0e100;
    for (int dz = -1; dz <= 1; ++dz) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dx = -1; dx <= 1; ++dx) {
                const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                const int chessboard = std::max(std::max(std::abs(dx), std::abs(dy)), std::abs(dz));
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
                const ObsCellFloat64* candidate = LookupCell(map_header, active_blocks, obs_cells, nbx, nby, nbz, ncell);
                if (candidate == nullptr) {
                    continue;
                }
                const double ddx = point.x - candidate->centroid_x;
                const double ddy = point.y - candidate->centroid_y;
                const double ddz = point.z - candidate->centroid_z;
                const double dist2 = ddx * ddx + ddy * ddy + ddz * ddz;
                if (dist2 < best_dist2) {
                    best_dist2 = dist2;
                    best = candidate;
                }
            }
        }
    }
    return best;
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
    if (scan_points == nullptr || pose == nullptr || map_header == nullptr || active_blocks == nullptr ||
        obs_cells == nullptr || output == nullptr) {
        return;
    }
    *output = SlamNormalEquation();

    double h[6][6] = {{0.0}};
    double b[6] = {0.0};
    for (uint32_t i = 0; i < num_points; ++i) {
        const SlamAccelScanPoint& scan = scan_points[i];
        if (!std::isfinite(scan.x) || !std::isfinite(scan.y) || !std::isfinite(scan.z)) {
            ++output->reject_count;
            continue;
        }

        const Vec3 p = RotatePoint(*pose, scan);
        const ObsCellFloat64* cell = LookupNearest(*map_header, active_blocks, obs_cells, p);
        if (cell == nullptr) {
            ++output->miss_count;
            continue;
        }

        const double nx = cell->normal_x;
        const double ny = cell->normal_y;
        const double nz = cell->normal_z;
        const double residual = nx * p.x + ny * p.y + nz * p.z + cell->plane_d;
        const double abs_residual = std::fabs(residual);
        if (!std::isfinite(residual) || abs_residual > 0.3) {
            ++output->reject_count;
            continue;
        }

        double j[6];
        j[0] = nx;
        j[1] = ny;
        j[2] = nz;
        j[3] = ny * p.z - nz * p.y;
        j[4] = nz * p.x - nx * p.z;
        j[5] = nx * p.y - ny * p.x;
        AccumulateUpper(h, b, j, residual);

        ++output->valid_count;
        output->residual_sum += residual;
        output->residual_abs_sum += abs_residual;
        if (abs_residual > output->residual_max_abs) {
            output->residual_max_abs = abs_residual;
        }
    }
    StoreOutput(h, b, output);
}

}  // namespace lightning::fpga::hls
