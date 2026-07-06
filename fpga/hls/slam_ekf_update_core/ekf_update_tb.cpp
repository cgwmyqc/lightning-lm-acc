// SPDX-License-Identifier: MIT
#include "slam_ekf_update_core.h"

#include <stdint.h>

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

using namespace slam_ekf_update_hls;

namespace {

constexpr uint32_t kFileMagic = 0x53455550u;  // SEUP
constexpr uint32_t kFileVersion = 1u;

union U64Double {
    uint64_t u;
    double d;
};

uint64_t double_to_u64(double v) {
    U64Double c;
    c.d = v;
    return c.u;
}

double u64_to_double(uint64_t v) {
    U64Double c;
    c.u = v;
    return c.d;
}

template <typename T>
bool read_raw(std::ifstream& ifs, T& value) {
    ifs.read(reinterpret_cast<char*>(&value), sizeof(T));
    return static_cast<bool>(ifs);
}

bool read_doubles(std::ifstream& ifs, double* data, int count) {
    ifs.read(reinterpret_cast<char*>(data), static_cast<std::streamsize>(sizeof(double) * count));
    return static_cast<bool>(ifs);
}

struct NavStateFile {
    double timestamp = 0.0;
    double pos[3] = {};
    double quat_xyzw[4] = {};
    double vel[3] = {};
    double bg[3] = {};
    double grav[3] = {};
};

struct UpdateInputFile {
    NavStateFile start_state;
    NavStateFile current_state;
    double propagated_cov[STATE_DIM * STATE_DIM] = {};
    double hth[OBS_DIM * OBS_DIM] = {};
    double htr[OBS_DIM] = {};
    double dx_from_start[STATE_DIM] = {};
    double R = 1.0;
    double degeneracy_threshold_ratio = 1e-3;
    double degeneracy_cov_inflation = 1.02;
    double min_cov_diag = 1e-9;
    double max_update_translation_step = 0.5;
    double max_update_rotation_step_deg = 5.0;
    double limit[STATE_DIM] = {};
    int32_t frame_index = 0;
    int32_t iteration_index = 0;
    bool finish_update = true;
};

struct UpdateOutputFile {
    bool success = false;
    bool rejected = false;
    bool converged = false;
    bool covariance_finalized = false;
    int32_t nullity = 0;
    double dx_current[STATE_DIM] = {};
    double k_r[STATE_DIM] = {};
    double k_h[STATE_DIM * STATE_DIM] = {};
    double hth_eff[OBS_DIM * OBS_DIM] = {};
    double htr_eff[OBS_DIM] = {};
    NavStateFile updated_state;
    double working_cov[STATE_DIM * STATE_DIM] = {};
    double updated_cov[STATE_DIM * STATE_DIM] = {};
    double dx_translation = 0.0;
    double dx_rotation_deg = 0.0;
    double dx_norm = 0.0;
};

bool read_header(std::ifstream& ifs) {
    uint32_t magic = 0;
    uint32_t version = 0;
    return read_raw(ifs, magic) && read_raw(ifs, version) && magic == kFileMagic && version == kFileVersion;
}

bool read_nav(std::ifstream& ifs, NavStateFile& state) {
    return read_raw(ifs, state.timestamp) && read_doubles(ifs, state.pos, 3) &&
           read_doubles(ifs, state.quat_xyzw, 4) && read_doubles(ifs, state.vel, 3) &&
           read_doubles(ifs, state.bg, 3) && read_doubles(ifs, state.grav, 3);
}

bool read_input(const std::string& path, UpdateInputFile& input) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs || !read_header(ifs)) {
        return false;
    }
    uint8_t finish = 0;
    if (!read_nav(ifs, input.start_state) || !read_nav(ifs, input.current_state) ||
        !read_doubles(ifs, input.propagated_cov, STATE_DIM * STATE_DIM) ||
        !read_doubles(ifs, input.hth, OBS_DIM * OBS_DIM) || !read_doubles(ifs, input.htr, OBS_DIM) ||
        !read_doubles(ifs, input.dx_from_start, STATE_DIM) || !read_raw(ifs, input.R) ||
        !read_raw(ifs, input.degeneracy_threshold_ratio) || !read_raw(ifs, input.degeneracy_cov_inflation) ||
        !read_raw(ifs, input.min_cov_diag) || !read_raw(ifs, input.max_update_translation_step) ||
        !read_raw(ifs, input.max_update_rotation_step_deg) || !read_doubles(ifs, input.limit, STATE_DIM) ||
        !read_raw(ifs, input.frame_index) || !read_raw(ifs, input.iteration_index) || !read_raw(ifs, finish)) {
        return false;
    }
    input.finish_update = finish != 0;
    return true;
}

bool read_output(const std::string& path, UpdateOutputFile& output) {
    std::ifstream ifs(path, std::ios::binary);
    if (!ifs || !read_header(ifs)) {
        return false;
    }
    uint8_t success = 0, rejected = 0, converged = 0, cov_final = 0;
    if (!read_raw(ifs, success) || !read_raw(ifs, rejected) || !read_raw(ifs, converged) ||
        !read_raw(ifs, cov_final) || !read_raw(ifs, output.nullity) ||
        !read_doubles(ifs, output.dx_current, STATE_DIM) || !read_doubles(ifs, output.k_r, STATE_DIM) ||
        !read_doubles(ifs, output.k_h, STATE_DIM * STATE_DIM) ||
        !read_doubles(ifs, output.hth_eff, OBS_DIM * OBS_DIM) || !read_doubles(ifs, output.htr_eff, OBS_DIM) ||
        !read_nav(ifs, output.updated_state) || !read_doubles(ifs, output.working_cov, STATE_DIM * STATE_DIM) ||
        !read_doubles(ifs, output.updated_cov, STATE_DIM * STATE_DIM) || !read_raw(ifs, output.dx_translation) ||
        !read_raw(ifs, output.dx_rotation_deg) || !read_raw(ifs, output.dx_norm)) {
        return false;
    }
    output.success = success != 0;
    output.rejected = rejected != 0;
    output.converged = converged != 0;
    output.covariance_finalized = cov_final != 0;
    return true;
}

std::string join_path(const std::string& dir, const std::string& name) {
    if (dir.empty()) {
        return name;
    }
    const char last = dir[dir.size() - 1];
    if (last == '/' || last == '\\') {
        return dir + name;
    }
    return dir + "/" + name;
}

void pack_nav(const NavStateFile& state, std::vector<uint64_t>& words, int base) {
    words[base + 0] = double_to_u64(state.timestamp);
    for (int i = 0; i < 3; ++i) {
        words[base + 1 + i] = double_to_u64(state.pos[i]);
    }
    for (int i = 0; i < 4; ++i) {
        words[base + 4 + i] = double_to_u64(state.quat_xyzw[i]);
    }
    for (int i = 0; i < 3; ++i) {
        words[base + 8 + i] = double_to_u64(state.vel[i]);
        words[base + 11 + i] = double_to_u64(state.bg[i]);
        words[base + 14 + i] = double_to_u64(state.grav[i]);
    }
}

void pack_input(const UpdateInputFile& input, std::vector<uint64_t>& words) {
    words.assign(IN_WORDS, 0);
    words[IN_MAGIC_VERSION] = (static_cast<uint64_t>(SLAM_EKF_UPDATE_VERSION) << 32) | SLAM_EKF_UPDATE_IN_MAGIC;
    words[IN_FLAGS] = input.finish_update ? 1u : 0u;
    words[IN_FRAME_ITER] = (static_cast<uint64_t>(static_cast<uint32_t>(input.iteration_index)) << 32) |
                           static_cast<uint32_t>(input.frame_index);
    pack_nav(input.current_state, words, IN_CURRENT_STATE);
    for (int i = 0; i < STATE_DIM * STATE_DIM; ++i) {
        words[IN_PROPAGATED_COV + i] = double_to_u64(input.propagated_cov[i]);
    }
    for (int i = 0; i < OBS_DIM * OBS_DIM; ++i) {
        words[IN_HTH + i] = double_to_u64(input.hth[i]);
    }
    for (int i = 0; i < OBS_DIM; ++i) {
        words[IN_HTR + i] = double_to_u64(input.htr[i]);
    }
    for (int i = 0; i < STATE_DIM; ++i) {
        words[IN_DX_FROM_START + i] = double_to_u64(input.dx_from_start[i]);
        words[IN_LIMIT + i] = double_to_u64(input.limit[i]);
    }
    words[IN_PARAMS + 0] = double_to_u64(input.R);
    words[IN_PARAMS + 1] = double_to_u64(input.degeneracy_threshold_ratio);
    words[IN_PARAMS + 2] = double_to_u64(input.degeneracy_cov_inflation);
    words[IN_PARAMS + 3] = double_to_u64(input.min_cov_diag);
    words[IN_PARAMS + 4] = double_to_u64(input.max_update_translation_step);
    words[IN_PARAMS + 5] = double_to_u64(input.max_update_rotation_step_deg);
}

double max_abs_vec(const double* actual, const double* expected, int n) {
    double m = 0.0;
    for (int i = 0; i < n; ++i) {
        m = std::max(m, std::fabs(actual[i] - expected[i]));
    }
    return m;
}

double state_max_abs(const std::vector<uint64_t>& output, const UpdateOutputFile& expected) {
    double m = 0.0;
    const int base = OUT_UPDATED_STATE;
    m = std::max(m, std::fabs(u64_to_double(output[base + 0]) - expected.updated_state.timestamp));
    for (int i = 0; i < 3; ++i) {
        m = std::max(m, std::fabs(u64_to_double(output[base + 1 + i]) - expected.updated_state.pos[i]));
    }
    for (int i = 0; i < 4; ++i) {
        m = std::max(m, std::fabs(u64_to_double(output[base + 4 + i]) - expected.updated_state.quat_xyzw[i]));
    }
    for (int i = 0; i < 3; ++i) {
        m = std::max(m, std::fabs(u64_to_double(output[base + 8 + i]) - expected.updated_state.vel[i]));
        m = std::max(m, std::fabs(u64_to_double(output[base + 11 + i]) - expected.updated_state.bg[i]));
        m = std::max(m, std::fabs(u64_to_double(output[base + 14 + i]) - expected.updated_state.grav[i]));
    }
    return m;
}

void unpack_doubles(const std::vector<uint64_t>& words, int base, double* out, int n) {
    for (int i = 0; i < n; ++i) {
        out[i] = u64_to_double(words[base + i]);
    }
}

}  // namespace

int main(int argc, char** argv) {
    std::printf("[ekf_update_tb] start\n");
    std::fflush(stdout);
    std::string golden_dir = "fpga/golden/mapping_update/frame_000001";
    if (argc >= 2) {
        golden_dir = argv[1];
    }
    UpdateInputFile input;
    UpdateOutputFile expected;
    if (!read_input(join_path(golden_dir, "update_input.bin"), input)) {
        std::cerr << "[ekf_update_tb] failed to read update_input.bin from " << golden_dir << "\n";
        return 1;
    }
    if (!read_output(join_path(golden_dir, "update_expected.bin"), expected)) {
        std::cerr << "[ekf_update_tb] failed to read update_expected.bin from " << golden_dir << "\n";
        return 1;
    }

    std::vector<uint64_t> in_words(IN_WORDS);
    std::vector<uint64_t> out_words(OUT_WORDS, 0);
    pack_input(input, in_words);
    slam_ekf_update_core(in_words.data(), out_words.data());

    const uint32_t status = static_cast<uint32_t>(out_words[OUT_STATUS] & 0xffffffffu);
    const bool success = (status & STATUS_SUCCESS) != 0;
    const bool rejected = (status & STATUS_REJECTED) != 0;
    const bool converged = (status & STATUS_CONVERGED) != 0;
    const bool cov_final = (status & STATUS_COVARIANCE_FINALIZED) != 0;
    const int nullity = static_cast<int>(out_words[OUT_NULLITY]);

    double actual_dx[STATE_DIM];
    double actual_cov[STATE_DIM * STATE_DIM];
    unpack_doubles(out_words, OUT_DX_CURRENT, actual_dx, STATE_DIM);
    unpack_doubles(out_words, OUT_UPDATED_COV, actual_cov, STATE_DIM * STATE_DIM);

    const bool flags_ok = success == expected.success && rejected == expected.rejected &&
                          converged == expected.converged && cov_final == expected.covariance_finalized &&
                          nullity == expected.nullity;
    const double dx_max_abs = max_abs_vec(actual_dx, expected.dx_current, STATE_DIM);
    const double cov_max_abs = max_abs_vec(actual_cov, expected.updated_cov, STATE_DIM * STATE_DIM);
    const double st_max_abs = state_max_abs(out_words, expected);

    std::cout << std::setprecision(12)
              << "[ekf_update_tb] flags_ok=" << (flags_ok ? 1 : 0)
              << " dx_max_abs=" << dx_max_abs
              << " cov_max_abs=" << cov_max_abs
              << " state_max_abs=" << st_max_abs
              << " actual_nullity=" << nullity
              << " expected_nullity=" << expected.nullity
              << " status=0x" << std::hex << status << std::dec
              << "\n";

    if (!flags_ok || dx_max_abs > 1e-9 || cov_max_abs > 1e-8 || st_max_abs > 1e-9) {
        std::cerr << "[ekf_update_tb] FAIL " << golden_dir << "\n";
        return 2;
    }

    std::cout << "MAPPING_EKF_UPDATE_HLS_CSIM_PASS golden_dir=" << golden_dir << "\n";
    return 0;
}
