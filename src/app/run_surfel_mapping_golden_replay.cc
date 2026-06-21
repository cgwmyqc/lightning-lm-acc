// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/lio/mapping_golden.h"

DEFINE_string(golden_dir, "fpga/golden/mapping/frame_000001", "Mapping golden directory");
DEFINE_double(abs_tol, 1e-4, "Absolute tolerance");
DEFINE_double(rel_tol, 1e-3, "Relative tolerance");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    lightning::mapping_golden::MappingGoldenFrame frame;
    std::string error;
    if (!lightning::mapping_golden::ReadGoldenFrame(FLAGS_golden_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    lightning::loc::LocNormalEquation actual;
    if (!lightning::mapping_golden::ComputeMappingObservation(frame.scan_body, frame.state, frame.extrinsic_R,
                                                             frame.extrinsic_t, frame.active_map,
                                                             frame.plane_icp_weight, actual)) {
        LOG(ERROR) << "failed to compute mapping observation";
        return 1;
    }

    std::string report;
    const bool pass =
        lightning::mapping_golden::CompareNormalEquation(actual, frame.expected_obs, FLAGS_abs_tol, FLAGS_rel_tol,
                                                         &report);
    LOG(INFO) << "[mapping_golden_replay] " << report;
    if (!pass) {
        return 2;
    }
    LOG(INFO) << "MAPPING_CPU_REPLAY_PASS golden_dir=" << FLAGS_golden_dir;
    return 0;
}
