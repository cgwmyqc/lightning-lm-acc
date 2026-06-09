#pragma once

#include <cstdint>

namespace lightning::fpga {

constexpr uint32_t kFpgaMagic = 0x4C464750;   // "LFGP"
constexpr uint32_t kGoldenMagic = 0x4C474F4C; // "LGOL"
constexpr uint32_t kFpgaInterfaceVersion = 1;

struct alignas(32) FpgaCorrInput {
    float px = 0.0f;
    float py = 0.0f;
    float pz = 0.0f;
    float nx = 0.0f;
    float ny = 0.0f;
    float nz = 0.0f;
    float d = 0.0f;
    float weight = 1.0f;
};

struct alignas(64) FpgaStateInput {
    uint32_t magic = kFpgaMagic;
    uint32_t version = kFpgaInterfaceVersion;
    uint32_t num_points = 0;
    uint32_t reserved0 = 0;

    float R[9] = {1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f};
    float t[3] = {0.0f, 0.0f, 0.0f};

    uint32_t reserved1[8] = {0};
};

struct alignas(64) FpgaNormalEqOutput {
    uint32_t magic = kFpgaMagic;
    uint32_t version = kFpgaInterfaceVersion;
    uint32_t valid_count = 0;
    uint32_t reserved0 = 0;

    float H_upper[21] = {0.0f};
    float b[6] = {0.0f};

    float residual_sum = 0.0f;
    float residual_abs_sum = 0.0f;
    float reserved1[7] = {0.0f};
};

struct alignas(64) GoldenHeader {
    uint32_t magic = kGoldenMagic;
    uint32_t version = kFpgaInterfaceVersion;
    uint32_t frame_id = 0;
    uint32_t num_points = 0;

    float R[9] = {1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f};
    float t[3] = {0.0f, 0.0f, 0.0f};

    float H_upper_cpu[21] = {0.0f};
    float b_cpu[6] = {0.0f};

    float residual_sum_cpu = 0.0f;
    float residual_abs_sum_cpu = 0.0f;

    uint32_t reserved[16] = {0};
};

static_assert(sizeof(FpgaCorrInput) == 32, "FpgaCorrInput must be 32 bytes");
static_assert(alignof(FpgaCorrInput) == 32, "FpgaCorrInput must be 32-byte aligned");
static_assert(alignof(FpgaStateInput) == 64, "FpgaStateInput must be 64-byte aligned");
static_assert(alignof(FpgaNormalEqOutput) == 64, "FpgaNormalEqOutput must be 64-byte aligned");
static_assert(alignof(GoldenHeader) == 64, "GoldenHeader must be 64-byte aligned");

}  // namespace lightning::fpga
