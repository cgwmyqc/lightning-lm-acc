// SPDX-License-Identifier: MIT

#include "core/localization/surfel_loc/surfel_loc_xdma_backend.h"

#include <algorithm>
#include <chrono>
#include <cmath>
#include <cstring>

#include "core/localization/surfel_loc/surfel_loc_backend.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"
#include "fpga/hls/slam_loc_iterative_core/slam_loc_iterative_core.h"

namespace lightning::loc {

namespace {

using Clock = std::chrono::steady_clock;

uint64_t Pack32(uint32_t lo, uint32_t hi) {
    return static_cast<uint64_t>(lo) | (static_cast<uint64_t>(hi) << 32);
}

uint32_t Low32(uint64_t value) {
    return static_cast<uint32_t>(value & 0xffffffffULL);
}

uint32_t High32(uint64_t value) {
    return static_cast<uint32_t>((value >> 32) & 0xffffffffULL);
}

uint64_t DoubleToBits(double value) {
    uint64_t bits = 0;
    std::memcpy(&bits, &value, sizeof(bits));
    return bits;
}

double BitsToDouble(uint64_t bits) {
    double value = 0.0;
    std::memcpy(&value, &bits, sizeof(value));
    return value;
}

fpga::XdmaRuntime::Options ToRuntimeOptions(const SurfelLocXdmaOptions& options) {
    fpga::XdmaRuntime::Options runtime_options;
    runtime_options.user_dev = options.user_dev;
    runtime_options.h2c_dev = options.h2c_dev;
    runtime_options.c2h_dev = options.c2h_dev;
    runtime_options.ctrl_base = options.ctrl_base;
    runtime_options.timeout_sec = options.timeout_sec;
    return runtime_options;
}

std::vector<uint64_t> MakeLocIterativeInputWords(const SE3& pose, const SurfelLocOptions& options,
                                                 uint32_t scan_count) {
    std::vector<uint64_t> words(fpga::LOC_ITER_INPUT_WORDS, 0);
    const Quatd q = pose.unit_quaternion();
    const Vec3d t = pose.translation();
    words[fpga::LOC_ITER_IN_MAGIC_VERSION] = Pack32(fpga::SLAM_LOC_ITER_MAGIC, fpga::SLAM_LOC_ITER_VERSION);
    words[fpga::LOC_ITER_IN_NUM_POINTS_MAX_ITERS] =
        Pack32(scan_count, static_cast<uint32_t>(std::max(1, options.max_iterations)));
    words[fpga::LOC_ITER_IN_RESIDUAL_OUTLIER_TH] = DoubleToBits(options.residual_outlier_th);
    words[fpga::LOC_ITER_IN_CONVERGENCE_TRANSLATION] = DoubleToBits(options.convergence_translation);
    words[fpga::LOC_ITER_IN_CONVERGENCE_ROTATION] = DoubleToBits(options.convergence_rotation);
    words[fpga::LOC_ITER_IN_MIN_VALID_COUNT_RESERVED] =
        Pack32(static_cast<uint32_t>(std::max(0, options.min_valid_count)), 0u);
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QX] = DoubleToBits(q.x());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QY] = DoubleToBits(q.y());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QZ] = DoubleToBits(q.z());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_QW] = DoubleToBits(q.w());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_TX] = DoubleToBits(t.x());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_TY] = DoubleToBits(t.y());
    words[fpga::LOC_ITER_IN_INITIAL_POSE_TZ] = DoubleToBits(t.z());
    return words;
}

bool DecodeLocIterativeOutput(const std::vector<uint64_t>& words, SE3& pose_out, Vec6d& last_dx,
                              LocQuality& quality, uint32_t& status, uint32_t& flags, std::string* error) {
    if (words.size() < fpga::LOC_ITER_OUTPUT_WORDS) {
        if (error != nullptr) {
            *error = "loc iterative output word count mismatch";
        }
        return false;
    }
    const uint32_t magic = Low32(words[fpga::LOC_ITER_OUT_MAGIC_VERSION]);
    const uint32_t version = High32(words[fpga::LOC_ITER_OUT_MAGIC_VERSION]);
    if (magic != fpga::SLAM_LOC_ITER_MAGIC || version != fpga::SLAM_LOC_ITER_VERSION) {
        if (error != nullptr) {
            *error = "loc iterative output magic/version mismatch";
        }
        return false;
    }

    status = Low32(words[fpga::LOC_ITER_OUT_STATUS_FLAGS]);
    flags = High32(words[fpga::LOC_ITER_OUT_STATUS_FLAGS]);
    quality.iterations = Low32(words[fpga::LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    quality.valid_count = High32(words[fpga::LOC_ITER_OUT_ITERATIONS_COUNTS0]);
    quality.reject_count = Low32(words[fpga::LOC_ITER_OUT_COUNTS1]);
    quality.miss_count = High32(words[fpga::LOC_ITER_OUT_COUNTS1]);

    Quatd q(BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QW]),
            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QX]),
            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QY]),
            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_QZ]));
    q.normalize();
    pose_out = SE3(q, Vec3d(BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_TX]),
                            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_TY]),
                            BitsToDouble(words[fpga::LOC_ITER_OUT_FINAL_POSE_TZ])));
    for (int i = 0; i < 6; ++i) {
        last_dx[i] = BitsToDouble(words[fpga::LOC_ITER_OUT_LAST_DX0 + i]);
    }
    quality.mean_residual =
        quality.valid_count > 0
            ? BitsToDouble(words[fpga::LOC_ITER_OUT_RESIDUAL_SUM]) / static_cast<double>(quality.valid_count)
            : 0.0;
    quality.mean_abs_residual =
        quality.valid_count > 0
            ? BitsToDouble(words[fpga::LOC_ITER_OUT_RESIDUAL_ABS_SUM]) / static_cast<double>(quality.valid_count)
            : 0.0;
    quality.max_abs_residual = BitsToDouble(words[fpga::LOC_ITER_OUT_RESIDUAL_MAX_ABS]);
    quality.score = BitsToDouble(words[fpga::LOC_ITER_OUT_SCORE]);
    quality.matrix_ok = status == fpga::SLAM_LOC_ITER_SUCCESS;
    quality.converged = (flags & 0x100u) != 0;
    return pose_out.matrix().allFinite() && last_dx.allFinite() && std::isfinite(quality.score);
}

}  // namespace

SurfelLocXdmaBackend::SurfelLocXdmaBackend(SurfelLocXdmaOptions options) { SetOptions(options); }

void SurfelLocXdmaBackend::SetOptions(const SurfelLocXdmaOptions& options) {
    options_ = options;
    runtime_ = std::make_unique<fpga::XdmaRuntime>(ToRuntimeOptions(options_));
}

bool SurfelLocXdmaBackend::ComputeObservation(const CloudPtr& scan_body, const SE3& pose_guess,
                                              const ActiveMapBuffer& map, LocNormalEquation& out,
                                              double* elapsed_sec, std::string* error,
                                              fpga::XdmaRuntime::RunResult* run_result,
                                              double* pack_scan_sec) const {
    out.Reset();
    if (scan_body == nullptr || scan_body->empty() || map.Empty()) {
        if (error != nullptr) {
            *error = "empty scan or active map";
        }
        return false;
    }
    if (!runtime_) {
        if (error != nullptr) {
            *error = "XDMA runtime is not initialized";
        }
        return false;
    }

    const auto pack_start = Clock::now();
    const auto scan_points = fpga::ToAbiScanPoints(scan_body);
    if (pack_scan_sec != nullptr) {
        *pack_scan_sec = std::chrono::duration<double>(Clock::now() - pack_start).count();
    }
    const auto pose = golden::ToAbiPose(pose_guess);
    fpga::XdmaRuntime::RunResult result;
    const bool run_ok =
        options_.candidate_abi_v2
            ? runtime_->RunLocalizationObservationV2(scan_points, pose, map, true, options_.verify_readback, result,
                                                     error)
            : runtime_->RunLocalizationObservation(scan_points, pose, map, true, options_.verify_readback, result,
                                                   error);
    if (!run_ok) {
        return false;
    }

    out = golden::FromAbiNormalEquation(result.output);
    if (elapsed_sec != nullptr) {
        *elapsed_sec = result.elapsed_sec;
    }
    if (run_result != nullptr) {
        *run_result = result;
    }
    return out.valid_count > 0;
}

bool SurfelLocXdmaBackend::ComputeObservationAndSolve6x6(const CloudPtr& scan_body, const SE3& pose_guess,
                                                         const ActiveMapBuffer& map, LocNormalEquation& out,
                                                         double* elapsed_sec, std::string* error,
                                                         fpga::XdmaRuntime::RunResult* run_result,
                                                         double* pack_scan_sec) const {
    out.Reset();
    if (!options_.candidate_abi_v2) {
        if (error != nullptr) {
            *error = "FPGA solve6x6 requires candidate ABI V2";
        }
        return false;
    }
    if (scan_body == nullptr || scan_body->empty() || map.Empty()) {
        if (error != nullptr) {
            *error = "empty scan or active map";
        }
        return false;
    }
    if (!runtime_) {
        if (error != nullptr) {
            *error = "XDMA runtime is not initialized";
        }
        return false;
    }

    const auto pack_start = Clock::now();
    const auto scan_points = fpga::ToAbiScanPoints(scan_body);
    if (pack_scan_sec != nullptr) {
        *pack_scan_sec = std::chrono::duration<double>(Clock::now() - pack_start).count();
    }
    const auto pose = golden::ToAbiPose(pose_guess);
    fpga::XdmaRuntime::RunResult result;
    const bool run_ok = runtime_->RunLocalizationObservationV2Solve6x6(scan_points, pose, map, true,
                                                                       options_.verify_readback, result, error);
    if (!run_ok) {
        return false;
    }

    out = golden::FromAbiNormalEquation(result.output);
    if (elapsed_sec != nullptr) {
        *elapsed_sec = result.elapsed_sec;
    }
    if (run_result != nullptr) {
        *run_result = result;
    }
    if (result.solve.status != fpga::SLAM_SOLVE6X6_SUCCESS && error != nullptr) {
        *error = "FPGA solve6x6 failed with status " + std::to_string(result.solve.status);
    }
    return out.valid_count > 0 && result.solve.status == fpga::SLAM_SOLVE6X6_SUCCESS;
}

bool SurfelLocXdmaBackend::ComputeFullIterative(const CloudPtr& scan_body, const SE3& pose_guess,
                                                const ActiveMapBuffer& map,
                                                const SurfelLocOptions& surfel_options, SE3& pose_out,
                                                LocQuality& quality_out, double* elapsed_sec, std::string* error,
                                                fpga::XdmaRuntime::LocIterativeRunResult* run_result,
                                                double* pack_scan_sec, double* pack_candidate_sec) const {
    quality_out = LocQuality();
    quality_out.active_window_id = map.window_id;
    quality_out.active_window_version = map.version;
    pose_out = pose_guess;

    if (!options_.candidate_abi_v2) {
        if (error != nullptr) {
            *error = "localization full iterative requires candidate ABI V2";
        }
        return false;
    }
    if (scan_body == nullptr || scan_body->empty() || map.Empty()) {
        if (error != nullptr) {
            *error = "empty scan or active map";
        }
        return false;
    }
    if (!runtime_) {
        if (error != nullptr) {
            *error = "XDMA runtime is not initialized";
        }
        return false;
    }

    const auto pack_scan_start = Clock::now();
    const auto scan_points = fpga::ToAbiScanPoints(scan_body);
    if (pack_scan_sec != nullptr) {
        *pack_scan_sec = std::chrono::duration<double>(Clock::now() - pack_scan_start).count();
    }

    const auto pack_candidate_start = Clock::now();
    SurfelLocBackend lookup_backend(surfel_options);
    std::vector<fpga::ObsCellFloat64> candidates(scan_body->size());
    uint32_t candidate_valid = 0;
    uint32_t candidate_miss = 0;
    for (size_t i = 0; i < scan_body->size(); ++i) {
        const Vec3d point_world = pose_guess * ToVec3d(scan_body->points[i]);
        const fpga::ObsCellFloat64* cell = nullptr;
        if (lookup_backend.TryLookupNearest(map, point_world, cell) && cell != nullptr) {
            candidates[i] = *cell;
            ++candidate_valid;
        } else {
            candidates[i] = fpga::ObsCellFloat64{};
            ++candidate_miss;
        }
    }
    if (pack_candidate_sec != nullptr) {
        *pack_candidate_sec = std::chrono::duration<double>(Clock::now() - pack_candidate_start).count();
    }

    const auto input_words =
        MakeLocIterativeInputWords(pose_guess, surfel_options, static_cast<uint32_t>(scan_points.size()));
    fpga::XdmaRuntime::LocIterativeRunResult result;
    result.candidate_count = static_cast<uint32_t>(candidates.size());
    result.candidate_valid_count = candidate_valid;
    result.candidate_miss_count = candidate_miss;
    result.candidate_bytes = candidates.size() * sizeof(fpga::ObsCellFloat64);
    if (!runtime_->RunLocalizationIterative(scan_points, candidates, input_words, true, options_.verify_readback,
                                            result, error)) {
        return false;
    }
    result.candidate_count = static_cast<uint32_t>(candidates.size());
    result.candidate_valid_count = candidate_valid;
    result.candidate_miss_count = candidate_miss;
    result.candidate_bytes = candidates.size() * sizeof(fpga::ObsCellFloat64);

    Vec6d last_dx = Vec6d::Zero();
    uint32_t loc_iter_status = 0;
    uint32_t loc_iter_flags = 0;
    if (!DecodeLocIterativeOutput(result.raw_output_words, pose_out, last_dx, quality_out, loc_iter_status,
                                  loc_iter_flags, error)) {
        return false;
    }

    if (elapsed_sec != nullptr) {
        *elapsed_sec = result.elapsed_sec;
    }
    if (run_result != nullptr) {
        *run_result = result;
    }
    if (loc_iter_status != fpga::SLAM_LOC_ITER_SUCCESS) {
        if (error != nullptr) {
            *error = "loc iterative failed with status " + std::to_string(loc_iter_status);
        }
        return false;
    }
    return quality_out.matrix_ok &&
           quality_out.valid_count >= static_cast<uint32_t>(surfel_options.min_valid_count) &&
           quality_out.mean_abs_residual <= surfel_options.max_mean_residual;
}

}  // namespace lightning::loc
