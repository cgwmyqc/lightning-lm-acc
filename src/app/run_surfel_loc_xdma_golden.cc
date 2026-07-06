// SPDX-License-Identifier: MIT

#include <filesystem>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <algorithm>
#include <array>
#include <cmath>
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
DEFINE_bool(abi_v2_candidates, false, "Use ABI V2 per-point precomputed candidate cells");
DEFINE_bool(fpga_solve6x6, false, "Request FPGA-side localization 6x6 solve after observation");

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

template <size_t N>
void WriteJsonArray(std::ostream& os, const std::array<uint64_t, N>& data) {
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

void WriteSolveJson(std::ostream& os, const lightning::fpga::SlamSolve6x6Result& solve) {
    os << "{";
    os << "\"magic\":" << solve.magic;
    os << ",\"version\":" << solve.version;
    os << ",\"status\":" << solve.status;
    os << ",\"flags\":" << solve.flags;
    os << ",\"dx\":";
    WriteJsonArray(os, solve.dx, 6);
    os << ",\"damping\":" << std::setprecision(17) << solve.damping;
    os << ",\"min_pivot\":" << std::setprecision(17) << solve.min_pivot;
    os << ",\"max_diag\":" << std::setprecision(17) << solve.max_diag;
    os << ",\"residual_norm\":" << std::setprecision(17) << solve.residual_norm;
    os << "}";
}

bool ReferenceSolve6x6(const lightning::fpga::SlamNormalEquation& equation, double dx[6], std::string* error) {
    constexpr double kDamping = 1.0e-6;
    double a[6][6] = {};
    double l[6][6] = {};
    double d[6] = {};
    double rhs[6] = {};
    int idx = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            a[r][c] = equation.h_upper[idx];
            a[c][r] = equation.h_upper[idx];
            ++idx;
        }
        a[r][r] += kDamping;
        rhs[r] = -equation.b[r];
        dx[r] = 0.0;
    }
    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < i; ++j) {
            double sum = a[i][j];
            for (int k = 0; k < j; ++k) {
                sum -= l[i][k] * d[k] * l[j][k];
            }
            if (std::fabs(d[j]) <= 1e-12) {
                if (error != nullptr) *error = "reference solve zero pivot";
                return false;
            }
            l[i][j] = sum / d[j];
        }
        double diag = a[i][i];
        for (int k = 0; k < i; ++k) {
            diag -= l[i][k] * l[i][k] * d[k];
        }
        if (!std::isfinite(diag) || diag <= 1e-12) {
            if (error != nullptr) *error = "reference solve non-positive pivot";
            return false;
        }
        d[i] = diag;
        l[i][i] = 1.0;
    }
    double y[6] = {};
    double z[6] = {};
    for (int i = 0; i < 6; ++i) {
        double sum = rhs[i];
        for (int k = 0; k < i; ++k) {
            sum -= l[i][k] * y[k];
        }
        y[i] = sum;
        z[i] = y[i] / d[i];
    }
    for (int i = 5; i >= 0; --i) {
        double sum = z[i];
        for (int k = i + 1; k < 6; ++k) {
            sum -= l[k][i] * dx[k];
        }
        dx[i] = sum;
    }
    return true;
}

bool CompareSolve6x6(const lightning::fpga::SlamSolve6x6Result& actual,
                     const lightning::fpga::SlamNormalEquation& equation, std::string* report) {
    double expected_dx[6] = {};
    std::string error;
    if (!ReferenceSolve6x6(equation, expected_dx, &error)) {
        if (report != nullptr) *report = error;
        return false;
    }
    double max_abs = 0.0;
    double max_rel = 0.0;
    for (int i = 0; i < 6; ++i) {
        const double abs_err = std::fabs(actual.dx[i] - expected_dx[i]);
        const double rel_err = abs_err / std::max(1.0, std::fabs(expected_dx[i]));
        max_abs = std::max(max_abs, abs_err);
        max_rel = std::max(max_rel, rel_err);
    }
    const bool pass = actual.magic == lightning::fpga::SLAM_ACCEL_SOLVE6X6_MAGIC &&
                      actual.version == lightning::fpga::SLAM_ACCEL_SOLVE6X6_VERSION &&
                      actual.status == lightning::fpga::SLAM_SOLVE6X6_SUCCESS &&
                      (max_abs <= 1e-7 || max_rel <= 1e-5);
    if (report != nullptr) {
        std::ostringstream ss;
        ss << "status=" << actual.status << " max_abs=" << max_abs << " max_rel=" << max_rel
           << " dx0=" << actual.dx[0] << " expected_dx0=" << expected_dx[0];
        *report = ss.str();
    }
    return pass;
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
    os << "  \"candidate_count\": " << result.candidate_count << ",\n";
    os << "  \"candidate_valid_count\": " << result.candidate_valid_count << ",\n";
    os << "  \"candidate_miss_count\": " << result.candidate_miss_count << ",\n";
    os << "  \"candidate_bytes\": " << result.candidate_bytes << ",\n";
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
    os << "  \"solve6x6\": ";
    WriteSolveJson(os, result.solve);
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
    std::cout << "abi_v2_candidates=" << (FLAGS_abi_v2_candidates ? 1 : 0) << "\n";
    std::cout << "fpga_solve6x6=" << (FLAGS_fpga_solve6x6 ? 1 : 0) << "\n";
    std::cout << "scan_count=" << scan_points.size() << "\n";
    std::cout << "active_blocks=" << frame.active_map.blocks.size() << "\n";
    std::cout << "active_cells=" << frame.active_map.cells.size() << "\n";
    std::cout << "expected_counts=" << Counts(frame.expected_obs) << "\n";

    double max_elapsed = 0.0;
    for (int iter = 1; iter <= FLAGS_repeat; ++iter) {
        XdmaRuntime::RunResult result;
        const bool write_full_image = iter == 1;
        bool run_ok = false;
        if (FLAGS_fpga_solve6x6) {
            if (!FLAGS_abi_v2_candidates) {
                LOG(ERROR) << "--fpga_solve6x6 currently requires --abi_v2_candidates";
                return 1;
            }
            run_ok = runtime.RunLocalizationObservationV2Solve6x6(scan_points, pose, frame.active_map,
                                                                  write_full_image,
                                                                  FLAGS_verify_readback && write_full_image,
                                                                  result, &error);
        } else if (FLAGS_abi_v2_candidates) {
            run_ok = runtime.RunLocalizationObservationV2(scan_points, pose, frame.active_map, write_full_image,
                                                          FLAGS_verify_readback && write_full_image, result, &error);
        } else {
            run_ok = runtime.RunLocalizationObservation(scan_points, pose, frame.active_map, write_full_image,
                                                       FLAGS_verify_readback && write_full_image, result, &error);
        }
        if (!run_ok) {
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
        if (FLAGS_fpga_solve6x6) {
            std::string solve_report;
            if (!CompareSolve6x6(result.solve, result.output, &solve_report)) {
                LOG(ERROR) << "solve6x6 mismatch: " << solve_report;
                return 9;
            }
            std::cout << "LOC_XDMA_SOLVE6X6_PASS " << solve_report << "\n";
            std::cout << "FPGA_SOLVE6X6_STATUS=" << result.solve.status << "\n";
            std::cout << "FPGA_SOLVE6X6_DX=";
            for (int i = 0; i < 6; ++i) {
                if (i != 0) {
                    std::cout << ",";
                }
                std::cout << std::setprecision(17) << result.solve.dx[i];
            }
            std::cout << "\n";
        }

        std::cout << "XDMA_CPP_HLS_DONE_PASS\n";
        std::cout << "ITER=" << iter << "/" << FLAGS_repeat << " STATUS=0x" << std::hex << std::setw(8)
                  << std::setfill('0') << result.status << " ERROR=0x" << std::setw(8) << result.error << std::dec
                  << std::setfill(' ') << " RUN_COUNT=" << result.run_count_before << "->" << result.run_count_after
                  << " ELAPSED_SEC=" << std::setprecision(6) << result.elapsed_sec << "\n";
        std::cout << "SCAN_COUNT_READBACK=" << result.scan_count_readback << "\n";
        std::cout << "ABI_V2_CANDIDATES=" << (FLAGS_abi_v2_candidates ? 1 : 0) << "\n";
        std::cout << "CANDIDATE_COUNT=" << result.candidate_count << "\n";
        std::cout << "CANDIDATE_VALID=" << result.candidate_valid_count << "\n";
        std::cout << "CANDIDATE_MISS=" << result.candidate_miss_count << "\n";
        std::cout << "CANDIDATE_BYTES=" << result.candidate_bytes << "\n";
        std::cout << "H2C_CANDIDATE_SEC=" << std::setprecision(6) << result.timing.h2c_candidate_sec << "\n";
        std::cout << "HLS_WAIT_SEC=" << std::setprecision(6) << result.timing.hls_wait_sec << "\n";
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
                  << " ABI_V2_CANDIDATES=" << (FLAGS_abi_v2_candidates ? 1 : 0)
                  << " MAX_ELAPSED_SEC=" << std::setprecision(6) << max_elapsed << "\n";
    }
    return 0;
}
