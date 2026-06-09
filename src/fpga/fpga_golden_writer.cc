#include "fpga/fpga_golden_writer.h"

#include <glog/logging.h>

#include <algorithm>
#include <fstream>
#include <iomanip>
#include <sstream>

namespace lightning::fpga {

FpgaGoldenWriter::FpgaGoldenWriter(Options options) : options_(std::move(options)) {}

bool FpgaGoldenWriter::MaybeWrite(uint32_t frame_id, const NormalEquationState& state,
                                  const std::vector<FpgaCorrInput>& corr,
                                  const NormalEquationResult& cpu_result) {
    if (!ShouldWrite(frame_id)) {
        return true;
    }

    std::error_code ec;
    std::filesystem::create_directories(options_.dump_dir, ec);
    if (ec) {
        LOG(ERROR) << "Failed to create FPGA golden directory: " << options_.dump_dir << ", " << ec.message();
        return false;
    }

    GoldenHeader header;
    header.frame_id = frame_id;
    header.num_points = static_cast<uint32_t>(corr.size());
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            header.R[r * 3 + c] = state.R_wi(r, c);
        }
        header.t[r] = state.t_wi(r);
    }
    MatrixToUpper21(cpu_result.H, header.H_upper_cpu);
    for (int i = 0; i < 6; ++i) {
        header.b_cpu[i] = cpu_result.b(i);
    }
    header.residual_sum_cpu = cpu_result.residual_sum;
    header.residual_abs_sum_cpu = cpu_result.residual_abs_sum;

    const auto path = MakePath(frame_id);
    std::ofstream os(path, std::ios::binary);
    if (!os) {
        LOG(ERROR) << "Failed to open FPGA golden file: " << path;
        return false;
    }
    os.write(reinterpret_cast<const char*>(&header), sizeof(header));
    if (!corr.empty()) {
        os.write(reinterpret_cast<const char*>(corr.data()),
                 static_cast<std::streamsize>(corr.size() * sizeof(FpgaCorrInput)));
    }
    if (!os) {
        LOG(ERROR) << "Failed to write FPGA golden file: " << path;
        return false;
    }

    PruneOldFiles();
    LOG(INFO) << "Wrote FPGA golden file: " << path << " points=" << corr.size();
    return true;
}

bool FpgaGoldenWriter::ShouldWrite(uint32_t frame_id) const {
    if (!options_.enable || options_.every_n_frames <= 0) {
        return false;
    }
    return frame_id % static_cast<uint32_t>(options_.every_n_frames) == 0;
}

void FpgaGoldenWriter::PruneOldFiles() const {
    if (options_.max_files <= 0) {
        return;
    }

    std::vector<std::filesystem::directory_entry> files;
    std::error_code ec;
    for (const auto& entry : std::filesystem::directory_iterator(options_.dump_dir, ec)) {
        if (ec) {
            return;
        }
        if (entry.is_regular_file() && entry.path().extension() == ".bin" &&
            entry.path().filename().string().rfind("frame_", 0) == 0) {
            files.emplace_back(entry);
        }
    }

    if (static_cast<int>(files.size()) <= options_.max_files) {
        return;
    }

    std::sort(files.begin(), files.end(), [](const auto& lhs, const auto& rhs) {
        return lhs.path().filename().string() < rhs.path().filename().string();
    });

    const int remove_count = static_cast<int>(files.size()) - options_.max_files;
    for (int i = 0; i < remove_count; ++i) {
        std::filesystem::remove(files[i].path(), ec);
    }
}

std::filesystem::path FpgaGoldenWriter::MakePath(uint32_t frame_id) const {
    std::ostringstream ss;
    ss << "frame_" << std::setw(6) << std::setfill('0') << frame_id << ".bin";
    return std::filesystem::path(options_.dump_dir) / ss.str();
}

}  // namespace lightning::fpga
