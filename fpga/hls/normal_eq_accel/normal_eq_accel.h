#ifndef LIGHTNING_FPGA_HLS_NORMAL_EQ_ACCEL_H_
#define LIGHTNING_FPGA_HLS_NORMAL_EQ_ACCEL_H_

#include <stdint.h>

#define LIGHTNING_FPGA_MAGIC 0x4C464750u
#define LIGHTNING_GOLDEN_MAGIC 0x4C474F4Cu
#define LIGHTNING_FPGA_INTERFACE_VERSION 1u
#define LIGHTNING_NORMAL_EQ_H_UPPER_SIZE 21
#define LIGHTNING_NORMAL_EQ_DIM 6

struct alignas(32) FpgaCorrInput {
    float px;
    float py;
    float pz;
    float nx;
    float ny;
    float nz;
    float d;
    float weight;
};

struct alignas(64) FpgaStateInput {
    uint32_t magic;
    uint32_t version;
    uint32_t num_points;
    uint32_t reserved0;

    float R[9];
    float t[3];

    uint32_t reserved1[8];
};

struct alignas(64) FpgaNormalEqOutput {
    uint32_t magic;
    uint32_t version;
    uint32_t valid_count;
    uint32_t reserved0;

    float H_upper[LIGHTNING_NORMAL_EQ_H_UPPER_SIZE];
    float b[LIGHTNING_NORMAL_EQ_DIM];

    float residual_sum;
    float residual_abs_sum;
    float reserved1[7];
};

struct alignas(64) GoldenHeader {
    uint32_t magic;
    uint32_t version;
    uint32_t frame_id;
    uint32_t num_points;

    float R[9];
    float t[3];

    float H_upper_cpu[LIGHTNING_NORMAL_EQ_H_UPPER_SIZE];
    float b_cpu[LIGHTNING_NORMAL_EQ_DIM];

    float residual_sum_cpu;
    float residual_abs_sum_cpu;

    uint32_t reserved[16];
};

static_assert(sizeof(FpgaCorrInput) == 32, "FpgaCorrInput must be 32 bytes");
static_assert(sizeof(FpgaStateInput) == 128, "FpgaStateInput must be 128 bytes");
static_assert(sizeof(FpgaNormalEqOutput) == 192, "FpgaNormalEqOutput must be 192 bytes");
static_assert(sizeof(GoldenHeader) == 256, "GoldenHeader must be 256 bytes");

constexpr int kFpgaStateInputWords = sizeof(FpgaStateInput) / sizeof(uint32_t);
constexpr int kFpgaCorrInputWords = sizeof(FpgaCorrInput) / sizeof(uint32_t);
constexpr int kFpgaNormalEqOutputWords = sizeof(FpgaNormalEqOutput) / sizeof(uint32_t);

void normal_eq_accel(const uint32_t* input, uint32_t* output, int num_points);

#endif  // LIGHTNING_FPGA_HLS_NORMAL_EQ_ACCEL_H_
