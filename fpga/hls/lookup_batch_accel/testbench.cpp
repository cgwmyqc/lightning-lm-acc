#include "lookup_batch_accel.h"

#include <algorithm>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

namespace {

constexpr float kMaxAbsError = 1.0e-4f;
constexpr float kMaxRelError = 1.0e-4f;

struct LoadedGolden {
    LookupGoldenHeader header;
    std::vector<FpgaLookupPointInput> points;
    std::vector<FpgaLookupBlock> blocks;
    std::vector<FpgaLookupResult> expected;
};

struct CompareStats {
    bool pass;
    int mismatches;
    float max_abs_error;
    float max_rel_error;
    std::string field;
    int point_index;

    CompareStats() : pass(true), mismatches(0), max_abs_error(0.0f), max_rel_error(0.0f), field("none"), point_index(-1) {}
};

uint32_t FloatToWord(float value) {
    union {
        uint32_t word;
        float value;
    } conv;
    conv.value = value;
    return conv.word;
}

float WordToFloat(uint32_t word) {
    union {
        uint32_t word;
        float value;
    } conv;
    conv.word = word;
    return conv.value;
}

bool ReadGolden(const std::string& path, LoadedGolden* golden) {
    if (golden == nullptr) {
        return false;
    }

    std::ifstream in(path.c_str(), std::ios::binary | std::ios::ate);
    if (!in) {
        std::cerr << "ERROR: failed to open " << path << "\n";
        return false;
    }

    const std::streamoff file_size = in.tellg();
    in.seekg(0, std::ios::beg);

    LookupGoldenHeader header;
    in.read(reinterpret_cast<char*>(&header), sizeof(header));
    if (!in) {
        std::cerr << "ERROR: failed to read LookupGoldenHeader from " << path << "\n";
        return false;
    }

    if (header.magic != LIGHTNING_LOOKUP_GOLDEN_MAGIC) {
        std::cerr << "ERROR: bad lookup golden magic in " << path << ", got 0x" << std::hex << header.magic
                  << std::dec << "\n";
        return false;
    }
    if (header.version != LIGHTNING_LOOKUP_INTERFACE_VERSION) {
        std::cerr << "ERROR: bad lookup golden version in " << path << ", got " << header.version << "\n";
        return false;
    }
    if (header.cells_per_block != LIGHTNING_LOOKUP_CELLS_PER_BLOCK) {
        std::cerr << "ERROR: bad cells_per_block in " << path << ", got " << header.cells_per_block << "\n";
        return false;
    }
    if (header.result_size != sizeof(FpgaLookupResult)) {
        std::cerr << "ERROR: bad result_size in " << path << ", got " << header.result_size << "\n";
        return false;
    }
    if (header.block_size != sizeof(FpgaLookupBlock)) {
        std::cerr << "ERROR: bad block_size in " << path << ", got " << header.block_size << "\n";
        return false;
    }

    const std::streamoff expected_size =
        static_cast<std::streamoff>(sizeof(LookupGoldenHeader)) +
        static_cast<std::streamoff>(header.num_points) * static_cast<std::streamoff>(sizeof(FpgaLookupPointInput)) +
        static_cast<std::streamoff>(header.num_blocks) * static_cast<std::streamoff>(sizeof(FpgaLookupBlock)) +
        static_cast<std::streamoff>(header.num_points) * static_cast<std::streamoff>(sizeof(FpgaLookupResult));
    if (file_size != expected_size) {
        std::cerr << "ERROR: bad lookup golden size in " << path << ", got " << file_size << ", expected "
                  << expected_size << "\n";
        return false;
    }

    std::vector<FpgaLookupPointInput> points(header.num_points);
    std::vector<FpgaLookupBlock> blocks(header.num_blocks);
    std::vector<FpgaLookupResult> expected(header.num_points);

    if (!points.empty()) {
        in.read(reinterpret_cast<char*>(&points[0]),
                static_cast<std::streamsize>(points.size() * sizeof(FpgaLookupPointInput)));
    }
    if (!blocks.empty()) {
        in.read(reinterpret_cast<char*>(&blocks[0]),
                static_cast<std::streamsize>(blocks.size() * sizeof(FpgaLookupBlock)));
    }
    if (!expected.empty()) {
        in.read(reinterpret_cast<char*>(&expected[0]),
                static_cast<std::streamsize>(expected.size() * sizeof(FpgaLookupResult)));
    }
    if (!in) {
        std::cerr << "ERROR: failed to read lookup golden payload from " << path << "\n";
        return false;
    }

    golden->header = header;
    golden->points.swap(points);
    golden->blocks.swap(blocks);
    golden->expected.swap(expected);
    return true;
}

void PackInput(const LoadedGolden& golden, std::vector<uint32_t>* input_words) {
    const std::size_t total_words =
        kFpgaLookupParamsWords + golden.points.size() * kFpgaLookupPointWords +
        golden.blocks.size() * kFpgaLookupBlockWords;
    input_words->assign(total_words, 0);

    (*input_words)[0] = LIGHTNING_FPGA_MAGIC;
    (*input_words)[1] = LIGHTNING_LOOKUP_INTERFACE_VERSION;
    (*input_words)[2] = golden.header.num_points;
    (*input_words)[3] = golden.header.num_blocks;
    (*input_words)[4] = FloatToWord(golden.header.cell_resolution);
    (*input_words)[5] = FloatToWord(golden.header.inv_cell_resolution);
    (*input_words)[6] = golden.header.min_support;
    (*input_words)[7] = golden.header.lookup_nearby_type;

    std::size_t offset = kFpgaLookupParamsWords;
    for (std::size_t i = 0; i < golden.points.size(); ++i) {
        const FpgaLookupPointInput& p = golden.points[i];
        (*input_words)[offset + 0] = FloatToWord(p.x);
        (*input_words)[offset + 1] = FloatToWord(p.y);
        (*input_words)[offset + 2] = FloatToWord(p.z);
        (*input_words)[offset + 3] = FloatToWord(p.intensity);
        offset += kFpgaLookupPointWords;
    }

    for (std::size_t bi = 0; bi < golden.blocks.size(); ++bi) {
        const FpgaLookupBlock& b = golden.blocks[bi];
        (*input_words)[offset + 0] = static_cast<uint32_t>(b.bx);
        (*input_words)[offset + 1] = static_cast<uint32_t>(b.by);
        (*input_words)[offset + 2] = static_cast<uint32_t>(b.bz);
        (*input_words)[offset + 3] = b.valid_cell_count;
        std::size_t cell_offset = offset + 4;
        for (int ci = 0; ci < LIGHTNING_LOOKUP_CELLS_PER_BLOCK; ++ci) {
            const FpgaLookupCell& c = b.cells[ci];
            (*input_words)[cell_offset + 0] = c.count;
            (*input_words)[cell_offset + 1] = c.flags;
            (*input_words)[cell_offset + 2] = FloatToWord(c.sum[0]);
            (*input_words)[cell_offset + 3] = FloatToWord(c.sum[1]);
            (*input_words)[cell_offset + 4] = FloatToWord(c.sum[2]);
            (*input_words)[cell_offset + 5] = FloatToWord(c.nx);
            (*input_words)[cell_offset + 6] = FloatToWord(c.ny);
            (*input_words)[cell_offset + 7] = FloatToWord(c.nz);
            (*input_words)[cell_offset + 8] = FloatToWord(c.d);
            (*input_words)[cell_offset + 9] = FloatToWord(c.quality);
            cell_offset += kFpgaLookupCellWords;
        }
        offset += kFpgaLookupBlockWords;
    }
}

FpgaLookupResult UnpackResult(const std::vector<uint32_t>& output_words, std::size_t index) {
    const std::size_t offset = index * kFpgaLookupResultWords;
    FpgaLookupResult r = {};
    r.valid = output_words[offset + 0];
    r.fallback = output_words[offset + 1];
    r.hit_neighbor = output_words[offset + 2];
    r.neighbor_level = output_words[offset + 3];
    r.miss_reason = output_words[offset + 4];
    r.count = output_words[offset + 5];
    r.quality = WordToFloat(output_words[offset + 6]);
    r.reserved0 = WordToFloat(output_words[offset + 7]);
    for (int i = 0; i < 4; ++i) {
        r.plane[i] = WordToFloat(output_words[offset + 8 + i]);
    }
    for (int i = 0; i < 3; ++i) {
        r.centroid[i] = WordToFloat(output_words[offset + 12 + i]);
    }
    r.reserved1 = WordToFloat(output_words[offset + 15]);
    return r;
}

void MarkMismatch(const std::string& field, int point_index, CompareStats* stats) {
    stats->pass = false;
    ++stats->mismatches;
    if (stats->field == "none") {
        stats->field = field;
        stats->point_index = point_index;
    }
}

void CompareScalar(float actual, float expected, const std::string& field, int point_index, CompareStats* stats) {
    const float abs_error = std::fabs(actual - expected);
    const float rel_error = abs_error / std::max(std::fabs(expected), 1.0e-12f);
    if (abs_error > stats->max_abs_error) {
        stats->max_abs_error = abs_error;
        stats->field = field;
        stats->point_index = point_index;
    }
    if (rel_error > stats->max_rel_error) {
        stats->max_rel_error = rel_error;
    }
    if (abs_error > kMaxAbsError && rel_error > kMaxRelError) {
        MarkMismatch(field, point_index, stats);
    }
}

void CompareResult(const FpgaLookupResult& actual, const FpgaLookupResult& expected, int point_index,
                   CompareStats* stats) {
    if (actual.valid != expected.valid) MarkMismatch("valid", point_index, stats);
    if (actual.fallback != expected.fallback) MarkMismatch("fallback", point_index, stats);
    if (actual.hit_neighbor != expected.hit_neighbor) MarkMismatch("hit_neighbor", point_index, stats);
    if (actual.neighbor_level != expected.neighbor_level) MarkMismatch("neighbor_level", point_index, stats);
    if (actual.miss_reason != expected.miss_reason) MarkMismatch("miss_reason", point_index, stats);
    if (actual.count != expected.count) MarkMismatch("count", point_index, stats);

    if (expected.valid != 0 || actual.valid != 0) {
        CompareScalar(actual.quality, expected.quality, "quality", point_index, stats);
        for (int i = 0; i < 4; ++i) {
            CompareScalar(actual.plane[i], expected.plane[i], "plane", point_index, stats);
        }
        for (int i = 0; i < 3; ++i) {
            CompareScalar(actual.centroid[i], expected.centroid[i], "centroid", point_index, stats);
        }
    }
}

bool RunOneGolden(const std::string& path) {
    LoadedGolden golden;
    if (!ReadGolden(path, &golden)) {
        return false;
    }

    std::vector<uint32_t> input_words;
    PackInput(golden, &input_words);

    std::vector<uint32_t> output_words(golden.points.size() * kFpgaLookupResultWords, 0);
    lookup_batch_accel(input_words.empty() ? nullptr : &input_words[0], output_words.empty() ? nullptr : &output_words[0],
                       static_cast<int>(golden.points.size()), static_cast<int>(golden.blocks.size()));

    CompareStats stats;
    for (std::size_t i = 0; i < golden.expected.size(); ++i) {
        const FpgaLookupResult actual = UnpackResult(output_words, i);
        CompareResult(actual, golden.expected[i], static_cast<int>(i), &stats);
    }

    std::cout << (stats.pass ? "PASS" : "FAIL") << " " << path << " frame=" << golden.header.frame_id
              << " points=" << golden.header.num_points << " blocks=" << golden.header.num_blocks
              << " mismatches=" << stats.mismatches << " max_abs_error=" << std::setprecision(9)
              << stats.max_abs_error << " max_rel_error=" << stats.max_rel_error << " field=" << stats.field
              << " point=" << stats.point_index << "\n";
    return stats.pass;
}

std::vector<std::string> DefaultGoldenPaths() {
    std::vector<std::string> paths;
    paths.push_back("../../golden_small/lookup_frame_000100.bin");
    paths.push_back("../../golden_small/lookup_frame_000200.bin");
    paths.push_back("../../golden_small/lookup_frame_000300.bin");
    paths.push_back("../../golden_small/lookup_frame_000400.bin");
    paths.push_back("../../golden_small/lookup_frame_000500.bin");
    paths.push_back("../../../golden_small/lookup_frame_000100.bin");
    paths.push_back("../../../golden_small/lookup_frame_000200.bin");
    paths.push_back("../../../golden_small/lookup_frame_000300.bin");
    paths.push_back("../../../golden_small/lookup_frame_000400.bin");
    paths.push_back("../../../golden_small/lookup_frame_000500.bin");
    return paths;
}

}  // namespace

int main(int argc, char** argv) {
    std::vector<std::string> paths;
    if (argc > 1) {
        for (int i = 1; i < argc; ++i) {
            paths.push_back(argv[i]);
        }
    } else {
        paths = DefaultGoldenPaths();
    }

    bool any_loaded = false;
    bool all_passed = true;
    for (std::size_t i = 0; i < paths.size(); ++i) {
        std::ifstream probe(paths[i].c_str(), std::ios::binary);
        if (!probe) {
            if (argc > 1) {
                std::cerr << "ERROR: missing requested lookup golden file " << paths[i] << "\n";
                all_passed = false;
            }
            continue;
        }
        probe.close();

        any_loaded = true;
        if (!RunOneGolden(paths[i])) {
            all_passed = false;
        }
    }

    if (!any_loaded) {
        std::cerr << "ERROR: no lookup golden files loaded\n";
        return 1;
    }

    return all_passed ? 0 : 1;
}
