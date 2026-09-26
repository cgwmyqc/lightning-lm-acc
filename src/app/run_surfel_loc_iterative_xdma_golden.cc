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
#include "loc_iterative_golden_common.h"

DEFINE_string(golden_dir, "fpga/golden/localization_iterative/frame_000001",
              "Localization full iterative golden directory");
DEFINE_string(user, "/dev/xdma0_user", "XDMA user BAR device");
DEFINE_string(h2c, "/dev/xdma0_h2c_0", "XDMA H2C device");
DEFINE_string(c2h, "/dev/xdma0_c2h_0", "XDMA C2H device");
DEFINE_string(ctrl_base, "0x1000", "Control register base, decimal or hex");
DEFINE_double(timeout_sec, 120.0, "HLS timeout in seconds");
DEFINE_bool(verify_readback, false, "Read back PL DDR image after writing full image");
DEFINE_int32(repeat, 1, "Number of localization iterative transactions");
DEFINE_string(output_dir, "", "Directory for per-iteration JSON output");
DEFINE_double(abs_tol, 1e-7, "Absolute tolerance for output comparison");
DEFINE_double(rel_tol, 1e-5, "Relative tolerance for output comparison");

namespace {

uint32_t ParseU32(const std::string& text) {
    size_t pos = 0;
    const auto value = std::stoul(text, &pos, 0);
    if (pos != text.size() || value > 0xFFFFFFFFull) {
        throw std::runtime_error("invalid uint32 value: " + text);
    }
    return static_cast<uint32_t>(value);
}

void WriteU64JsonArray(std::ostream& os, const std::vector<uint64_t>& data) {
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

void WriteVec6Json(std::ostream& os, const lightning::Vec6d& data) {
    os << "[";
    for (int i = 0; i < 6; ++i) {
        if (i != 0) {
            os << ",";
        }
        os << std::setprecision(17) << data[i];
    }
    os << "]";
}

void WriteOutputJson(std::ostream& os, const lightning::loc::iter_golden::LocIterativeOutput& output) {
    const auto q = output.final_pose.unit_quaternion();
    const auto t = output.final_pose.translation();
    os << "{";
    os << "\"status\":" << output.status;
    os << ",\"flags\":" << output.flags;
    os << ",\"iterations\":" << output.iterations;
    os << ",\"valid_count\":" << output.valid_count;
    os << ",\"reject_count\":" << output.reject_count;
    os << ",\"miss_count\":" << output.miss_count;
    os << ",\"final_pose\":{";
    os << "\"tx\":" << std::setprecision(17) << t.x();
    os << ",\"ty\":" << std::setprecision(17) << t.y();
    os << ",\"tz\":" << std::setprecision(17) << t.z();
    os << ",\"qx\":" << std::setprecision(17) << q.x();
    os << ",\"qy\":" << std::setprecision(17) << q.y();
    os << ",\"qz\":" << std::setprecision(17) << q.z();
    os << ",\"qw\":" << std::setprecision(17) << q.w();
    os << "}";
    os << ",\"last_dx\":";
    WriteVec6Json(os, output.last_dx);
    os << ",\"dx_norm\":" << std::setprecision(17) << lightning::loc::iter_golden::DxNorm(output.last_dx);
    os << ",\"residual_sum\":" << std::setprecision(17) << output.residual_sum;
    os << ",\"residual_abs_sum\":" << std::setprecision(17) << output.residual_abs_sum;
    os << ",\"residual_max_abs\":" << std::setprecision(17) << output.residual_max_abs;
    os << ",\"score\":" << std::setprecision(17) << output.score;
    os << "}";
}

bool ToArray(const std::vector<uint64_t>& in, std::array<uint64_t, lightning::fpga::LOC_ITER_OUTPUT_WORDS>& out,
             std::string* error) {
    if (in.size() != out.size()) {
        if (error != nullptr) {
            *error = "loc iterative output word count mismatch";
        }
        return false;
    }
    std::copy(in.begin(), in.end(), out.begin());
    return true;
}

bool WriteResultJson(const std::string& output_dir, int iteration, const std::string& golden_dir, uint32_t ctrl_base,
                     const lightning::fpga::XdmaRuntime::LocIterativeRunResult& result,
                     const lightning::loc::iter_golden::LocIterativeOutput& actual,
                     const lightning::loc::iter_golden::LocIterativeOutput& expected,
                     const std::string& compare_report, std::string* error) {
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
    name << "loc_iter_xdma_output_iter_" << std::setw(2) << std::setfill('0') << iteration << ".json";
    const auto path = std::filesystem::path(output_dir) / name.str();
    std::ofstream os(path);
    if (!os) {
        if (error != nullptr) {
            *error = "failed to open " + path.string();
        }
        return false;
    }

    os << "{\n";
    os << "  \"label\": \"LOC_ITER_XDMA_GOLDEN\",\n";
    os << "  \"golden_dir\": \"" << golden_dir << "\",\n";
    os << "  \"iteration\": " << iteration << ",\n";
    os << "  \"ctrl_base\": " << ctrl_base << ",\n";
    os << "  \"status\": " << result.status << ",\n";
    os << "  \"error\": " << result.error << ",\n";
    os << "  \"run_count_before\": " << result.run_count_before << ",\n";
    os << "  \"run_count_after\": " << result.run_count_after << ",\n";
    os << "  \"scan_count_readback\": " << result.scan_count_readback << ",\n";
    os << "  \"fpga_cycle_count\": " << result.fpga_cycle_count << ",\n";
    os << "  \"fpga_kernel_sec\": " << std::setprecision(9) << result.fpga_kernel_sec << ",\n";
    os << "  \"polling_overhead_sec\": " << std::setprecision(9) << result.polling_overhead_sec << ",\n";
    os << "  \"elapsed_sec\": " << std::setprecision(9) << result.elapsed_sec << ",\n";
    os << "  \"hls_wait_sec\": " << std::setprecision(9) << result.timing.hls_wait_sec << ",\n";
    os << "  \"compare_report\": \"" << compare_report << "\",\n";
    os << "  \"raw_output_words\": ";
    WriteU64JsonArray(os, result.raw_output_words);
    os << ",\n";
    os << "  \"actual\": ";
    WriteOutputJson(os, actual);
    os << ",\n";
    os << "  \"expected\": ";
    WriteOutputJson(os, expected);
    os << "\n}\n";

    std::cout << "LOC_ITER_XDMA_OUTPUT_JSON=" << path.string() << "\n";
    return true;
}

}  // namespace

int main(int argc, char** argv) {
    google::InitGoogleLogging(argv[0]);
    FLAGS_colorlogtostderr = true;
    FLAGS_stderrthreshold = google::INFO;
    google::ParseCommandLineFlags(&argc, &argv, true);

    using lightning::fpga::XdmaRuntime;
    using lightning::loc::iter_golden::LocIterativeGolden;

    LocIterativeGolden golden;
    std::string error;
    if (!lightning::loc::iter_golden::ReadGolden(FLAGS_golden_dir, golden, &error)) {
        LOG(ERROR) << error;
        return 1;
    }

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
    if (FLAGS_repeat < 1) {
        LOG(ERROR) << "--repeat must be >= 1";
        return 1;
    }

    const std::vector<uint64_t> input_words(golden.input_words.begin(), golden.input_words.end());
    const auto expected = lightning::loc::iter_golden::DecodeOutput(golden.expected_words);
    XdmaRuntime runtime(options);

    std::cout << "LOC_ITER_XDMA_GOLDEN_LOAD_PASS\n";
    std::cout << "scan_count=" << golden.scan_points.size() << "\n";
    std::cout << "candidate_count=" << golden.candidate_cells.size() << "\n";
    std::cout << "expected_iterations=" << expected.iterations << "\n";
    std::cout << "expected_counts=" << expected.valid_count << "/" << expected.reject_count << "/"
              << expected.miss_count << "\n";

    for (int iter = 1; iter <= FLAGS_repeat; ++iter) {
        XdmaRuntime::LocIterativeRunResult result;
        const bool write_full_image = iter == 1;
        if (!runtime.RunLocalizationIterative(golden.scan_points, golden.candidate_cells, input_words,
                                              write_full_image, FLAGS_verify_readback && write_full_image, result,
                                              &error)) {
            LOG(ERROR) << error;
            return 2;
        }
        std::cout << "LOC_ITER_XDMA_START_PASS\n";
        std::cout << "LOC_ITER_XDMA_DONE_PASS\n";

        std::array<uint64_t, lightning::fpga::LOC_ITER_OUTPUT_WORDS> actual_words{};
        if (!ToArray(result.raw_output_words, actual_words, &error)) {
            LOG(ERROR) << error;
            return 3;
        }
        if (actual_words[lightning::fpga::LOC_ITER_OUT_MAGIC_VERSION] !=
            lightning::loc::iter_golden::Pack32(lightning::fpga::SLAM_LOC_ITER_MAGIC,
                                                lightning::fpga::SLAM_LOC_ITER_VERSION)) {
            LOG(ERROR) << "bad loc iterative output magic/version";
            return 4;
        }
        const auto actual = lightning::loc::iter_golden::DecodeOutput(actual_words);
        std::string report;
        const bool numeric_pass =
            lightning::loc::iter_golden::CompareOutputs(actual, expected, FLAGS_abs_tol, FLAGS_rel_tol, &report);
        LOG(INFO) << "[loc_iter_xdma] iter=" << iter << "/" << FLAGS_repeat << " STATUS=0x" << std::hex
                  << result.status << " ERROR=0x" << result.error << std::dec << " RUN_COUNT="
                  << result.run_count_before << "->" << result.run_count_after
                  << " hls_wait_sec=" << result.timing.hls_wait_sec
                  << " fpga_cycles=" << result.fpga_cycle_count
                  << " fpga_kernel_sec=" << result.fpga_kernel_sec
                  << " polling_overhead_sec=" << result.polling_overhead_sec << " " << report;

        if (!WriteResultJson(FLAGS_output_dir, iter, FLAGS_golden_dir, options.ctrl_base, result, actual, expected,
                             report, &error)) {
            LOG(ERROR) << error;
            return 5;
        }
        if (!numeric_pass) {
            LOG(ERROR) << "LOC_ITER_XDMA_NUMERIC_FAIL";
            return 6;
        }

        std::cout << "LOC_ITER_XDMA_NUMERIC_PASS\n";
        std::cout << "ITER=" << iter << "/" << FLAGS_repeat << " STATUS=0x" << std::hex << std::setw(8)
                  << std::setfill('0') << result.status << " ERROR=0x" << std::setw(8) << result.error << std::dec
                  << std::setfill(' ') << " RUN_COUNT=" << result.run_count_before << "->" << result.run_count_after
                  << " ELAPSED_SEC=" << std::setprecision(6) << result.elapsed_sec << "\n";
        std::cout << "SCAN_COUNT_READBACK=" << result.scan_count_readback << "\n";
        std::cout << "FPGA_CYCLES=" << result.fpga_cycle_count << "\n";
        std::cout << "FPGA_KERNEL_SEC=" << std::setprecision(9) << result.fpga_kernel_sec << "\n";
        std::cout << "POLLING_OVERHEAD_SEC=" << std::setprecision(9) << result.polling_overhead_sec << "\n";
        std::cout << "iterations=" << actual.iterations << "\n";
        std::cout << "counts=" << actual.valid_count << "/" << actual.reject_count << "/" << actual.miss_count
                  << "\n";
        std::cout << "flags=" << actual.flags << "\n";
        std::cout << "score=" << std::setprecision(9) << actual.score << "\n";
    }

    std::cout << "LOC_ITER_XDMA_PASS golden_dir=" << FLAGS_golden_dir << "\n";
    return 0;
}
