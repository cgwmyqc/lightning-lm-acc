// SPDX-License-Identifier: MIT

#include "core/localization/surfel_loc/surfel_map_window.h"

#include <Eigen/Eigenvalues>
#include <algorithm>
#include <cmath>
#include <unordered_map>

#include <glog/logging.h>

namespace lightning::loc {
namespace {

constexpr int kBlockDimX = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_X);
constexpr int kBlockDimY = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Y);
constexpr int kBlockDimZ = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Z);
constexpr int kCellsPerBlock = static_cast<int>(fpga::SLAM_ACCEL_CELLS_PER_BLOCK);

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

}  // namespace

size_t SurfelMapWindow::BlockKeyHash::operator()(const BlockKey& key) const {
    uint64_t h = static_cast<uint64_t>(key.x) * 73856093u;
    h ^= static_cast<uint64_t>(key.y) * 19349663u;
    h ^= static_cast<uint64_t>(key.z) * 83492791u;
    return static_cast<size_t>(h);
}

SurfelMapWindow::SurfelMapWindow(SurfelLocOptions options) { SetOptions(options); }

void SurfelMapWindow::SetOptions(const SurfelLocOptions& options) {
    options_ = options;
    buffer_.cell_resolution = options_.cell_resolution;
    buffer_.inv_cell_resolution = 1.0f / std::max(options_.cell_resolution, 1e-3f);
    buffer_.cells_per_block = kCellsPerBlock;
    buffer_.lookup_nearby_type = static_cast<uint32_t>(options_.lookup_nearby_type);
}

bool SurfelMapWindow::BuildFromCloud(const CloudPtr& cloud) {
    buffer_.Clear();
    buffer_.cell_resolution = options_.cell_resolution;
    buffer_.inv_cell_resolution = 1.0f / std::max(options_.cell_resolution, 1e-3f);
    buffer_.cells_per_block = kCellsPerBlock;
    buffer_.lookup_nearby_type = static_cast<uint32_t>(options_.lookup_nearby_type);

    if (cloud == nullptr || cloud->empty()) {
        LOG(WARNING) << "[SurfelMapWindow] empty active map cloud";
        return false;
    }

    std::unordered_map<BlockKey, TempBlock, BlockKeyHash> temp_blocks;
    temp_blocks.reserve(cloud->size() / kCellsPerBlock + 1);

    for (const auto& point : cloud->points) {
        if (!std::isfinite(point.x) || !std::isfinite(point.y) || !std::isfinite(point.z)) {
            continue;
        }

        BlockKey block_key;
        int cell_idx = 0;
        Encode(point.getVector3fMap(), block_key, cell_idx);
        auto& cell = temp_blocks[block_key].cells[cell_idx];
        const double x = point.x;
        const double y = point.y;
        const double z = point.z;
        ++cell.count;
        cell.sum[0] += x;
        cell.sum[1] += y;
        cell.sum[2] += z;
        cell.scatter[0] += x * x;
        cell.scatter[1] += x * y;
        cell.scatter[2] += x * z;
        cell.scatter[3] += y * y;
        cell.scatter[4] += y * z;
        cell.scatter[5] += z * z;
    }

    std::vector<BlockKey> keys;
    keys.reserve(temp_blocks.size());
    for (const auto& item : temp_blocks) {
        keys.emplace_back(item.first);
    }
    std::sort(keys.begin(), keys.end(), [](const BlockKey& lhs, const BlockKey& rhs) {
        if (lhs.x != rhs.x) return lhs.x < rhs.x;
        if (lhs.y != rhs.y) return lhs.y < rhs.y;
        return lhs.z < rhs.z;
    });

    buffer_.blocks.reserve(keys.size());
    buffer_.cells.reserve(keys.size() * kCellsPerBlock);

    uint32_t valid_blocks = 0;
    uint32_t valid_cells = 0;
    for (const auto& key : keys) {
        ActiveBlockRecord block;
        block.x = key.x;
        block.y = key.y;
        block.z = key.z;
        block.first_cell = static_cast<uint32_t>(buffer_.cells.size());

        uint32_t block_valid_cells = 0;
        const auto& temp_block = temp_blocks.at(key);
        for (int i = 0; i < kCellsPerBlock; ++i) {
            ObsCellFloat64 obs_cell;
            if (FitCell(temp_block.cells[i], obs_cell)) {
                ++block_valid_cells;
                ++valid_cells;
            }
            buffer_.cells.emplace_back(obs_cell);
        }

        block.valid_cell_count = block_valid_cells;
        if (block_valid_cells > 0) {
            ++valid_blocks;
        }
        buffer_.blocks.emplace_back(block);
    }

    buffer_.window_id = next_window_id_++;
    ++buffer_.version;

    LOG(INFO) << "[SurfelMapWindow] active cloud pts=" << cloud->size() << " blocks=" << buffer_.blocks.size()
              << " valid_blocks=" << valid_blocks << " valid_cells=" << valid_cells
              << " version=" << buffer_.version;

    return valid_cells > 0;
}

void SurfelMapWindow::Encode(const Vec3f& point, BlockKey& block_key, int& cell_idx) const {
    const int gx = static_cast<int>(std::floor(point.x() * buffer_.inv_cell_resolution));
    const int gy = static_cast<int>(std::floor(point.y() * buffer_.inv_cell_resolution));
    const int gz = static_cast<int>(std::floor(point.z() * buffer_.inv_cell_resolution));

    block_key.x = FloorDiv(gx, kBlockDimX);
    block_key.y = FloorDiv(gy, kBlockDimY);
    block_key.z = FloorDiv(gz, kBlockDimZ);

    const int lx = PositiveMod(gx, kBlockDimX);
    const int ly = PositiveMod(gy, kBlockDimY);
    const int lz = PositiveMod(gz, kBlockDimZ);
    cell_idx = (lz * kBlockDimY + ly) * kBlockDimX + lx;
}

bool SurfelMapWindow::FitCell(const CellAccum& accum, ObsCellFloat64& out) const {
    if (static_cast<int>(accum.count) < options_.min_support) {
        return false;
    }

    const double inv_count = 1.0 / static_cast<double>(accum.count);
    const Vec3d centroid(accum.sum[0] * inv_count, accum.sum[1] * inv_count, accum.sum[2] * inv_count);

    Mat3d cov;
    cov(0, 0) = accum.scatter[0] * inv_count - centroid.x() * centroid.x();
    cov(0, 1) = accum.scatter[1] * inv_count - centroid.x() * centroid.y();
    cov(0, 2) = accum.scatter[2] * inv_count - centroid.x() * centroid.z();
    cov(1, 0) = cov(0, 1);
    cov(1, 1) = accum.scatter[3] * inv_count - centroid.y() * centroid.y();
    cov(1, 2) = accum.scatter[4] * inv_count - centroid.y() * centroid.z();
    cov(2, 0) = cov(0, 2);
    cov(2, 1) = cov(1, 2);
    cov(2, 2) = accum.scatter[5] * inv_count - centroid.z() * centroid.z();

    Eigen::SelfAdjointEigenSolver<Mat3d> solver(cov);
    if (solver.info() != Eigen::Success) {
        return false;
    }

    const Vec3d eigen_values = solver.eigenvalues();
    const double trace = eigen_values.sum();
    if (trace < 1e-12) {
        return false;
    }

    const double quality = eigen_values[0] / trace;
    if (quality > options_.quality_max) {
        out.quality = static_cast<float>(quality);
        return false;
    }

    Vec3d normal = solver.eigenvectors().col(0);
    const double norm = normal.norm();
    if (norm < 1e-12) {
        return false;
    }
    normal /= norm;

    out.centroid_x = static_cast<float>(centroid.x());
    out.centroid_y = static_cast<float>(centroid.y());
    out.centroid_z = static_cast<float>(centroid.z());
    out.normal_x = static_cast<float>(normal.x());
    out.normal_y = static_cast<float>(normal.y());
    out.normal_z = static_cast<float>(normal.z());
    out.plane_d = static_cast<float>(-normal.dot(centroid));
    out.quality = static_cast<float>(quality);
    out.count = accum.count;
    out.flags = fpga::OBS_CELL_VALID;
    return true;
}

}  // namespace lightning::loc
