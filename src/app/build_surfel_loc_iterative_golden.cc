// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/localization/surfel_loc/surfel_loc_golden.h"
#include "loc_iterative_golden_common.h"

DEFINE_string(source_golden_dir, "fpga/golden/localization/frame_000001",
              "Source localization observation golden directory");
DEFINE_string(output_dir, "fpga/golden/localization_iterative/frame_000001",
              "Output localization iterative golden directory");
DEFINE_uint32(max_iterations, 4, "Maximum fixed-candidate localization iterations");
DEFINE_double(residual_outlier_th, 0.3, "Residual outlier threshold");
DEFINE_double(conv_translation, 1e-4, "Translation convergence threshold");
DEFINE_double(conv_rotation, 1e-4, "Rotation convergence threshold");
DEFINE_uint32(min_valid_count, 300, "Minimum valid count quality threshold");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    using namespace lightning::loc;

    golden::LocalizationGolden source;
    std::string error;
    if (!golden::ReadLocalizationGolden(FLAGS_source_golden_dir, source, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    iter_golden::LocIterativeOptions options;
    options.max_iterations = FLAGS_max_iterations;
    options.residual_outlier_th = FLAGS_residual_outlier_th;
    options.conv_translation = FLAGS_conv_translation;
    options.conv_rotation = FLAGS_conv_rotation;
    options.min_valid_count = FLAGS_min_valid_count;

    iter_golden::LocIterativeGolden golden;
    uint32_t candidate_valid = 0;
    uint32_t candidate_miss = 0;
    if (!iter_golden::BuildFromLocalizationGolden(source, options, golden, candidate_valid, candidate_miss, &error)) {
        LOG(ERROR) << error;
        return 1;
    }
    if (!iter_golden::WriteGolden(FLAGS_output_dir, golden, options, FLAGS_source_golden_dir, candidate_valid,
                                  candidate_miss, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    const auto expected = iter_golden::DecodeOutput(golden.expected_words);
    LOG(INFO) << "LOC_ITER_GOLDEN_BUILD_PASS";
    LOG(INFO) << "scan_count=" << golden.scan_points.size() << " candidate_count=" << golden.candidate_cells.size()
              << " candidate_valid=" << candidate_valid << " candidate_miss=" << candidate_miss;
    LOG(INFO) << "iterations_used=" << expected.iterations << " status=" << expected.status
              << " flags=0x" << std::hex << expected.flags << std::dec << " counts=" << expected.valid_count << "/"
              << expected.reject_count << "/" << expected.miss_count << " score=" << expected.score
              << " dx_norm=" << iter_golden::DxNorm(expected.last_dx);
    LOG(INFO) << "wrote localization iterative golden to " << FLAGS_output_dir;
    return 0;
}
