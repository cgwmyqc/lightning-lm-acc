// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include <array>

#include "core/fpga/xdma_runtime.h"
#include "core/lio/mapping_golden.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"

DEFINE_string(golden_dir, "fpga/golden/mapping/frame_000001", "Mapping golden directory");
DEFINE_uint32(ctrl_base, 0x1000, "XDMA control base");
DEFINE_double(timeout_sec, 120.0, "HLS timeout in seconds");
DEFINE_bool(verify_readback, false, "Verify DDR image readback");
DEFINE_double(abs_tol, 1e-4, "Absolute tolerance");
DEFINE_double(rel_tol, 1e-3, "Relative tolerance");
DEFINE_bool(abi_v2_candidates, false, "Use ABI V2 per-point precomputed candidate cells");

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

    lightning::fpga::XdmaRuntime::Options options;
    options.ctrl_base = FLAGS_ctrl_base;
    options.timeout_sec = FLAGS_timeout_sec;
    lightning::fpga::XdmaRuntime runtime(options);

    const auto scan_points = lightning::fpga::ToAbiScanPoints(frame.scan_body);
    const auto lidar_pose = lightning::mapping_golden::LidarPoseFromState(frame.state, frame.extrinsic_R,
                                                                          frame.extrinsic_t);
    const auto pose = lightning::loc::golden::ToAbiPose(lidar_pose);
    std::array<float, 9> extrinsic_R{};
    std::array<float, 3> extrinsic_T{};
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            extrinsic_R[static_cast<size_t>(r * 3 + c)] = static_cast<float>(frame.extrinsic_R(r, c));
        }
        extrinsic_T[static_cast<size_t>(r)] = static_cast<float>(frame.extrinsic_t[r]);
    }
    const auto params = lightning::fpga::MakeMappingObservationParams(static_cast<float>(frame.plane_icp_weight),
                                                                      extrinsic_R, extrinsic_T);

    lightning::fpga::XdmaRuntime::RunResult result;
    const bool run_ok =
        FLAGS_abi_v2_candidates
            ? runtime.RunMappingObservationV2(scan_points, pose, frame.active_map, params, true, FLAGS_verify_readback,
                                             result, &error)
            : runtime.RunMappingObservation(scan_points, pose, frame.active_map, params, true, FLAGS_verify_readback,
                                            result, &error);
    if (!run_ok) {
        LOG(ERROR) << error;
        return 1;
    }

    const lightning::loc::LocNormalEquation actual =
        lightning::loc::golden::FromAbiNormalEquation(result.output);
    std::string report;
    const bool pass =
        lightning::mapping_golden::CompareNormalEquation(actual, frame.expected_obs, FLAGS_abs_tol, FLAGS_rel_tol,
                                                         &report);
    LOG(INFO) << "[mapping_xdma_golden] STATUS=0x" << std::hex << result.status << " ERROR=0x" << result.error
              << std::dec << " RUN_COUNT=" << result.run_count_before << "->" << result.run_count_after
              << " SCAN_COUNT_READBACK=" << result.scan_count_readback
              << " abi_v2_candidates=" << (FLAGS_abi_v2_candidates ? 1 : 0)
              << " candidate_count=" << result.candidate_count
              << " candidate_valid=" << result.candidate_valid_count
              << " candidate_miss=" << result.candidate_miss_count
              << " candidate_bytes=" << result.candidate_bytes
              << " h2c_candidate_sec=" << result.timing.h2c_candidate_sec
              << " hls_wait_sec=" << result.timing.hls_wait_sec << " " << report;
    if (!pass) {
        LOG(ERROR) << "MAPPING_XDMA_REPLAY_FAIL";
        return 2;
    }
    LOG(INFO) << "MAPPING_XDMA_REPLAY_PASS golden_dir=" << FLAGS_golden_dir;
    return 0;
}
