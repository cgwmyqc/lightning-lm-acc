// SPDX-License-Identifier: MIT
#pragma once

#include <stdint.h>

namespace slam_ekf_update_hls {

static const uint32_t SLAM_EKF_UPDATE_IN_MAGIC = 0x45554650u;   // EUFP
static const uint32_t SLAM_EKF_UPDATE_OUT_MAGIC = 0x4555464fu;  // EUFO
static const uint32_t SLAM_EKF_UPDATE_VERSION = 1u;

static const int STATE_DIM = 12;
static const int OBS_DIM = 6;
static const int MAT12_WORDS = STATE_DIM * STATE_DIM;
static const int MAT6_WORDS = OBS_DIM * OBS_DIM;

enum InputWordOffset {
    IN_MAGIC_VERSION = 0,
    IN_FLAGS = 1,
    IN_FRAME_ITER = 2,
    IN_CURRENT_STATE = 3,
    IN_PROPAGATED_COV = IN_CURRENT_STATE + 17,
    IN_HTH = IN_PROPAGATED_COV + MAT12_WORDS,
    IN_HTR = IN_HTH + MAT6_WORDS,
    IN_DX_FROM_START = IN_HTR + OBS_DIM,
    IN_PARAMS = IN_DX_FROM_START + STATE_DIM,
    IN_LIMIT = IN_PARAMS + 6,
    IN_WORDS = IN_LIMIT + STATE_DIM
};

enum OutputWordOffset {
    OUT_MAGIC_VERSION = 0,
    OUT_STATUS = 1,
    OUT_NULLITY = 2,
    OUT_DX_CURRENT = 3,
    OUT_K_R = OUT_DX_CURRENT + STATE_DIM,
    OUT_K_H = OUT_K_R + STATE_DIM,
    OUT_HTH_EFF = OUT_K_H + MAT12_WORDS,
    OUT_HTR_EFF = OUT_HTH_EFF + MAT6_WORDS,
    OUT_UPDATED_STATE = OUT_HTR_EFF + OBS_DIM,
    OUT_WORKING_COV = OUT_UPDATED_STATE + 17,
    OUT_UPDATED_COV = OUT_WORKING_COV + MAT12_WORDS,
    OUT_DIAGNOSTICS = OUT_UPDATED_COV + MAT12_WORDS,
    OUT_WORDS = OUT_DIAGNOSTICS + 4
};

enum StatusBits {
    STATUS_SUCCESS = 1u << 0,
    STATUS_REJECTED = 1u << 1,
    STATUS_CONVERGED = 1u << 2,
    STATUS_COVARIANCE_FINALIZED = 1u << 3,
    STATUS_EIGEN_FAILED = 1u << 8,
    STATUS_INVERSE_FAILED = 1u << 9,
    STATUS_NAN_DX = 1u << 10,
    STATUS_STEP_REJECTED = 1u << 11
};

void slam_ekf_update_core_impl(const uint64_t* input_words, uint64_t* output_words);

}  // namespace slam_ekf_update_hls

void slam_ekf_update_core(const uint64_t* input_words, uint64_t* output_words);
