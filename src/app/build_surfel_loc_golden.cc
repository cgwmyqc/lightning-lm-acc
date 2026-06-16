// SPDX-License-Identifier: MIT

#include <gflags/gflags.h>
#include <glog/logging.h>
#include <pcl/io/pcd_io.h>

#include "core/localization/surfel_loc/surfel_loc_backend.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"
#include "core/localization/surfel_loc/surfel_map_window.h"

DEFINE_string(map_pcd, "", "Active/local map PCD used to build ObsCell active window");
DEFINE_string(scan_pcd, "", "Body-frame scan PCD used as replay input");
DEFINE_string(output_dir, "fpga/golden/localization/frame_000001", "Output golden frame directory");
DEFINE_double(tx, 0.0, "Pose translation x");
DEFINE_double(ty, 0.0, "Pose translation y");
DEFINE_double(tz, 0.0, "Pose translation z");
DEFINE_double(qx, 0.0, "Pose quaternion x");
DEFINE_double(qy, 0.0, "Pose quaternion y");
DEFINE_double(qz, 0.0, "Pose quaternion z");
DEFINE_double(qw, 1.0, "Pose quaternion w");
DEFINE_double(cell_resolution, 0.8, "Surfel cell resolution");
DEFINE_int32(min_support, 3, "Minimum points per surfel cell");
DEFINE_double(quality_max, 0.05, "Maximum surfel plane quality");
DEFINE_int32(lookup_nearby_type, 26, "Neighbor lookup type: 0, 6, 18, or 26");
DEFINE_double(residual_outlier_th, 0.3, "Residual outlier threshold");

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    if (FLAGS_map_pcd.empty() || FLAGS_scan_pcd.empty()) {
        LOG(ERROR) << "map_pcd and scan_pcd are required";
        return 1;
    }

    using namespace lightning;
    using namespace lightning::loc;

    CloudPtr map_cloud(new PointCloudType);
    CloudPtr scan_cloud(new PointCloudType);
    if (pcl::io::loadPCDFile<PointType>(FLAGS_map_pcd, *map_cloud) != 0) {
        LOG(ERROR) << "failed to load map_pcd: " << FLAGS_map_pcd;
        return 1;
    }
    if (pcl::io::loadPCDFile<PointType>(FLAGS_scan_pcd, *scan_cloud) != 0) {
        LOG(ERROR) << "failed to load scan_pcd: " << FLAGS_scan_pcd;
        return 1;
    }

    SurfelLocOptions options;
    options.cell_resolution = static_cast<float>(FLAGS_cell_resolution);
    options.min_support = FLAGS_min_support;
    options.quality_max = static_cast<float>(FLAGS_quality_max);
    options.lookup_nearby_type = FLAGS_lookup_nearby_type;
    options.residual_outlier_th = FLAGS_residual_outlier_th;

    SurfelMapWindow window(options);
    if (!window.BuildFromCloud(map_cloud)) {
        LOG(ERROR) << "failed to build active surfel window";
        return 1;
    }

    Quatd q(FLAGS_qw, FLAGS_qx, FLAGS_qy, FLAGS_qz);
    q.normalize();
    const SE3 pose_guess(q, Vec3d(FLAGS_tx, FLAGS_ty, FLAGS_tz));

    SurfelLocBackend backend(options);
    LocNormalEquation expected;
    if (!backend.ComputeObservation(scan_cloud, pose_guess, window.Buffer(), expected)) {
        LOG(ERROR) << "failed to compute expected observation";
        return 1;
    }

    std::string error;
    if (!golden::WriteLocalizationGolden(FLAGS_output_dir, scan_cloud, pose_guess, window.Buffer(), expected, options,
                                         &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    LOG(INFO) << "wrote localization golden to " << FLAGS_output_dir << " valid=" << expected.valid_count
              << " reject=" << expected.reject_count << " miss=" << expected.miss_count;
    return 0;
}
