#include "fpga/fpga_lookup_golden_writer.h"

#include <glog/logging.h>

#include <algorithm>
#include <fstream>
#include <iomanip>
#include <sstream>
#include <vector>

namespace lightning::fpga {

FpgaLookupGoldenWriter::FpgaLookupGoldenWriter(Options options) : options_(std::move(options)) {}

bool FpgaLookupGoldenWriter::MaybeWrite(uint32_t frame_id, const LookupBatchInput& input,
                                        const LookupBatchOutput& cpu_output, const SurfelLookupStats& stats) {
    if (!ShouldWrite(frame_id)) {
        return true;
    }
    if (cpu_output.results.size() != input.points.size()) {
        LOG(ERROR) << "Invalid lookup golden output size: " << cpu_output.results.size()
                   << " expected=" << input.points.size();
        return false;
    }

    std::error_code ec;
    std::filesystem::create_directories(options_.dump_dir, ec);
    if (ec) {
        LOG(ERROR) << "Failed to create FPGA lookup golden directory: " << options_.dump_dir << ", "
                   << ec.message();
        return false;
    }

    LookupGoldenHeader header;
    header.frame_id = frame_id;
    header.num_points = static_cast<uint32_t>(input.points.size());
    header.num_blocks = static_cast<uint32_t>(input.blocks.size());
    header.cell_resolution = input.params.cell_resolution;
    header.inv_cell_resolution = input.params.inv_cell_resolution;
    header.min_support = input.params.min_support;
    header.lookup_nearby_type = input.params.lookup_nearby_type;
    header.hit_exact = static_cast<uint32_t>(stats.hit_exact);
    header.hit_neighbor = static_cast<uint32_t>(stats.hit_neighbor);
    header.hit_count = header.hit_exact + header.hit_neighbor;
    header.fallback_count = static_cast<uint32_t>(input.points.size()) - header.hit_count;
    header.miss_no_block = static_cast<uint32_t>(stats.miss_no_block);
    header.miss_empty_cell = static_cast<uint32_t>(stats.miss_empty_cell);
    header.miss_support_low = static_cast<uint32_t>(stats.miss_support_low);
    header.miss_quality_bad = static_cast<uint32_t>(stats.miss_quality_bad);

    const auto path = MakePath(frame_id);
    std::ofstream os(path, std::ios::binary);
    if (!os) {
        LOG(ERROR) << "Failed to open FPGA lookup golden file: " << path;
        return false;
    }

    os.write(reinterpret_cast<const char*>(&header), sizeof(header));
    if (!input.points.empty()) {
        os.write(reinterpret_cast<const char*>(input.points.data()),
                 static_cast<std::streamsize>(input.points.size() * sizeof(FpgaLookupPointInput)));
    }
    if (!input.blocks.empty()) {
        os.write(reinterpret_cast<const char*>(input.blocks.data()),
                 static_cast<std::streamsize>(input.blocks.size() * sizeof(FpgaLookupBlock)));
    }
    if (!cpu_output.results.empty()) {
        os.write(reinterpret_cast<const char*>(cpu_output.results.data()),
                 static_cast<std::streamsize>(cpu_output.results.size() * sizeof(FpgaLookupResult)));
    }
    if (!os) {
        LOG(ERROR) << "Failed to write FPGA lookup golden file: " << path;
        return false;
    }

    PruneOldFiles();
    LOG(INFO) << "Wrote FPGA lookup golden file: " << path << " points=" << input.points.size()
              << " blocks=" << input.blocks.size() << " hits=" << header.hit_count;
    return true;
}

bool FpgaLookupGoldenWriter::ShouldWrite(uint32_t frame_id) const {
    if (!options_.enable || options_.every_n_frames <= 0) {
        return false;
    }
    return frame_id % static_cast<uint32_t>(options_.every_n_frames) == 0;
}

void FpgaLookupGoldenWriter::PruneOldFiles() const {
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
            entry.path().filename().string().rfind("lookup_frame_", 0) == 0) {
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

std::filesystem::path FpgaLookupGoldenWriter::MakePath(uint32_t frame_id) const {
    std::ostringstream ss;
    ss << "lookup_frame_" << std::setw(6) << std::setfill('0') << frame_id << ".bin";
    return std::filesystem::path(options_.dump_dir) / ss.str();
}

}  // namespace lightning::fpga
