// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "loc_iterative_golden_common.h"

DEFINE_string(golden_dir, "fpga/golden/localization_iterative/frame_000001",
              "Localization iterative golden directory");
DEFINE_double(abs_tol, 1e-10, "Absolute tolerance");
DEFINE_double(rel_tol, 1e-9, "Relative tolerance");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    using namespace lightning::loc;

    iter_golden::LocIterativeGolden golden;
    std::string error;
    if (!iter_golden::ReadGolden(FLAGS_golden_dir, golden, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    iter_golden::LocIterativeOutput actual;
    if (!iter_golden::RunCpuReference(golden, actual, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    const auto expected = iter_golden::DecodeOutput(golden.expected_words);
    std::string report;
    const bool pass = iter_golden::CompareOutputs(actual, expected, FLAGS_abs_tol, FLAGS_rel_tol, &report);
    LOG(INFO) << "[surfel_loc_iterative_golden_replay] " << report;
    LOG(INFO) << "candidate_count=" << golden.candidate_cells.size() << " scan_count=" << golden.scan_points.size()
              << " iterations_used=" << actual.iterations << " final_pose_finite="
              << actual.final_pose.matrix().allFinite() << " parser_roundtrip=" << pass;

    if (!pass) {
        return 2;
    }

    LOG(INFO) << "LOC_ITER_CPU_REPLAY_PASS";
    LOG(INFO) << "loc_iter_expected.bin parser roundtrip PASS";
    return 0;
}
