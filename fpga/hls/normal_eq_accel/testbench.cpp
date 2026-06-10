#include "normal_eq_accel.h"

#include <algorithm>
#include <cmath>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

namespace {

constexpr float kMaxAbsError = 1.0e-4f;
constexpr float kMaxRelError = 1.0e-3f;

struct LoadedGolden {
    GoldenHeader header;
    std::vector<FpgaCorrInput> corr;
};

struct ErrorStats {
    float max_abs_error;
    float max_rel_error;
    std::string field;
    int index;
    bool pass;

    ErrorStats() : max_abs_error(0.0f), max_rel_error(0.0f), field("none"), index(-1), pass(true) {}
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

void PackGoldenInput(const LoadedGolden& golden, std::vector<uint32_t>* input_words) {
    input_words->assign(kFpgaStateInputWords + golden.corr.size() * kFpgaCorrInputWords, 0);

    (*input_words)[0] = LIGHTNING_FPGA_MAGIC;
    (*input_words)[1] = LIGHTNING_FPGA_INTERFACE_VERSION;
    (*input_words)[2] = golden.header.num_points;
    (*input_words)[3] = 0;

    for (int i = 0; i < 9; ++i) {
        (*input_words)[4 + i] = FloatToWord(golden.header.R[i]);
    }
    for (int i = 0; i < 3; ++i) {
        (*input_words)[13 + i] = FloatToWord(golden.header.t[i]);
    }

    const std::size_t corr_base = kFpgaStateInputWords;
    for (std::size_t i = 0; i < golden.corr.size(); ++i) {
        const std::size_t offset = corr_base + i * kFpgaCorrInputWords;
        const FpgaCorrInput& c = golden.corr[i];
        (*input_words)[offset + 0] = FloatToWord(c.px);
        (*input_words)[offset + 1] = FloatToWord(c.py);
        (*input_words)[offset + 2] = FloatToWord(c.pz);
        (*input_words)[offset + 3] = FloatToWord(c.nx);
        (*input_words)[offset + 4] = FloatToWord(c.ny);
        (*input_words)[offset + 5] = FloatToWord(c.nz);
        (*input_words)[offset + 6] = FloatToWord(c.d);
        (*input_words)[offset + 7] = FloatToWord(c.weight);
    }
}

FpgaNormalEqOutput UnpackOutput(const std::vector<uint32_t>& output_words) {
    FpgaNormalEqOutput out = {};
    out.magic = output_words[0];
    out.version = output_words[1];
    out.valid_count = output_words[2];
    out.reserved0 = output_words[3];

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_H_UPPER_SIZE; ++i) {
        out.H_upper[i] = WordToFloat(output_words[4 + i]);
    }
    for (int i = 0; i < LIGHTNING_NORMAL_EQ_DIM; ++i) {
        out.b[i] = WordToFloat(output_words[25 + i]);
    }

    out.residual_sum = WordToFloat(output_words[31]);
    out.residual_abs_sum = WordToFloat(output_words[32]);
    for (int i = 0; i < 7; ++i) {
        out.reserved1[i] = WordToFloat(output_words[33 + i]);
    }
    return out;
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

    GoldenHeader header;
    in.read(reinterpret_cast<char*>(&header), sizeof(header));
    if (!in) {
        std::cerr << "ERROR: failed to read GoldenHeader from " << path << "\n";
        return false;
    }

    if (header.magic != LIGHTNING_GOLDEN_MAGIC) {
        std::cerr << "ERROR: bad golden magic in " << path << ", got 0x" << std::hex << header.magic << std::dec
                  << "\n";
        return false;
    }

    if (header.version != LIGHTNING_FPGA_INTERFACE_VERSION) {
        std::cerr << "ERROR: bad golden version in " << path << ", got " << header.version << "\n";
        return false;
    }

    const std::streamoff expected_size =
        static_cast<std::streamoff>(sizeof(GoldenHeader)) +
        static_cast<std::streamoff>(header.num_points) * static_cast<std::streamoff>(sizeof(FpgaCorrInput));
    if (file_size != expected_size) {
        std::cerr << "ERROR: bad golden size in " << path << ", got " << file_size << ", expected " << expected_size
                  << "\n";
        return false;
    }

    std::vector<FpgaCorrInput> corr(header.num_points);
    if (!corr.empty()) {
        in.read(reinterpret_cast<char*>(&corr[0]),
                static_cast<std::streamsize>(corr.size() * sizeof(FpgaCorrInput)));
        if (!in) {
            std::cerr << "ERROR: failed to read corr records from " << path << "\n";
            return false;
        }
    }

    golden->header = header;
    golden->corr.swap(corr);
    return true;
}

void UpdateError(float actual, float expected, const std::string& field, int index, ErrorStats* stats) {
    const float abs_error = std::fabs(actual - expected);
    const float rel_error = abs_error / std::max(std::fabs(expected), 1.0e-12f);
    if (abs_error > stats->max_abs_error) {
        stats->max_abs_error = abs_error;
        stats->field = field;
        stats->index = index;
    }
    if (rel_error > stats->max_rel_error) {
        stats->max_rel_error = rel_error;
    }
    if (abs_error > kMaxAbsError && rel_error > kMaxRelError) {
        stats->pass = false;
    }
}

bool RunOneGolden(const std::string& path) {
    LoadedGolden golden;
    if (!ReadGolden(path, &golden)) {
        return false;
    }

    std::vector<uint32_t> input_words;
    PackGoldenInput(golden, &input_words);

    std::vector<uint32_t> output_words(kFpgaNormalEqOutputWords, 0);
    normal_eq_accel(input_words.empty() ? nullptr : &input_words[0], &output_words[0],
                    static_cast<int>(golden.corr.size()));
    const FpgaNormalEqOutput out = UnpackOutput(output_words);

    bool pass = true;
    ErrorStats stats;

    if (out.magic != LIGHTNING_FPGA_MAGIC) {
        std::cerr << "ERROR: output magic mismatch, got 0x" << std::hex << out.magic << std::dec << "\n";
        pass = false;
    }
    if (out.version != LIGHTNING_FPGA_INTERFACE_VERSION) {
        std::cerr << "ERROR: output version mismatch, got " << out.version << "\n";
        pass = false;
    }
    if (out.valid_count != golden.header.num_points) {
        std::cerr << "ERROR: valid_count mismatch, got " << out.valid_count << ", expected " << golden.header.num_points
                  << "\n";
        pass = false;
    }

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_H_UPPER_SIZE; ++i) {
        UpdateError(out.H_upper[i], golden.header.H_upper_cpu[i], "H_upper", i, &stats);
    }

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_DIM; ++i) {
        UpdateError(out.b[i], golden.header.b_cpu[i], "b", i, &stats);
    }

    UpdateError(out.residual_sum, golden.header.residual_sum_cpu, "residual_sum", 0, &stats);
    UpdateError(out.residual_abs_sum, golden.header.residual_abs_sum_cpu, "residual_abs_sum", 0, &stats);

    if (!stats.pass) {
        pass = false;
    }

    std::cout << (pass ? "PASS" : "FAIL") << " " << path << " frame=" << golden.header.frame_id
              << " points=" << golden.header.num_points << " max_abs_error=" << std::setprecision(9)
              << stats.max_abs_error << " max_rel_error=" << stats.max_rel_error << " field=" << stats.field << "["
              << stats.index << "]\n";
    return pass;
}

std::vector<std::string> DefaultGoldenPaths() {
    std::vector<std::string> paths;
    paths.push_back("../../golden_small/frame_000100.bin");
    paths.push_back("../../golden_small/frame_000200.bin");
    paths.push_back("../../golden_small/frame_000300.bin");
    paths.push_back("../../../golden_small/frame_000100.bin");
    paths.push_back("../../../golden_small/frame_000200.bin");
    paths.push_back("../../../golden_small/frame_000300.bin");
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
                std::cerr << "ERROR: missing requested golden file " << paths[i] << "\n";
                all_passed = false;
            }
            continue;
        }
        probe.close();

        any_loaded = true;
        all_passed = RunOneGolden(paths[i]) && all_passed;
    }

    if (!any_loaded) {
        std::cerr << "ERROR: no golden files were loaded\n";
        return 1;
    }

    return all_passed ? 0 : 1;
}
