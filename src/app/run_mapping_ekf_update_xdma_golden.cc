// SPDX-License-Identifier: MIT

#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include <gflags/gflags.h>
#include <glog/logging.h>

#include "core/fpga/xdma_runtime.h"
#include "core/lio/mapping_eskf_update.h"

DEFINE_string(golden_dir, "fpga/golden/mapping_update/frame_000001", "Mapping ESKF update golden directory");
DEFINE_string(user, "/dev/xdma0_user", "XDMA user BAR device");
DEFINE_string(h2c, "/dev/xdma0_h2c_0", "XDMA H2C device");
DEFINE_string(c2h, "/dev/xdma0_c2h_0", "XDMA C2H device");
DEFINE_string(ctrl_base, "0x1000", "Control register base, decimal or hex");
DEFINE_double(timeout_sec, 120.0, "EKF update HLS timeout in seconds");
DEFINE_bool(verify_readback, false, "Read back EKF input DDR image after writing");
DEFINE_string(output_dir, "", "Directory for EKF update XDMA JSON output");
DEFINE_int32(repeat, 1, "Number of EKF update transactions");
DEFINE_double(dx_abs_tol, 1e-9, "Absolute tolerance for dx");
DEFINE_double(cov_abs_tol, 1e-8, "Absolute tolerance for covariance");
DEFINE_double(state_abs_tol, 1e-9, "Absolute tolerance for state");

namespace {

uint32_t ParseU32(const std::string& text) {
    size_t pos = 0;
    const auto value = std::stoul(text, &pos, 0);
    if (pos != text.size() || value > 0xFFFFFFFFull) {
        throw std::runtime_error("invalid uint32 value: " + text);
    }
    return static_cast<uint32_t>(value);
}

void WriteJsonArray(std::ostream& os, const std::vector<uint64_t>& data) {
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

template <typename Derived>
void WriteEigenVectorJson(std::ostream& os, const Eigen::MatrixBase<Derived>& v) {
    os << "[";
    for (int i = 0; i < v.size(); ++i) {
        if (i != 0) {
            os << ",";
        }
        os << std::setprecision(17) << v(i);
    }
    os << "]";
}

template <typename Derived>
void WriteEigenMatrixJson(std::ostream& os, const Eigen::MatrixBase<Derived>& m) {
    os << "[";
    for (int r = 0; r < m.rows(); ++r) {
        if (r != 0) {
            os << ",";
        }
        os << "[";
        for (int c = 0; c < m.cols(); ++c) {
            if (c != 0) {
                os << ",";
            }
            os << std::setprecision(17) << m(r, c);
        }
        os << "]";
    }
    os << "]";
}

void WriteUpdateOutputJson(std::ostream& os, const lightning::mapping_update::UpdateOutput& output) {
    os << "{";
    os << "\"success\":" << (output.success ? "true" : "false");
    os << ",\"rejected\":" << (output.rejected ? "true" : "false");
    os << ",\"converged\":" << (output.converged ? "true" : "false");
    os << ",\"covariance_finalized\":" << (output.covariance_finalized ? "true" : "false");
    os << ",\"nullity\":" << output.nullity;
    os << ",\"status\":\"" << output.status << "\"";
    os << ",\"dx_current\":";
    WriteEigenVectorJson(os, output.dx_current);
    os << ",\"updated_cov\":";
    WriteEigenMatrixJson(os, output.updated_cov);
    os << ",\"dx_translation\":" << std::setprecision(17) << output.dx_translation;
    os << ",\"dx_rotation_deg\":" << std::setprecision(17) << output.dx_rotation_deg;
    os << ",\"dx_norm\":" << std::setprecision(17) << output.dx_norm;
    os << "}";
}

bool WriteResultJson(const std::string& output_dir, const std::string& golden_dir, uint32_t ctrl_base,
                     int iteration,
                     const lightning::fpga::XdmaRuntime::EkfUpdateRunResult& result,
                     const lightning::mapping_update::UpdateOutput& expected, const std::string& compare_report,
                     std::string* error) {
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

    std::ostringstream filename;
    filename << "ekf_update_xdma_output_iter_" << std::setw(2) << std::setfill('0') << iteration << ".json";
    const auto path = std::filesystem::path(output_dir) / filename.str();
    std::ofstream os(path);
    if (!os) {
        if (error != nullptr) {
            *error = "failed to open " + path.string();
        }
        return false;
    }

    os << "{\n";
    os << "  \"label\": \"MAPPING_EKF_UPDATE_XDMA_GOLDEN\",\n";
    os << "  \"golden_dir\": \"" << golden_dir << "\",\n";
    os << "  \"iteration\": " << iteration << ",\n";
    os << "  \"ctrl_base\": " << ctrl_base << ",\n";
    os << "  \"status\": " << result.status << ",\n";
    os << "  \"error\": " << result.error << ",\n";
    os << "  \"run_count_before\": " << result.run_count_before << ",\n";
    os << "  \"run_count_after\": " << result.run_count_after << ",\n";
    os << "  \"elapsed_sec\": " << std::setprecision(9) << result.elapsed_sec << ",\n";
    os << "  \"hls_wait_sec\": " << std::setprecision(9) << result.timing.hls_wait_sec << ",\n";
    os << "  \"compare_report\": \"" << compare_report << "\",\n";
    os << "  \"raw_output_words\": ";
    WriteJsonArray(os, result.raw_output_words);
    os << ",\n";
    os << "  \"actual\": ";
    WriteUpdateOutputJson(os, result.output);
    os << ",\n";
    os << "  \"expected\": ";
    WriteUpdateOutputJson(os, expected);
    os << "\n}\n";

    std::cout << "MAPPING_EKF_UPDATE_XDMA_OUTPUT_JSON=" << path.string() << "\n";
    return true;
}

}  // namespace

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    lightning::mapping_update::GoldenFrame frame;
    std::string error;
    if (!lightning::mapping_update::ReadGoldenFrame(FLAGS_golden_dir, frame, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

    lightning::fpga::XdmaRuntime::Options options;
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

    lightning::fpga::XdmaRuntime runtime(options);

    if (FLAGS_repeat <= 0) {
        LOG(ERROR) << "--repeat must be positive";
        return 1;
    }

    for (int iter = 0; iter < FLAGS_repeat; ++iter) {
        lightning::fpga::XdmaRuntime::EkfUpdateRunResult result;
        if (!runtime.RunMappingEkfUpdate(frame.input, true, FLAGS_verify_readback, result, &error)) {
            LOG(ERROR) << error;
            return 2;
        }

        std::cout << "MAPPING_EKF_UPDATE_XDMA_START_PASS\n";
        std::cout << "MAPPING_EKF_UPDATE_XDMA_DONE_PASS\n";

        std::string report;
        const bool pass = lightning::mapping_update::CompareUpdateOutput(
            result.output, frame.expected, FLAGS_dx_abs_tol, FLAGS_cov_abs_tol, FLAGS_state_abs_tol, &report);
        LOG(INFO) << "[mapping_ekf_update_xdma] iter=" << (iter + 1) << "/" << FLAGS_repeat
                  << " STATUS=0x" << std::hex << result.status << " ERROR=0x" << result.error << std::dec
                  << " RUN_COUNT=" << result.run_count_before << "->" << result.run_count_after
                  << " hls_wait_sec=" << result.timing.hls_wait_sec << " " << report;

        if (!WriteResultJson(FLAGS_output_dir, FLAGS_golden_dir, options.ctrl_base, iter, result, frame.expected,
                             report, &error)) {
            LOG(ERROR) << error;
            return 3;
        }

        if (!pass) {
            LOG(ERROR) << "MAPPING_EKF_UPDATE_XDMA_NUMERIC_FAIL";
            return 4;
        }
        std::cout << "MAPPING_EKF_UPDATE_XDMA_NUMERIC_PASS\n";
        std::cout << "MAPPING_EKF_UPDATE_REPEAT_ITER_PASS " << (iter + 1) << "/" << FLAGS_repeat << "\n";
    }
    std::cout << "MAPPING_EKF_UPDATE_XDMA_PASS golden_dir=" << FLAGS_golden_dir << "\n";
    if (FLAGS_repeat > 1) {
        std::cout << "MAPPING_EKF_UPDATE_REPEAT_PASS repeat=" << FLAGS_repeat << "\n";
    }
    return 0;
}
