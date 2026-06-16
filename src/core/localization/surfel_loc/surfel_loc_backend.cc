// SPDX-License-Identifier: MIT

#include "core/localization/surfel_loc/surfel_loc_backend.h"

#include <Eigen/Cholesky>
#include <algorithm>
#include <cmath>
#include <limits>

#include <glog/logging.h>
#include <pcl/common/transforms.h>

namespace lightning::loc {
namespace {

constexpr int kBlockDimX = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_X);
constexpr int kBlockDimY = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Y);
constexpr int kBlockDimZ = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Z);

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

bool BlockLess(int32_t x, int32_t y, int32_t z, const ActiveBlockRecord& rhs) {
    if (x != rhs.x) return x < rhs.x;
    if (y != rhs.y) return y < rhs.y;
    return z < rhs.z;
}

bool BlockLess(const ActiveBlockRecord& lhs, int32_t x, int32_t y, int32_t z) {
    if (lhs.x != x) return lhs.x < x;
    if (lhs.y != y) return lhs.y < y;
    return lhs.z < z;
}

Mat3d Skew(const Vec3d& v) {
    Mat3d s;
    s << 0.0, -v.z(), v.y(), v.z(), 0.0, -v.x(), -v.y(), v.x(), 0.0;
    return s;
}

}  // namespace

SurfelLocBackend::SurfelLocBackend(SurfelLocOptions options) : options_(options) {}

bool SurfelLocBackend::ComputeObservation(const CloudPtr& scan_body, const SE3& pose_guess,
                                          const ActiveMapBuffer& map, LocNormalEquation& out) const {
    out.Reset();
    if (scan_body == nullptr || scan_body->empty() || map.Empty()) {
        return false;
    }

    for (const auto& point : scan_body->points) {
        if (!std::isfinite(point.x) || !std::isfinite(point.y) || !std::isfinite(point.z)) {
            ++out.reject_count;
            continue;
        }

        const Vec3d point_world = pose_guess * ToVec3d(point);
        const ObsCellFloat64* cell = nullptr;
        if (!TryLookupNearest(map, point_world, cell)) {
            ++out.miss_count;
            continue;
        }

        const Vec3d normal(cell->normal_x, cell->normal_y, cell->normal_z);
        const double residual = normal.dot(point_world) + static_cast<double>(cell->plane_d);
        const double abs_residual = std::fabs(residual);
        if (!std::isfinite(residual) || abs_residual > options_.residual_outlier_th) {
            ++out.reject_count;
            continue;
        }

        Eigen::Matrix<double, 1, 6> jacobian;
        jacobian.block<1, 3>(0, 0) = normal.transpose();
        jacobian.block<1, 3>(0, 3) = -normal.transpose() * Skew(point_world);

        out.hessian.noalias() += jacobian.transpose() * jacobian;
        out.gradient.noalias() += jacobian.transpose() * residual;
        ++out.valid_count;
        out.residual_sum += residual;
        out.residual_abs_sum += abs_residual;
        out.residual_max_abs = std::max(out.residual_max_abs, abs_residual);
    }

    return out.valid_count > 0;
}

bool SurfelLocBackend::Align(const CloudPtr& scan_body, const SE3& init_pose, const ActiveMapBuffer& map,
                             SE3& pose_out, LocQuality& quality_out) const {
    pose_out = init_pose;
    quality_out = LocQuality();
    quality_out.active_window_id = map.window_id;
    quality_out.active_window_version = map.version;

    if (scan_body == nullptr || scan_body->empty() || map.Empty()) {
        return false;
    }

    LocNormalEquation equation;
    bool matrix_ok = false;
    for (int iter = 0; iter < options_.max_iterations; ++iter) {
        if (!ComputeObservation(scan_body, pose_out, map, equation)) {
            break;
        }

        quality_out.iterations = iter + 1;
        quality_out.valid_count = equation.valid_count;
        quality_out.reject_count = equation.reject_count;
        quality_out.miss_count = equation.miss_count;
        quality_out.mean_residual =
            equation.valid_count > 0 ? equation.residual_sum / static_cast<double>(equation.valid_count) : 0.0;
        quality_out.mean_abs_residual =
            equation.valid_count > 0 ? equation.residual_abs_sum / static_cast<double>(equation.valid_count) : 0.0;
        quality_out.max_abs_residual = equation.residual_max_abs;

        Mat6d hessian = equation.hessian;
        hessian.diagonal().array() += 1e-6;
        Eigen::LDLT<Mat6d> ldlt(hessian);
        if (ldlt.info() != Eigen::Success) {
            matrix_ok = false;
            break;
        }

        const Vec6d dx = ldlt.solve(-equation.gradient);
        if (!dx.allFinite()) {
            matrix_ok = false;
            break;
        }

        matrix_ok = true;
        pose_out = SE3::exp(dx) * pose_out;

        const double trans_step = dx.head<3>().norm();
        const double rot_step = dx.tail<3>().norm();
        if (trans_step < options_.convergence_translation && rot_step < options_.convergence_rotation) {
            quality_out.converged = true;
            break;
        }
    }

    quality_out.matrix_ok = matrix_ok;
    const double inlier_ratio =
        scan_body->empty() ? 0.0 : static_cast<double>(quality_out.valid_count) / static_cast<double>(scan_body->size());
    quality_out.score = 4.0 * inlier_ratio / (1.0 + 10.0 * quality_out.mean_abs_residual);

    return quality_out.matrix_ok && quality_out.valid_count >= static_cast<uint32_t>(options_.min_valid_count) &&
           quality_out.mean_abs_residual <= options_.max_mean_residual;
}

SurfelLocBackend::EncodedCell SurfelLocBackend::Encode(const Vec3d& point_world, const ActiveMapBuffer& map) const {
    const int gx = static_cast<int>(std::floor(point_world.x() * map.inv_cell_resolution));
    const int gy = static_cast<int>(std::floor(point_world.y() * map.inv_cell_resolution));
    const int gz = static_cast<int>(std::floor(point_world.z() * map.inv_cell_resolution));

    EncodedCell encoded;
    encoded.block_x = FloorDiv(gx, kBlockDimX);
    encoded.block_y = FloorDiv(gy, kBlockDimY);
    encoded.block_z = FloorDiv(gz, kBlockDimZ);

    const int lx = PositiveMod(gx, kBlockDimX);
    const int ly = PositiveMod(gy, kBlockDimY);
    const int lz = PositiveMod(gz, kBlockDimZ);
    encoded.cell_idx = (lz * kBlockDimY + ly) * kBlockDimX + lx;
    return encoded;
}

const ObsCellFloat64* SurfelLocBackend::LookupCell(const ActiveMapBuffer& map, const EncodedCell& encoded) const {
    const auto iter = std::lower_bound(
        map.blocks.begin(), map.blocks.end(), encoded,
        [](const ActiveBlockRecord& lhs, const EncodedCell& rhs) {
            return BlockLess(lhs, rhs.block_x, rhs.block_y, rhs.block_z);
        });
    if (iter == map.blocks.end() || BlockLess(encoded.block_x, encoded.block_y, encoded.block_z, *iter)) {
        return nullptr;
    }

    const size_t cell_offset = static_cast<size_t>(iter->first_cell) + static_cast<size_t>(encoded.cell_idx);
    if (cell_offset >= map.cells.size()) {
        return nullptr;
    }

    const ObsCellFloat64& cell = map.cells[cell_offset];
    if ((cell.flags & fpga::OBS_CELL_VALID) == 0) {
        return nullptr;
    }
    return &cell;
}

bool SurfelLocBackend::TryLookupNearest(const ActiveMapBuffer& map, const Vec3d& point_world,
                                        const ObsCellFloat64*& cell) const {
    const EncodedCell center = Encode(point_world, map);
    cell = LookupCell(map, center);
    if (cell != nullptr || options_.lookup_nearby_type <= 0) {
        return cell != nullptr;
    }

    int neighbor_limit = 0;
    if (options_.lookup_nearby_type <= 6) {
        neighbor_limit = 6;
    } else if (options_.lookup_nearby_type <= 18) {
        neighbor_limit = 18;
    } else {
        neighbor_limit = 26;
    }

    double best_dist2 = std::numeric_limits<double>::max();
    const ObsCellFloat64* best_cell = nullptr;
    for (int dz = -1; dz <= 1; ++dz) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dx = -1; dx <= 1; ++dx) {
                const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                const int chessboard = std::max({std::abs(dx), std::abs(dy), std::abs(dz)});
                if (manhattan == 0) {
                    continue;
                }
                if ((neighbor_limit == 6 && manhattan != 1) || (neighbor_limit == 18 && chessboard > 1) ||
                    (neighbor_limit == 18 && manhattan > 2)) {
                    continue;
                }

                EncodedCell neighbor = center;
                int local = center.cell_idx;
                int lx = local % kBlockDimX;
                local /= kBlockDimX;
                int ly = local % kBlockDimY;
                int lz = local / kBlockDimY;

                lx += dx;
                ly += dy;
                lz += dz;
                if (lx < 0) {
                    lx += kBlockDimX;
                    --neighbor.block_x;
                } else if (lx >= kBlockDimX) {
                    lx -= kBlockDimX;
                    ++neighbor.block_x;
                }
                if (ly < 0) {
                    ly += kBlockDimY;
                    --neighbor.block_y;
                } else if (ly >= kBlockDimY) {
                    ly -= kBlockDimY;
                    ++neighbor.block_y;
                }
                if (lz < 0) {
                    lz += kBlockDimZ;
                    --neighbor.block_z;
                } else if (lz >= kBlockDimZ) {
                    lz -= kBlockDimZ;
                    ++neighbor.block_z;
                }
                neighbor.cell_idx = (lz * kBlockDimY + ly) * kBlockDimX + lx;

                const ObsCellFloat64* candidate = LookupCell(map, neighbor);
                if (candidate == nullptr) {
                    continue;
                }
                const Vec3d centroid(candidate->centroid_x, candidate->centroid_y, candidate->centroid_z);
                const double dist2 = (point_world - centroid).squaredNorm();
                if (dist2 < best_dist2) {
                    best_dist2 = dist2;
                    best_cell = candidate;
                }
            }
        }
    }

    cell = best_cell;
    return cell != nullptr;
}

}  // namespace lightning::loc
