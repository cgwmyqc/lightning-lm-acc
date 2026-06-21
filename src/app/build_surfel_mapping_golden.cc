// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/lio/mapping_golden.h"

DEFINE_string(source_dir, "fpga/golden_src/mapping/frame_000001", "Mapping golden source directory");
DEFINE_string(output_dir, "fpga/golden/mapping/frame_000001", "Output mapping golden directory");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    lightning::mapping_golden::MappingGoldenFrame frame;
    std::string error;
    if (!lightning::mapping_golden::ReadSourceFrame(FLAGS_source_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 1;
    }
    if (!lightning::mapping_golden::WriteGoldenFrame(FLAGS_output_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 1;
    }
    LOG(INFO) << "MAPPING_GOLDEN_BUILD_PASS output_dir=" << FLAGS_output_dir
              << " scan_points=" << (frame.scan_body ? frame.scan_body->size() : 0)
              << " active_blocks=" << frame.active_map.blocks.size()
              << " active_cells=" << frame.active_map.cells.size()
              << " expected_counts=" << frame.expected_obs.valid_count << "/" << frame.expected_obs.reject_count
              << "/" << frame.expected_obs.miss_count;
    return 0;
}
