// SPDX-License-Identifier: MIT

#include <filesystem>
#include <fstream>
#include <iomanip>
#include <string>

#include <gflags/gflags.h>
#include <glog/logging.h>
#include <pcl/io/pcd_io.h>

#include "common/options.h"
#include "core/localization/localization.h"
#include "io/yaml_io.h"
#include "wrapper/bag_io.h"

DEFINE_string(input_bag, "", "Input rosbag2 sqlite3 db3 file");
DEFINE_string(config, "./config/default.yaml", "Localization config YAML");
DEFINE_string(map_path, "./data/new_map/", "Tiled map path");
DEFINE_int32(frame_index, 20, "Valid initialized localization frame index to capture");
DEFINE_string(output_dir, "./fpga/golden_src/localization/frame_000001", "Output golden source frame directory");

namespace {

bool WritePoseGuess(const std::filesystem::path& path, const lightning::SE3& pose) {
    std::ofstream fout(path);
    if (!fout.is_open()) {
        return false;
    }

    const auto& t = pose.translation();
    const auto q = pose.unit_quaternion();
    fout << std::setprecision(18) << t.x() << " " << t.y() << " " << t.z() << " " << q.x() << " " << q.y()
         << " " << q.z() << " " << q.w() << "\n";
    return true;
}

bool WriteFrameMeta(const std::filesystem::path& path, const lightning::loc::LidarLoc::LocGoldenFrameData& data,
                    const std::string& bag, const std::string& config, const std::string& map_path) {
    std::ofstream fout(path);
    if (!fout.is_open()) {
        return false;
    }

    const auto& t = data.pose_guess.translation();
    const auto q = data.pose_guess.unit_quaternion();
    fout << std::setprecision(18);
    fout << "bag: " << bag << "\n";
    fout << "config: " << config << "\n";
    fout << "map_path: " << map_path << "\n";
    fout << "frame_index: " << data.frame_index << "\n";
    fout << "timestamp: " << data.timestamp << "\n";
    fout << "scan_points: " << (data.scan_body ? data.scan_body->size() : 0) << "\n";
    fout << "active_map_points: " << (data.active_map ? data.active_map->size() : 0) << "\n";
    fout << "pose_guess:\n";
    fout << "  tx: " << t.x() << "\n";
    fout << "  ty: " << t.y() << "\n";
    fout << "  tz: " << t.z() << "\n";
    fout << "  qx: " << q.x() << "\n";
    fout << "  qy: " << q.y() << "\n";
    fout << "  qz: " << q.z() << "\n";
    fout << "  qw: " << q.w() << "\n";
    return true;
}

}  // namespace

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    if (FLAGS_input_bag.empty()) {
        LOG(ERROR) << "input_bag is required";
        return 1;
    }
    if (FLAGS_output_dir.empty()) {
        LOG(ERROR) << "output_dir is required";
        return 1;
    }
    if (FLAGS_frame_index < 0) {
        LOG(ERROR) << "frame_index must be non-negative";
        return 1;
    }

    using namespace lightning;

    loc::Localization::Options options;
    options.online_mode_ = false;
    options.force_disable_ui_ = true;

    loc::Localization loc(options);
    if (!loc.Init(FLAGS_config, FLAGS_map_path)) {
        LOG(ERROR) << "failed to init localization";
        return 1;
    }

    const std::filesystem::path output_dir(FLAGS_output_dir);
    std::error_code ec;
    std::filesystem::create_directories(output_dir, ec);
    if (ec) {
        LOG(ERROR) << "failed to create output_dir " << output_dir << ": " << ec.message();
        return 1;
    }

    bool captured = false;
    loc.SetLocGoldenFrameCapture(FLAGS_frame_index, [&](const loc::LidarLoc::LocGoldenFrameData& data) {
        const auto scan_path = output_dir / "scan_body_undistorted.pcd";
        const auto map_path = output_dir / "active_map.pcd";
        const auto pose_path = output_dir / "pose_guess.txt";
        const auto meta_path = output_dir / "frame_meta.yaml";

        if (!data.scan_body || data.scan_body->empty()) {
            LOG(ERROR) << "captured scan is empty";
            return false;
        }
        if (!data.active_map || data.active_map->empty()) {
            LOG(ERROR) << "captured active map is empty";
            return false;
        }

        if (pcl::io::savePCDFileBinaryCompressed(scan_path.string(), *data.scan_body) != 0) {
            LOG(ERROR) << "failed to write " << scan_path;
            return false;
        }
        if (pcl::io::savePCDFileBinaryCompressed(map_path.string(), *data.active_map) != 0) {
            LOG(ERROR) << "failed to write " << map_path;
            return false;
        }
        if (!WritePoseGuess(pose_path, data.pose_guess)) {
            LOG(ERROR) << "failed to write " << pose_path;
            return false;
        }
        if (!WriteFrameMeta(meta_path, data, FLAGS_input_bag, FLAGS_config, FLAGS_map_path)) {
            LOG(ERROR) << "failed to write " << meta_path;
            return false;
        }

        captured = true;
        lightning::debug::flg_exit = true;
        LOG(INFO) << "wrote localization golden source frame to " << output_dir;
        return true;
    });

    YAML_IO yaml(FLAGS_config);
    const std::string lidar_topic = yaml.GetValue<std::string>("common", "lidar_topic");
    const std::string imu_topic = yaml.GetValue<std::string>("common", "imu_topic");
    const std::string livox_lidar_topic = yaml.GetValue<std::string>("common", "livox_lidar_topic");

    lightning::debug::flg_exit = false;
    RosbagIO rosbag(FLAGS_input_bag);
    rosbag
        .AddImuHandle(imu_topic,
                      [&loc](IMUPtr imu) {
                          loc.ProcessIMUMsg(imu);
                          return true;
                      })
        .AddPointCloud2Handle(lidar_topic,
                              [&loc](sensor_msgs::msg::PointCloud2::SharedPtr cloud) {
                                  loc.ProcessLidarMsg(cloud);
                                  return true;
                              })
        .AddLivoxCloudHandle(livox_lidar_topic,
                             [&loc](livox_ros_driver2::msg::CustomMsg::SharedPtr cloud) {
                                 loc.ProcessLivoxLidarMsg(cloud);
                                 return true;
                             })
        .Go();

    if (!captured || !loc.LocGoldenFrameCaptured()) {
        LOG(ERROR) << "failed to capture localization golden frame index=" << FLAGS_frame_index;
        return 2;
    }

    LOG(INFO) << "capture complete; skipped loc.Finish() to avoid saving dynamic map updates";
    return 0;
}
