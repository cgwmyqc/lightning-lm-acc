// SPDX-License-Identifier: MIT

#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/fpga/xdma_runtime.h"
#include "core/localization/surfel_loc/surfel_loc_golden.h"

DEFINE_string(golden_dir, "fpga/golden/localization/frame_000001", "Localization golden directory");
DEFINE_string(user, "/dev/xdma0_user", "XDMA user BAR device");
DEFINE_string(h2c, "/dev/xdma0_h2c_0", "XDMA H2C device");
DEFINE_string(c2h, "/dev/xdma0_c2h_0", "XDMA C2H device");
DEFINE_string(ctrl_base, "0x1000", "Control register base, decimal or hex");
DEFINE_double(timeout_sec, 120.0, "HLS timeout in seconds");
DEFINE_bool(verify_readback, false, "Read back PL DDR image after writing full image");
DEFINE_int32(repeat, 1, "Number of full-frame golden transactions");
DEFINE_string(output_dir, "", "Directory for per-iteration JSON output");
DEFINE_bool(shim_smoke, false, "Run XDMA BAR shim smoke");
DEFINE_bool(reg_smoke, false, "Run slam_accel_ctrl register smoke");
DEFINE_bool(ddr_smoke, false, "Run PL DDR pattern smoke");
DEFINE_int32(ddr_size, 4096, "Bytes per PL DDR smoke region");
DEFINE_double(abs_tol, 1e-4, "Absolute tolerance for normal-equation comparison");
DEFINE_double(rel_tol, 1e-3, "Relative tolerance for normal-equation comparison");

namespace {

uint32_t ParseU32(const std::string& text) {
    size_t pos = 0;
    const auto value = std::stoul(text, &pos, 0);
    if (pos != text.size() || value > 0xFFFFFFFFull) {
        throw std::runtime_error("invalid uint32 value: " + text);
    }
    return static_cast<uint32_t>(value);
}

void WriteJsonArray(std::ostream& os, const double* data, size_t size) {
    os << "[";
    for (size_t i = 0; i < size; ++i) {
        if (i != 0) {
            os << ",";
        }
        os << std::setprecision(17) << data[i];
    }
    os << "]";
}

void WriteJsonArray(std::ostream& os, const std::array<uint64_t, 40>& data) {
    os << "[";
    for (size_t i = 0; i < data.size(); ++i) {
        if (i != 0) {
            os << ",";
        }
        os << "\"0x" << std::hex << std::setw(16) << std::setfill('0') << data[i] << std::dec << std::setfill(' ')
           << "\"";
    }
    os << "]";
}

void WriteEquationJson(std::ostream& os, const lightning::fpga::SlamNormalEquation& equation) {
    os << "{";
    os << "\"h_upper\":";
    WriteJsonArray(os, equation.h_upper, 21);
    os << ",\"b\":";
    WriteJsonArray(os, equation.b, 6);
    os << ",\"valid_count\":" << equation.valid_count;
    os << ",\"reject_count\":" << equation.reject_count;
    os << ",\"miss_count\":" << equation.miss_count;
    os << ",\"flags\":" << equation.flags;
    os << ",\"residual_sum\":" << std::setprecision(17) << equation.residual_sum;
    os << ",\"residual_abs_sum\":" << std::setprecision(17) << equation.residual_abs_sum;
    os << ",\"residual_max_abs\":" << std::setprecision(17) << equation.residual_max_abs;
    os << "}";
}

bool WriteResultJson(const std::string& output_dir, int iteration, const std::string& golden_dir, uint32_t ctrl_base,
                     const lightning::fpga::XdmaRuntime::RunResult& result,
                     const lightning::fpga::SlamNormalEquation& expected, std::string* error) {
    if (output_dir.empty()) {
        return true;
    }
    std::error_code ec;
    std::filesystem::create_directories(output_dir, ec);
    if (ec) {
        if (error != nullptr) {
            *error = "failed to create output_dir: " + ec.message();
        }
        return false;
    }

    std::ostringstream name;
    name << "cpp_full_frame_output_iter_" << std::setw(2) << std::setfill('0') << iteration << ".json";
    const std::filesystem::path path = std::filesystem::path(output_dir) / name.str();
    std::ofstream os(path);
    if (!os) {
        if (error != nullptr) {
            *error = "failed to open " + path.string();
        }
        return false;
    }

    os << "{\n";
    os << "  \"label\": \"CPP_XDMA_GOLDEN\",\n";
    os << "  \"golden_dir\": \"" << golden_dir << "\",\n";
    os << "  \"ctrl_base\": " << ctrl_base << ",\n";
    os << "  \"scan_count\": " << result.scan_count_readback << ",\n";
    os << "  \"status\": " << result.status << ",\n";
    os << "  \"error\": " << result.error << ",\n";
    os << "  \"run_count_before\": " << result.run_count_before << ",\n";
    os << "  \"run_count_after\": " << result.run_count_after << ",\n";
    os << "  \"elapsed_sec\": " << std::setprecision(9) << result.elapsed_sec << ",\n";
    os << "  \"raw_output_words\": ";
    WriteJsonArray(os, result.raw_output_words);
    os << ",\n";
    os << "  \"actual\": ";
    WriteEquationJson(os, result.output);
    os << ",\n";
    os << "  \"expected\": ";
    WriteEquationJson(os, expected);
    os << "\n}\n";

    std::cout << "XDMA_CPP_OUTPUT_JSON=" << path.string() << "\n";
    return true;
}

std::string Counts(const lightning::loc::LocNormalEquation& equation) {
    std::ostringstream ss;
    ss << equation.valid_count << "/" << equation.reject_count << "/" << equation.miss_count;
    return ss.str();
}

}  // namespace

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    using lightning::fpga::XdmaRuntime;
    using lightning::loc::golden::LocalizationGolden;

    XdmaRuntime::Options options;
    options.user_dev = FLAGS_user;
    options.h2c_dev = FLAGS_h2c;
    options.c2h_dev = FLAGS_c2h;
    options.timeout_sec = FLAGS_timeout_sec;
    try {
        options.ctrl_base = ParseU32(FLAGS_ctrl_base);
    } catch (const std::exception& e) {
        LOG(ERROR) << e.what();
        return 1;
    }

    XdmaRuntime runtime(options);
    std::string error;

    if (FLAGS_shim_smoke) {
        if (!runtime.ShimSmoke(&error)) {
            LOG(ERROR) << error;
            return 2;
        }
        std::cout << "XDMA_CPP_SHIM_SMOKE_PASS\n";
    }
    if (FLAGS_reg_smoke) {
        if (!runtime.RegSmoke(1, &error)) {
            LOG(ERROR) << error;
            return 3;
        }
        std::cout << "XDMA_CPP_REG_SMOKE_PASS\n";
        std::cout << "CTRL_BASE=0x" << std::hex << std::setw(8) << std::setfill('0') << options.ctrl_base << std::dec
                  << std::setfill(' ') << "\n";
    }
    if (FLAGS_ddr_smoke) {
        if (!runtime.DdrSmoke(static_cast<size_t>(FLAGS_ddr_size), &error)) {
            LOG(ERROR) << error;
            return 4;
        }
        std::cout << "XDMA_CPP_DDR_SMOKE_PASS\n";
    }

    const bool smoke_requested = FLAGS_shim_smoke || FLAGS_reg_smoke || FLAGS_ddr_smoke;
    const bool replay_requested = !smoke_requested || !FLAGS_output_dir.empty();
    if (!replay_requested) {
        return 0;
    }
    if (FLAGS_repeat < 1) {
        LOG(ERROR) << "--repeat must be >= 1";
        return 1;
    }

    LocalizationGolden frame;
    if (!lightning::loc::golden::ReadLocalizationGolden(FLAGS_golden_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 5;
    }
    const auto scan_points = lightning::fpga::ToAbiScanPoints(frame.scan_body);
    const auto pose = lightning::loc::golden::ToAbiPose(frame.pose_guess);
    const auto expected_abi = lightning::loc::golden::ToAbiNormalEquation(frame.expected_obs);

    std::cout << "XDMA_CPP_GOLDEN_LOAD_PASS\n";
    std::cout << "scan_count=" << scan_points.size() << "\n";
    std::cout << "active_blocks=" << frame.active_map.blocks.size() << "\n";
    std::cout << "active_cells=" << frame.active_map.cells.size() << "\n";
    std::cout << "expected_counts=" << Counts(frame.expected_obs) << "\n";

    double max_elapsed = 0.0;
    for (int iter = 1; iter <= FLAGS_repeat; ++iter) {
        XdmaRuntime::RunResult result;
        const bool write_full_image = iter == 1;
        if (!runtime.RunLocalizationObservation(scan_points, pose, frame.active_map, write_full_image,
                                                FLAGS_verify_readback && write_full_image, result, &error)) {
            LOG(ERROR) << error;
            return 6;
        }
        max_elapsed = std::max(max_elapsed, result.elapsed_sec);

        const auto actual = lightning::loc::golden::FromAbiNormalEquation(result.output);
        std::string report;
        if (!lightning::loc::golden::CompareNormalEquation(actual, frame.expected_obs, FLAGS_abs_tol, FLAGS_rel_tol,
                                                           &report)) {
            LOG(ERROR) << report;
            if (!WriteResultJson(FLAGS_output_dir, iter, FLAGS_golden_dir, options.ctrl_base, result, expected_abi,
                                 &error)) {
                LOG(ERROR) << error;
            }
            return 7;
        }
        if (!WriteResultJson(FLAGS_output_dir, iter, FLAGS_golden_dir, options.ctrl_base, result, expected_abi,
                             &error)) {
            LOG(ERROR) << error;
            return 8;
        }

        std::cout << "XDMA_CPP_HLS_DONE_PASS\n";
        std::cout << "ITER=" << iter << "/" << FLAGS_repeat << " STATUS=0x" << std::hex << std::setw(8)
                  << std::setfill('0') << result.status << " ERROR=0x" << std::setw(8) << result.error << std::dec
                  << std::setfill(' ') << " RUN_COUNT=" << result.run_count_before << "->" << result.run_count_after
                  << " ELAPSED_SEC=" << std::setprecision(6) << result.elapsed_sec << "\n";
        std::cout << "SCAN_COUNT_READBACK=" << result.scan_count_readback << "\n";
        std::cout << "COUNTS=" << Counts(actual) << "\n";
        std::cout << "OUTPUT_WORD[27]=0x" << std::hex << std::setw(16) << std::setfill('0')
                  << result.raw_output_words[27] << "\n";
        std::cout << "OUTPUT_WORD[28]=0x" << std::setw(16) << result.raw_output_words[28] << std::dec
                  << std::setfill(' ') << "\n";
        std::cout << "XDMA_CPP_COMPARE " << report << "\n";
        std::cout << "XDMA_CPP_GOLDEN_NUMERIC_PASS\n";
    }

    if (FLAGS_repeat > 1) {
        std::cout << "XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=" << FLAGS_repeat
                  << " MAX_ELAPSED_SEC=" << std::setprecision(6) << max_elapsed << "\n";
    }
    return 0;
}
