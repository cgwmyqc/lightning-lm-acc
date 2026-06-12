#include <pcl/common/transforms.h>
#include <yaml-cpp/yaml.h>

#include <algorithm>
#include <cctype>
#include <cmath>
#include <execution>
#include <fstream>
#include <sstream>
#include <stdexcept>

#include "common/options.h"
#include "core/lightning_math.hpp"
#include "fpga/cpu_normal_equation_backend.h"
#include "fpga/cpu_surfel_lookup_backend.h"
#include "fpga/fpga_normal_equation_backend.h"
#include "laser_mapping.h"

#include <opencv2/core/mat.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

#include "ui/pangolin_window.h"
#include "utils/perf_monitor.h"
#include "wrapper/ros_utils.h"

namespace lightning {

namespace {

template <typename T>
T GetYamlValue(const YAML::Node& node, const std::string& key, const T& default_value) {
    if (node && node[key]) {
        return node[key].as<T>();
    }
    return default_value;
}

std::string NormalizeFpgaMode(std::string mode) {
    std::transform(mode.begin(), mode.end(), mode.begin(), [](unsigned char c) {
        if (c == '-') {
            return '_';
        }
        return static_cast<char>(std::toupper(c));
    });
    return mode.empty() ? "CPU" : mode;
}

uint64_t GetYamlUint64(const YAML::Node& node, const std::string& key, uint64_t default_value) {
    if (!node || !node[key]) {
        return default_value;
    }
    const std::string text = node[key].as<std::string>();
    std::size_t pos = 0;
    const uint64_t value = std::stoull(text, &pos, 0);
    if (pos != text.size()) {
        throw std::runtime_error("invalid uint64 yaml value for " + key + ": " + text);
    }
    return value;
}

struct NormalEquationCompareStats {
    float max_abs_error = 0.0f;
    float max_rel_error = 0.0f;
    std::string max_name;
};

void UpdateCompareStats(NormalEquationCompareStats* stats, const std::string& name, float actual, float expected) {
    const float abs_error = std::fabs(actual - expected);
    const float rel_error = abs_error / std::max(1.0f, std::fabs(expected));
    if (abs_error > stats->max_abs_error) {
        stats->max_abs_error = abs_error;
        stats->max_rel_error = rel_error;
        stats->max_name = name;
    }
}

NormalEquationCompareStats CompareNormalEquationResults(const fpga::NormalEquationResult& actual,
                                                        const fpga::NormalEquationResult& expected) {
    NormalEquationCompareStats stats;
    for (int r = 0; r < 6; ++r) {
        for (int c = 0; c < 6; ++c) {
            UpdateCompareStats(&stats, "H(" + std::to_string(r) + "," + std::to_string(c) + ")", actual.H(r, c),
                               expected.H(r, c));
        }
        UpdateCompareStats(&stats, "b(" + std::to_string(r) + ")", actual.b(r), expected.b(r));
    }
    UpdateCompareStats(&stats, "residual_sum", actual.residual_sum, expected.residual_sum);
    UpdateCompareStats(&stats, "residual_abs_sum", actual.residual_abs_sum, expected.residual_abs_sum);
    return stats;
}

bool IsComparePass(const NormalEquationCompareStats& stats, float abs_tol, float rel_tol) {
    return stats.max_abs_error <= abs_tol || stats.max_rel_error <= rel_tol;
}

struct LookupCompareStats {
    int mismatches = 0;
    float max_abs_error = 0.0f;
    std::string max_name;
};

void UpdateLookupCompareStats(LookupCompareStats* stats, const std::string& name, float actual, float expected) {
    const float abs_error = std::fabs(actual - expected);
    if (abs_error > stats->max_abs_error) {
        stats->max_abs_error = abs_error;
        stats->max_name = name;
    }
}

fpga::FpgaLookupResult ToFpgaLookupResult(const SurfelCorrespondence& corr) {
    fpga::FpgaLookupResult result;
    result.valid = corr.valid ? 1u : 0u;
    result.fallback = corr.fallback ? 1u : 0u;
    result.hit_neighbor = corr.hit_neighbor ? 1u : 0u;
    result.neighbor_level = static_cast<uint32_t>(corr.neighbor_level);
    result.miss_reason = static_cast<uint32_t>(corr.miss_reason);
    result.count = corr.count;
    result.quality = corr.quality;
    result.plane[0] = corr.plane.x();
    result.plane[1] = corr.plane.y();
    result.plane[2] = corr.plane.z();
    result.plane[3] = corr.plane.w();
    result.centroid[0] = corr.centroid.x();
    result.centroid[1] = corr.centroid.y();
    result.centroid[2] = corr.centroid.z();
    return result;
}

SurfelCorrespondence ToSurfelCorrespondence(const fpga::FpgaLookupResult& result) {
    SurfelCorrespondence corr;
    corr.valid = result.valid != 0;
    corr.fallback = result.fallback != 0;
    corr.hit_neighbor = result.hit_neighbor != 0;
    corr.neighbor_level = static_cast<int>(result.neighbor_level);
    corr.miss_reason = static_cast<SurfelMissReason>(result.miss_reason);
    corr.plane = Vec4f(result.plane[0], result.plane[1], result.plane[2], result.plane[3]);
    corr.centroid = Vec3f(result.centroid[0], result.centroid[1], result.centroid[2]);
    corr.quality = result.quality;
    corr.count = result.count;
    return corr;
}

void AddLookupStats(const SurfelCorrespondence& corr, SurfelLookupStats* stats) {
    if (corr.valid && !corr.fallback) {
        if (corr.hit_neighbor) {
            ++stats->hit_neighbor;
        } else {
            ++stats->hit_exact;
        }
        return;
    }
    switch (corr.miss_reason) {
        case SurfelMissReason::NO_BLOCK:
            ++stats->miss_no_block;
            break;
        case SurfelMissReason::EMPTY_CELL:
            ++stats->miss_empty_cell;
            break;
        case SurfelMissReason::SUPPORT_LOW:
            ++stats->miss_support_low;
            break;
        case SurfelMissReason::QUALITY_BAD:
            ++stats->miss_quality_bad;
            break;
        case SurfelMissReason::NONE:
        default:
            break;
    }
}

LookupCompareStats CompareLookupResults(const std::vector<fpga::FpgaLookupResult>& actual,
                                        const PointCloudType& points_world,
                                        const BlockSurfelMap& surfel_map) {
    LookupCompareStats stats;
    if (actual.size() != points_world.size()) {
        stats.mismatches += 1;
        stats.max_name = "result_size";
        stats.max_abs_error = static_cast<float>(
            std::abs(static_cast<int64_t>(actual.size()) - static_cast<int64_t>(points_world.size())));
        return stats;
    }

    for (size_t i = 0; i < points_world.size(); ++i) {
        SurfelCorrespondence expected_corr;
        const bool expected_hit = surfel_map.LookupSurfel(points_world.points[i], expected_corr);
        if (!expected_hit) {
            expected_corr.valid = false;
        }
        const fpga::FpgaLookupResult expected = ToFpgaLookupResult(expected_corr);
        const fpga::FpgaLookupResult& got = actual[i];

        if (got.valid != expected.valid || got.hit_neighbor != expected.hit_neighbor ||
            got.neighbor_level != expected.neighbor_level || got.miss_reason != expected.miss_reason ||
            got.count != expected.count) {
            ++stats.mismatches;
        }
        for (int k = 0; k < 4; ++k) {
            UpdateLookupCompareStats(&stats, "plane[" + std::to_string(k) + "]", got.plane[k],
                                     expected.plane[k]);
        }
        for (int k = 0; k < 3; ++k) {
            UpdateLookupCompareStats(&stats, "centroid[" + std::to_string(k) + "]", got.centroid[k],
                                     expected.centroid[k]);
        }
        UpdateLookupCompareStats(&stats, "quality", got.quality, expected.quality);
    }

    return stats;
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
    if (options_.fpga_enable_ && options_.normal_equation_backend_ == "CPU_SIM") {
        normal_equation_backend_ = std::make_shared<fpga::CpuNormalEquationBackend>();
        fpga_golden_writer_ = std::make_unique<fpga::FpgaGoldenWriter>(options_.fpga_golden_options_);
        LOG(INFO) << "[fpga] normal equation backend: " << normal_equation_backend_->Name();
    } else if (options_.fpga_enable_ && options_.normal_equation_backend_ == "FPGA") {
        normal_equation_backend_ = std::make_shared<fpga::FpgaNormalEquationBackend>(options_.fpga_backend_options_);
        LOG(INFO) << "[fpga] normal equation backend: " << normal_equation_backend_->Name();
    }
    if (options_.fpga_lookup_enable_ && options_.fpga_lookup_mode_ == "CPU_SIM") {
        surfel_lookup_backend_ = std::make_shared<fpga::CpuSurfelLookupBackend>();
        fpga_lookup_golden_writer_ =
            std::make_unique<fpga::FpgaLookupGoldenWriter>(options_.fpga_lookup_golden_options_);
        LOG(INFO) << "[fpga] surfel lookup backend: " << surfel_lookup_backend_->Name();
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
        if (yaml["fasterlio"]["min_pts_when_no_ivox_fallback"]) {
            options_.min_pts_when_no_ivox_fallback_ =
                yaml["fasterlio"]["min_pts_when_no_ivox_fallback"].as<int>();
        }

        const YAML::Node fpga = yaml["fpga"];
        options_.fpga_enable_ = GetYamlValue(fpga, "enable", false);
        options_.normal_equation_backend_ = NormalizeFpgaMode(GetYamlValue(fpga, "mode", std::string("cpu")));
        options_.fpga_golden_options_.enable = GetYamlValue(fpga, "golden_dump_enable", false);
        options_.fpga_golden_options_.dump_dir =
            GetYamlValue(fpga, "golden_dump_dir", std::string("/tmp/lightning_fpga_golden"));
        options_.fpga_golden_options_.every_n_frames = GetYamlValue(fpga, "golden_dump_every_n_frames", 100);
        options_.fpga_golden_options_.max_files = GetYamlValue(fpga, "golden_dump_max_files", 50);
        options_.fpga_backend_options_.xdma_h2c =
            GetYamlValue(fpga, "xdma_h2c", options_.fpga_backend_options_.xdma_h2c);
        options_.fpga_backend_options_.xdma_c2h =
            GetYamlValue(fpga, "xdma_c2h", options_.fpga_backend_options_.xdma_c2h);
        options_.fpga_backend_options_.xdma_user =
            GetYamlValue(fpga, "xdma_user", options_.fpga_backend_options_.xdma_user);
        options_.fpga_backend_options_.normal_eq_ctrl_addr =
            GetYamlUint64(fpga, "normal_eq_ctrl_addr", options_.fpga_backend_options_.normal_eq_ctrl_addr);
        options_.fpga_backend_options_.input_addr =
            GetYamlUint64(fpga, "input_addr", options_.fpga_backend_options_.input_addr);
        options_.fpga_backend_options_.output_addr =
            GetYamlUint64(fpga, "output_addr", options_.fpga_backend_options_.output_addr);
        options_.fpga_backend_options_.timeout_ms =
            GetYamlValue(fpga, "timeout_ms", options_.fpga_backend_options_.timeout_ms);
        options_.fpga_compare_with_cpu_ = GetYamlValue(fpga, "compare_with_cpu", false);
        options_.fpga_compare_abs_tol_ = GetYamlValue(fpga, "compare_abs_tol", 1.0e-3f);
        options_.fpga_compare_rel_tol_ = GetYamlValue(fpga, "compare_rel_tol", 1.0e-5f);
        options_.fpga_fallback_to_cpu_on_error_ = GetYamlValue(fpga, "fallback_to_cpu_on_error", true);
        options_.fpga_lookup_enable_ = GetYamlValue(fpga, "lookup_enable", false);
        options_.fpga_lookup_mode_ = NormalizeFpgaMode(GetYamlValue(fpga, "lookup_mode", std::string("cpu")));
        options_.fpga_lookup_golden_options_.enable = GetYamlValue(fpga, "lookup_golden_dump_enable", false);
        options_.fpga_lookup_golden_options_.dump_dir =
            GetYamlValue(fpga, "lookup_golden_dump_dir", std::string("/tmp/lightning_fpga_lookup_golden"));
        options_.fpga_lookup_golden_options_.every_n_frames =
            GetYamlValue(fpga, "lookup_golden_dump_every_n_frames", 100);
        options_.fpga_lookup_golden_options_.max_files = GetYamlValue(fpga, "lookup_golden_dump_max_files", 50);
        options_.fpga_lookup_compare_with_cpu_ = GetYamlValue(fpga, "lookup_compare_with_cpu", true);
        if (!options_.fpga_enable_) {
            options_.normal_equation_backend_ = "CPU";
        }
        if (!options_.fpga_lookup_enable_) {
            options_.fpga_lookup_mode_ = "CPU";
        }

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

    {
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

/**
 * Lidar point cloud registration
 * will be called by the eskf custom observation model
 * compute point-to-plane residual here
 * @param s kf state
 * @param ekfom_data H matrix
 */
void LaserMapping::ObsModel(NavState &s, ESKF::CustomObservationModel &obs) {
    int cnt_pts = scan_down_body_->size();
    const bool ivox_fallback_enabled = options_.surfel_fallback_mode_ == "ivox" || !surfel_map_;
    const bool ivox_fallback_disabled = options_.surfel_fallback_mode_ == "none" && surfel_map_;

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
                });

                bool used_lookup_backend = false;
                if (surfel_map_ && surfel_lookup_backend_) {
                    fpga::LookupBatchInput lookup_input = surfel_map_->ExportLookupBatchInput(*scan_down_world_);
                    fpga::LookupBatchOutput lookup_output;
                    used_lookup_backend = surfel_lookup_backend_->Lookup(lookup_input, &lookup_output) &&
                                          lookup_output.results.size() == index.size();
                    if (used_lookup_backend) {
                        if (options_.fpga_lookup_compare_with_cpu_) {
                            const LookupCompareStats stats =
                                CompareLookupResults(lookup_output.results, *scan_down_world_, *surfel_map_);
                            if (stats.mismatches == 0 && stats.max_abs_error <= 1.0e-6f) {
                                LOG(INFO) << "[fpga lookup] compare_with_cpu PASS points=" << lookup_output.results.size()
                                          << " max_abs=" << stats.max_abs_error;
                            } else {
                                LOG(WARNING) << "[fpga lookup] compare_with_cpu FAIL mismatches="
                                             << stats.mismatches << " max_abs=" << stats.max_abs_error
                                             << " at=" << stats.max_name;
                            }
                        }

                        SurfelLookupStats lookup_stats;
                        for (const auto& result : lookup_output.results) {
                            SurfelCorrespondence corr = ToSurfelCorrespondence(result);
                            if (!corr.valid) {
                                corr.fallback = true;
                            }
                            AddLookupStats(corr, &lookup_stats);
                        }
                        if (fpga_lookup_golden_writer_) {
                            fpga_lookup_golden_writer_->MaybeWrite(static_cast<uint32_t>(scan_count_), lookup_input,
                                                                   lookup_output, lookup_stats);
                        }

                        std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                            PointType &point_body = scan_down_body_->points[i];
                            auto &points_near = nearest_points_[i];
                            surfel_corr_[i] = ToSurfelCorrespondence(lookup_output.results[i]);
                            if (surfel_corr_[i].valid) {
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
                                surfel_map_->EnqueueFallback(scan_down_world_->points[i]);
                            }
                        });
                    } else {
                        LOG(ERROR) << "[fpga lookup] backend " << surfel_lookup_backend_->Name()
                                   << " failed, falling back to direct CPU LookupSurfel";
                    }
                }

                if (!used_lookup_backend) {
                    std::for_each(std::execution::par_unseq, index.begin(), index.end(), [&](const size_t &i) {
                        PointType &point_body = scan_down_body_->points[i];
                        PointType &point_world = scan_down_world_->points[i];
                        auto &points_near = nearest_points_[i];

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
            }

            if (ivox_fallback_enabled) {
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
                  << " fallback=" << surfel_fallback_num_ << "/" << cnt_pts
                  << (ivox_fallback_disabled ? " ivox_fallback=disabled" : "");
        if (fallback_ratio > options_.surfel_fallback_warn_ratio_) {
            LOG(WARNING) << "Surfel fallback ratio is high: " << fallback_ratio << " fallback "
                         << surfel_fallback_num_ << "/" << cnt_pts;
        }
    }

    effect_feat_surf_ = 0;
    effect_feat_icp_ = 0;

    corr_pts_.resize(cnt_pts);
    corr_norm_.resize(cnt_pts);
    const bool use_normal_equation_backend =
        (options_.normal_equation_backend_ == "CPU_SIM" || options_.normal_equation_backend_ == "FPGA") &&
        normal_equation_backend_;
    const bool use_fpga_backend = options_.normal_equation_backend_ == "FPGA" && normal_equation_backend_;
    std::vector<fpga::FpgaCorrInput> fpga_corrs;
    std::vector<size_t> fallback_effect_indices;
    if (use_normal_equation_backend) {
        fpga_corrs.reserve(cnt_pts);
        fallback_effect_indices.reserve(cnt_pts);
    }

    const Mat3f off_R = offset_R_lidar_fixed_.cast<float>();
    const Vec3f off_t = offset_t_lidar_fixed_.cast<float>();
    const Mat3f R_wi = s.rot_.matrix().cast<float>();
    const Vec3f t_wi = s.pos_.cast<float>();
    const Mat3f Rt = R_wi.transpose();

    for (int i = 0; i < cnt_pts; i++) {
        if (point_selected_surf_[i]) {
            const size_t effect_idx = static_cast<size_t>(effect_feat_surf_);
            corr_norm_[effect_feat_surf_] = plane_coef_[i];
            corr_pts_[effect_feat_surf_] = scan_down_body_->points[i].getVector4fMap();
            corr_pts_[effect_feat_surf_][3] = residuals_[i];

            if (use_normal_equation_backend && surfel_corr_[i].valid && !surfel_corr_[i].fallback) {
                const Vec3f p_lidar = scan_down_body_->points[i].getVector3fMap();
                const Vec3f p_imu = off_R * p_lidar + off_t;
                const Vec4f& plane = plane_coef_[i];

                fpga::FpgaCorrInput corr;
                corr.px = p_imu.x();
                corr.py = p_imu.y();
                corr.pz = p_imu.z();
                corr.nx = plane.x();
                corr.ny = plane.y();
                corr.nz = plane.z();
                corr.d = plane.w();
                corr.weight = 1.0f;
                fpga_corrs.emplace_back(corr);
            } else if (use_normal_equation_backend && !ivox_fallback_disabled) {
                fallback_effect_indices.emplace_back(effect_idx);
            }

            effect_feat_surf_++;
        }

        if (point_selected_icp_[i]) {
            effect_feat_icp_++;
        }
    }

    corr_pts_.resize(effect_feat_surf_);
    corr_norm_.resize(effect_feat_surf_);
    PerfMonitor::SetEffectivePointStats(effect_feat_surf_, effect_feat_icp_);

    const int min_effective_surface_points =
        ivox_fallback_disabled ? options_.min_pts_when_no_ivox_fallback_ : 20;
    if (effect_feat_surf_ < min_effective_surface_points) {
        obs.valid_ = false;
        if (ivox_fallback_disabled) {
            LOG(WARNING) << "No enough effective surface points with ivox fallback disabled: " << effect_feat_surf_
                         << ", icp: " << effect_feat_icp_ << ", required: " << min_effective_surface_points;
        } else {
            LOG(WARNING) << "No enough effective surface points: " << effect_feat_surf_ << ", icp: "
                         << effect_feat_icp_ << ", required: " << min_effective_surface_points;
        }
        return;
    }

    index.resize(effect_feat_surf_);

    /// 点面ICP部分
    obs.HTH_.setZero();
    obs.HTr_.setZero();

    std::vector<double> res_sq(index.size());
    for (size_t i = 0; i < index.size(); ++i) {
        const double res = -corr_pts_[i][3];
        res_sq[i] = res * res;
    }

    auto accumulate_cpu_indices = [&](const std::vector<size_t>& cpu_indices, const std::string& perf_name,
                                      const std::string& backend_name) {
        if (cpu_indices.empty()) {
            return;
        }

        std::vector<Mat6d> JTJ(effect_feat_surf_);
        std::vector<Vec6d> JTr(effect_feat_surf_);

        ScopedPerfStage perf(perf_name, effect_feat_surf_, static_cast<int>(cpu_indices.size()), backend_name);
        {
            ScopedPerfStage sub_perf("Plane ICP Residual/Jacobian");
            std::for_each(std::execution::par_unseq, cpu_indices.begin(), cpu_indices.end(), [&](const size_t &i) {
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
            });
        }

        {
            ScopedPerfStage sub_perf("Plane ICP HTH/HTr Accumulate");
            for (const size_t i : cpu_indices) {
                obs.HTH_ += JTJ[i] * options_.plane_icp_weight_;
                obs.HTr_ += JTr[i] * options_.plane_icp_weight_;
            }
        }
    };

    if (use_normal_equation_backend) {
        const std::string backend_name = normal_equation_backend_->Name();
        ScopedPerfStage perf("Plane ICP HTH/HTr " + backend_name, effect_feat_surf_, static_cast<int>(fpga_corrs.size()),
                             backend_name);

        fpga::NormalEquationState ne_state;
        ne_state.R_wi = R_wi;
        ne_state.t_wi = t_wi;

        fpga::NormalEquationResult ne_result;
        bool use_backend_result = normal_equation_backend_->Accumulate(fpga_corrs, ne_state, &ne_result);
        fpga::NormalEquationResult cpu_compare_result;
        if (use_backend_result && use_fpga_backend && options_.fpga_compare_with_cpu_) {
            fpga::CpuNormalEquationBackend cpu_backend;
            const bool cpu_ok = cpu_backend.Accumulate(fpga_corrs, ne_state, &cpu_compare_result);
            if (cpu_ok) {
                const NormalEquationCompareStats stats = CompareNormalEquationResults(ne_result, cpu_compare_result);
                const bool compare_pass =
                    IsComparePass(stats, options_.fpga_compare_abs_tol_, options_.fpga_compare_rel_tol_);
                LOG(INFO) << "[fpga] compare_with_cpu " << (compare_pass ? "PASS" : "FAIL")
                          << " max_abs_error=" << stats.max_abs_error
                          << " max_rel_error=" << stats.max_rel_error
                          << " at " << stats.max_name
                          << " valid_count=" << ne_result.valid_count;
                if (!compare_pass) {
                    if (options_.fpga_fallback_to_cpu_on_error_) {
                        ne_result = cpu_compare_result;
                        LOG(WARNING) << "[fpga] compare failed; using CPU_SIM normal equation for surfel-hit points.";
                    } else {
                        obs.valid_ = false;
                        LOG(ERROR) << "[fpga] compare failed and fallback_to_cpu_on_error=false; reject observation.";
                        return;
                    }
                }
            } else {
                LOG(WARNING) << "[fpga] CPU compare backend failed; comparison skipped.";
            }
        }

        if (use_backend_result) {
            obs.HTH_ += ne_result.H.cast<double>() * options_.plane_icp_weight_;
            obs.HTr_ += ne_result.b.cast<double>() * options_.plane_icp_weight_;
            if (fpga_golden_writer_) {
                fpga_golden_writer_->MaybeWrite(static_cast<uint32_t>(scan_count_), ne_state, fpga_corrs, ne_result);
            }
        } else {
            LOG(WARNING) << "Normal equation backend " << normal_equation_backend_->Name()
                         << " failed, falling back to CPU for surfel-hit points.";
            if (use_fpga_backend && !options_.fpga_fallback_to_cpu_on_error_) {
                obs.valid_ = false;
                LOG(ERROR) << "[fpga] backend failed and fallback_to_cpu_on_error=false; reject observation.";
                return;
            } else {
                accumulate_cpu_indices(index, "Plane ICP HTH/HTr FALLBACK_CPU", "FALLBACK_CPU");
                fallback_effect_indices.clear();
            }
        }

        accumulate_cpu_indices(fallback_effect_indices, "Plane ICP HTH/HTr FALLBACK_CPU", "FALLBACK_CPU");
    } else {
        accumulate_cpu_indices(index, "Plane ICP HTH/HTr CPU", "CPU");
    }

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
        std::vector<Mat6d> JTJ(cnt_pts);
        std::vector<Vec6d> JTr(cnt_pts);

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
