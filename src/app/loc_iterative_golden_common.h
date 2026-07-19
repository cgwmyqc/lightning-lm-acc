// SPDX-License-Identifier: MIT
#pragma once

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <limits>
#include <sstream>
#include <string>
#include <vector>

#include "core/localization/surfel_loc/surfel_loc_backend.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"
#include "fpga/hls/slam_loc_iterative_core/slam_loc_iterative_core.h"

namespace lightning::loc::iter_golden {

struct LocIterativeOptions {
    uint32_t max_iterations = 4;
    double residual_outlier_th = 0.3;
    double conv_translation = 1e-4;
    double conv_rotation = 1e-4;
    uint32_t min_valid_count = 300;
};

struct LocIterativeOutput {
    uint32_t status = 0;
    uint32_t flags = 0;
    uint32_t iterations = 0;
    uint32_t valid_count = 0;
    uint32_t reject_count = 0;
    uint32_t miss_count = 0;
    SE3 final_pose;
    Vec6d last_dx = Vec6d::Zero();
    double residual_sum = 0.0;
    double residual_abs_sum = 0.0;
    double residual_max_abs = 0.0;
    double score = 0.0;
};

struct LocIterativeGolden {
    std::vector<fpga::SlamAccelScanPoint> scan_points;
    std::vector<fpga::ObsCellFloat64> candidate_cells;
    std::array<uint64_t, fpga::LOC_ITER_INPUT_WORDS> input_words{};
    std::array<uint64_t, fpga::LOC_ITER_OUTPUT_WORDS> expected_words{};
};

inline std::string JoinPath(const std::string& dir, const std::string& name) {
    return (std::filesystem::path(dir) / name).string();
}

inline void SetError(std::string* error, const std::string& message) {
    if (error != nullptr) {
        *error = message;
    }
}

inline uint64_t Pack32(uint32_t lo, uint32_t hi) {
    return static_cast<uint64_t>(lo) | (static_cast<uint64_t>(hi) << 32);
}

inline uint32_t Low32(uint64_t value) {
    return static_cast<uint32_t>(value & 0xffffffffULL);
}

inline uint32_t High32(uint64_t value) {
    return static_cast<uint32_t>((value >> 32) & 0xffffffffULL);
}

inline uint64_t DoubleToBits(double value) {
    uint64_t bits = 0;
    std::memcpy(&bits, &value, sizeof(bits));
    return bits;
}

inline double BitsToDouble(uint64_t bits) {
    double value = 0.0;
    std::memcpy(&value, &bits, sizeof(value));
    return value;
}

inline double DxNorm(const Vec6d& dx) {
    return std::sqrt(dx.squaredNorm());
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

inline bool ValidateHeader(const fpga::GoldenFileHeader& header, uint32_t record_type, uint32_t record_bytes,
                           std::string* error) {
    if (header.magic != fpga::SLAM_ACCEL_ABI_MAGIC || header.version != fpga::SLAM_ACCEL_GOLDEN_VERSION) {
        SetError(error, "golden file header magic/version mismatch");
        return false;
    }
    if (header.record_type != record_type || header.record_bytes != record_bytes) {
        std::ostringstream ss;
        ss << "golden file record type/size mismatch type=" << header.record_type << " bytes="
           << header.record_bytes << " expected_type=" << record_type << " expected_bytes=" << record_bytes;
        SetError(error, ss.str());
        return false;
    }
    return true;
}

template <typename T>
bool WriteVectorFile(const std::string& path, uint32_t record_type, const std::vector<T>& values, std::string* error) {
    fpga::GoldenFileHeader header;
    header.record_type = record_type;
    header.record_bytes = sizeof(T);
    header.record_count = static_cast<uint32_t>(values.size());
    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    if (!WritePod(ofs, header)) {
        SetError(error, "failed to write header: " + path);
        return false;
    }
    if (!values.empty()) {
        ofs.write(reinterpret_cast<const char*>(values.data()),
                  static_cast<std::streamsize>(values.size() * sizeof(T)));
    }
    if (!ofs) {
        SetError(error, "failed to write vector body: " + path);
        return false;
    }
    return true;
}

template <typename T>
bool ReadVectorFile(const std::string& path, uint32_t record_type, std::vector<T>& values, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    fpga::GoldenFileHeader header;
    if (!ReadPod(ifs, header) || !ValidateHeader(header, record_type, sizeof(T), error)) {
        return false;
    }
    values.resize(header.record_count);
    if (!values.empty()) {
        ifs.read(reinterpret_cast<char*>(values.data()), static_cast<std::streamsize>(values.size() * sizeof(T)));
    }
    if (!ifs) {
        SetError(error, "failed to read vector body: " + path);
        return false;
    }
    return true;
}

template <size_t N>
bool WriteWordFile(const std::string& path, uint32_t record_type, const std::array<uint64_t, N>& words,
                   std::string* error) {
    fpga::GoldenFileHeader header;
    header.record_type = record_type;
    header.record_bytes = sizeof(uint64_t);
    header.record_count = static_cast<uint32_t>(words.size());
    std::ofstream ofs(path, std::ios::binary);
    if (!ofs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    ofs.write(reinterpret_cast<const char*>(&header), sizeof(header));
    ofs.write(reinterpret_cast<const char*>(words.data()), static_cast<std::streamsize>(words.size() * sizeof(uint64_t)));
    if (!ofs) {
        SetError(error, "failed to write words: " + path);
        return false;
    }
    return true;
}

template <size_t N>
bool ReadWordFile(const std::string& path, uint32_t record_type, std::array<uint64_t, N>& words, std::string* error) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs) {
        SetError(error, "failed to open " + path);
        return false;
    }
    fpga::GoldenFileHeader header;
    if (!ReadPod(ifs, header) || !ValidateHeader(header, record_type, sizeof(uint64_t), error)) {
        return false;
    }
    if (header.record_count != words.size()) {
        SetError(error, "word count mismatch in " + path);
        return false;
    }
    ifs.read(reinterpret_cast<char*>(words.data()), static_cast<std::streamsize>(words.size() * sizeof(uint64_t)));
    if (!ifs) {
        SetError(error, "failed to read words: " + path);
        return false;
    }
    return true;
}

inline std::vector<fpga::SlamAccelScanPoint> ToAbiScan(const CloudPtr& cloud) {
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

inline std::array<uint64_t, fpga::LOC_ITER_INPUT_WORDS> MakeInputWords(const SE3& pose,
                                                                       const LocIterativeOptions& options,
                                                                       uint32_t scan_count) {
    std::array<uint64_t, fpga::LOC_ITER_INPUT_WORDS> words{};
    const Quatd q = pose.unit_quaternion();
    const Vec3d t = pose.translation();
    words[fpga::LOC_ITER_IN_MAGIC_VERSION] = Pack32(fpga::SLAM_LOC_ITER_MAGIC, fpga::SLAM_LOC_ITER_VERSION);
    words[fpga::LOC_ITER_IN_NUM_POINTS_MAX_ITERS] = Pack32(scan_count, options.max_iterations);
    words[fpga::LOC_ITER_IN_RESIDUAL_OUTLIER_TH] = DoubleToBits(options.residual_outlier_th);
    words[fpga::LOC_ITER_IN_CONVERGENCE_TRANSLATION] = DoubleToBits(options.conv_translation);
    words[fpga::LOC_ITER_IN_CONVERGENCE_ROTATION] = DoubleToBits(options.conv_rotation);
    words[fpga::LOC_ITER_IN_MIN_VALID_COUNT_RESERVED] = Pack32(options.min_valid_count, 0u);
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QX] = DoubleToBits(q.x());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QY] = DoubleToBits(q.y());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QZ] = DoubleToBits(q.z());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QW] = DoubleToBits(q.w());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_TX] = DoubleToBits(t.x());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_TY] = DoubleToBits(t.y());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_TZ] = DoubleToBits(t.z());
    return words;
}

inline bool BuildCandidates(const golden::LocalizationGolden& source, std::vector<fpga::ObsCellFloat64>& candidates,
                            uint32_t& valid_count, uint32_t& miss_count, std::string* error) {
    if (source.scan_body == nullptr) {
        SetError(error, "source scan is null");
        return false;
    }
    SurfelLocOptions options;
    options.cell_resolution = source.active_map.cell_resolution;
    options.lookup_nearby_type = static_cast<int>(source.active_map.lookup_nearby_type);
    SurfelLocBackend backend(options);

    candidates.clear();
    candidates.resize(source.scan_body->size());
    valid_count = 0;
    miss_count = 0;
    for (size_t i = 0; i < source.scan_body->size(); ++i) {
        const Vec3d point_world = source.pose_guess * ToVec3d(source.scan_body->points[i]);
        const fpga::ObsCellFloat64* cell = nullptr;
        if (backend.TryLookupNearest(source.active_map, point_world, cell) && cell != nullptr) {
            candidates[i] = *cell;
            ++valid_count;
        } else {
            candidates[i] = fpga::ObsCellFloat64{};
            ++miss_count;
        }
    }
    return true;
}

inline bool Solve6x6(const Mat6d& hessian, const Vec6d& gradient, Vec6d& dx) {
    constexpr double kDamping = 1e-6;
    constexpr double kMinPivot = 1e-12;
    Mat6d a = hessian;
    a.diagonal().array() += kDamping;
    if (!a.allFinite() || !gradient.allFinite()) {
        return false;
    }

    Eigen::Matrix<double, 6, 6> l = Eigen::Matrix<double, 6, 6>::Identity();
    Vec6d d = Vec6d::Zero();
    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < i; ++j) {
            double sum = a(i, j);
            for (int k = 0; k < j; ++k) {
                sum -= l(i, k) * d[k] * l(j, k);
            }
            if (std::fabs(d[j]) <= kMinPivot) {
                return false;
            }
            l(i, j) = sum / d[j];
        }
        double diag = a(i, i);
        for (int k = 0; k < i; ++k) {
            diag -= l(i, k) * l(i, k) * d[k];
        }
        if (!std::isfinite(diag) || diag <= kMinPivot) {
            return false;
        }
        d[i] = diag;
    }

    const Vec6d rhs = -gradient;
    Vec6d y = Vec6d::Zero();
    Vec6d z = Vec6d::Zero();
    for (int i = 0; i < 6; ++i) {
        double sum = rhs[i];
        for (int k = 0; k < i; ++k) {
            sum -= l(i, k) * y[k];
        }
        y[i] = sum;
        z[i] = y[i] / d[i];
    }
    for (int i = 5; i >= 0; --i) {
        double sum = z[i];
        for (int k = i + 1; k < 6; ++k) {
            sum -= l(k, i) * dx[k];
        }
        dx[i] = sum;
        if (!std::isfinite(dx[i])) {
            return false;
        }
    }
    return true;
}

inline LocIterativeOutput DecodeOutput(const std::array<uint64_t, fpga::LOC_ITER_OUTPUT_WORDS>& words) {
    LocIterativeOutput out;
    out.status = Low32(words[fpga::LOC_ITER_OUT_STATUS_FLAGS]);
    out.flags = High32(words[fpga::LOC_ITER_OUT_STATUS_FLAGS]);
    out.iterations = Low32(words[fpga::LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    out.valid_count = High32(words[fpga::LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    out.reject_count = Low32(words[fpga::LOC_ITER_OUT_COUNTS1]);
    out.miss_count = High32(words[fpga::LOC_ITER_OUT_COUNTS1]);
    Quatd q(BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QW]),
            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QX]),
            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QY]),
            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QZ]));
    q.normalize();
    out.final_pose = SE3(q, Vec3d(BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_TX]),
                                  BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_TY]),
                                  BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_TZ])));
    for (int i = 0; i < 6; ++i) {
        out.last_dx[i] = BitsToDouble(words[fpga::LOC_ITER_OUT_LAST_DX0 + i]);
    }
    out.residual_sum = BitsToDouble(words[fpga::LOC_ITER_OUT_RESIDUAL_SUM]);
    out.residual_abs_sum = BitsToDouble(words[fpga::LOC_ITER_OUT_RESIDUAL_ABS_SUM]);
    out.residual_max_abs = BitsToDouble(words[fpga::LOC_ITER_OUT_RESIDUAL_MAX_ABS]);
    out.score = BitsToDouble(words[fpga::LOC_ITER_OUT_SCORE]);
    return out;
}

inline std::array<uint64_t, fpga::LOC_ITER_OUTPUT_WORDS> EncodeOutput(const LocIterativeOutput& out) {
    std::array<uint64_t, fpga::LOC_ITER_OUTPUT_WORDS> words{};
    const Quatd q = out.final_pose.unit_quaternion();
    const Vec3d t = out.final_pose.translation();
    words[fpga::LOC_ITER_OUT_MAGIC_VERSION] = Pack32(fpga::SLAM_LOC_ITER_MAGIC, fpga::SLAM_LOC_ITER_VERSION);
    words[fpga::LOC_ITER_OUT_STATUS_FLAGS] = Pack32(out.status, out.flags);
    words[fpga::LOC_ITER_OUT_ITERATIONS_COUNTS0] = Pack32(out.iterations, out.valid_count);
    words[fpga::LOC_ITER_OUT_COUNTS1] = Pack32(out.reject_count, out.miss_count);
    words[fpga::LOC_ITER_OUT_FINAL_POSE_QX] = DoubleToBits(q.x());
    words[fpga::LOC_ITER_OUT_FINAL_POSE_QY] = DoubleToBits(q.y());
    words[fpga::LOC_ITER_OUT_FINAL_POSE_QZ] = DoubleToBits(q.z());
    words[fpga::LOC_ITER_OUT_FINAL_POSE_QW] = DoubleToBits(q.w());
    words[fpga::LOC_ITER_OUT_FINAL_POSE_TX] = DoubleToBits(t.x());
    words[fpga::LOC_ITER_OUT_FINAL_POSE_TY] = DoubleToBits(t.y());
    words[fpga::LOC_ITER_OUT_FINAL_POSE_TZ] = DoubleToBits(t.z());
    for (int i = 0; i < 6; ++i) {
        words[fpga::LOC_ITER_OUT_LAST_DX0 + i] = DoubleToBits(out.last_dx[i]);
    }
    words[fpga::LOC_ITER_OUT_RESIDUAL_SUM] = DoubleToBits(out.residual_sum);
    words[fpga::LOC_ITER_OUT_RESIDUAL_ABS_SUM] = DoubleToBits(out.residual_abs_sum);
    words[fpga::LOC_ITER_OUT_RESIDUAL_MAX_ABS] = DoubleToBits(out.residual_max_abs);
    words[fpga::LOC_ITER_OUT_SCORE] = DoubleToBits(out.score);
    return words;
}

inline bool RunCpuReference(const LocIterativeGolden& golden, LocIterativeOutput& out, std::string* error) {
    const uint32_t magic = Low32(golden.input_words[fpga::LOC_ITER_IN_MAGIC_VERSION]);
    const uint32_t version = High32(golden.input_words[fpga::LOC_ITER_IN_MAGIC_VERSION]);
    if (magic != fpga::SLAM_LOC_ITER_MAGIC || version != fpga::SLAM_LOC_ITER_VERSION) {
        SetError(error, "iterative input magic/version mismatch");
        return false;
    }

    const uint32_t num_points = Low32(golden.input_words[fpga::LOC_ITER_IN_NUM_POINTS_MAX_ITERS]);
    const uint32_t max_iterations = High32(golden.input_words[fpga::LOC_ITER_IN_NUM_POINTS_MAX_ITERS]);
    const uint32_t min_valid_count = Low32(golden.input_words[fpga::LOC_ITER_IN_MIN_VALID_COUNT_RESERVED]);
    if (num_points == 0 || max_iterations == 0 || num_points > golden.scan_points.size() ||
        num_points > golden.candidate_cells.size()) {
        SetError(error, "invalid iterative input counts");
        return false;
    }

    const double residual_outlier_th = BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_RESIDUAL_OUTLIER_TH]);
    const double conv_trans = BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_CONVERGENCE_TRANSLATION]);
    const double conv_rot = BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_CONVERGENCE_ROTATION]);
    Quatd q(BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_QW]),
            BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_QX]),
            BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_QY]),
            BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_QZ]));
    q.normalize();
    SE3 pose(q, Vec3d(BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_TX]),
                      BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_TY]),
                      BitsToDouble(golden.input_words[fpga::LOC_ITER_IN_INITIAL_POSE_TZ])));

    out = LocIterativeOutput{};
    out.status = fpga::SLAM_LOC_ITER_SUCCESS;
    out.flags = fpga::SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    out.final_pose = pose;

    for (uint32_t iter = 0; iter < max_iterations; ++iter) {
        Mat6d hessian = Mat6d::Zero();
        Vec6d gradient = Vec6d::Zero();
        out.valid_count = 0;
        out.reject_count = 0;
        out.miss_count = 0;
        out.residual_sum = 0.0;
        out.residual_abs_sum = 0.0;
        out.residual_max_abs = 0.0;

        for (uint32_t i = 0; i < num_points; ++i) {
            const auto& scan = golden.scan_points[i];
            if (!std::isfinite(scan.x) || !std::isfinite(scan.y) || !std::isfinite(scan.z)) {
                ++out.reject_count;
                continue;
            }
            const auto& cell = golden.candidate_cells[i];
            if ((cell.flags & fpga::OBS_CELL_VALID) == 0u) {
                ++out.miss_count;
                continue;
            }
            const Vec3d point_body(scan.x, scan.y, scan.z);
            const Vec3d point_world = pose * point_body;
            const double nx = cell.normal_x;
            const double ny = cell.normal_y;
            const double nz = cell.normal_z;
            const double residual = nx * point_world.x() + ny * point_world.y() + nz * point_world.z() + cell.plane_d;
            const double abs_residual = std::fabs(residual);
            if (!std::isfinite(residual) || abs_residual > residual_outlier_th) {
                ++out.reject_count;
                continue;
            }
            Vec6d jacobian;
            jacobian[0] = nx;
            jacobian[1] = ny;
            jacobian[2] = nz;
            jacobian[3] = nz * point_world.y() - ny * point_world.z();
            jacobian[4] = nx * point_world.z() - nz * point_world.x();
            jacobian[5] = ny * point_world.x() - nx * point_world.y();
            hessian += jacobian * jacobian.transpose();
            gradient += jacobian * residual;
            ++out.valid_count;
            out.residual_sum += residual;
            out.residual_abs_sum += abs_residual;
            out.residual_max_abs = std::max(out.residual_max_abs, abs_residual);
        }

        out.iterations = iter + 1;
        if (out.valid_count == 0) {
            out.status = fpga::SLAM_LOC_ITER_NO_VALID_OBSERVATION;
            break;
        }

        Vec6d dx = Vec6d::Zero();
        if (!Solve6x6(hessian, gradient, dx)) {
            out.status = fpga::SLAM_LOC_ITER_SOLVE_FAILED;
            break;
        }
        out.last_dx = dx;
        const double trans_step = dx.head<3>().norm();
        const double rot_step = dx.tail<3>().norm();
        pose = SE3::exp(dx) * pose;
        out.final_pose = pose;
        if (!pose.matrix().allFinite()) {
            out.status = fpga::SLAM_LOC_ITER_NON_FINITE;
            break;
        }
        if (trans_step < conv_trans && rot_step < conv_rot) {
            out.flags |= 0x100u;
            break;
        }
    }

    const double mean_abs =
        out.valid_count > 0 ? out.residual_abs_sum / static_cast<double>(out.valid_count) : 0.0;
    const double inlier_ratio = static_cast<double>(out.valid_count) / static_cast<double>(num_points);
    out.score = 4.0 * inlier_ratio / (1.0 + 10.0 * mean_abs);
    if (out.valid_count < min_valid_count) {
        out.flags |= 0x200u;
    }
    return true;
}

inline bool BuildFromLocalizationGolden(const golden::LocalizationGolden& source, const LocIterativeOptions& options,
                                        LocIterativeGolden& golden, uint32_t& candidate_valid,
                                        uint32_t& candidate_miss, std::string* error) {
    golden.scan_points = ToAbiScan(source.scan_body);
    if (golden.scan_points.empty()) {
        SetError(error, "source localization golden has no scan points");
        return false;
    }
    if (!BuildCandidates(source, golden.candidate_cells, candidate_valid, candidate_miss, error)) {
        return false;
    }
    golden.input_words = MakeInputWords(source.pose_guess, options, static_cast<uint32_t>(golden.scan_points.size()));
    LocIterativeOutput expected;
    if (!RunCpuReference(golden, expected, error)) {
        return false;
    }
    golden.expected_words = EncodeOutput(expected);
    return true;
}

inline bool WriteGolden(const std::string& dir, const LocIterativeGolden& golden, const LocIterativeOptions& options,
                        const std::string& source_dir, uint32_t candidate_valid, uint32_t candidate_miss,
                        std::string* error) {
    std::error_code ec;
    std::filesystem::create_directories(dir, ec);
    if (ec) {
        SetError(error, "failed to create iterative golden dir: " + ec.message());
        return false;
    }
    if (!WriteVectorFile(JoinPath(dir, "loc_iter_scan.bin"), fpga::GOLDEN_SCAN_POINTS, golden.scan_points, error) ||
        !WriteVectorFile(JoinPath(dir, "loc_iter_candidates.bin"), fpga::GOLDEN_LOC_ITER_CANDIDATE_CELLS,
                         golden.candidate_cells, error) ||
        !WriteWordFile(JoinPath(dir, "loc_iter_input.bin"), fpga::GOLDEN_LOC_ITER_INPUT_WORDS, golden.input_words,
                       error) ||
        !WriteWordFile(JoinPath(dir, "loc_iter_expected.bin"), fpga::GOLDEN_LOC_ITER_OUTPUT_WORDS,
                       golden.expected_words, error)) {
        return false;
    }

    const auto expected = DecodeOutput(golden.expected_words);
    const auto q = expected.final_pose.unit_quaternion();
    const auto t = expected.final_pose.translation();
    std::ofstream meta(JoinPath(dir, "loc_iter_meta.yaml"));
    if (!meta) {
        SetError(error, "failed to write loc_iter_meta.yaml");
        return false;
    }
    meta << std::setprecision(17);
    meta << "mode: LOCALIZATION_FULL_ITERATIVE\n";
    meta << "source_golden_dir: " << source_dir << "\n";
    meta << "scan_count: " << golden.scan_points.size() << "\n";
    meta << "candidate_count: " << golden.candidate_cells.size() << "\n";
    meta << "candidate_valid_count: " << candidate_valid << "\n";
    meta << "candidate_miss_count: " << candidate_miss << "\n";
    meta << "fixed_candidate_list: true\n";
    meta << "max_iterations: " << options.max_iterations << "\n";
    meta << "residual_outlier_th: " << options.residual_outlier_th << "\n";
    meta << "conv_translation: " << options.conv_translation << "\n";
    meta << "conv_rotation: " << options.conv_rotation << "\n";
    meta << "min_valid_count: " << options.min_valid_count << "\n";
    meta << "expected:\n";
    meta << "  status: " << expected.status << "\n";
    meta << "  flags: " << expected.flags << "\n";
    meta << "  iterations_used: " << expected.iterations << "\n";
    meta << "  valid_count: " << expected.valid_count << "\n";
    meta << "  reject_count: " << expected.reject_count << "\n";
    meta << "  miss_count: " << expected.miss_count << "\n";
    meta << "  residual_abs_sum: " << expected.residual_abs_sum << "\n";
    meta << "  residual_max_abs: " << expected.residual_max_abs << "\n";
    meta << "  score: " << expected.score << "\n";
    meta << "  dx_norm: " << DxNorm(expected.last_dx) << "\n";
    meta << "  final_pose:\n";
    meta << "    tx: " << t.x() << "\n";
    meta << "    ty: " << t.y() << "\n";
    meta << "    tz: " << t.z() << "\n";
    meta << "    qx: " << q.x() << "\n";
    meta << "    qy: " << q.y() << "\n";
    meta << "    qz: " << q.z() << "\n";
    meta << "    qw: " << q.w() << "\n";
    return true;
}

inline bool ReadGolden(const std::string& dir, LocIterativeGolden& golden, std::string* error) {
    return ReadVectorFile(JoinPath(dir, "loc_iter_scan.bin"), fpga::GOLDEN_SCAN_POINTS, golden.scan_points, error) &&
           ReadVectorFile(JoinPath(dir, "loc_iter_candidates.bin"), fpga::GOLDEN_LOC_ITER_CANDIDATE_CELLS,
                          golden.candidate_cells, error) &&
           ReadWordFile(JoinPath(dir, "loc_iter_input.bin"), fpga::GOLDEN_LOC_ITER_INPUT_WORDS, golden.input_words,
                        error) &&
           ReadWordFile(JoinPath(dir, "loc_iter_expected.bin"), fpga::GOLDEN_LOC_ITER_OUTPUT_WORDS,
                        golden.expected_words, error);
}

inline bool CompareOutputs(const LocIterativeOutput& actual, const LocIterativeOutput& expected, double abs_tol,
                           double rel_tol, std::string* report) {
    double max_abs = 0.0;
    double max_rel = 0.0;
    std::string worst = "none";
    auto check = [&](const std::string& name, double a, double e) {
        const double abs_err = std::fabs(a - e);
        const double rel_err = abs_err / std::max(1.0, std::fabs(e));
        if (abs_err > max_abs) {
            max_abs = abs_err;
            worst = name;
        }
        max_rel = std::max(max_rel, rel_err);
    };

    const auto aq = actual.final_pose.unit_quaternion();
    const auto eq = expected.final_pose.unit_quaternion();
    const auto at = actual.final_pose.translation();
    const auto et = expected.final_pose.translation();
    check("tx", at.x(), et.x());
    check("ty", at.y(), et.y());
    check("tz", at.z(), et.z());
    check("qx", aq.x(), eq.x());
    check("qy", aq.y(), eq.y());
    check("qz", aq.z(), eq.z());
    check("qw", aq.w(), eq.w());
    for (int i = 0; i < 6; ++i) {
        check("dx" + std::to_string(i), actual.last_dx[i], expected.last_dx[i]);
    }
    check("residual_sum", actual.residual_sum, expected.residual_sum);
    check("residual_abs_sum", actual.residual_abs_sum, expected.residual_abs_sum);
    check("residual_max_abs", actual.residual_max_abs, expected.residual_max_abs);
    check("score", actual.score, expected.score);

    const bool status_ok = actual.status == expected.status && actual.flags == expected.flags &&
                           actual.iterations == expected.iterations &&
                           actual.valid_count == expected.valid_count &&
                           actual.reject_count == expected.reject_count && actual.miss_count == expected.miss_count;
    const bool values_ok = max_abs <= abs_tol || max_rel <= rel_tol;
    if (report != nullptr) {
        std::ostringstream ss;
        ss << "status_ok=" << status_ok << " values_ok=" << values_ok << " max_abs=" << max_abs
           << " max_rel=" << max_rel << " worst_field=" << worst << " actual_counts=" << actual.valid_count << "/"
           << actual.reject_count << "/" << actual.miss_count << " expected_counts=" << expected.valid_count << "/"
           << expected.reject_count << "/" << expected.miss_count << " actual_status=" << actual.status
           << " expected_status=" << expected.status << " actual_iterations=" << actual.iterations
           << " expected_iterations=" << expected.iterations;
        *report = ss.str();
    }
    return status_ok && values_ok;
}

}  // namespace lightning::loc::iter_golden
