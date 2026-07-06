// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/lio/mapping_eskf_update.h"

DEFINE_string(golden_dir, "fpga/golden/mapping_update/frame_000001", "Mapping ESKF update golden directory");
DEFINE_double(dx_abs_tol, 1e-10, "Absolute tolerance for dx");
DEFINE_double(cov_abs_tol, 1e-9, "Absolute tolerance for covariance");
DEFINE_double(state_abs_tol, 1e-10, "Absolute tolerance for state");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    lightning::mapping_update::GoldenFrame frame;
    std::string error;
    if (!lightning::mapping_update::ReadGoldenFrame(FLAGS_golden_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    lightning::mapping_update::UpdateOutput actual;
    if (!lightning::mapping_update::RunUpdateStep(frame.input, actual)) {
        LOG(ERROR) << "mapping update replay helper failed: " << actual.status;
        return 2;
    }

    std::string report;
    const bool pass = lightning::mapping_update::CompareUpdateOutput(
        actual, frame.expected, FLAGS_dx_abs_tol, FLAGS_cov_abs_tol, FLAGS_state_abs_tol, &report);
    LOG(INFO) << "[mapping_eskf_update_replay] " << report;
    if (!pass) {
        return 3;
    }
    LOG(INFO) << "MAPPING_ESKF_UPDATE_CPU_REPLAY_PASS golden_dir=" << FLAGS_golden_dir;
    return 0;
}
