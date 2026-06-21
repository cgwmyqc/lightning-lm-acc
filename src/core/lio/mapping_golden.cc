// SPDX-License-Identifier: MIT

#include "core/lio/mapping_golden.h"

#include <algorithm>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <vector>

#include <pcl/io/pcd_io.h>
#include <yaml-cpp/yaml.h>

#include "core/fpga/xdma_runtime.h"
#include "core/lightning_math.hpp"
#include "core/localization/surfel_loc/surfel_loc_backend.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"

namespace lightning::mapping_golden {
namespace {

std::string JoinPath(const std::string& dir, const std::string& name) {
    return (std::filesystem::path(dir) / name).string();
}

void SetError(std::string* error, const std::string& message) {
    if (error != nullptr) {
        *error = message;
    }
}

template <typename T>
bool WritePod(std::ofstream& ofs, const T& value) {
    ofs.write(reinterpret_cast<const char*>(&value), sizeof(T));
    return static_cast<bool>(ofs);
}

template <typename T>
bool ReadPod(std::ifstream& ifs, T& value) {
    ifs.read(reinterpret_cast<char*>(&value), sizeof(T));
    return static_cast<bool>(ifs);
}

bool ValidateHeader(const fpga::GoldenFileHeader& header, uint32_t record_type, uint32_t record_bytes,
                    uint32_t mode, std::string* error) {
    if (header.magic != fpga::SLAM_ACCEL_ABI_MAGIC || header.version != fpga::SLAM_ACCEL_GOLDEN_VERSION) {
        SetError(error, "golden file header magic/version mismatch");
        return false;
    }
    if (header.record_type != record_type || header.record_bytes != record_bytes || header.mode != mode) {
        SetError(error, "golden file record type/size/mode mismatch");
        return false;
    }
    return true;
}

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

loc::SurfelLocBackend::EncodedCell EncodeCell(const loc::ActiveMapBuffer& active_map, const Vec3d& point_world) {
    const int block_dim_x = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_X);
    const int block_dim_y = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Y);
    const int block_dim_z = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Z);
    const double inv_res = active_map.inv_cell_resolution;
    const int gx = static_cast<int>(std::floor(point_world.x() * inv_res));
    const int gy = static_cast<int>(std::floor(point_world.y() * inv_res));
    const int gz = static_cast<int>(std::floor(point_world.z() * inv_res));

    loc::SurfelLocBackend::EncodedCell encoded;
    encoded.block_x = DivFloor(gx, block_dim_x);
    encoded.block_y = DivFloor(gy, block_dim_y);
    encoded.block_z = DivFloor(gz, block_dim_z);
    const int lx = ModFloor(gx, block_dim_x);
    const int ly = ModFloor(gy, block_dim_y);
    const int lz = ModFloor(gz, block_dim_z);
    encoded.cell_idx = (lz * block_dim_y + ly) * block_dim_x + lx;
    return encoded;
}

double PlaneResidual(const loc::ObsCellFloat64& cell, const Vec3d& point_world) {
    return cell.normal_x * point_world.x() + cell.normal_y * point_world.y() + cell.normal_z * point_world.z() +
           cell.plane_d;
}

bool BetterMappingCell(const loc::ObsCellFloat64& lhs, const loc::ObsCellFloat64& rhs, const Vec3d& point_world) {
    const double lhs_res = std::fabs(PlaneResidual(lhs, point_world));
    const double rhs_res = std::fabs(PlaneResidual(rhs, point_world));
    if (std::fabs(lhs_res - rhs_res) > 1e-4) {
        return lhs_res < rhs_res;
    }

    const Vec3d lhs_centroid(lhs.centroid_x, lhs.centroid_y, lhs.centroid_z);
    const Vec3d rhs_centroid(rhs.centroid_x, rhs.centroid_y, rhs.centroid_z);
    const double lhs_dist = (lhs_centroid - point_world).squaredNorm();
    const double rhs_dist = (rhs_centroid - point_world).squaredNorm();
    if (std::fabs(lhs_dist - rhs_dist) > 1e-4) {
        return lhs_dist < rhs_dist;
    }
    return lhs.quality < rhs.quality;
}

bool LookupMappingCell(const loc::SurfelLocBackend& lookup_backend, const loc::ActiveMapBuffer& active_map,
                       const Vec3d& point_world, const loc::ObsCellFloat64*& out_cell) {
    const auto encoded = EncodeCell(active_map, point_world);
    out_cell = lookup_backend.LookupCell(active_map, encoded);
    if (out_cell != nullptr) {
        return true;
    }

    if (active_map.lookup_nearby_type == 0) {
        return false;
    }

    bool has_candidate = false;
    const loc::ObsCellFloat64* best = nullptr;
    const int block_dim_x = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_X);
    const int block_dim_y = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Y);
    const int block_dim_z = static_cast<int>(fpga::SLAM_ACCEL_BLOCK_DIM_Z);
    const int base_lz = encoded.cell_idx / (block_dim_x * block_dim_y);
    const int rem = encoded.cell_idx - base_lz * block_dim_x * block_dim_y;
    const int base_ly = rem / block_dim_x;
    const int base_lx = rem - base_ly * block_dim_x;

    const int gx = encoded.block_x * block_dim_x + base_lx;
    const int gy = encoded.block_y * block_dim_y + base_ly;
    const int gz = encoded.block_z * block_dim_z + base_lz;
    for (int dx = -1; dx <= 1; ++dx) {
        for (int dy = -1; dy <= 1; ++dy) {
            for (int dz = -1; dz <= 1; ++dz) {
                if (dx == 0 && dy == 0 && dz == 0) {
                    continue;
                }
                const int manhattan = std::abs(dx) + std::abs(dy) + std::abs(dz);
                if (active_map.lookup_nearby_type == 6 && manhattan > 1) {
                    continue;
                }
                if (active_map.lookup_nearby_type == 18 && manhattan > 2) {
                    continue;
                }

                const int ngx = gx + dx;
                const int ngy = gy + dy;
                const int ngz = gz + dz;
                const int nbx = DivFloor(ngx, block_dim_x);
                const int nby = DivFloor(ngy, block_dim_y);
                const int nbz = DivFloor(ngz, block_dim_z);
                const int nlx = ModFloor(ngx, block_dim_x);
                const int nly = ModFloor(ngy, block_dim_y);
                const int nlz = ModFloor(ngz, block_dim_z);
                loc::SurfelLocBackend::EncodedCell neighbor;
                neighbor.block_x = nbx;
                neighbor.block_y = nby;
                neighbor.block_z = nbz;
                neighbor.cell_idx = (nlz * block_dim_y + nly) * block_dim_x + nlx;

                const loc::ObsCellFloat64* candidate = lookup_backend.LookupCell(active_map, neighbor);
                if (candidate != nullptr && (!has_candidate || BetterMappingCell(*candidate, *best, point_world))) {
                    best = candidate;
                    has_candidate = true;
                }
            }
        }
    }
    out_cell = best;
    return has_candidate;
}

std::vector<fpga::SlamAccelScanPoint> ToAbiScan(const CloudPtr& cloud) {
    std::vector<fpga::SlamAccelScanPoint> out;
    if (!cloud) {
        return out;
    }
    out.reserve(cloud->size());
    for (const auto& point : cloud->points) {
        fpga::SlamAccelScanPoint abi;
        abi.x = point.x;
        abi.y = point.y;
        abi.z = point.z;
        abi.intensity = point.intensity;
        out.emplace_back(abi);
    }
    return out;
}

CloudPtr FromAbiScan(const std::vector<fpga::SlamAccelScanPoint>& points) {
    CloudPtr cloud(new PointCloudType);
    cloud->reserve(points.size());
    for (const auto& point : points) {
        PointType p;
        p.x = point.x;
        p.y = point.y;
        p.z = point.z;
        p.intensity = point.intensity;
        cloud->push_back(p);
    }
    return cloud;
}

bool WriteScan(const std::string& path, const CloudPtr& cloud, std::string* error) {
    const auto points = ToAbiScan(cloud);
    fpga::GoldenFileHeader header;
    header.record_type = fpga::GOLDEN_SCAN_POINTS;
    header.record_bytes = sizeof(fpga::SlamAccelScanPoint);
    header.record_count = static_cast<uint32_t>(points.size());
    header.mode = fpga::MAPPING_OBSERVATION;

    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    if (!WritePod(ofs, header)) {
        SetError(error, "failed to write scan header");
        return false;
    }
    ofs.write(reinterpret_cast<const char*>(points.data()),
              static_cast<std::streamsize>(points.size() * sizeof(fpga::SlamAccelScanPoint)));
    if (!ofs) {
        SetError(error, "failed to write scan body");
        return false;
    }
    return true;
}

bool ReadScan(const std::string& path, CloudPtr& cloud, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    fpga::GoldenFileHeader header;
    if (!ReadPod(ifs, header) ||
        !ValidateHeader(header, fpga::GOLDEN_SCAN_POINTS, sizeof(fpga::SlamAccelScanPoint),
                        fpga::MAPPING_OBSERVATION, error)) {
        return false;
    }
    std::vector<fpga::SlamAccelScanPoint> points(header.record_count);
    ifs.read(reinterpret_cast<char*>(points.data()),
             static_cast<std::streamsize>(points.size() * sizeof(fpga::SlamAccelScanPoint)));
    if (!ifs) {
        SetError(error, "failed to read scan body");
        return false;
    }
    cloud = FromAbiScan(points);
    return true;
}

bool WriteActiveMap(const std::string& path, const loc::ActiveMapBuffer& active_map, std::string* error) {
    fpga::GoldenFileHeader file_header;
    file_header.record_type = fpga::GOLDEN_ACTIVE_MAP;
    file_header.record_bytes = sizeof(fpga::ActiveMapHeader);
    file_header.record_count = 1;
    file_header.mode = fpga::MAPPING_OBSERVATION;

    fpga::ActiveMapHeader map_header = fpga::MakeActiveMapHeader(active_map);
    map_header.mode = fpga::MAPPING_OBSERVATION;

    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    if (!WritePod(ofs, file_header) || !WritePod(ofs, map_header)) {
        SetError(error, "failed to write active map header");
        return false;
    }
    ofs.write(reinterpret_cast<const char*>(active_map.blocks.data()),
              static_cast<std::streamsize>(active_map.blocks.size() * sizeof(fpga::ActiveBlockRecord)));
    ofs.write(reinterpret_cast<const char*>(active_map.cells.data()),
              static_cast<std::streamsize>(active_map.cells.size() * sizeof(fpga::ObsCellFloat64)));
    if (!ofs) {
        SetError(error, "failed to write active map body");
        return false;
    }
    return true;
}

bool ReadActiveMap(const std::string& path, loc::ActiveMapBuffer& active_map, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    fpga::GoldenFileHeader file_header;
    fpga::ActiveMapHeader map_header;
    if (!ReadPod(ifs, file_header) ||
        !ValidateHeader(file_header, fpga::GOLDEN_ACTIVE_MAP, sizeof(fpga::ActiveMapHeader),
                        fpga::MAPPING_OBSERVATION, error) ||
        !ReadPod(ifs, map_header)) {
        return false;
    }

    active_map.Clear();
    active_map.cell_resolution = map_header.cell_resolution;
    active_map.inv_cell_resolution = map_header.inv_cell_resolution;
    active_map.window_id = map_header.window_id;
    active_map.version = map_header.window_version;
    active_map.cells_per_block = map_header.cells_per_block;
    active_map.lookup_nearby_type = map_header.lookup_nearby_type;
    active_map.blocks.resize(map_header.num_blocks);
    active_map.cells.resize(map_header.num_cells);
    ifs.read(reinterpret_cast<char*>(active_map.blocks.data()),
             static_cast<std::streamsize>(active_map.blocks.size() * sizeof(fpga::ActiveBlockRecord)));
    ifs.read(reinterpret_cast<char*>(active_map.cells.data()),
             static_cast<std::streamsize>(active_map.cells.size() * sizeof(fpga::ObsCellFloat64)));
    if (!ifs) {
        SetError(error, "failed to read active map body");
        return false;
    }
    return true;
}

bool WriteExpected(const std::string& path, const loc::LocNormalEquation& equation, std::string* error) {
    fpga::GoldenFileHeader header;
    header.record_type = fpga::GOLDEN_NORMAL_EQUATION;
    header.record_bytes = sizeof(fpga::SlamNormalEquation);
    header.record_count = 1;
    header.mode = fpga::MAPPING_OBSERVATION;

    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    const auto abi = loc::golden::ToAbiNormalEquation(equation);
    return WritePod(ofs, header) && WritePod(ofs, abi);
}

bool ReadExpected(const std::string& path, loc::LocNormalEquation& equation, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    fpga::GoldenFileHeader header;
    fpga::SlamNormalEquation abi;
    if (!ReadPod(ifs, header) ||
        !ValidateHeader(header, fpga::GOLDEN_NORMAL_EQUATION, sizeof(fpga::SlamNormalEquation),
                        fpga::MAPPING_OBSERVATION, error) ||
        !ReadPod(ifs, abi)) {
        return false;
    }
    equation = loc::golden::FromAbiNormalEquation(abi);
    return true;
}

bool WritePoseText(const std::string& path, const MappingGoldenFrame& frame, std::string* error) {
    std::ofstream ofs(path);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    const auto q = frame.state.rot_.unit_quaternion();
    ofs << std::setprecision(18) << frame.state.pos_.x() << " " << frame.state.pos_.y() << " "
        << frame.state.pos_.z() << " " << q.x() << " " << q.y() << " " << q.z() << " " << q.w() << "\n";
    return true;
}

bool ReadPoseText(const std::string& path, MappingGoldenFrame& frame, std::string* error) {
    std::ifstream ifs(path);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    double tx = 0.0, ty = 0.0, tz = 0.0, qx = 0.0, qy = 0.0, qz = 0.0, qw = 1.0;
    if (!(ifs >> tx >> ty >> tz >> qx >> qy >> qz >> qw)) {
        SetError(error, "failed to parse pose text");
        return false;
    }
    frame.state.pos_ = Vec3d(tx, ty, tz);
    frame.state.rot_ = SO3(Quatd(qw, qx, qy, qz).normalized());
    return true;
}

bool WriteMeta(const std::string& path, const MappingGoldenFrame& frame, const std::string& bag,
               const std::string& config, std::string* error) {
    std::ofstream ofs(path);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    ofs << std::setprecision(18);
    ofs << "bag: " << bag << "\n";
    ofs << "config: " << config << "\n";
    ofs << "frame_index: " << frame.frame_index << "\n";
    ofs << "timestamp: " << frame.timestamp << "\n";
    ofs << "scan_points: " << (frame.scan_body ? frame.scan_body->size() : 0) << "\n";
    ofs << "active_blocks: " << frame.active_map.blocks.size() << "\n";
    ofs << "active_cells: " << frame.active_map.cells.size() << "\n";
    ofs << "effect_feat_surf: " << frame.effect_feat_surf << "\n";
    ofs << "plane_icp_weight: " << frame.plane_icp_weight << "\n";
    ofs << "expected_counts: " << frame.expected_obs.valid_count << "/" << frame.expected_obs.reject_count << "/"
        << frame.expected_obs.miss_count << "\n";
    ofs << "extrinsic_T: [" << frame.extrinsic_t.x() << ", " << frame.extrinsic_t.y() << ", "
        << frame.extrinsic_t.z() << "]\n";
    ofs << "extrinsic_R: [";
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            if (r != 0 || c != 0) ofs << ", ";
            ofs << frame.extrinsic_R(r, c);
        }
    }
    ofs << "]\n";
    return true;
}

void ReadMetaIfPresent(const std::string& path, MappingGoldenFrame& frame) {
    if (!std::filesystem::exists(path)) {
        return;
    }
    YAML::Node yaml = YAML::LoadFile(path);
    if (yaml["frame_index"]) frame.frame_index = yaml["frame_index"].as<int>();
    if (yaml["timestamp"]) {
        frame.timestamp = yaml["timestamp"].as<double>();
        frame.state.timestamp_ = frame.timestamp;
    }
    if (yaml["effect_feat_surf"]) frame.effect_feat_surf = yaml["effect_feat_surf"].as<int>();
    if (yaml["plane_icp_weight"]) frame.plane_icp_weight = yaml["plane_icp_weight"].as<double>();
    if (yaml["extrinsic_T"]) {
        const auto t = yaml["extrinsic_T"].as<std::vector<double>>();
        if (t.size() == 3) frame.extrinsic_t = Vec3d(t[0], t[1], t[2]);
    }
    if (yaml["extrinsic_R"]) {
        const auto r = yaml["extrinsic_R"].as<std::vector<double>>();
        if (r.size() == 9) {
            frame.extrinsic_R << r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8];
        }
    }
}

}  // namespace

SE3 LidarPoseFromState(const NavState& state, const Mat3d& extrinsic_R, const Vec3d& extrinsic_t) {
    return SE3(SO3(state.rot_.matrix() * extrinsic_R), state.rot_ * extrinsic_t + state.pos_);
}

bool WriteSourceFrame(const std::string& output_dir, const MappingGoldenFrame& frame, const std::string& bag,
                      const std::string& config, std::string* error) {
    std::error_code ec;
    std::filesystem::create_directories(output_dir, ec);
    if (ec) {
        SetError(error, "failed to create " + output_dir + ": " + ec.message());
        return false;
    }
    if (frame.scan_body == nullptr || frame.scan_body->empty() || frame.active_map.Empty()) {
        SetError(error, "mapping source frame is empty");
        return false;
    }
    if (pcl::io::savePCDFileBinaryCompressed(JoinPath(output_dir, "scan_body_downsampled.pcd"), *frame.scan_body) != 0) {
        SetError(error, "failed to write scan_body_downsampled.pcd");
        return false;
    }
    return WriteScan(JoinPath(output_dir, "scan_body.bin"), frame.scan_body, error) &&
           WritePoseText(JoinPath(output_dir, "mapping_pose.txt"), frame, error) &&
           WriteActiveMap(JoinPath(output_dir, "active_map.bin"), frame.active_map, error) &&
           WriteExpected(JoinPath(output_dir, "expected_mapping_obs.bin"), frame.expected_obs, error) &&
           WriteMeta(JoinPath(output_dir, "frame_meta.yaml"), frame, bag, config, error);
}

bool ReadSourceFrame(const std::string& source_dir, MappingGoldenFrame& frame, std::string* error) {
    if (!ReadScan(JoinPath(source_dir, "scan_body.bin"), frame.scan_body, error) ||
        !ReadPoseText(JoinPath(source_dir, "mapping_pose.txt"), frame, error) ||
        !ReadActiveMap(JoinPath(source_dir, "active_map.bin"), frame.active_map, error) ||
        !ReadExpected(JoinPath(source_dir, "expected_mapping_obs.bin"), frame.expected_obs, error)) {
        return false;
    }
    ReadMetaIfPresent(JoinPath(source_dir, "frame_meta.yaml"), frame);
    return true;
}

bool WriteGoldenFrame(const std::string& output_dir, const MappingGoldenFrame& frame, std::string* error) {
    std::error_code ec;
    std::filesystem::create_directories(output_dir, ec);
    if (ec) {
        SetError(error, "failed to create " + output_dir + ": " + ec.message());
        return false;
    }
    return WriteScan(JoinPath(output_dir, "map_scan.bin"), frame.scan_body, error) &&
           WritePoseText(JoinPath(output_dir, "map_pose.txt"), frame, error) &&
           WriteActiveMap(JoinPath(output_dir, "map_active_map.bin"), frame.active_map, error) &&
           WriteExpected(JoinPath(output_dir, "map_expected_obs.bin"), frame.expected_obs, error) &&
           WriteMeta(JoinPath(output_dir, "map_meta.yaml"), frame, "", "", error);
}

bool ReadGoldenFrame(const std::string& golden_dir, MappingGoldenFrame& frame, std::string* error) {
    if (!ReadScan(JoinPath(golden_dir, "map_scan.bin"), frame.scan_body, error) ||
        !ReadPoseText(JoinPath(golden_dir, "map_pose.txt"), frame, error) ||
        !ReadActiveMap(JoinPath(golden_dir, "map_active_map.bin"), frame.active_map, error) ||
        !ReadExpected(JoinPath(golden_dir, "map_expected_obs.bin"), frame.expected_obs, error)) {
        return false;
    }
    ReadMetaIfPresent(JoinPath(golden_dir, "map_meta.yaml"), frame);
    return true;
}

bool ComputeMappingObservation(const CloudPtr& scan_body, const NavState& state, const Mat3d& extrinsic_R,
                               const Vec3d& extrinsic_t, const loc::ActiveMapBuffer& active_map,
                               double plane_icp_weight, loc::LocNormalEquation& out) {
    out.Reset();
    if (scan_body == nullptr || scan_body->empty() || active_map.Empty()) {
        return false;
    }

    loc::SurfelLocOptions options;
    options.cell_resolution = active_map.cell_resolution;
    options.lookup_nearby_type = static_cast<int>(active_map.lookup_nearby_type);
    loc::SurfelLocBackend lookup_backend(options);

    const SE3 lidar_pose = LidarPoseFromState(state, extrinsic_R, extrinsic_t);
    const Mat3f off_R = extrinsic_R.cast<float>();
    const Vec3f off_t = extrinsic_t.cast<float>();
    const Mat3f Rt = state.rot_.matrix().transpose().cast<float>();

    for (const auto& point : scan_body->points) {
        if (!std::isfinite(point.x) || !std::isfinite(point.y) || !std::isfinite(point.z)) {
            ++out.reject_count;
            continue;
        }
        const Vec3d point_world = lidar_pose * ToVec3d(point);
        const loc::ObsCellFloat64* cell = nullptr;
        if (!LookupMappingCell(lookup_backend, active_map, point_world, cell) || cell == nullptr) {
            ++out.miss_count;
            continue;
        }

        const Vec3f norm_vec(cell->normal_x, cell->normal_y, cell->normal_z);
        const float residual = norm_vec.x() * static_cast<float>(point_world.x()) +
                               norm_vec.y() * static_cast<float>(point_world.y()) +
                               norm_vec.z() * static_cast<float>(point_world.z()) + cell->plane_d;
        if (!std::isfinite(residual)) {
            ++out.reject_count;
            continue;
        }
        if (point.getVector3fMap().norm() <= 81.0f * residual * residual) {
            ++out.miss_count;
            continue;
        }

        const Vec3f point_this_be = point.getVector3fMap();
        const Vec3f point_this = off_R * point_this_be + off_t;
        const Mat3f point_crossmat = math::SKEW_SYM_MATRIX(point_this);
        const Vec3f C = Rt * norm_vec;
        const Vec3f A = point_crossmat * C;

        Eigen::Matrix<double, 1, 6> J;
        J << norm_vec[0], norm_vec[1], norm_vec[2], A[0], A[1], A[2];
        const double res = -static_cast<double>(residual);
        out.hessian.noalias() += (J.transpose() * J) * plane_icp_weight;
        out.gradient.noalias() += (J.transpose() * res) * plane_icp_weight;
        ++out.valid_count;
        out.residual_sum += residual;
        out.residual_abs_sum += std::fabs(residual);
        out.residual_max_abs = std::max(out.residual_max_abs, std::fabs(static_cast<double>(residual)));
    }
    return out.valid_count > 0;
}

bool CompareNormalEquation(const loc::LocNormalEquation& actual, const loc::LocNormalEquation& expected,
                           double abs_tol, double rel_tol, std::string* report) {
    bool pass = true;
    double max_abs = 0.0;
    double max_rel = 0.0;
    std::string worst = "none";
    auto check = [&](double a, double e, const std::string& name) {
        const double abs_err = std::fabs(a - e);
        const double rel_err = abs_err / std::max(1e-12, std::fabs(e));
        if (abs_err > max_abs) {
            max_abs = abs_err;
            worst = name;
        }
        max_rel = std::max(max_rel, rel_err);
        if (abs_err > abs_tol && rel_err > rel_tol) {
            pass = false;
        }
    };

    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            check(actual.hessian(r, c), expected.hessian(r, c),
                  "H(" + std::to_string(r) + "," + std::to_string(c) + ")");
        }
        check(actual.gradient(r), expected.gradient(r), "b(" + std::to_string(r) + ")");
    }
    pass = pass && actual.valid_count == expected.valid_count && actual.reject_count == expected.reject_count &&
           actual.miss_count == expected.miss_count;

    if (report != nullptr) {
        std::ostringstream oss;
        oss << "counts actual=" << actual.valid_count << "/" << actual.reject_count << "/" << actual.miss_count
            << " expected=" << expected.valid_count << "/" << expected.reject_count << "/" << expected.miss_count
            << " values_ok=" << (pass ? 1 : 0) << " max_abs=" << max_abs << " max_rel=" << max_rel
            << " worst_field=" << worst;
        *report = oss.str();
    }
    return pass;
}

}  // namespace lightning::mapping_golden
