// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "common/options.h"
#include "core/lio/laser_mapping.h"
#include "core/lio/mapping_golden.h"
#include "io/yaml_io.h"
#include "wrapper/bag_io.h"

DEFINE_string(input_bag, "", "Input rosbag2 sqlite3 db3 file");
DEFINE_string(config, "./config/default_livox.yaml", "Config YAML");
DEFINE_int32(frame_index, 20, "Valid mapping observation frame index to capture");
DEFINE_string(output_dir, "fpga/golden_src/mapping/frame_000001", "Output mapping golden source directory");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    if (FLAGS_input_bag.empty()) {
        LOG(ERROR) << "input_bag is required";
        return 1;
    }
    if (FLAGS_frame_index < 0) {
        LOG(ERROR) << "frame_index must be non-negative";
        return 1;
    }

    using namespace lightning;

    YAML_IO yaml(FLAGS_config);
    if (yaml.GetValue<bool>("fasterlio", "enable_icp_part")) {
        LOG(ERROR) << "MAPPING_GOLDEN_EXPORT_FAIL: enable_icp_part=true; Stage52 exports surfel plane observation only";
        return 2;
    }

    LaserMapping lio;
    if (!lio.Init(FLAGS_config)) {
        LOG(ERROR) << "failed to init LaserMapping";
        return 1;
    }

    bool captured = false;
    lio.SetMappingGoldenFrameCapture(FLAGS_frame_index, [&](const LaserMapping::MappingGoldenFrameData& data) {
        mapping_golden::MappingGoldenFrame frame;
        frame.scan_body = data.scan_body;
        frame.state = data.state;
        frame.extrinsic_R = data.extrinsic_R;
        frame.extrinsic_t = data.extrinsic_t;
        frame.active_map = data.active_map;
        frame.expected_obs = data.expected_obs;
        frame.frame_index = data.frame_index;
        frame.timestamp = data.timestamp;
        frame.effect_feat_surf = data.effect_feat_surf;
        frame.plane_icp_weight = data.plane_icp_weight;

        std::string error;
        if (!mapping_golden::WriteSourceFrame(FLAGS_output_dir, frame, FLAGS_input_bag, FLAGS_config, &error)) {
            LOG(ERROR) << error;
            return false;
        }
        captured = true;
        lightning::debug::flg_exit = true;
        LOG(INFO) << "MAPPING_GOLDEN_EXPORT_PASS output_dir=" << FLAGS_output_dir
                  << " scan_points=" << (frame.scan_body ? frame.scan_body->size() : 0)
                  << " active_blocks=" << frame.active_map.blocks.size()
                  << " active_cells=" << frame.active_map.cells.size()
                  << " effect_feat_surf=" << frame.effect_feat_surf;
        return true;
    });

    const std::string lidar_topic = yaml.GetValue<std::string>("common", "lidar_topic");
    const std::string imu_topic = yaml.GetValue<std::string>("common", "imu_topic");
    const std::string livox_lidar_topic = yaml.GetValue<std::string>("common", "livox_lidar_topic");

    lightning::debug::flg_exit = false;
    RosbagIO rosbag(FLAGS_input_bag);
    rosbag
        .AddImuHandle(imu_topic,
                      [&lio](IMUPtr imu) {
                          lio.ProcessIMU(imu);
                          return true;
                      })
        .AddPointCloud2Handle(lidar_topic,
                              [&lio](sensor_msgs::msg::PointCloud2::SharedPtr cloud) {
                                  lio.ProcessPointCloud2(cloud);
                                  lio.Run();
                                  return true;
                              })
        .AddLivoxCloudHandle(livox_lidar_topic,
                             [&lio](livox_ros_driver2::msg::CustomMsg::SharedPtr cloud) {
                                 lio.ProcessPointCloud2(cloud);
                                 lio.Run();
                                 return true;
                             })
        .Go();

    if (!captured || !lio.MappingGoldenFrameCaptured()) {
        LOG(ERROR) << "MAPPING_GOLDEN_EXPORT_FAIL frame_index=" << FLAGS_frame_index;
        return 3;
    }
    LOG(INFO) << "capture complete; skipped SaveMap()";
    return 0;
}
