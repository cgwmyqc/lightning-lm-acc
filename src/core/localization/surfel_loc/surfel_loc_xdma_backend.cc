// SPDX-License-Identifier: MIT

#include "core/localization/surfel_loc/surfel_loc_xdma_backend.h"

#include <chrono>

#include "core/localization/surfel_loc/surfel_loc_golden.h"

namespace lightning::loc {

namespace {

using Clock = std::chrono::steady_clock;

fpga::XdmaRuntime::Options ToRuntimeOptions(const SurfelLocXdmaOptions& options) {
    fpga::XdmaRuntime::Options runtime_options;
    runtime_options.user_dev = options.user_dev;
    runtime_options.h2c_dev = options.h2c_dev;
    runtime_options.c2h_dev = options.c2h_dev;
    runtime_options.ctrl_base = options.ctrl_base;
    runtime_options.timeout_sec = options.timeout_sec;
    return runtime_options;
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
    if (!runtime_->RunLocalizationObservation(scan_points, pose, map, true, options_.verify_readback, result, error)) {
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

}  // namespace lightning::loc
