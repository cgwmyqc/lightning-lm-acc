#include "utils/perf_monitor.h"

#include <glog/logging.h>

#include <algorithm>
#include <cctype>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <numeric>
#include <sstream>
#include <utility>

namespace lightning {

std::mutex PerfMonitor::mutex_;
PerfMonitor::Config PerfMonitor::config_;
PerfMonitor::FrameState PerfMonitor::current_;
PerfSnapshot PerfMonitor::latest_;
std::map<std::string, PerfMonitor::StageStats> PerfMonitor::stage_stats_;
PerfMonitor::Clock::time_point PerfMonitor::first_input_time_;
PerfMonitor::Clock::time_point PerfMonitor::first_processed_time_;
bool PerfMonitor::have_first_input_time_ = false;
bool PerfMonitor::have_first_processed_time_ = false;
bool PerfMonitor::csv_header_written_ = false;
bool g_csv_path_logged = false;

namespace {

template <typename T>
T GetYamlValue(const YAML::Node& node, const std::string& key, const T& default_value) {
    if (node && node[key]) {
        return node[key].as<T>();
    }
    return default_value;
}

std::string NormalizeBackend(std::string backend) {
    std::transform(backend.begin(), backend.end(), backend.begin(), [](unsigned char c) {
        if (c == '-') {
            return '_';
        }
        return static_cast<char>(std::toupper(c));
    });
    return backend.empty() ? "CPU" : backend;
}

}  // namespace

void PerfMonitor::ConfigureFromYaml(const YAML::Node& yaml) {
    std::lock_guard<std::mutex> lock(mutex_);

    const YAML::Node profile = yaml["profile"];
    config_.enable = GetYamlValue(profile, "enable", config_.enable);
    config_.ui_enable = GetYamlValue(profile, "ui_enable", config_.ui_enable);
    config_.csv_enable = GetYamlValue(profile, "csv_enable", config_.csv_enable);
    config_.csv_path = GetYamlValue(profile, "csv_path", config_.csv_path);
    config_.log_every_n_frames = GetYamlValue(profile, "log_every_n_frames", config_.log_every_n_frames);

    const YAML::Node fpga = yaml["fpga"];
    config_.backend = NormalizeBackend(GetYamlValue(fpga, "mode", std::string("cpu")));
    if (fpga && fpga["enable"] && !fpga["enable"].as<bool>()) {
        config_.backend = "CPU";
    }

    latest_.backend = config_.backend;
    current_.snapshot.backend = config_.backend;

    LOG(INFO) << "[profile] config enable=" << config_.enable << " ui_enable=" << config_.ui_enable
              << " csv_enable=" << config_.csv_enable << " csv_path=" << config_.csv_path
              << " log_every_n_frames=" << config_.log_every_n_frames << " backend=" << config_.backend;
}

bool PerfMonitor::Enabled() {
    std::lock_guard<std::mutex> lock(mutex_);
    return config_.enable;
}

bool PerfMonitor::UiEnabled() {
    std::lock_guard<std::mutex> lock(mutex_);
    return config_.enable && config_.ui_enable;
}

int64_t PerfMonitor::BeginFrame(double timestamp) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!config_.enable) {
        return 0;
    }

    const auto now = Clock::now();
    if (!have_first_input_time_) {
        first_input_time_ = now;
        have_first_input_time_ = true;
    }

    current_ = FrameState();
    current_.active = true;
    current_.frame_id = latest_.frame_id + 1;
    current_.timestamp = timestamp;
    current_.start_time = now;
    current_.snapshot = PerfSnapshot();
    current_.snapshot.frame_id = current_.frame_id;
    current_.snapshot.timestamp = timestamp;
    current_.snapshot.backend = config_.backend;
    current_.snapshot.input_frames = latest_.input_frames + 1;
    current_.snapshot.processed_frames = latest_.processed_frames;
    current_.snapshot.skipped_frames = latest_.skipped_frames;
    current_.snapshot.input_fps = ElapsedFps(current_.snapshot.input_frames, first_input_time_, now);
    current_.snapshot.slam_fps = latest_.slam_fps;
    return current_.frame_id;
}

void PerfMonitor::EndFrame(bool processed) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!config_.enable || !current_.active) {
        return;
    }

    const auto now = Clock::now();
    current_.snapshot.frame_total_ms = ToMs(now - current_.start_time);
    current_.snapshot.processing_fps =
        current_.snapshot.frame_total_ms > 1e-9 ? 1000.0 / current_.snapshot.frame_total_ms : 0.0;
    if (processed) {
        if (!have_first_processed_time_) {
            first_processed_time_ = now;
            have_first_processed_time_ = true;
        }
        current_.snapshot.processed_frames += 1;
        current_.snapshot.slam_fps = ElapsedFps(current_.snapshot.processed_frames, first_processed_time_, now);
    } else {
        current_.snapshot.skipped_frames += 1;
        current_.snapshot.slam_fps = latest_.slam_fps;
    }

    UpdateDerivedMetrics(current_.snapshot);
    current_.snapshot.stage_summaries = BuildStageSummaries();
    latest_ = current_.snapshot;
    current_.active = false;

    if (config_.csv_enable) {
        AppendCsvRow(latest_);
    }

    if (config_.log_every_n_frames > 0 && latest_.frame_id % config_.log_every_n_frames == 0) {
        LOG(INFO) << FormatProfileLine(latest_);
    }
}

void PerfMonitor::SetFramePointStats(int input_points, int downsampled_points) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!config_.enable || !current_.active) {
        return;
    }
    current_.snapshot.input_points = input_points;
    current_.snapshot.downsampled_points = downsampled_points;
}

void PerfMonitor::SetEffectivePointStats(int effective_surface_points, int effective_icp_points) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!config_.enable || !current_.active) {
        return;
    }
    current_.snapshot.effective_surface_points = effective_surface_points;
    current_.snapshot.effective_icp_points = effective_icp_points;
}

void PerfMonitor::RecordStage(const std::string& name, double ms, int, int, const std::string& backend) {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!config_.enable) {
        return;
    }

    auto& stats = stage_stats_[name];
    stats.latest_ms = ms;
    stats.window_ms.emplace_back(ms);
    if (stats.window_ms.size() > 2000) {
        stats.window_ms.erase(stats.window_ms.begin());
    }

    if (!backend.empty()) {
        current_.snapshot.backend = NormalizeBackend(backend);
    }

    if (current_.active) {
        ApplyStageToSnapshot(current_.snapshot, name, ms);
    }
}

PerfSnapshot PerfMonitor::GetLatestSnapshot() {
    std::lock_guard<std::mutex> lock(mutex_);
    return latest_;
}

int64_t PerfMonitor::GetCurrentFrameId() {
    std::lock_guard<std::mutex> lock(mutex_);
    return current_.active ? current_.frame_id : latest_.frame_id;
}

uint64_t PerfMonitor::GetCurrentObsModelCalls() {
    std::lock_guard<std::mutex> lock(mutex_);
    return current_.active ? current_.snapshot.obs_model_calls : latest_.obs_model_calls;
}

void PerfMonitor::DumpCsv() {
    std::lock_guard<std::mutex> lock(mutex_);
    if (!config_.enable || !config_.csv_enable || latest_.frame_id == 0) {
        return;
    }
    EnsureCsvHeader();
}

double PerfMonitor::ToMs(Clock::duration duration) {
    return std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(duration).count();
}

void PerfMonitor::ApplyStageToSnapshot(PerfSnapshot& snapshot, const std::string& name, double ms) {
    if (name == "Preprocess") {
        snapshot.preprocess_ms = ms;
    } else if (name == "SyncPackages") {
        snapshot.sync_ms = ms;
    } else if (name == "IMU Undistort") {
        snapshot.imu_undistort_ms = ms;
    } else if (name == "Downsample") {
        snapshot.downsample_ms = ms;
    } else if (name == "ESKF Update total") {
        snapshot.eskf_update_ms = ms;
    } else if (name == "ESKF Iter Loop total") {
        snapshot.iter_loop_total_ms += ms;
    } else if (name == "ESKF ObsModel call" || name == "ObsModel total") {
        snapshot.obs_total_ms += ms;
        snapshot.obs_model_calls += 1;
    } else if (name == "ObsModel Lidar Match") {
        snapshot.lidar_match_ms += ms;
    } else if (name == "ObsModel iVox KNN Search" || name == "ObsModel iVox KNN Fallback") {
        snapshot.ivox_knn_search_ms += ms;
    } else if (name == "ObsModel Plane Fit" || name == "ObsModel Plane Fit Fallback") {
        snapshot.plane_fit_ms += ms;
    } else if (name == "ObsModel Valid Point Check") {
        snapshot.valid_point_check_ms += ms;
    } else if (name == "Plane ICP HTH/HTr CPU" || name == "Plane ICP HTH/HTr CPU_SIM" ||
               name == "Plane ICP HTH/HTr FPGA" || name == "Plane ICP HTH/HTr FALLBACK_CPU") {
        snapshot.plane_icp_ms += ms;
    } else if (name == "Plane ICP Residual/Jacobian") {
        snapshot.residual_jacobian_ms += ms;
    } else if (name == "Plane ICP HTH/HTr Accumulate") {
        snapshot.hth_htr_accumulate_ms += ms;
    } else if (name == "Point ICP CPU") {
        snapshot.point_icp_ms += ms;
    } else if (name == "Incremental Mapping") {
        snapshot.mapping_ms = ms;
    } else if (name == "ESKF Solve Matrix") {
        snapshot.solve_matrix_ms += ms;
    } else if (name == "ESKF State Update") {
        snapshot.state_update_ms += ms;
    } else if (name == "ESKF Covariance Update") {
        snapshot.covariance_update_ms += ms;
    } else if (name == "ESKF Convergence Check") {
        snapshot.convergence_check_ms += ms;
    } else if (name == "FPGA H2C") {
        snapshot.h2c_ms = ms;
    } else if (name == "FPGA Kernel") {
        snapshot.kernel_ms = ms;
    } else if (name == "FPGA C2H") {
        snapshot.c2h_ms = ms;
    } else if (name == "FPGA Compare") {
        snapshot.compare_ms = ms;
    }
}

void PerfMonitor::UpdateDerivedMetrics(PerfSnapshot& snapshot) {
    if (snapshot.obs_model_calls > 0) {
        snapshot.obs_model_avg_ms = snapshot.obs_total_ms / static_cast<double>(snapshot.obs_model_calls);
    }

    const double obs_children_ms =
        snapshot.lidar_match_ms + snapshot.plane_icp_ms + snapshot.point_icp_ms;
    snapshot.obs_model_misc_ms = std::max(0.0, snapshot.obs_total_ms - obs_children_ms);

    snapshot.eskf_misc_ms = std::max(0.0, snapshot.eskf_update_ms - snapshot.iter_loop_total_ms);
}

double PerfMonitor::ElapsedFps(uint64_t frames, Clock::time_point start_time, Clock::time_point now) {
    if (frames == 0) {
        return 0.0;
    }
    const double seconds = std::chrono::duration_cast<std::chrono::duration<double>>(now - start_time).count();
    if (seconds <= 1e-9) {
        return 0.0;
    }
    return static_cast<double>(frames) / seconds;
}

std::string PerfMonitor::FormatProfileLine(const PerfSnapshot& snapshot) {
    std::ostringstream ss;
    ss << std::fixed << std::setprecision(3) << "[profile] frame=" << snapshot.frame_id
       << " backend=" << snapshot.backend << " processed=" << snapshot.processed_frames
       << " skipped=" << snapshot.skipped_frames << " frame_total_ms=" << snapshot.frame_total_ms
       << " preprocess_ms=" << snapshot.preprocess_ms << " sync_ms=" << snapshot.sync_ms
       << " imu_undistort_ms=" << snapshot.imu_undistort_ms << " downsample_ms=" << snapshot.downsample_ms
       << " eskf_update_ms=" << snapshot.eskf_update_ms << " iter_loop_total_ms=" << snapshot.iter_loop_total_ms
       << " obs_total_ms=" << snapshot.obs_total_ms << " obs_model_calls=" << snapshot.obs_model_calls
       << " obs_model_avg_ms=" << snapshot.obs_model_avg_ms << " lidar_match_ms=" << snapshot.lidar_match_ms
       << " ivox_knn_search_ms=" << snapshot.ivox_knn_search_ms << " plane_fit_ms=" << snapshot.plane_fit_ms
       << " valid_point_check_ms=" << snapshot.valid_point_check_ms << " plane_icp_ms=" << snapshot.plane_icp_ms
       << " residual_jacobian_ms=" << snapshot.residual_jacobian_ms
       << " hth_htr_accumulate_ms=" << snapshot.hth_htr_accumulate_ms
       << " point_icp_ms=" << snapshot.point_icp_ms << " solve_matrix_ms=" << snapshot.solve_matrix_ms
       << " state_update_ms=" << snapshot.state_update_ms
       << " covariance_update_ms=" << snapshot.covariance_update_ms
       << " convergence_check_ms=" << snapshot.convergence_check_ms
       << " eskf_misc_ms=" << snapshot.eskf_misc_ms << " obs_model_misc_ms=" << snapshot.obs_model_misc_ms
       << " mapping_ms=" << snapshot.mapping_ms
       << " lidar_fps=" << snapshot.input_fps << " slam_throughput_fps=" << snapshot.slam_fps
       << " processing_fps=" << snapshot.processing_fps
       << " input_points=" << snapshot.input_points << " downsampled_points=" << snapshot.downsampled_points
       << " effective_surface_points=" << snapshot.effective_surface_points
       << " effective_icp_points=" << snapshot.effective_icp_points;
    return ss.str();
}

void PerfMonitor::AppendCsvRow(const PerfSnapshot& snapshot) {
    EnsureCsvHeader();

    std::ofstream ofs(config_.csv_path, std::ios::out | std::ios::app);
    if (!ofs.is_open()) {
        LOG(ERROR) << "Failed to open profile csv: " << config_.csv_path;
        return;
    }

    ofs << std::fixed << std::setprecision(6) << snapshot.frame_id << "," << snapshot.timestamp << ","
        << snapshot.backend << "," << snapshot.input_frames << "," << snapshot.processed_frames << ","
        << snapshot.skipped_frames << "," << snapshot.input_fps << "," << snapshot.slam_fps << ","
        << snapshot.input_points << "," << snapshot.downsampled_points << "," << snapshot.effective_surface_points
        << "," << snapshot.effective_icp_points << "," << snapshot.frame_total_ms << "," << snapshot.preprocess_ms
        << "," << snapshot.sync_ms << "," << snapshot.imu_undistort_ms << "," << snapshot.downsample_ms << ","
        << snapshot.eskf_update_ms << "," << snapshot.iter_loop_total_ms << "," << snapshot.obs_total_ms << ","
        << snapshot.obs_model_calls << "," << snapshot.obs_model_avg_ms << "," << snapshot.lidar_match_ms << ","
        << snapshot.ivox_knn_search_ms << "," << snapshot.plane_fit_ms << "," << snapshot.valid_point_check_ms
        << "," << snapshot.plane_icp_ms << "," << snapshot.residual_jacobian_ms << ","
        << snapshot.hth_htr_accumulate_ms << "," << snapshot.point_icp_ms << "," << snapshot.solve_matrix_ms
        << "," << snapshot.state_update_ms << "," << snapshot.covariance_update_ms << ","
        << snapshot.convergence_check_ms << "," << snapshot.eskf_misc_ms << "," << snapshot.obs_model_misc_ms
        << "," << snapshot.mapping_ms << "," << snapshot.h2c_ms << "," << snapshot.kernel_ms << ","
        << snapshot.c2h_ms << "," << snapshot.compare_ms << "," << snapshot.fallback_count << ","
        << snapshot.processing_fps << "\n";
}

void PerfMonitor::EnsureCsvHeader() {
    if (csv_header_written_) {
        return;
    }

    const std::filesystem::path csv_path(config_.csv_path);
    if (csv_path.has_parent_path()) {
        std::error_code ec;
        std::filesystem::create_directories(csv_path.parent_path(), ec);
        if (ec) {
            LOG(ERROR) << "Failed to create profile csv directory: " << csv_path.parent_path() << ", " << ec.message();
            return;
        }
    }

    const char* header =
        "frame_id,timestamp,backend,input_frames,processed_frames,skipped_frames,input_fps,slam_fps,"
        "input_points,downsampled_points,effective_surface_points,effective_icp_points,frame_total_ms,"
        "preprocess_ms,sync_ms,imu_undistort_ms,downsample_ms,eskf_update_ms,iter_loop_total_ms,"
        "obs_total_ms,obs_model_calls,obs_model_avg_ms,lidar_match_ms,ivox_knn_search_ms,plane_fit_ms,"
        "valid_point_check_ms,plane_icp_ms,residual_jacobian_ms,hth_htr_accumulate_ms,point_icp_ms,"
        "solve_matrix_ms,state_update_ms,covariance_update_ms,convergence_check_ms,eskf_misc_ms,"
        "obs_model_misc_ms,mapping_ms,h2c_ms,kernel_ms,c2h_ms,compare_ms,fallback_count,processing_fps\n";

    const bool exists = std::filesystem::exists(csv_path) && std::filesystem::file_size(csv_path) > 0;
    bool needs_header = !exists;
    if (exists) {
        std::ifstream ifs(config_.csv_path);
        std::string first_line;
        std::getline(ifs, first_line);
        needs_header = first_line.find("iter_loop_total_ms") == std::string::npos;
    }

    std::ofstream ofs(config_.csv_path, std::ios::out | std::ios::app);
    if (!ofs.is_open()) {
        LOG(ERROR) << "Failed to open profile csv: " << config_.csv_path;
        return;
    }

    if (needs_header) {
        ofs << header;
    }
    if (!g_csv_path_logged) {
        LOG(INFO) << "[profile] csv writing to " << config_.csv_path;
        g_csv_path_logged = true;
    }
    csv_header_written_ = true;
}

std::map<std::string, PerfStageSummary> PerfMonitor::BuildStageSummaries() {
    std::map<std::string, PerfStageSummary> summaries;
    for (const auto& [name, stats] : stage_stats_) {
        PerfStageSummary summary;
        summary.latest_ms = stats.latest_ms;
        summary.count = stats.window_ms.size();
        if (!stats.window_ms.empty()) {
            std::vector<double> sorted = stats.window_ms;
            std::sort(sorted.begin(), sorted.end());
            summary.mean_ms = std::accumulate(sorted.begin(), sorted.end(), 0.0) / static_cast<double>(sorted.size());
            summary.p50_ms = sorted[sorted.size() / 2];
            summary.p95_ms = sorted[std::min(sorted.size() - 1, static_cast<size_t>(sorted.size() * 0.95))];
        }
        summaries.emplace(name, summary);
    }
    return summaries;
}

ScopedPerfStage::ScopedPerfStage(std::string name, int points, int effective_points, std::string backend)
    : name_(std::move(name)),
      points_(points),
      effective_points_(effective_points),
      backend_(std::move(backend)),
      enabled_(PerfMonitor::Enabled()),
      start_(std::chrono::steady_clock::now()) {}

ScopedPerfStage::~ScopedPerfStage() {
    if (!enabled_) {
        return;
    }
    const auto end = std::chrono::steady_clock::now();
    const double ms = std::chrono::duration_cast<std::chrono::duration<double, std::milli>>(end - start_).count();
    PerfMonitor::RecordStage(name_, ms, points_, effective_points_, backend_);
}

}  // namespace lightning
