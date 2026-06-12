#pragma once

#include <cstdint>
#include <vector>

#include "fpga/fpga_types.h"

namespace lightning::fpga {

constexpr uint32_t kLookupGoldenMagic = 0x4C474C4B;  // "LGLK"
constexpr uint32_t kLookupInterfaceVersion = 1;
constexpr uint32_t kLookupCellsPerBlock = 8 * 8 * 4;

struct alignas(16) FpgaLookupPointInput {
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float intensity = 0.0f;
};

struct alignas(16) FpgaLookupParams {
    uint32_t magic = kFpgaMagic;
    uint32_t version = kLookupInterfaceVersion;
    uint32_t num_points = 0;
    uint32_t num_blocks = 0;

    float cell_resolution = 0.5f;
    float inv_cell_resolution = 2.0f;
    uint32_t min_support = 5;
    uint32_t lookup_nearby_type = 26;
};

struct alignas(16) FpgaLookupCell {
    uint32_t count = 0;
    uint32_t flags = 0;
    float sum[3] = {0.0f, 0.0f, 0.0f};
    float nx = 0.0f;
    float ny = 0.0f;
    float nz = 0.0f;
    float d = 0.0f;
    float quality = 0.0f;
};

struct alignas(16) FpgaLookupBlock {
    int32_t bx = 0;
    int32_t by = 0;
    int32_t bz = 0;
    uint32_t valid_cell_count = 0;
    FpgaLookupCell cells[kLookupCellsPerBlock];
};

struct alignas(16) FpgaLookupResult {
    uint32_t valid = 0;
    uint32_t fallback = 0;
    uint32_t hit_neighbor = 0;
    uint32_t neighbor_level = 0;

    uint32_t miss_reason = 0;
    uint32_t count = 0;
    float quality = 0.0f;
    float reserved0 = 0.0f;

    float plane[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float centroid[3] = {0.0f, 0.0f, 0.0f};
    float reserved1 = 0.0f;
};

struct alignas(64) LookupGoldenHeader {
    uint32_t magic = kLookupGoldenMagic;
    uint32_t version = kLookupInterfaceVersion;
    uint32_t frame_id = 0;
    uint32_t num_points = 0;

    uint32_t num_blocks = 0;
    uint32_t cells_per_block = kLookupCellsPerBlock;
    uint32_t result_size = sizeof(FpgaLookupResult);
    uint32_t block_size = sizeof(FpgaLookupBlock);

    float cell_resolution = 0.5f;
    float inv_cell_resolution = 2.0f;
    uint32_t min_support = 5;
    uint32_t lookup_nearby_type = 26;

    uint32_t hit_count = 0;
    uint32_t fallback_count = 0;
    uint32_t hit_exact = 0;
    uint32_t hit_neighbor = 0;

    uint32_t miss_no_block = 0;
    uint32_t miss_empty_cell = 0;
    uint32_t miss_support_low = 0;
    uint32_t miss_quality_bad = 0;

    uint32_t reserved[16] = {0};
};

struct LookupBatchInput {
    FpgaLookupParams params;
    std::vector<FpgaLookupPointInput> points;
    std::vector<FpgaLookupBlock> blocks;
};

struct LookupBatchOutput {
    std::vector<FpgaLookupResult> results;
};

static_assert(sizeof(FpgaLookupPointInput) == 16, "FpgaLookupPointInput must be 16 bytes");
static_assert(sizeof(FpgaLookupParams) == 32, "FpgaLookupParams must be 32 bytes");
static_assert(sizeof(FpgaLookupCell) == 48, "FpgaLookupCell must be 48 bytes");
static_assert(sizeof(FpgaLookupResult) == 64, "FpgaLookupResult must be 64 bytes");
static_assert(alignof(LookupGoldenHeader) == 64, "LookupGoldenHeader must be 64-byte aligned");

}  // namespace lightning::fpga
