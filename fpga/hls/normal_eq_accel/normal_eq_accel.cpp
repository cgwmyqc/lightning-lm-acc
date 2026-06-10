#include "normal_eq_accel.h"

namespace {

constexpr int kStateRWordOffset = 4;
constexpr int kStateTWordOffset = 13;
constexpr int kCorrBaseWordOffset = kFpgaStateInputWords;
constexpr int kOutputHUpperWordOffset = 4;
constexpr int kOutputBWordOffset = 25;
constexpr int kOutputResidualSumWordOffset = 31;
constexpr int kOutputResidualAbsSumWordOffset = 32;
constexpr int kOutputReserved1WordOffset = 33;

union FloatWord {
    uint32_t word;
    float value;
};

float word_to_float(uint32_t word) {
#pragma HLS INLINE
    FloatWord conv;
    conv.word = word;
    return conv.value;
}

uint32_t float_to_word(float value) {
#pragma HLS INLINE
    FloatWord conv;
    conv.value = value;
    return conv.word;
}

float abs_float(float x) {
#pragma HLS INLINE
    return x < 0.0f ? -x : x;
}

int upper21_index(int row, int col) {
#pragma HLS INLINE
    return row * LIGHTNING_NORMAL_EQ_DIM - (row * (row - 1)) / 2 + (col - row);
}

}  // namespace

void normal_eq_accel(const uint32_t* input, uint32_t* output, int num_points) {
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=gmem depth=32768
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=gmem depth=64
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=num_points bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    float R[9];
    float t[3];
    float H_upper[LIGHTNING_NORMAL_EQ_H_UPPER_SIZE];
    float b[LIGHTNING_NORMAL_EQ_DIM];
#pragma HLS ARRAY_PARTITION variable=R complete dim=1
#pragma HLS ARRAY_PARTITION variable=t complete dim=1
#pragma HLS ARRAY_PARTITION variable=H_upper complete dim=1
#pragma HLS ARRAY_PARTITION variable=b complete dim=1

    for (int i = 0; i < 9; ++i) {
#pragma HLS UNROLL
        R[i] = word_to_float(input[kStateRWordOffset + i]);
    }

    for (int i = 0; i < 3; ++i) {
#pragma HLS UNROLL
        t[i] = word_to_float(input[kStateTWordOffset + i]);
    }

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_H_UPPER_SIZE; ++i) {
#pragma HLS UNROLL
        H_upper[i] = 0.0f;
    }

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_DIM; ++i) {
#pragma HLS UNROLL
        b[i] = 0.0f;
    }

    float residual_sum = 0.0f;
    float residual_abs_sum = 0.0f;

    for (int i = 0; i < num_points; ++i) {
#pragma HLS PIPELINE II=1
        const int corr_offset = kCorrBaseWordOffset + i * kFpgaCorrInputWords;

        const float px = word_to_float(input[corr_offset + 0]);
        const float py = word_to_float(input[corr_offset + 1]);
        const float pz = word_to_float(input[corr_offset + 2]);
        const float nx = word_to_float(input[corr_offset + 3]);
        const float ny = word_to_float(input[corr_offset + 4]);
        const float nz = word_to_float(input[corr_offset + 5]);
        const float d = word_to_float(input[corr_offset + 6]);
        const float weight = word_to_float(input[corr_offset + 7]);

        const float pwx = R[0] * px + R[1] * py + R[2] * pz + t[0];
        const float pwy = R[3] * px + R[4] * py + R[5] * pz + t[1];
        const float pwz = R[6] * px + R[7] * py + R[8] * pz + t[2];
        const float residual = nx * pwx + ny * pwy + nz * pwz + d;

        const float Cx = R[0] * nx + R[3] * ny + R[6] * nz;
        const float Cy = R[1] * nx + R[4] * ny + R[7] * nz;
        const float Cz = R[2] * nx + R[5] * ny + R[8] * nz;

        const float J[LIGHTNING_NORMAL_EQ_DIM] = {
            nx,
            ny,
            nz,
            -pz * Cy + py * Cz,
            pz * Cx - px * Cz,
            -py * Cx + px * Cy,
        };

        const float weighted_neg_residual = -residual * weight;

        for (int r = 0; r < LIGHTNING_NORMAL_EQ_DIM; ++r) {
#pragma HLS UNROLL
            b[r] += J[r] * weighted_neg_residual;
        }

        for (int r = 0; r < LIGHTNING_NORMAL_EQ_DIM; ++r) {
#pragma HLS UNROLL
            for (int col = r; col < LIGHTNING_NORMAL_EQ_DIM; ++col) {
#pragma HLS UNROLL
                H_upper[upper21_index(r, col)] += J[r] * J[col] * weight;
            }
        }

        residual_sum += residual;
        residual_abs_sum += abs_float(residual);
    }

    output[0] = LIGHTNING_FPGA_MAGIC;
    output[1] = LIGHTNING_FPGA_INTERFACE_VERSION;
    output[2] = static_cast<uint32_t>(num_points);
    output[3] = 0;

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_H_UPPER_SIZE; ++i) {
#pragma HLS UNROLL
        output[kOutputHUpperWordOffset + i] = float_to_word(H_upper[i]);
    }

    for (int i = 0; i < LIGHTNING_NORMAL_EQ_DIM; ++i) {
#pragma HLS UNROLL
        output[kOutputBWordOffset + i] = float_to_word(b[i]);
    }

    output[kOutputResidualSumWordOffset] = float_to_word(residual_sum);
    output[kOutputResidualAbsSumWordOffset] = float_to_word(residual_abs_sum);

    for (int i = 0; i < 7; ++i) {
#pragma HLS UNROLL
        output[kOutputReserved1WordOffset + i] = 0;
    }
}
