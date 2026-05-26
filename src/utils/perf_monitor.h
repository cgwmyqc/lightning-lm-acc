#pragma once

#include <chrono>
#include <cstdint>
#include <map>
#include <mutex>
#include <string>
#include <vector>

#include <yaml-cpp/yaml.h>

namespace lightning {

struct PerfStageSummary {
    double latest_ms = 0.0;
    double mean_ms = 0.0;
    double p50_ms = 0.0;
    double p95_ms = 0.0;
    uint64_t count = 0;
};

struct PerfSnapshot {
    int64_t frame_id = 0;
    double timestamp = 0.0;
    std::string backend = "CPU";

    uint64_t input_frames = 0;
    uint64_t processed_frames = 0;
    uint64_t skipped_frames = 0;
    double input_fps = 0.0;
    double slam_fps = 0.0;
    double processing_fps = 0.0;

    int input_points = 0;
    int downsampled_points = 0;
    int effective_surface_points = 0;
    int effective_icp_points = 0;

    double frame_total_ms = 0.0;
    double preprocess_ms = 0.0;
    double sync_ms = 0.0;
    double imu_undistort_ms = 0.0;
    double downsample_ms = 0.0;
    double eskf_update_ms = 0.0;
    double iter_loop_total_ms = 0.0;
    double obs_total_ms = 0.0;
    uint64_t obs_model_calls = 0;
    double obs_model_avg_ms = 0.0;
    double lidar_match_ms = 0.0;
    double ivox_knn_search_ms = 0.0;
    double plane_fit_ms = 0.0;
    double valid_point_check_ms = 0.0;
    double plane_icp_ms = 0.0;
    double residual_jacobian_ms = 0.0;
    double hth_htr_accumulate_ms = 0.0;
    double point_icp_ms = 0.0;
    double mapping_ms = 0.0;
    double solve_matrix_ms = 0.0;
    double state_update_ms = 0.0;
    double covariance_update_ms = 0.0;
    double convergence_check_ms = 0.0;
    double eskf_misc_ms = 0.0;
    double obs_model_misc_ms = 0.0;

    double h2c_ms = 0.0;
    double kernel_ms = 0.0;
    double c2h_ms = 0.0;
    double compare_ms = 0.0;
    uint64_t fallback_count = 0;

    std::map<std::string, PerfStageSummary> stage_summaries;
};

class PerfMonitor {
   public:
    struct Config {
        bool enable = true;
        bool ui_enable = true;
        bool csv_enable = true;
        std::string csv_path = "./data/profile/slam_perf.csv";
        int log_every_n_frames = 10;
        std::string backend = "CPU";
    };

    static void ConfigureFromYaml(const YAML::Node& yaml);
    static bool Enabled();
    static bool UiEnabled();

    static int64_t BeginFrame(double timestamp);
    static void EndFrame(bool processed);
    static void SetFramePointStats(int input_points, int downsampled_points);
    static void SetEffectivePointStats(int effective_surface_points, int effective_icp_points);
    static void RecordStage(const std::string& name, double ms, int points = 0, int effective_points = 0,
                            const std::string& backend = "");
    static PerfSnapshot GetLatestSnapshot();
    static void DumpCsv();

   private:
    using Clock = std::chrono::steady_clock;

    struct FrameState {
        bool active = false;
        int64_t frame_id = 0;
        double timestamp = 0.0;
        Clock::time_point start_time;
        PerfSnapshot snapshot;
    };

    struct StageStats {
        std::vector<double> window_ms;
        double latest_ms = 0.0;
    };

    static double ToMs(Clock::duration duration);
    static void ApplyStageToSnapshot(PerfSnapshot& snapshot, const std::string& name, double ms);
    static void UpdateDerivedMetrics(PerfSnapshot& snapshot);
    static double ElapsedFps(uint64_t frames, Clock::time_point start_time, Clock::time_point now);
    static std::string FormatProfileLine(const PerfSnapshot& snapshot);
    static void AppendCsvRow(const PerfSnapshot& snapshot);
    static void EnsureCsvHeader();
    static std::map<std::string, PerfStageSummary> BuildStageSummaries();

    static std::mutex mutex_;
    static Config config_;
    static FrameState current_;
    static PerfSnapshot latest_;
    static std::map<std::string, StageStats> stage_stats_;
    static Clock::time_point first_input_time_;
    static Clock::time_point first_processed_time_;
    static bool have_first_input_time_;
    static bool have_first_processed_time_;
    static bool csv_header_written_;
};

class ScopedPerfStage {
   public:
    explicit ScopedPerfStage(std::string name, int points = 0, int effective_points = 0, std::string backend = "");
    ~ScopedPerfStage();

    ScopedPerfStage(const ScopedPerfStage&) = delete;
    ScopedPerfStage& operator=(const ScopedPerfStage&) = delete;

   private:
    std::string name_;
    int points_ = 0;
    int effective_points_ = 0;
    std::string backend_;
    bool enabled_ = false;
    std::chrono::steady_clock::time_point start_;
};

}  // namespace lightning
