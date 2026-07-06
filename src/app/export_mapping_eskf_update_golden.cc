// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "common/options.h"
#include "core/lio/laser_mapping.h"
#include "core/lio/mapping_eskf_update.h"
#include "io/yaml_io.h"
#include "wrapper/bag_io.h"

DEFINE_string(input_bag, "", "Input rosbag2 sqlite3 db3 file");
DEFINE_string(config, "./config/default_livox.yaml", "Config YAML");
DEFINE_int32(frame_index, 20, "Completed mapping ESKF update index to capture");
DEFINE_string(output_dir, "fpga/golden/mapping_update/frame_000001", "Output mapping update golden directory");

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
        LOG(ERROR) << "MAPPING_ESKF_UPDATE_GOLDEN_EXPORT_FAIL: enable_icp_part=true; Stage64 captures surfel plane "
                      "update only";
        return 2;
    }

    LaserMapping lio;
    if (!lio.Init(FLAGS_config)) {
        LOG(ERROR) << "failed to init LaserMapping";
        return 1;
    }

    bool captured = false;
    lio.SetMappingUpdateGoldenCapture(
        FLAGS_frame_index, [&](const mapping_update::GoldenFrame& frame) {
            std::string error;
            if (!mapping_update::WriteGoldenFrame(FLAGS_output_dir, frame, FLAGS_input_bag, FLAGS_config, &error)) {
                LOG(ERROR) << error;
                return false;
            }
            captured = true;
            lightning::debug::flg_exit = true;
            LOG(INFO) << "MAPPING_ESKF_UPDATE_GOLDEN_EXPORT_PASS output_dir=" << FLAGS_output_dir
                      << " frame_index=" << frame.input.frame_index
                      << " iteration_index=" << frame.input.iteration_index
                      << " nullity=" << frame.expected.nullity
                      << " dx_norm=" << frame.expected.dx_norm
                      << " cov_finalized=" << frame.expected.covariance_finalized;
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

    if (!captured || !lio.MappingUpdateGoldenCaptured()) {
        LOG(ERROR) << "MAPPING_ESKF_UPDATE_GOLDEN_EXPORT_FAIL frame_index=" << FLAGS_frame_index;
        return 3;
    }
    LOG(INFO) << "mapping update golden capture complete; skipped SaveMap()";
    return 0;
}
