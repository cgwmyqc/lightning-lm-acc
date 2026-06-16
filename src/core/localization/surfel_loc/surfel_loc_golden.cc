// SPDX-License-Identifier: MIT

#include "core/localization/surfel_loc/surfel_loc_golden.h"

#include <algorithm>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <vector>

namespace lightning::loc::golden {
namespace {

using lightning::fpga::GoldenFileHeader;

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

bool ValidateHeader(const GoldenFileHeader& header, uint32_t record_type, uint32_t record_bytes, std::string* error) {
    if (header.magic != fpga::SLAM_ACCEL_ABI_MAGIC || header.version != fpga::SLAM_ACCEL_GOLDEN_VERSION) {
        SetError(error, "golden file header magic/version mismatch");
        return false;
    }
    if (header.record_type != record_type || header.record_bytes != record_bytes) {
        SetError(error, "golden file record type/size mismatch");
        return false;
    }
    return true;
}

std::vector<fpga::SlamAccelScanPoint> ToAbiScan(const CloudPtr& cloud) {
    std::vector<fpga::SlamAccelScanPoint> out;
    if (cloud == nullptr) {
        return out;
    }
    out.reserve(cloud->size());
    for (const auto& point : cloud->points) {
        fpga::SlamAccelScanPoint abi_point;
        abi_point.x = point.x;
        abi_point.y = point.y;
        abi_point.z = point.z;
        abi_point.intensity = point.intensity;
        out.emplace_back(abi_point);
    }
    return out;
}

CloudPtr FromAbiScan(const std::vector<fpga::SlamAccelScanPoint>& points) {
    CloudPtr cloud(new PointCloudType);
    cloud->reserve(points.size());
    for (const auto& point : points) {
        PointType pcl_point;
        pcl_point.x = point.x;
        pcl_point.y = point.y;
        pcl_point.z = point.z;
        pcl_point.intensity = point.intensity;
        cloud->push_back(pcl_point);
    }
    return cloud;
}

bool WriteScan(const std::string& path, const CloudPtr& scan_body, std::string* error) {
    const auto points = ToAbiScan(scan_body);
    GoldenFileHeader header;
    header.record_type = fpga::GOLDEN_SCAN_POINTS;
    header.record_bytes = sizeof(fpga::SlamAccelScanPoint);
    header.record_count = static_cast<uint32_t>(points.size());

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
        SetError(error, "failed to write scan points");
        return false;
    }
    return true;
}

bool ReadScan(const std::string& path, CloudPtr& scan_body, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    GoldenFileHeader header;
    if (!ReadPod(ifs, header) ||
        !ValidateHeader(header, fpga::GOLDEN_SCAN_POINTS, sizeof(fpga::SlamAccelScanPoint), error)) {
        return false;
    }
    std::vector<fpga::SlamAccelScanPoint> points(header.record_count);
    ifs.read(reinterpret_cast<char*>(points.data()),
             static_cast<std::streamsize>(points.size() * sizeof(fpga::SlamAccelScanPoint)));
    if (!ifs) {
        SetError(error, "failed to read scan points");
        return false;
    }
    scan_body = FromAbiScan(points);
    return true;
}

bool WritePose(const std::string& path, const SE3& pose, std::string* error) {
    GoldenFileHeader header;
    header.record_type = fpga::GOLDEN_POSE;
    header.record_bytes = sizeof(fpga::SlamAccelPose);
    header.record_count = 1;

    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    const auto abi_pose = ToAbiPose(pose);
    return WritePod(ofs, header) && WritePod(ofs, abi_pose);
}

bool ReadPose(const std::string& path, SE3& pose, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    GoldenFileHeader header;
    fpga::SlamAccelPose abi_pose;
    if (!ReadPod(ifs, header) || !ValidateHeader(header, fpga::GOLDEN_POSE, sizeof(fpga::SlamAccelPose), error) ||
        !ReadPod(ifs, abi_pose)) {
        return false;
    }
    pose = FromAbiPose(abi_pose);
    return true;
}

fpga::ActiveMapHeader MakeActiveMapHeader(const ActiveMapBuffer& active_map) {
    fpga::ActiveMapHeader header;
    header.mode = fpga::LOCALIZATION_OBSERVATION;
    header.cells_per_block = active_map.cells_per_block;
    header.cell_resolution = active_map.cell_resolution;
    header.inv_cell_resolution = active_map.inv_cell_resolution;
    header.window_id = active_map.window_id;
    header.window_version = active_map.version;
    header.num_blocks = static_cast<uint32_t>(active_map.blocks.size());
    header.num_cells = static_cast<uint32_t>(active_map.cells.size());
    header.lookup_nearby_type = active_map.lookup_nearby_type;
    return header;
}

bool WriteActiveMap(const std::string& path, const ActiveMapBuffer& active_map, std::string* error) {
    GoldenFileHeader file_header;
    file_header.record_type = fpga::GOLDEN_ACTIVE_MAP;
    file_header.record_bytes = sizeof(fpga::ActiveMapHeader);
    file_header.record_count = 1;

    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    const auto map_header = MakeActiveMapHeader(active_map);
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

bool ReadActiveMap(const std::string& path, ActiveMapBuffer& active_map, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    GoldenFileHeader file_header;
    fpga::ActiveMapHeader map_header;
    if (!ReadPod(ifs, file_header) ||
        !ValidateHeader(file_header, fpga::GOLDEN_ACTIVE_MAP, sizeof(fpga::ActiveMapHeader), error) ||
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

bool WriteExpected(const std::string& path, const LocNormalEquation& equation, std::string* error) {
    GoldenFileHeader header;
    header.record_type = fpga::GOLDEN_NORMAL_EQUATION;
    header.record_bytes = sizeof(fpga::SlamNormalEquation);
    header.record_count = 1;

    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    const auto abi_equation = ToAbiNormalEquation(equation);
    return WritePod(ofs, header) && WritePod(ofs, abi_equation);
}

bool ReadExpected(const std::string& path, LocNormalEquation& equation, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    GoldenFileHeader header;
    fpga::SlamNormalEquation abi_equation;
    if (!ReadPod(ifs, header) ||
        !ValidateHeader(header, fpga::GOLDEN_NORMAL_EQUATION, sizeof(fpga::SlamNormalEquation), error) ||
        !ReadPod(ifs, abi_equation)) {
        return false;
    }
    equation = FromAbiNormalEquation(abi_equation);
    return true;
}

}  // namespace

fpga::SlamAccelPose ToAbiPose(const SE3& pose) {
    const Quatd q = pose.unit_quaternion();
    const Vec3d t = pose.translation();
    fpga::SlamAccelPose out;
    out.qx = static_cast<float>(q.x());
    out.qy = static_cast<float>(q.y());
    out.qz = static_cast<float>(q.z());
    out.qw = static_cast<float>(q.w());
    out.tx = static_cast<float>(t.x());
    out.ty = static_cast<float>(t.y());
    out.tz = static_cast<float>(t.z());
    return out;
}

SE3 FromAbiPose(const fpga::SlamAccelPose& pose) {
    Quatd q(pose.qw, pose.qx, pose.qy, pose.qz);
    q.normalize();
    return SE3(q, Vec3d(pose.tx, pose.ty, pose.tz));
}

fpga::SlamNormalEquation ToAbiNormalEquation(const LocNormalEquation& equation) {
    fpga::SlamNormalEquation out;
    int idx = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            out.h_upper[idx++] = equation.hessian(r, c);
        }
        out.b[r] = equation.gradient[r];
    }
    out.valid_count = equation.valid_count;
    out.reject_count = equation.reject_count;
    out.miss_count = equation.miss_count;
    out.residual_sum = equation.residual_sum;
    out.residual_abs_sum = equation.residual_abs_sum;
    out.residual_max_abs = equation.residual_max_abs;
    return out;
}

LocNormalEquation FromAbiNormalEquation(const fpga::SlamNormalEquation& equation) {
    LocNormalEquation out;
    out.Reset();
    int idx = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            out.hessian(r, c) = equation.h_upper[idx];
            out.hessian(c, r) = equation.h_upper[idx];
            ++idx;
        }
        out.gradient[r] = equation.b[r];
    }
    out.valid_count = equation.valid_count;
    out.reject_count = equation.reject_count;
    out.miss_count = equation.miss_count;
    out.residual_sum = equation.residual_sum;
    out.residual_abs_sum = equation.residual_abs_sum;
    out.residual_max_abs = equation.residual_max_abs;
    return out;
}

bool WriteLocalizationGolden(const std::string& dir, const CloudPtr& scan_body, const SE3& pose_guess,
                             const ActiveMapBuffer& active_map, const LocNormalEquation& expected_obs,
                             const SurfelLocOptions& options, std::string* error) {
    std::error_code ec;
    std::filesystem::create_directories(dir, ec);
    if (ec) {
        SetError(error, "failed to create golden dir: " + ec.message());
        return false;
    }

    if (!WriteScan(JoinPath(dir, "loc_scan.bin"), scan_body, error) ||
        !WritePose(JoinPath(dir, "loc_pose.bin"), pose_guess, error) ||
        !WriteActiveMap(JoinPath(dir, "loc_active_map.bin"), active_map, error) ||
        !WriteExpected(JoinPath(dir, "loc_expected_obs.bin"), expected_obs, error)) {
        return false;
    }

    std::ofstream meta(JoinPath(dir, "loc_meta.yaml"));
    if (!meta) {
        SetError(error, "failed to write loc_meta.yaml");
        return false;
    }
    meta << "mode: LOCALIZATION_OBSERVATION\n";
    meta << "num_scan_points: " << (scan_body ? scan_body->size() : 0) << "\n";
    meta << "num_active_blocks: " << active_map.blocks.size() << "\n";
    meta << "num_active_cells: " << active_map.cells.size() << "\n";
    meta << "map_window_id: " << active_map.window_id << "\n";
    meta << "map_window_version: " << active_map.version << "\n";
    meta << "cell_resolution: " << std::setprecision(9) << active_map.cell_resolution << "\n";
    meta << "lookup_nearby_type: " << options.lookup_nearby_type << "\n";
    meta << "expected:\n";
    meta << "  valid_count: " << expected_obs.valid_count << "\n";
    meta << "  reject_count: " << expected_obs.reject_count << "\n";
    meta << "  miss_count: " << expected_obs.miss_count << "\n";
    meta << "  residual_abs_sum: " << std::setprecision(17) << expected_obs.residual_abs_sum << "\n";
    meta << "  residual_max_abs: " << std::setprecision(17) << expected_obs.residual_max_abs << "\n";
    return true;
}

bool ReadLocalizationGolden(const std::string& dir, LocalizationGolden& golden, std::string* error) {
    return ReadScan(JoinPath(dir, "loc_scan.bin"), golden.scan_body, error) &&
           ReadPose(JoinPath(dir, "loc_pose.bin"), golden.pose_guess, error) &&
           ReadActiveMap(JoinPath(dir, "loc_active_map.bin"), golden.active_map, error) &&
           ReadExpected(JoinPath(dir, "loc_expected_obs.bin"), golden.expected_obs, error);
}

bool CompareNormalEquation(const LocNormalEquation& actual, const LocNormalEquation& expected, double abs_tol,
                           double rel_tol, std::string* report) {
    double max_abs = 0.0;
    double max_rel = 0.0;
    std::string field = "none";

    auto check_value = [&](const std::string& name, double a, double e) {
        const double abs_err = std::fabs(a - e);
        const double rel_err = abs_err / std::max(1.0, std::fabs(e));
        if (abs_err > max_abs) {
            max_abs = abs_err;
            field = name;
        }
        max_rel = std::max(max_rel, rel_err);
    };

    for (int r = 0; r < 6; ++r) {
        for (int c = 0; c < 6; ++c) {
            check_value("H(" + std::to_string(r) + "," + std::to_string(c) + ")", actual.hessian(r, c),
                        expected.hessian(r, c));
        }
        check_value("b(" + std::to_string(r) + ")", actual.gradient[r], expected.gradient[r]);
    }
    check_value("residual_sum", actual.residual_sum, expected.residual_sum);
    check_value("residual_abs_sum", actual.residual_abs_sum, expected.residual_abs_sum);
    check_value("residual_max_abs", actual.residual_max_abs, expected.residual_max_abs);

    const bool counts_ok = actual.valid_count == expected.valid_count && actual.reject_count == expected.reject_count &&
                           actual.miss_count == expected.miss_count;
    const bool values_ok = max_abs <= abs_tol || max_rel <= rel_tol;

    if (report != nullptr) {
        std::ostringstream ss;
        ss << "counts_ok=" << counts_ok << " values_ok=" << values_ok << " max_abs=" << max_abs
           << " max_rel=" << max_rel << " worst_field=" << field << " actual_counts=" << actual.valid_count << "/"
           << actual.reject_count << "/" << actual.miss_count << " expected_counts=" << expected.valid_count << "/"
           << expected.reject_count << "/" << expected.miss_count;
        *report = ss.str();
    }
    return counts_ok && values_ok;
}

}  // namespace lightning::loc::golden
