#include <pcl/common/transforms.h>
#include <yaml-cpp/yaml.h>
#include <array>
#include <cstdint>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <iomanip>

#include "common/fpga_config.h"
#include "common/options.h"
#include "core/lightning_math.hpp"
#include "core/lio/mapping_golden.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"
#include "laser_mapping.h"

#include <opencv2/core/mat.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "ui/pangolin_window.h"
#include "utils/perf_monitor.h"
#include "wrapper/ros_utils.h"

namespace lightning {
namespace {

using Clock = std::chrono::steady_clock;

const char* MappingBackendName(MappingBackendType backend) {
    switch (backend) {
        case MappingBackendType::CPU:
            return "CPU";
        case MappingBackendType::CPU_SIM:
            return "CPU_SIM";
        case MappingBackendType::FPGA_OBS:
            return "FPGA_OBS";
        case MappingBackendType::FPGA_OBS_UPDATE:
            return "FPGA_OBS_UPDATE";
        case MappingBackendType::FPGA_FULL:
            return "FPGA_FULL";
    }
    return "UNKNOWN";
}

template <typename T>
T GetYamlValue(const YAML::Node& node, const std::string& key, const T& default_value) {
    if (node && node[key]) {
        return node[key].as<T>();
    }
    return default_value;
}

uint32_t GetYamlUint32(const YAML::Node& node, const std::string& key, uint32_t default_value) {
    if (!node || !node[key]) {
        return default_value;
    }
    try {
        const std::string text = node[key].as<std::string>();
        size_t pos = 0;
        const unsigned long value = std::stoul(text, &pos, 0);
        if (pos == text.size() && value <= 0xFFFFFFFFul) {
            return static_cast<uint32_t>(value);
        }
    } catch (const std::exception&) {
    }
    return node[key].as<uint32_t>();
}

double SecondsSince(const Clock::time_point& start) {
    return std::chrono::duration<double>(Clock::now() - start).count();
}

}  // namespace

bool LaserMapping::Init(const std::string &config_yaml) {
    LOG(INFO) << "init laser mapping from " << config_yaml;
    if (!LoadParamsFromYAML(config_yaml)) {
        return false;
    }

    // localmap init (after LoadParams)
    ivox_ = std::make_shared<IVoxType>(ivox_options_);
    if (options_.enable_surfel_map_) {
        surfel_map_ = std::make_shared<BlockSurfelMap>(surfel_map_options_);
    }

    // esekf init
    ESKF::Options eskf_options;
    eskf_options.max_iterations_ = fasterlio::NUM_MAX_ITERATIONS;
    eskf_options.epsi_ = 1e-3 * Eigen::Matrix<double, ESKF::state_dim_, 1>::Ones();
    eskf_options.lidar_obs_func_ = [this](NavState &s, ESKF::CustomObservationModel &obs) { ObsModel(s, obs); };
    eskf_options.use_aa_ = use_aa_;
    kf_.Init(eskf_options);

    return true;
}

bool LaserMapping::LoadParamsFromYAML(const std::string &yaml_file) {
    // get params from yaml
    int lidar_type, ivox_nearby_type;
    double gyr_cov, acc_cov, b_gyr_cov, b_acc_cov;
    double filter_size_scan;

    auto yaml = YAML::LoadFile(yaml_file);
    try {
        fasterlio::NUM_MAX_ITERATIONS = yaml["fasterlio"]["max_iteration"].as<int>();
        fasterlio::ESTI_PLANE_THRESHOLD = yaml["fasterlio"]["esti_plane_threshold"].as<float>();

        filter_size_scan = yaml["fasterlio"]["filter_size_scan"].as<float>();
        filter_size_map_min_ = yaml["fasterlio"]["filter_size_map"].as<float>();
        keep_first_imu_estimation_ = yaml["fasterlio"]["keep_first_imu_estimation"].as<bool>();
        gyr_cov = yaml["fasterlio"]["gyr_cov"].as<float>();
        acc_cov = yaml["fasterlio"]["acc_cov"].as<float>();
        b_gyr_cov = yaml["fasterlio"]["b_gyr_cov"].as<float>();
        b_acc_cov = yaml["fasterlio"]["b_acc_cov"].as<float>();
        preprocess_->Blind() = yaml["fasterlio"]["blind"].as<double>();
        preprocess_->TimeScale() = yaml["fasterlio"]["time_scale"].as<double>();
        lidar_type = yaml["fasterlio"]["lidar_type"].as<int>();
        preprocess_->NumScans() = yaml["fasterlio"]["scan_line"].as<int>();
        preprocess_->PointFilterNum() = yaml["fasterlio"]["point_filter_num"].as<int>();

        extrinT_ = yaml["fasterlio"]["extrinsic_T"].as<std::vector<double>>();
        extrinR_ = yaml["fasterlio"]["extrinsic_R"].as<std::vector<double>>();

        ivox_options_.resolution_ = yaml["fasterlio"]["ivox_grid_resolution"].as<float>();
        surfel_map_options_.cell_resolution = ivox_options_.resolution_;
        if (yaml["fasterlio"]["surfel_cell_resolution"]) {
            surfel_map_options_.cell_resolution = yaml["fasterlio"]["surfel_cell_resolution"].as<float>();
        }
        ivox_nearby_type = yaml["fasterlio"]["ivox_nearby_type"].as<int>();
        use_aa_ = yaml["fasterlio"]["use_aa"].as<bool>();

        skip_lidar_num_ = yaml["fasterlio"]["skip_lidar_num"].as<int>();
        enable_skip_lidar_ = skip_lidar_num_ > 0;

        float height_max = yaml["roi"]["height_max"].as<float>();
        float height_min = yaml["roi"]["height_min"].as<float>();

        preprocess_->SetHeightROI(height_max, height_min);

        options_.kf_dis_th_ = yaml["fasterlio"]["kf_dis_th"].as<double>();
        options_.kf_angle_th_ = yaml["fasterlio"]["kf_angle_th"].as<double>() * M_PI / 180.0;
        options_.enable_icp_part_ = yaml["fasterlio"]["enable_icp_part"].as<bool>();
        options_.min_pts = yaml["fasterlio"]["min_pts"].as<int>();
        options_.plane_icp_weight_ = yaml["fasterlio"]["plane_icp_weight"].as<float>();
        if (yaml["fasterlio"]["enable_surfel_map"]) {
            options_.enable_surfel_map_ = yaml["fasterlio"]["enable_surfel_map"].as<bool>();
        }
        if (yaml["fasterlio"]["surfel_min_support"]) {
            surfel_map_options_.min_support = yaml["fasterlio"]["surfel_min_support"].as<int>();
        }
        if (yaml["fasterlio"]["surfel_quality_max"]) {
            surfel_map_options_.quality_max = yaml["fasterlio"]["surfel_quality_max"].as<float>();
        }
        if (yaml["fasterlio"]["surfel_block_capacity"]) {
            surfel_map_options_.block_capacity = yaml["fasterlio"]["surfel_block_capacity"].as<size_t>();
        }
        if (yaml["fasterlio"]["surfel_lookup_nearby_type"]) {
            surfel_map_options_.lookup_nearby_type = yaml["fasterlio"]["surfel_lookup_nearby_type"].as<int>();
        }
        if (yaml["fasterlio"]["surfel_fallback_mode"]) {
            options_.surfel_fallback_mode_ = yaml["fasterlio"]["surfel_fallback_mode"].as<std::string>();
        }
        if (yaml["fasterlio"]["surfel_fallback_warn_ratio"]) {
            options_.surfel_fallback_warn_ratio_ = yaml["fasterlio"]["surfel_fallback_warn_ratio"].as<double>();
        }

        const FpgaSubsystemConfig fpga_mapping = LoadFpgaSubsystemConfig(yaml, "mapping", "cpu_sim", "cpu");
        const YAML::Node fpga_runtime = yaml["fpga"] ? yaml["fpga"]["runtime"] : YAML::Node();
        options_.mapping_xdma_options_.user_dev =
            GetYamlValue(fpga_runtime, "user_dev", options_.mapping_xdma_options_.user_dev);
        options_.mapping_xdma_options_.h2c_dev =
            GetYamlValue(fpga_runtime, "h2c_dev", options_.mapping_xdma_options_.h2c_dev);
        options_.mapping_xdma_options_.c2h_dev =
            GetYamlValue(fpga_runtime, "c2h_dev", options_.mapping_xdma_options_.c2h_dev);
        options_.mapping_xdma_options_.ctrl_base =
            GetYamlUint32(fpga_runtime, "ctrl_base", options_.mapping_xdma_options_.ctrl_base);
        options_.mapping_xdma_options_.timeout_sec =
            GetYamlValue(fpga_runtime, "timeout_sec", options_.mapping_xdma_options_.timeout_sec);
        options_.mapping_xdma_verify_readback_ =
            GetYamlValue(fpga_runtime, "verify_readback", options_.mapping_xdma_verify_readback_);
        options_.mapping_candidate_abi_v2_ =
            GetYamlValue(fpga_runtime, "candidate_abi_v2", options_.mapping_candidate_abi_v2_);
        const YAML::Node profile_node = yaml["profile"];
        options_.mapping_fpga_profile_enable_ =
            GetYamlValue(profile_node, "fpga_obs_trace_enable", options_.mapping_fpga_profile_enable_);
        options_.mapping_fpga_profile_csv_enable_ =
            GetYamlValue(profile_node, "fpga_obs_trace_csv_enable", options_.mapping_fpga_profile_csv_enable_);
        options_.mapping_fpga_profile_csv_path_ =
            GetYamlValue(profile_node, "fpga_obs_trace_csv_path", options_.mapping_fpga_profile_csv_path_);
        options_.mapping_fallback_to_cpu_ = fpga_mapping.fallback == "cpu";
        options_.mapping_backend_type_ = MappingBackendType::CPU;
        if (fpga_mapping.effective_enable) {
            if (fpga_mapping.mode == "cpu") {
                options_.mapping_backend_type_ = MappingBackendType::CPU;
            } else if (fpga_mapping.mode == "cpu_sim") {
                options_.mapping_backend_type_ = MappingBackendType::CPU_SIM;
            } else if (fpga_mapping.mode == "fpga_obs" || fpga_mapping.mode == "fpga_observation") {
                options_.mapping_backend_type_ = MappingBackendType::FPGA_OBS;
            } else if (fpga_mapping.mode == "fpga_obs_update" || fpga_mapping.mode == "fpga_update") {
                options_.mapping_backend_type_ = MappingBackendType::FPGA_OBS_UPDATE;
            } else if (fpga_mapping.mode == "fpga_full" || fpga_mapping.mode == "fpga_full_pipeline") {
                options_.mapping_backend_type_ = MappingBackendType::FPGA_FULL;
            } else {
                LOG(WARNING) << "[LaserMapping] unknown mapping mode '" << fpga_mapping.mode
                             << "', falling back to CPU";
            }
        }
        LOG(INFO) << "[LaserMapping] mapping_backend=" << MappingBackendName(options_.mapping_backend_type_)
                  << " fpga_global_enable=" << fpga_mapping.global_enable
                  << " fpga_mapping_enable=" << fpga_mapping.enable << " fpga_mapping_mode=" << fpga_mapping.mode
                  << " mapping_fallback_to_cpu=" << options_.mapping_fallback_to_cpu_
                  << " mapping_fpga_ctrl_base=0x" << std::hex << options_.mapping_xdma_options_.ctrl_base
                  << std::dec << " mapping_fpga_timeout_sec=" << options_.mapping_xdma_options_.timeout_sec
                  << " mapping_candidate_abi_v2=" << options_.mapping_candidate_abi_v2_
                  << " fpga_obs_trace_enable=" << options_.mapping_fpga_profile_enable_
                  << " fpga_obs_trace_csv_enable=" << options_.mapping_fpga_profile_csv_enable_
                  << " fpga_obs_trace_csv_path=" << options_.mapping_fpga_profile_csv_path_;

        bool use_imu_filter = yaml["fasterlio"]["imu_filter"].as<bool>();
        p_imu_->SetUseIMUFilter(use_imu_filter);
        options_.proj_kfs_ = yaml["fasterlio"]["proj_kfs"].as<bool>();

    } catch (...) {
        LOG(ERROR) << "bad conversion";
        return false;
    }

    LOG(INFO) << "lidar_type " << lidar_type;
    if (lidar_type == 1) {
        preprocess_->SetLidarType(LidarType::AVIA);
        LOG(INFO) << "Using AVIA Lidar";
    } else if (lidar_type == 2) {
        preprocess_->SetLidarType(LidarType::VELO32);
        LOG(INFO) << "Using Velodyne 32 Lidar";
    } else if (lidar_type == 3) {
        preprocess_->SetLidarType(LidarType::OUST64);
        LOG(INFO) << "Using OUST 64 Lidar";
    } else if (lidar_type == 4) {
        preprocess_->SetLidarType(LidarType::ROBOSENSE);
        LOG(INFO) << "Using RoboSense Lidar";
    } else {
        LOG(WARNING) << "unknown lidar_type";
        return false;
    }

    if (ivox_nearby_type == 0) {
        ivox_options_.nearby_type_ = IVoxType::NearbyType::CENTER;
    } else if (ivox_nearby_type == 6) {
        ivox_options_.nearby_type_ = IVoxType::NearbyType::NEARBY6;
    } else if (ivox_nearby_type == 18) {
        ivox_options_.nearby_type_ = IVoxType::NearbyType::NEARBY18;
    } else if (ivox_nearby_type == 26) {
        ivox_options_.nearby_type_ = IVoxType::NearbyType::NEARBY26;
    } else {
        LOG(WARNING) << "unknown ivox_nearby_type, use NEARBY18";
        ivox_options_.nearby_type_ = IVoxType::NearbyType::NEARBY18;
    }

    voxel_scan_.setLeafSize(filter_size_scan, filter_size_scan, filter_size_scan);

    offset_t_lidar_fixed_ = math::VecFromArray<double>(extrinT_);
    offset_R_lidar_fixed_ = math::MatFromArray<double>(extrinR_);

    p_imu_->SetExtrinsic(offset_t_lidar_fixed_, offset_R_lidar_fixed_);
    p_imu_->SetGyrCov(Vec3d(gyr_cov, gyr_cov, gyr_cov));
    p_imu_->SetAccCov(Vec3d(acc_cov, acc_cov, acc_cov));
    p_imu_->SetGyrBiasCov(Vec3d(b_gyr_cov, b_gyr_cov, b_gyr_cov));
    p_imu_->SetAccBiasCov(Vec3d(b_acc_cov, b_acc_cov, b_acc_cov));
    return true;
}

LaserMapping::LaserMapping(Options options) : options_(options) {
    preprocess_.reset(new PointCloudPreprocess());
    p_imu_.reset(new ImuProcess());
}

void LaserMapping::SetMappingGoldenFrameCapture(int target_frame_index, MappingGoldenFrameCaptureCallback callback) {
    mapping_golden_target_frame_index_ = target_frame_index;
    mapping_golden_callback_ = std::move(callback);
    mapping_golden_valid_frame_count_ = 0;
    mapping_golden_current_scan_serial_ = 0;
    mapping_golden_last_counted_scan_serial_ = std::numeric_limits<uint64_t>::max();
    mapping_golden_frame_captured_ = false;
}

void LaserMapping::ProcessIMU(const lightning::IMUPtr &imu) {
    publish_count_++;

    double timestamp = imu->timestamp;

    UL lock(mtx_buffer_);
    if (timestamp < last_timestamp_imu_) {
        LOG(WARNING) << "imu loop back, clear buffer";
        imu_buffer_.clear();
    }

    if (p_imu_->IsIMUInited()) {
        /// 更新最新imu状态
        kf_imu_.Predict(timestamp - last_timestamp_imu_, p_imu_->Q_, imu->angular_velocity, imu->linear_acceleration);

        // LOG(INFO) << "newest wrt lidar: " << timestamp - kf_.GetX().timestamp_;

        /// 更新ui
        if (ui_) {
            ui_->UpdateNavState(kf_imu_.GetX());
        }
    }

    last_timestamp_imu_ = timestamp;

    imu_buffer_.emplace_back(imu);
}

bool LaserMapping::Run() {
    bool sync_ok = false;
    {
        ScopedPerfStage perf("SyncPackages");
        sync_ok = SyncPackages();
    }
    if (!sync_ok) {
        LOG(WARNING) << "sync package failed";
        return false;
    }

    /// IMU process, kf prediction, undistortion
    {
        ScopedPerfStage perf("IMU Undistort");
        p_imu_->Process(measures_, kf_, scan_undistort_);
    }

    if (scan_undistort_->empty() || (scan_undistort_ == nullptr)) {
        LOG(WARNING) << "No point, skip this scan!";
        return false;
    }

    /// the first scan
    if (flg_first_scan_) {
        LOG(INFO) << "first scan pts: " << scan_undistort_->size();

        state_point_ = kf_.GetX();
        scan_down_world_->resize(scan_undistort_->size());
        for (int i = 0; i < scan_undistort_->size(); i++) {
            PointBodyToWorld(scan_undistort_->points[i], scan_down_world_->points[i]);
        }
        ivox_->AddPoints(scan_down_world_->points);
        if (surfel_map_) {
            surfel_map_->Initialize(scan_down_world_->points);
        }

        first_lidar_time_ = measures_.lidar_end_time_;
        state_point_.timestamp_ = lidar_end_time_;
        flg_first_scan_ = false;
        return true;
    }

    if (enable_skip_lidar_) {
        skip_lidar_cnt_++;
        skip_lidar_cnt_ = skip_lidar_cnt_ % skip_lidar_num_;

        if (skip_lidar_cnt_ != 0) {
            /// 更新UI中的内容
            if (ui_) {
                ui_->UpdateNavState(kf_.GetX());
                ui_->UpdateScan(scan_undistort_, kf_.GetX().GetPose());
            }

            return false;
        }
    }

    LOG(INFO) << "=============================";
    LOG(INFO) << "LIO get cloud at beg: " << std::setprecision(14) << measures_.lidar_begin_time_
              << ", end: " << measures_.lidar_end_time_;
    ++mapping_golden_current_scan_serial_;

    if (last_lidar_time_ > 0 && (measures_.lidar_begin_time_ - last_lidar_time_) > 0.5) {
        LOG(ERROR) << "检测到雷达断流，时长：" << (measures_.lidar_begin_time_ - last_lidar_time_);
    }

    last_lidar_time_ = measures_.lidar_begin_time_;

    flg_EKF_inited_ = (measures_.lidar_begin_time_ - first_lidar_time_) >= fasterlio::INIT_TIME;

    /// downsample
    {
        ScopedPerfStage perf("Downsample");
        voxel_scan_.setInputCloud(scan_undistort_);
        voxel_scan_.filter(*scan_down_body_);

        // if (options_.proj_kfs_) {
        //     ProjectKFs();
        // }

        int cur_pts = scan_down_body_->size();

        if (cur_pts < (scan_undistort_->size() * 0.1) || cur_pts < options_.min_pts) {
            /// 降采样太狠了,有效点数不够，用0.1分辨率代替
            // LOG(INFO) << "too few points, using 0.1 resol";
            auto v = voxel_scan_;
            v.setLeafSize(0.1, 0.1, 0.1);
            v.setInputCloud(scan_undistort_);
            v.filter(*scan_down_body_);

            // LOG(INFO) << "Now pts: " << scan_down_body_->size() << ", before: " << cur_pts;
        }
    }

    int cur_pts = scan_down_body_->size();
    PerfMonitor::SetFramePointStats(static_cast<int>(scan_undistort_->size()), cur_pts);

    if (cur_pts < 5) {
        LOG(WARNING) << "Too few points, skip this scan!" << scan_undistort_->size() << ", " << scan_down_body_->size();
        return false;
    }

    scan_down_world_->resize(cur_pts);
    nearest_points_.resize(cur_pts);

    // 成员变量预分配
    residuals_.resize(cur_pts, 0);
    point_selected_surf_.resize(cur_pts, 1);
    point_selected_icp_.resize(cur_pts, 1);
    plane_coef_.resize(cur_pts, Vec4f::Zero());
    surfel_corr_.resize(cur_pts);

    auto pred_state = kf_.GetX();
    // pred_state.pos_ = state_point_.pos_;  // 假定位置不动行不行,防止速度漂移
    // kf_.ChangeX(pred_state);

    if (options_.mapping_backend_type_ == MappingBackendType::FPGA_FULL) {
        ScopedPerfStage perf("Mapping FPGA_FULL one-shot total");
        if (!RunMappingFpgaFullOneShot()) {
            if (!RunCpuEskfUpdateForFpgaFallback()) {
                return false;
            }
        }
    } else {
        ScopedPerfStage perf("ESKF Update total");
        kf_.Update(ESKF::ObsType::LIDAR, 1.0);
    }

    state_point_ = kf_.GetX();
    state_point_.timestamp_ = measures_.lidar_end_time_;

    const double delta_translation = (pred_state.pos_ - state_point_.pos_).norm();
    const double delta_rotation_deg = (pred_state.rot_.inverse() * state_point_.rot_).log().norm() * 180.0 / M_PI;
    const double delta_velocity = (pred_state.vel_ - state_point_.vel_).norm();

    const double current_speed = state_point_.vel_.norm();

    LOG(INFO) << "[ mapping ]: In num: " << scan_undistort_->points.size() << " down " << cur_pts
              << " Map grid num: " << ivox_->NumValidGrids()
              << (surfel_map_ ? " surfel blocks: " + std::to_string(surfel_map_->NumBlocks()) +
                                     " valid surfels: " + std::to_string(surfel_map_->NumValidSurfels())
                               : "")
              << " effect num : " << effect_feat_surf_ << ", " << effect_feat_icp_
              << " surfel hit/fallback: " << surfel_hit_num_ << "/" << surfel_fallback_num_;
    LOG(INFO) << "delta trans: " << (pred_state.pos_ - state_point_.pos_).transpose()
              << ", ang: " << delta_rotation_deg;
    // LOG(INFO) << "P diag: " << kf_.GetP().diagonal().transpose();

    // Vec3d v_from_last = (state_point_.pos_ - last_state.pos_) / (state_point_.timestamp_ - last_state.timestamp_);
    // LOG(INFO) << "v from last: " << v_from_last.transpose();

    // if (delta_velocity > 1.0 || current_speed > 4.0) {
    //     LOG(ERROR) << "detected very large vel change, last: " << last_state.vel_.transpose()
    //                << ", pred: " << pred_state.vel_.transpose() << ", cur:" << state_point_.vel_.transpose();
    //     LOG(ERROR) << "please check";
    // }

    /// keyframes
    if (last_kf_ == nullptr) {
        MakeKF();
    } else {
        SE3 last_pose = last_kf_->GetLIOPose();
        SE3 cur_pose = state_point_.GetPose();
        if ((last_pose.translation() - cur_pose.translation()).norm() > options_.kf_dis_th_ ||
            (last_pose.so3().inverse() * cur_pose.so3()).log().norm() > options_.kf_angle_th_) {
            MakeKF();
        } else if (!options_.is_in_slam_mode_ && (state_point_.timestamp_ - last_kf_->GetState().timestamp_) > 2.0) {
            MakeKF();
        } else if ((last_pose.so3().inverse() * cur_pose.so3()).log().norm() > 1.0 * M_PI / 180.0) {
            // MapIncremental();
        }
    }

    /// 更新kf_for_imu
    kf_imu_ = kf_;
    if (!measures_.imu_.empty()) {
        double t = measures_.imu_.back()->timestamp;
        for (auto &imu : imu_buffer_) {
            double dt = imu->timestamp - t;
            kf_imu_.Predict(dt, p_imu_->Q_, imu->angular_velocity, imu->linear_acceleration);
            t = imu->timestamp;
        }
    }

    if (ui_) {
        ui_->UpdateScan(scan_down_body_, state_point_.GetPose());
    }

    LOG(INFO) << "LIO state: " << state_point_.pos_.transpose() << ", yaw "
              << state_point_.rot_.angleZ<double>() * 180 / M_PI << ", vel: " << state_point_.vel_.transpose()
              << ", grav: " << state_point_.grav_.transpose() << ", grav norm: " << state_point_.grav_.norm();

    return true;
}

void LaserMapping::ProjectKFs(CloudPtr cloud, int size_limit) {
    auto state = kf_.GetX();
    SE3 pose_cur(state.rot_, state.pos_);
    pose_cur = pose_cur.inverse();

    for (auto kf : proj_kfs_) {
        // LOG(INFO) << "projecting kf: " << kf->GetID();
        // if (last_kf_) {
        // auto kf = last_kf_;
        SE3 pose = pose_cur * kf->GetLIOPose();

        int cnt = 0;
        for (auto &pt : kf->GetCloud()->points) {
            Vec3d p = pose * ToVec3d(pt);
            PointType pcl_pt;

            pcl_pt.x = p.x();
            pcl_pt.y = p.y();
            pcl_pt.z = p.z();
            pcl_pt.intensity = pt.intensity;

            cloud->push_back(pcl_pt);
            cnt++;

            if (cnt > size_limit) {
                break;
            }
        }
        // }
    }
}

void LaserMapping::MakeKF() {
    Keyframe::Ptr kf = std::make_shared<Keyframe>(kf_id_++, scan_undistort_, state_point_);

    if (last_kf_) {
        /// opt pose 用之前的递推
        SE3 delta = last_kf_->GetLIOPose().inverse() * kf->GetLIOPose();
        kf->SetOptPose(last_kf_->GetOptPose() * delta);
    } else {
        kf->SetOptPose(kf->GetLIOPose());
    }

    kf->SetState(state_point_);

    LOG(INFO) << "LIO: create kf " << kf->GetID() << ", state: " << state_point_.pos_.transpose()
              << ", kf opt pose: " << kf->GetOptPose().translation().transpose()
              << ", lio pose: " << kf->GetLIOPose().translation().transpose() << ", time: " << std::setprecision(14)
              << state_point_.timestamp_;

    if (options_.is_in_slam_mode_) {
        all_keyframes_.emplace_back(kf);
    }

    last_kf_ = kf;

    // 有keyframes时更新local map
    Timer::Evaluate(
        [&, this]() {
            ScopedPerfStage perf("Incremental Mapping");
            MapIncremental();
        },
        "    Incremental Mapping");

    /// 更新project kfs
    if (proj_kfs_.size() >= options_.max_proj_kfs_) {
        auto last = proj_kfs_.back();

        SE3 delta = last->GetLIOPose().inverse() * kf->GetLIOPose();

        if (delta.translation().norm() < 3 || delta.so3().log().norm() < 20 / 180 * M_PI) {
            // proj_kfs_.pop_back();
        } else {
            proj_kfs_.pop_front();
            proj_kfs_.emplace_back(kf);
        }
    } else {
        proj_kfs_.emplace_back(kf);
    }

    // for (auto &kf : proj_kfs_) {
    //     LOG(INFO) << "proj kf: " << kf->GetID();
    // }
}

void LaserMapping::ProcessPointCloud2(const sensor_msgs::msg::PointCloud2::SharedPtr &msg) {
    UL lock(mtx_buffer_);
    Timer::Evaluate(
        [&, this]() {
            ScopedPerfStage perf("Preprocess");
            scan_count_++;
            double timestamp = ToSec(msg->header.stamp);
            if (timestamp < last_timestamp_lidar_) {
                LOG(ERROR) << "lidar loop back, dt: " << timestamp - last_timestamp_lidar_;
                return;
            }

            LOG(INFO) << "get cloud at " << std::setprecision(14) << timestamp
                      << ", latest imu: " << last_timestamp_imu_;

            CloudPtr cloud(new PointCloudType());
            preprocess_->Process(msg, cloud);

            lidar_buffer_.push_back(cloud);
            time_buffer_.push_back(timestamp);
            last_timestamp_lidar_ = timestamp;
        },
        "Preprocess (Standard)");
}

void LaserMapping::ProcessPointCloud2(const livox_ros_driver2::msg::CustomMsg::SharedPtr &msg) {
    UL lock(mtx_buffer_);
    Timer::Evaluate(
        [&, this]() {
            ScopedPerfStage perf("Preprocess");
            scan_count_++;
            double timestamp = ToSec(msg->header.stamp);
            if (timestamp < last_timestamp_lidar_) {
                LOG(ERROR) << "lidar loop back, clear buffer";
                lidar_buffer_.clear();
            }

            // LOG(INFO) << "get cloud at " << std::setprecision(14) << timestamp
            //           << ", latest imu: " << last_timestamp_imu_;

            CloudPtr cloud(new PointCloudType());
            preprocess_->Process(msg, cloud);

            lidar_buffer_.push_back(cloud);
            time_buffer_.push_back(timestamp);
            last_timestamp_lidar_ = timestamp;
        },
        "Preprocess (Standard)");
}

void LaserMapping::ProcessPointCloud2(CloudPtr cloud) {
    UL lock(mtx_buffer_);
    Timer::Evaluate(
        [&, this]() {
            ScopedPerfStage perf("Preprocess");
            scan_count_++;

            double timestamp = math::ToSec(cloud->header.stamp);
            if (timestamp < last_timestamp_lidar_) {
                LOG(ERROR) << "lidar loop back, clear buffer";
                lidar_buffer_.clear();
            }

            lidar_buffer_.push_back(cloud);
            time_buffer_.push_back(timestamp);
            last_timestamp_lidar_ = timestamp;
        },
        "Preprocess (Standard)");
}

bool LaserMapping::SyncPackages() {
    if (lidar_buffer_.empty() || imu_buffer_.empty()) {
        LOG(INFO) << "lidar or imu is empty";
        return false;
    }

    /*** push a lidar scan ***/
    if (!lidar_pushed_) {
        measures_.scan_ = lidar_buffer_.front();
        measures_.lidar_begin_time_ = time_buffer_.front();

        if (measures_.scan_->points.size() <= 1) {
            LOG(WARNING) << "Too few input point cloud!";
            lidar_end_time_ = measures_.lidar_begin_time_ + lidar_mean_scantime_;
        } else if (measures_.scan_->points.back().time / double(1000) < 0.5 * lidar_mean_scantime_) {
            lidar_end_time_ = measures_.lidar_begin_time_ + lidar_mean_scantime_;
        } else {
            scan_num_++;
            lidar_end_time_ = measures_.lidar_begin_time_ + measures_.scan_->points.back().time / double(1000);

            lidar_mean_scantime_ +=
                (measures_.scan_->points.back().time / double(1000) - lidar_mean_scantime_) / scan_num_;

            if ((lidar_end_time_ - measures_.lidar_begin_time_) > 5 * lo::lidar_time_interval) {
                /// timestamp 有异常
                lidar_end_time_ = measures_.lidar_begin_time_ + lo::lidar_time_interval;
                lidar_mean_scantime_ = lo::lidar_time_interval;
            }
        }

        lo::lidar_time_interval = lidar_mean_scantime_;

        // LOG(INFO) << "recompute lidar end time: " << std::setprecision(14) << lidar_end_time_;
        measures_.lidar_end_time_ = lidar_end_time_;
        lidar_pushed_ = true;
    }

    if (last_timestamp_imu_ < lidar_end_time_) {
        LOG(INFO) << "sync failed: " << std::setprecision(14) << last_timestamp_imu_ << ", " << lidar_end_time_;
        return false;
    }

    /*** push imu_ data, and pop from imu_ buffer ***/
    double imu_time = imu_buffer_.front()->timestamp;
    measures_.imu_.clear();
    while ((!imu_buffer_.empty()) && (imu_time < lidar_end_time_)) {
        imu_time = imu_buffer_.front()->timestamp;
        if (imu_time > lidar_end_time_) {
            break;
        }

        measures_.imu_.push_back(imu_buffer_.front());

        imu_buffer_.pop_front();
    }

    lidar_buffer_.pop_front();
    time_buffer_.pop_front();
    lidar_pushed_ = false;

    // LOG(INFO) << "sync: " << std::setprecision(14) << measures_.lidar_begin_time_ << ", " <<
    // measures_.lidar_end_time_;

    return true;
}

void LaserMapping::MapIncremental() {
    if (options_.mapping_backend_type_ == MappingBackendType::FPGA_OBS_UPDATE ||
        options_.mapping_backend_type_ == MappingBackendType::FPGA_FULL) {
        MapIncrementalFpgaUpdate();
        return;
    }
    MapIncrementalCpu();
}

void LaserMapping::MapIncrementalFpgaUpdate() {
    if (!mapping_backend_warning_logged_) {
        LOG(WARNING) << "[LaserMapping] FPGA map incremental update is not implemented yet; "
                     << "using CPU MapIncremental. FPGA_FULL still uses FPGA observation + FPGA EKF update.";
        mapping_backend_warning_logged_ = true;
    }
    MapIncrementalCpu();
}

void LaserMapping::MapIncrementalCpu() {
    PointVector points_to_add;
    PointVector point_no_need_downsample;
    PointVector surfel_points_to_update;

    size_t cur_pts = scan_down_body_->size();
    points_to_add.reserve(cur_pts);
    point_no_need_downsample.reserve(cur_pts);
    surfel_points_to_update.reserve(cur_pts);

    std::vector<size_t> index(cur_pts);
    for (size_t i = 0; i < cur_pts; ++i) {
        index[i] = i;
    }

    std::for_each(index.begin(), index.end(), [&](const size_t &i) {
        /* transform to world frame */
        PointBodyToWorld(scan_down_body_->points[i], scan_down_world_->points[i]);

        /* decide if need add to map */
        PointType &point_world = scan_down_world_->points[i];
        if (surfel_map_) {
            surfel_points_to_update.emplace_back(point_world);
        }
        if (!nearest_points_[i].empty() && flg_EKF_inited_) {
            const PointVector &points_near = nearest_points_[i];

            Eigen::Vector3f center =
                ((point_world.getVector3fMap() / filter_size_map_min_).array().floor() + 0.5) * filter_size_map_min_;

            Eigen::Vector3f dis_2_center = points_near[0].getVector3fMap() - center;

            if (fabs(dis_2_center.x()) > 0.5 * filter_size_map_min_ &&
                fabs(dis_2_center.y()) > 0.5 * filter_size_map_min_ &&
                fabs(dis_2_center.z()) > 0.5 * filter_size_map_min_) {
                point_no_need_downsample.emplace_back(point_world);
                return;
            }

            bool need_add = true;
            float dist = math::calc_dist(point_world.getVector3fMap(), center);
            if (points_near.size() >= fasterlio::NUM_MATCH_POINTS) {
                for (int readd_i = 0; readd_i < fasterlio::NUM_MATCH_POINTS; readd_i++) {
                    if (math::calc_dist(points_near[readd_i].getVector3fMap(), center) < dist + 1e-6) {
                        need_add = false;
                        break;
                    }
                }
            }

            if (need_add) {
                points_to_add.emplace_back(point_world);  // FIXME 这并发可能有点问题
            }
        } else {
            points_to_add.emplace_back(point_world);
        }
    });

    Timer::Evaluate(
        [&, this]() {
            ivox_->AddPoints(points_to_add);
            ivox_->AddPoints(point_no_need_downsample);
            if (surfel_map_) {
                surfel_map_->BatchUpdate(surfel_points_to_update);
            }
        },
        "    Local Map Add Points");
}

bool LaserMapping::RunCpuEskfUpdateForFpgaFallback() {
    if (!options_.mapping_fallback_to_cpu_) {
        LOG(ERROR) << "[LaserMapping] mapping FPGA_FULL failed and CPU fallback is disabled.";
        return false;
    }
    const MappingBackendType saved_backend = options_.mapping_backend_type_;
    options_.mapping_backend_type_ = MappingBackendType::CPU;
    {
        ScopedPerfStage perf("ESKF Update total (FPGA_FULL CPU fallback)");
        kf_.Update(ESKF::ObsType::LIDAR, 1.0);
    }
    options_.mapping_backend_type_ = saved_backend;
    return true;
}

bool LaserMapping::RunMappingFpgaFullOneShot() {
    const auto full_start = Clock::now();
    const uint64_t fpga_call_id = ++mapping_fpga_call_count_;
    const int64_t frame_id = PerfMonitor::GetCurrentFrameId();

    auto fail = [&](const std::string& reason) {
        ++mapping_fpga_fallback_count_;
        LOG(WARNING) << "[LaserMapping] mapping FPGA_FULL failed -> CPU fallback: " << reason
                     << " fallback_count=" << mapping_fpga_fallback_count_;
        return false;
    };

    if (options_.enable_icp_part_) {
        return fail("enable_icp_part=true but FPGA_FULL one-shot only supports surfel plane observation");
    }
    if (use_aa_) {
        return fail("use_aa=true is not supported by FPGA_FULL one-shot");
    }
    if (!options_.mapping_candidate_abi_v2_) {
        return fail("FPGA_FULL requires candidate ABI V2");
    }
    if (!surfel_map_) {
        return fail("surfel_map is disabled");
    }
    if (scan_down_body_ == nullptr || scan_down_body_->empty()) {
        return fail("empty scan_down_body");
    }

    loc::ActiveMapBuffer active_map;
    auto stage_start = Clock::now();
    if (!surfel_map_->ExportActiveMap(active_map) || active_map.Empty()) {
        return fail("failed to export active surfel map");
    }
    const double export_active_map_sec = SecondsSince(stage_start);

    std::array<float, 9> extrinsic_R{};
    std::array<float, 3> extrinsic_T{};
    const Mat3f extrinsic_R_f = offset_R_lidar_fixed_.cast<float>();
    const Vec3f extrinsic_T_f = offset_t_lidar_fixed_.cast<float>();
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            extrinsic_R[static_cast<size_t>(r * 3 + c)] = extrinsic_R_f(r, c);
        }
        extrinsic_T[static_cast<size_t>(r)] = extrinsic_T_f(r);
    }

    stage_start = Clock::now();
    const auto scan_points = fpga::ToAbiScanPoints(scan_down_body_);
    const double pack_scan_sec = SecondsSince(stage_start);

    const NavState start_state = kf_.GetX();
    const ESKF::CovType propagated_cov = kf_.GetP();
    const SE3 lidar_pose = mapping_golden::LidarPoseFromState(start_state, offset_R_lidar_fixed_, offset_t_lidar_fixed_);
    const auto pose = loc::golden::ToAbiPose(lidar_pose);
    const auto params = fpga::MakeMappingObservationParams(static_cast<float>(options_.plane_icp_weight_),
                                                           extrinsic_R, extrinsic_T);

    fpga::XdmaRuntime runtime(options_.mapping_xdma_options_);
    fpga::XdmaRuntime::RunResult obs_result;
    std::string error;
    stage_start = Clock::now();
    if (!runtime.RunMappingObservationV2(scan_points, pose, active_map, params, true,
                                         options_.mapping_xdma_verify_readback_, obs_result, &error)) {
        return fail("observation V2 failed: " + error);
    }
    const double observation_call_sec = SecondsSince(stage_start);

    const loc::LocNormalEquation equation = loc::golden::FromAbiNormalEquation(obs_result.output);
    if (equation.valid_count < 20) {
        return fail("not enough FPGA_FULL effective surface points: " + std::to_string(equation.valid_count));
    }

    mapping_update::UpdateInput update_input;
    update_input.start_state = start_state;
    update_input.current_state = start_state;
    update_input.propagated_cov = propagated_cov;
    update_input.HTH = equation.hessian;
    update_input.HTr = equation.gradient;
    update_input.dx_from_start = ESKF::StateVecType::Zero();
    update_input.params.R = 1.0;
    update_input.params.limit = 1e-3 * ESKF::StateVecType::Ones();
    update_input.frame_index = static_cast<int>(frame_id);
    update_input.iteration_index = 0;
    update_input.finish_update = true;

    fpga::XdmaRuntime::EkfUpdateRunResult ekf_result;
    stage_start = Clock::now();
    if (!runtime.RunMappingEkfUpdate(update_input, true, options_.mapping_xdma_verify_readback_, ekf_result, &error)) {
        return fail("EKF update failed: " + error);
    }
    const double ekf_call_sec = SecondsSince(stage_start);
    if (!ekf_result.output.success || ekf_result.output.rejected) {
        return fail("EKF update output status=" + ekf_result.output.status);
    }

    NavState updated_state = ekf_result.output.updated_state;
    updated_state.timestamp_ = measures_.lidar_end_time_;
    kf_.ChangeX(updated_state);
    kf_.ChangeP(ekf_result.output.updated_cov);

    effect_feat_surf_ = static_cast<int>(equation.valid_count);
    effect_feat_icp_ = 0;
    surfel_hit_num_ = static_cast<int>(equation.valid_count);
    surfel_fallback_num_ = static_cast<int>(equation.miss_count);
    ++mapping_fpga_success_count_;
    PerfMonitor::SetEffectivePointStats(effect_feat_surf_, effect_feat_icp_);

    if (options_.mapping_fpga_profile_enable_) {
        AppendMappingFpgaProfileCsv(frame_id, 1, fpga_call_id, scan_points.size(), active_map.blocks.size(),
                                    active_map.cells.size(), export_active_map_sec, pack_scan_sec, obs_result,
                                    equation);
    }

    LOG(INFO) << "[LaserMapping] mapping FPGA_FULL observation success=1"
              << " ekf_update success=1"
              << " success_count=" << mapping_fpga_success_count_
              << " frame_id=" << frame_id
              << " fpga_call=" << fpga_call_id
              << " scan_points=" << scan_points.size()
              << " active_blocks=" << active_map.blocks.size()
              << " active_cells=" << active_map.cells.size()
              << " kernel_sel_obs=4"
              << " kernel_sel_ekf=5"
              << " candidate_abi_v2=" << options_.mapping_candidate_abi_v2_
              << " candidate_count=" << obs_result.candidate_count
              << " candidate_valid=" << obs_result.candidate_valid_count
              << " candidate_miss=" << obs_result.candidate_miss_count
              << " candidate_bytes=" << obs_result.candidate_bytes
              << " valid/reject/miss=" << equation.valid_count << "/" << equation.reject_count << "/"
              << equation.miss_count
              << " residual_abs_sum=" << equation.residual_abs_sum
              << " residual_max_abs=" << equation.residual_max_abs
              << " obs_hls_wait=" << obs_result.timing.hls_wait_sec
              << " obs_total=" << obs_result.timing.total_sec
              << " obs_runtime_call=" << observation_call_sec
              << " ekf_hls_wait=" << ekf_result.timing.hls_wait_sec
              << " ekf_total=" << ekf_result.timing.total_sec
              << " ekf_runtime_call=" << ekf_call_sec
              << " ekf_status=" << ekf_result.output.status
              << " dx_norm=" << ekf_result.output.dx_norm
              << " dx_translation=" << ekf_result.output.dx_translation
              << " dx_rotation_deg=" << ekf_result.output.dx_rotation_deg
              << " fallback=0"
              << " full_total=" << SecondsSince(full_start)
              << " obs_status=0x" << std::hex << obs_result.status
              << " obs_error=0x" << obs_result.error
              << " ekf_status_reg=0x" << ekf_result.status
              << " ekf_error=0x" << ekf_result.error
              << std::dec << " obs_run_count=" << obs_result.run_count_before << "->" << obs_result.run_count_after
              << " ekf_run_count=" << ekf_result.run_count_before << "->" << ekf_result.run_count_after;
    return true;
}

/**
 * Lidar point cloud registration
 * will be called by the eskf custom observation model
 * compute point-to-plane residual here
 * @param s kf state
 * @param ekfom_data H matrix
 */
void LaserMapping::ObsModel(NavState &s, ESKF::CustomObservationModel &obs) {
    if (options_.mapping_backend_type_ == MappingBackendType::FPGA_OBS ||
        options_.mapping_backend_type_ == MappingBackendType::FPGA_OBS_UPDATE ||
        options_.mapping_backend_type_ == MappingBackendType::FPGA_FULL) {
        ObsModelFpgaObservation(s, obs);
        return;
    }
    ObsModelCpu(s, obs);
}

void LaserMapping::ObsModelFpgaObservation(NavState &s, ESKF::CustomObservationModel &obs) {
    const uint64_t fpga_call_id = ++mapping_fpga_call_count_;
    const int64_t frame_id = PerfMonitor::GetCurrentFrameId();
    const uint64_t obs_call_index = PerfMonitor::GetCurrentObsModelCalls() + 1;
    const auto obs_start = Clock::now();

    auto fallback_to_cpu = [&](const std::string& reason) {
        ++mapping_fpga_fallback_count_;
        if (options_.mapping_fallback_to_cpu_) {
            LOG(WARNING) << "[LaserMapping] mapping FPGA_OBS failed -> CPU fallback: " << reason
                         << " fallback_count=" << mapping_fpga_fallback_count_;
            ObsModelCpu(s, obs);
        } else {
            LOG(ERROR) << "[LaserMapping] mapping FPGA_OBS failed and CPU fallback is disabled: " << reason;
            obs.valid_ = false;
        }
    };

    if (options_.enable_icp_part_) {
        fallback_to_cpu("enable_icp_part=true but Stage55 FPGA_OBS only supports surfel plane observation");
        return;
    }
    if (!surfel_map_) {
        fallback_to_cpu("surfel_map is disabled");
        return;
    }
    if (scan_down_body_ == nullptr || scan_down_body_->empty()) {
        fallback_to_cpu("empty scan_down_body");
        return;
    }

    loc::ActiveMapBuffer active_map;
    auto stage_start = Clock::now();
    if (!surfel_map_->ExportActiveMap(active_map) || active_map.Empty()) {
        fallback_to_cpu("failed to export active surfel map");
        return;
    }
    const double export_active_map_sec = SecondsSince(stage_start);

    std::array<float, 9> extrinsic_R{};
    std::array<float, 3> extrinsic_T{};
    const Mat3f extrinsic_R_f = offset_R_lidar_fixed_.cast<float>();
    const Vec3f extrinsic_T_f = offset_t_lidar_fixed_.cast<float>();
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            extrinsic_R[static_cast<size_t>(r * 3 + c)] = extrinsic_R_f(r, c);
        }
        extrinsic_T[static_cast<size_t>(r)] = extrinsic_T_f(r);
    }

    stage_start = Clock::now();
    const auto scan_points = fpga::ToAbiScanPoints(scan_down_body_);
    const double pack_scan_sec = SecondsSince(stage_start);
    const SE3 lidar_pose = mapping_golden::LidarPoseFromState(s, offset_R_lidar_fixed_, offset_t_lidar_fixed_);
    const auto pose = loc::golden::ToAbiPose(lidar_pose);
    const auto params = fpga::MakeMappingObservationParams(static_cast<float>(options_.plane_icp_weight_),
                                                           extrinsic_R, extrinsic_T);

    fpga::XdmaRuntime runtime(options_.mapping_xdma_options_);
    fpga::XdmaRuntime::RunResult result;
    std::string error;
    stage_start = Clock::now();
    const bool run_ok =
        options_.mapping_candidate_abi_v2_
            ? runtime.RunMappingObservationV2(scan_points, pose, active_map, params, true,
                                              options_.mapping_xdma_verify_readback_, result, &error)
            : runtime.RunMappingObservation(scan_points, pose, active_map, params, true,
                                            options_.mapping_xdma_verify_readback_, result, &error);
    if (!run_ok) {
        fallback_to_cpu(error);
        return;
    }
    const double runtime_call_sec = SecondsSince(stage_start);

    const loc::LocNormalEquation equation = loc::golden::FromAbiNormalEquation(result.output);
    if (equation.valid_count < 20) {
        fallback_to_cpu("not enough FPGA effective surface points: " + std::to_string(equation.valid_count));
        return;
    }

    obs.valid_ = true;
    obs.HTH_ = equation.hessian;
    obs.HTr_ = equation.gradient;
    obs.lidar_residual_mean_ =
        equation.valid_count > 0 ? equation.residual_abs_sum / static_cast<double>(equation.valid_count) : 0.0;
    obs.lidar_residual_max_ = equation.residual_max_abs;
    effect_feat_surf_ = static_cast<int>(equation.valid_count);
    effect_feat_icp_ = 0;
    surfel_hit_num_ = static_cast<int>(equation.valid_count);
    surfel_fallback_num_ = static_cast<int>(equation.miss_count);
    ++mapping_fpga_success_count_;

    PerfMonitor::SetEffectivePointStats(effect_feat_surf_, effect_feat_icp_);
    if (options_.mapping_fpga_profile_enable_) {
        AppendMappingFpgaProfileCsv(frame_id, obs_call_index, fpga_call_id, scan_points.size(),
                                    active_map.blocks.size(), active_map.cells.size(), export_active_map_sec,
                                    pack_scan_sec, result, equation);
    }

    LOG(INFO) << "[LaserMapping] mapping FPGA_OBS success=1"
              << " success_count=" << mapping_fpga_success_count_
              << " frame_id=" << frame_id
              << " obs_call=" << obs_call_index
              << " fpga_call=" << fpga_call_id
              << " scan_points=" << scan_points.size()
              << " active_blocks=" << active_map.blocks.size()
              << " active_cells=" << active_map.cells.size()
              << " candidate_abi_v2=" << options_.mapping_candidate_abi_v2_
              << " candidate_count=" << result.candidate_count
              << " candidate_valid=" << result.candidate_valid_count
              << " candidate_miss=" << result.candidate_miss_count
              << " candidate_bytes=" << result.candidate_bytes
              << " valid/reject/miss=" << equation.valid_count << "/" << equation.reject_count << "/"
              << equation.miss_count
              << " residual_abs_sum=" << equation.residual_abs_sum
              << " residual_max_abs=" << equation.residual_max_abs
              << " xdma_elapsed_sec=" << result.elapsed_sec
              << " profile_sec export_active_map=" << export_active_map_sec
              << " pack_scan=" << pack_scan_sec
              << " runtime_call=" << runtime_call_sec
              << " obs_total=" << SecondsSince(obs_start)
              << " timing_sec total=" << result.timing.total_sec
              << " mutex_wait=" << result.timing.mutex_wait_sec
              << " lock=" << result.timing.lock_sec
              << " open=" << result.timing.open_sec
              << " h2c_scan=" << result.timing.h2c_scan_sec
              << " h2c_pose_header_params=" << result.timing.h2c_pose_header_params_sec
              << " h2c_map=" << result.timing.h2c_map_sec
              << " verify_readback=" << result.timing.verify_readback_sec
              << " output_zero=" << result.timing.output_zero_sec
              << " reg_config=" << result.timing.reg_config_sec
              << " hls_wait=" << result.timing.hls_wait_sec
              << " c2h_output=" << result.timing.c2h_output_sec
              << " status=0x" << std::hex << result.status
              << " error=0x" << result.error
              << std::dec << " run_count=" << result.run_count_before << "->" << result.run_count_after;
}

void LaserMapping::AppendMappingFpgaProfileCsv(int64_t frame_id, uint64_t obs_call_index, uint64_t fpga_call_id,
                                               size_t scan_points, size_t active_blocks, size_t active_cells,
                                               double export_active_map_sec, double pack_scan_sec,
                                               const fpga::XdmaRuntime::RunResult& result,
                                               const loc::LocNormalEquation& equation) {
    if (!options_.mapping_fpga_profile_enable_ || !options_.mapping_fpga_profile_csv_enable_ ||
        options_.mapping_fpga_profile_csv_path_.empty()) {
        return;
    }

    const std::filesystem::path path(options_.mapping_fpga_profile_csv_path_);
    std::error_code ec;
    if (path.has_parent_path()) {
        std::filesystem::create_directories(path.parent_path(), ec);
    }
    const bool needs_header = !std::filesystem::exists(path, ec) || std::filesystem::file_size(path, ec) == 0;
    std::ofstream ofs(path, std::ios::app);
    if (!ofs) {
        LOG(WARNING) << "[LaserMapping] failed to open FPGA_OBS profile CSV: " << path;
        return;
    }
    if (needs_header) {
        ofs << "frame_id,obs_call,fpga_call,scan_points,active_blocks,active_cells,"
               "valid_count,reject_count,miss_count,residual_abs_sum,residual_max_abs,"
               "export_active_map_ms,pack_scan_ms,total_ms,mutex_wait_ms,lock_ms,open_ms,"
               "h2c_scan_ms,h2c_pose_header_params_ms,h2c_map_ms,h2c_candidate_ms,verify_readback_ms,output_zero_ms,"
               "reg_config_ms,hls_wait_ms,c2h_output_ms,status,error,run_count_before,run_count_after,"
               "scan_count_readback,candidate_count,candidate_valid,candidate_miss,candidate_bytes\n";
    }
    const auto ms = [](double sec) { return sec * 1000.0; };
    ofs << std::fixed << std::setprecision(6)
        << frame_id << "," << obs_call_index << "," << fpga_call_id << "," << scan_points << ","
        << active_blocks << "," << active_cells << "," << equation.valid_count << "," << equation.reject_count
        << "," << equation.miss_count << "," << equation.residual_abs_sum << "," << equation.residual_max_abs
        << "," << ms(export_active_map_sec) << "," << ms(pack_scan_sec) << "," << ms(result.timing.total_sec)
        << "," << ms(result.timing.mutex_wait_sec) << "," << ms(result.timing.lock_sec) << ","
        << ms(result.timing.open_sec) << "," << ms(result.timing.h2c_scan_sec) << ","
        << ms(result.timing.h2c_pose_header_params_sec) << "," << ms(result.timing.h2c_map_sec) << ","
        << ms(result.timing.h2c_candidate_sec) << "," << ms(result.timing.verify_readback_sec) << ","
        << ms(result.timing.output_zero_sec) << "," << ms(result.timing.reg_config_sec) << ","
        << ms(result.timing.hls_wait_sec) << "," << ms(result.timing.c2h_output_sec) << "," << result.status << ","
        << result.error << "," << result.run_count_before << "," << result.run_count_after << ","
        << result.scan_count_readback << "," << result.candidate_count << "," << result.candidate_valid_count << ","
        << result.candidate_miss_count << "," << result.candidate_bytes << "\n";
}

void LaserMapping::ObsModelCpu(NavState &s, ESKF::CustomObservationModel &obs) {
    int cnt_pts = scan_down_body_->size();

    std::vector<size_t> index(cnt_pts);
    for (size_t i = 0; i < index.size(); ++i) {
        index[i] = i;
    }

    // LOG(INFO) << "obs from state: " << s.pos_.transpose() << ", " << s.rot_.unit_quaternion().coeffs().transpose();

    Timer::Evaluate(
        [&, this]() {
            ScopedPerfStage lidar_match_perf("ObsModel Lidar Match");
            Mat3f R_wl = (s.rot_.matrix() * offset_R_lidar_fixed_).cast<float>();
            Vec3f t_wl = (s.rot_ * offset_t_lidar_fixed_ + s.pos_).cast<float>();

            {
                ScopedPerfStage perf("ObsModel Surfel Lookup");
                std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                    PointType &point_body = scan_down_body_->points[i];
                    PointType &point_world = scan_down_world_->points[i];

                    /* transform to world frame */
                    Vec3f p_body = point_body.getVector3fMap();
                    point_world.getVector3fMap() = R_wl * p_body + t_wl;
                    point_world.intensity = point_body.intensity;

                    auto &points_near = nearest_points_[i];
                    points_near.clear();
                    residuals_[i] = 0.0f;
                    plane_coef_[i] = Vec4f::Zero();
                    surfel_corr_[i] = SurfelCorrespondence();
                    point_selected_surf_[i] = false;
                    point_selected_icp_[i] = false;

                    if (surfel_map_ && surfel_map_->LookupSurfel(point_world, surfel_corr_[i])) {
                        plane_coef_[i] = surfel_corr_[i].plane;
                        PointType centroid;
                        centroid.x = surfel_corr_[i].centroid.x();
                        centroid.y = surfel_corr_[i].centroid.y();
                        centroid.z = surfel_corr_[i].centroid.z();
                        centroid.intensity = point_body.intensity;
                        centroid.time = point_body.time;
                        points_near.emplace_back(centroid);
                        point_selected_surf_[i] = true;
                        point_selected_icp_[i] = true;
                    } else {
                        surfel_corr_[i].fallback = true;
                        if (surfel_map_) {
                            surfel_map_->EnqueueFallback(point_world);
                        }
                    }
                });
            }

            if (!surfel_map_ || options_.surfel_fallback_mode_ == "ivox") {
                ScopedPerfStage perf("ObsModel iVox KNN Fallback");
                std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                    if (!surfel_corr_[i].fallback) {
                        return;
                    }
                    PointType &point_world = scan_down_world_->points[i];
                    auto &points_near = nearest_points_[i];
                    points_near.clear();

                    ivox_->GetClosestPoint(point_world, points_near, fasterlio::NUM_MATCH_POINTS);
                    point_selected_surf_[i] = points_near.size() >= fasterlio::MIN_NUM_MATCH_POINTS;
                    point_selected_icp_[i] = point_selected_surf_[i];
                });
            }

            {
                ScopedPerfStage perf("ObsModel Plane Fit Fallback");
                std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                    /// 能找到3个点以上，则估计平面
                    if (point_selected_surf_[i] && surfel_corr_[i].fallback) {
                        point_selected_surf_[i] =
                            math::esti_plane(plane_coef_[i], nearest_points_[i], fasterlio::ESTI_PLANE_THRESHOLD);
                    }
                });
            }

            {
                ScopedPerfStage perf("ObsModel Valid Point Check");
                std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                    /// 计算平面阈值
                    if (point_selected_surf_[i]) {
                        PointType &point_body = scan_down_body_->points[i];
                        PointType &point_world = scan_down_world_->points[i];
                        Vec3f p_body = point_body.getVector3fMap();
                        auto temp = point_world.getVector4fMap();
                        temp[3] = 1.0;
                        float pd2 = plane_coef_[i].dot(temp);

                        if (p_body.norm() > 81 * pd2 * pd2) {
                            point_selected_surf_[i] = true;
                            residuals_[i] = pd2;
                        } else {
                            point_selected_surf_[i] = false;
                        }
                    }
                });
            }
        },
        "    ObsModel (Lidar Match)");

    surfel_hit_num_ = 0;
    surfel_fallback_num_ = 0;
    surfel_lookup_stats_ = SurfelLookupStats();
    for (int i = 0; i < cnt_pts; ++i) {
        if (surfel_corr_[i].valid && !surfel_corr_[i].fallback) {
            ++surfel_hit_num_;
            if (surfel_corr_[i].hit_neighbor) {
                ++surfel_lookup_stats_.hit_neighbor;
            } else {
                ++surfel_lookup_stats_.hit_exact;
            }
        }
        if (surfel_corr_[i].fallback) {
            ++surfel_fallback_num_;
            switch (surfel_corr_[i].miss_reason) {
                case SurfelMissReason::NO_BLOCK:
                    ++surfel_lookup_stats_.miss_no_block;
                    break;
                case SurfelMissReason::EMPTY_CELL:
                    ++surfel_lookup_stats_.miss_empty_cell;
                    break;
                case SurfelMissReason::SUPPORT_LOW:
                    ++surfel_lookup_stats_.miss_support_low;
                    break;
                case SurfelMissReason::QUALITY_BAD:
                    ++surfel_lookup_stats_.miss_quality_bad;
                    break;
                case SurfelMissReason::NONE:
                default:
                    break;
            }
        }
    }
    if (surfel_map_ && cnt_pts > 0) {
        const double fallback_ratio = static_cast<double>(surfel_fallback_num_) / static_cast<double>(cnt_pts);
        LOG(INFO) << "surfel stats exact=" << surfel_lookup_stats_.hit_exact
                  << " neighbor=" << surfel_lookup_stats_.hit_neighbor
                  << " no_block=" << surfel_lookup_stats_.miss_no_block
                  << " empty=" << surfel_lookup_stats_.miss_empty_cell
                  << " support_low=" << surfel_lookup_stats_.miss_support_low
                  << " quality_bad=" << surfel_lookup_stats_.miss_quality_bad
                  << " fallback=" << surfel_fallback_num_ << "/" << cnt_pts;
        if (fallback_ratio > options_.surfel_fallback_warn_ratio_) {
            LOG(WARNING) << "Surfel fallback ratio is high: " << fallback_ratio << " fallback "
                         << surfel_fallback_num_ << "/" << cnt_pts;
        }
    }

    effect_feat_surf_ = 0;
    effect_feat_icp_ = 0;

    corr_pts_.resize(cnt_pts);
    corr_norm_.resize(cnt_pts);
    for (int i = 0; i < cnt_pts; i++) {
        if (point_selected_surf_[i]) {
            corr_norm_[effect_feat_surf_] = plane_coef_[i];
            corr_pts_[effect_feat_surf_] = scan_down_body_->points[i].getVector4fMap();
            corr_pts_[effect_feat_surf_][3] = residuals_[i];

            effect_feat_surf_++;
        }

        if (point_selected_icp_[i]) {
            effect_feat_icp_++;
        }
    }

    corr_pts_.resize(effect_feat_surf_);
    corr_norm_.resize(effect_feat_surf_);
    PerfMonitor::SetEffectivePointStats(effect_feat_surf_, effect_feat_icp_);

    if (effect_feat_surf_ < 20) {
        obs.valid_ = false;
        LOG(WARNING) << "No enough effective surface points: " << effect_feat_surf_ << ", icp: " << effect_feat_icp_
                     << ", required: " << 20;
        return;
    }

    index.resize(effect_feat_surf_);
    const Mat3f off_R = offset_R_lidar_fixed_.cast<float>();
    const Vec3f off_t = offset_t_lidar_fixed_.cast<float>();
    const Mat3f Rt = s.rot_.matrix().transpose().cast<float>();

    /// 点面ICP部分
    obs.HTH_.setZero();
    obs.HTr_.setZero();

    std::vector<Mat6d> JTJ(effect_feat_surf_);
    std::vector<Vec6d> JTr(effect_feat_surf_);

    std::vector<double> res_sq(index.size());

    {
        ScopedPerfStage perf("Plane ICP HTH/HTr CPU", effect_feat_surf_, effect_feat_surf_, "CPU");
        {
            ScopedPerfStage sub_perf("Plane ICP Residual/Jacobian");
            std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                Vec3f point_this_be = corr_pts_[i].head<3>();
                Vec3f point_this = off_R * point_this_be + off_t;
                Mat3f point_crossmat = math::SKEW_SYM_MATRIX(point_this);

                /*** get the normal vector of closest surface/corner ***/
                Vec3f norm_vec = corr_norm_[i].head<3>();

                /*** calculate the Measurement Jacobian matrix H ***/
                Vec3f C(Rt * norm_vec);
                Vec3f A(point_crossmat * C);

                Eigen::Matrix<double, 1, ESKF::pose_obs_dim_> J;
                J.setZero();
                J << norm_vec[0], norm_vec[1], norm_vec[2], A[0], A[1], A[2];

                float res = -corr_pts_[i][3];

                // double w = huber_weight(res);
                double w = 1.0;

                JTJ[i] = (J.transpose() * J).eval() * w;
                JTr[i] = J.transpose() * res * w;

                res_sq[i] = res * res;
            });
        }

        {
            ScopedPerfStage sub_perf("Plane ICP HTH/HTr Accumulate");
            for (int i = 0; i < index.size(); ++i) {
                obs.HTH_ += JTJ[i] * options_.plane_icp_weight_;
                obs.HTr_ += JTr[i] * options_.plane_icp_weight_;
            }
        }
    }

    MaybeCaptureMappingGoldenFrame(s, obs);

    if (!res_sq.empty()) {
        std::sort(res_sq.begin(), res_sq.end());
        obs.lidar_residual_mean_ = res_sq[res_sq.size() / 2];
        obs.lidar_residual_max_ = res_sq[res_sq.size() - 1];
        // LOG(INFO) << "residual mean: " << obs.lidar_residual_mean_ << ", max: " << obs.lidar_residual_max_
        //           << ", 85%: " << res_sq[res_sq.size() * 0.85];
    }

    /// 点到点ICP部分

    if (options_.enable_icp_part_) {
        ScopedPerfStage perf("Point ICP CPU", cnt_pts, effect_feat_icp_, "CPU");
        JTJ.resize(cnt_pts);
        JTr.resize(cnt_pts);

        std::vector<size_t> index(cnt_pts);
        for (size_t i = 0; i < index.size(); ++i) {
            index[i] = i;
        }

        std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
            if (point_selected_icp_[i] == false) {
                return;
            }

            /// TODO: 外参
            Vec3d q = scan_down_body_->points[i].getVector3fMap().cast<double>();
            Vec3d qs = scan_down_world_->points[i].getVector3fMap().cast<double>();

            Eigen::Matrix<double, 3, ESKF::pose_obs_dim_> J;
            J.setZero();

            /// translation 部分
            J.block<3, 3>(0, 0) = Mat3d::Identity();

            /// rotation 部分
            J.block<3, 3>(0, 3) = -(s.rot_.matrix() * offset_R_lidar_fixed_) * SO3::hat(q);

            Vec3d e = qs - nearest_points_[i][0].getVector3fMap().cast<double>();

            if (e.norm() > 0.5) {
                point_selected_icp_[i] = false;
                return;
            }

            JTJ[i] = J.transpose() * J;
            JTr[i] = -J.transpose() * e;
        });

        for (int i = 0; i < cnt_pts; ++i) {
            if (point_selected_icp_[i] == false) {
                continue;
            }
            obs.HTH_ += JTJ[i] * options_.icp_weight_;
            obs.HTr_ += JTr[i] * options_.icp_weight_;
        }
    }
}

void LaserMapping::MaybeCaptureMappingGoldenFrame(const NavState& state, const ESKF::CustomObservationModel& obs) {
    if (mapping_golden_frame_captured_ || !mapping_golden_callback_) {
        return;
    }
    if (!obs.valid_ || effect_feat_surf_ < 20 || scan_down_body_ == nullptr || scan_down_body_->empty() ||
        surfel_map_ == nullptr) {
        return;
    }

    if (mapping_golden_last_counted_scan_serial_ == mapping_golden_current_scan_serial_) {
        return;
    }
    mapping_golden_last_counted_scan_serial_ = mapping_golden_current_scan_serial_;
    const int capture_frame_index = mapping_golden_valid_frame_count_++;
    if (capture_frame_index < mapping_golden_target_frame_index_) {
        return;
    }

    MappingGoldenFrameData data;
    data.frame_index = capture_frame_index;
    data.timestamp = state.timestamp_;
    data.scan_body.reset(new PointCloudType(*scan_down_body_));
    data.state = state;
    data.extrinsic_R = offset_R_lidar_fixed_;
    data.extrinsic_t = offset_t_lidar_fixed_;
    data.effect_feat_surf = effect_feat_surf_;
    data.scan_points = static_cast<int>(scan_down_body_->size());
    data.plane_icp_weight = options_.plane_icp_weight_;
    if (!surfel_map_->ExportActiveMap(data.active_map)) {
        LOG(WARNING) << "[LaserMapping] failed to export active surfel map for mapping golden";
        return;
    }
    data.expected_obs.Reset();
    const Mat3f off_R = offset_R_lidar_fixed_.cast<float>();
    const Vec3f off_t = offset_t_lidar_fixed_.cast<float>();
    const Mat3f Rt = state.rot_.matrix().transpose().cast<float>();
    for (int i = 0; i < static_cast<int>(scan_down_body_->size()); ++i) {
        if (!point_selected_surf_[i] || !surfel_corr_[i].valid || surfel_corr_[i].fallback) {
            continue;
        }
        const Vec3f point_this_be = scan_down_body_->points[i].getVector3fMap();
        const Vec3f point_this = off_R * point_this_be + off_t;
        const Mat3f point_crossmat = math::SKEW_SYM_MATRIX(point_this);
        const Vec3f norm_vec = plane_coef_[i].head<3>();
        const Vec3f C = Rt * norm_vec;
        const Vec3f A = point_crossmat * C;

        Eigen::Matrix<double, 1, ESKF::pose_obs_dim_> J;
        J.setZero();
        J << norm_vec[0], norm_vec[1], norm_vec[2], A[0], A[1], A[2];
        const double res = -static_cast<double>(residuals_[i]);
        data.expected_obs.hessian.noalias() += (J.transpose() * J).eval() * options_.plane_icp_weight_;
        data.expected_obs.gradient.noalias() += J.transpose() * res * options_.plane_icp_weight_;
        ++data.expected_obs.valid_count;
        data.expected_obs.residual_sum += residuals_[i];
        data.expected_obs.residual_abs_sum += std::fabs(static_cast<double>(residuals_[i]));
        data.expected_obs.residual_max_abs =
            std::max(data.expected_obs.residual_max_abs, std::fabs(static_cast<double>(residuals_[i])));
    }
    data.expected_obs.reject_count = 0;
    data.expected_obs.miss_count = static_cast<uint32_t>(
        std::max(0, static_cast<int>(scan_down_body_->size()) - static_cast<int>(data.expected_obs.valid_count)));

    if (mapping_golden_callback_(data)) {
        mapping_golden_frame_captured_ = true;
    }
}

///////////////////////////  private method /////////////////////////////////////////////////////////////////////

CloudPtr LaserMapping::GetGlobalMap(bool use_lio_pose, bool use_voxel, float res) {
    CloudPtr global_map(new PointCloudType);

    pcl::VoxelGrid<PointType> voxel;
    voxel.setLeafSize(res, res, res);

    for (auto &kf : all_keyframes_) {
        CloudPtr cloud = kf->GetCloud();

        CloudPtr cloud_filter(new PointCloudType);

        if (use_voxel) {
            voxel.setInputCloud(cloud);
            voxel.filter(*cloud_filter);

        } else {
            cloud_filter = cloud;
        }

        CloudPtr cloud_trans(new PointCloudType);

        if (use_lio_pose) {
            pcl::transformPointCloud(*cloud_filter, *cloud_trans, kf->GetLIOPose().matrix());
        } else {
            pcl::transformPointCloud(*cloud_filter, *cloud_trans, kf->GetOptPose().matrix());
        }

        *global_map += *cloud_trans;

        LOG(INFO) << "kf " << kf->GetID() << ", pose: " << kf->GetOptPose().translation().transpose();
    }

    CloudPtr global_map_filtered(new PointCloudType);
    if (use_voxel) {
        voxel.setInputCloud(global_map);
        voxel.filter(*global_map_filtered);
    } else {
        global_map_filtered = global_map;
    }

    global_map_filtered->is_dense = false;
    global_map_filtered->height = 1;
    global_map_filtered->width = global_map_filtered->size();

    LOG(INFO) << "global map: " << global_map_filtered->size();

    return global_map_filtered;
}

void LaserMapping::SaveMap() {
    /// 保存地图
    auto global_map = GetGlobalMap(true);

    pcl::io::savePCDFileBinaryCompressed("./data/lio.pcd", *global_map);

    LOG(INFO) << "lio map is saved to ./data/lio.pcd";
}

CloudPtr LaserMapping::GetRecentCloud() {
    if (lidar_buffer_.empty()) {
        return nullptr;
    }

    return lidar_buffer_.front();
}

CloudPtr LaserMapping::GetProjCloud() {
    auto cloud = scan_undistort_;
    ProjectKFs(cloud);
    return cloud;
}

}  // namespace lightning
