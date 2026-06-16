// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/localization/surfel_loc/surfel_loc_backend.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"

DEFINE_string(golden_dir, "fpga/golden/localization/frame_000001", "Golden frame directory");
DEFINE_double(abs_tol, 1e-4, "Absolute tolerance for H/b comparison");
DEFINE_double(rel_tol, 1e-3, "Relative tolerance for H/b comparison");
DEFINE_int32(lookup_nearby_type, -1, "Override lookup type; -1 uses active map metadata");
DEFINE_double(residual_outlier_th, 0.3, "Residual outlier threshold");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    using namespace lightning::loc;

    golden::LocalizationGolden frame;
    std::string error;
    if (!golden::ReadLocalizationGolden(FLAGS_golden_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    SurfelLocOptions options;
    options.cell_resolution = frame.active_map.cell_resolution;
    options.lookup_nearby_type =
        FLAGS_lookup_nearby_type >= 0 ? FLAGS_lookup_nearby_type : static_cast<int>(frame.active_map.lookup_nearby_type);
    options.residual_outlier_th = FLAGS_residual_outlier_th;

    SurfelLocBackend backend(options);
    LocNormalEquation actual;
    if (!backend.ComputeObservation(frame.scan_body, frame.pose_guess, frame.active_map, actual)) {
        LOG(ERROR) << "failed to compute observation from golden";
        return 1;
    }

    std::string report;
    const bool pass =
        golden::CompareNormalEquation(actual, frame.expected_obs, FLAGS_abs_tol, FLAGS_rel_tol, &report);
    LOG(INFO) << "[surfel_loc_golden_replay] " << report;
    if (!pass) {
        return 2;
    }

    LOG(INFO) << "golden replay PASS: " << FLAGS_golden_dir;
    return 0;
}
