#ifndef LIGHTNING_FPGA_HLS_LOOKUP_BATCH_ACCEL_H_
#define LIGHTNING_FPGA_HLS_LOOKUP_BATCH_ACCEL_H_

#include <stdint.h>

#define LIGHTNING_FPGA_MAGIC 0x4C464750u
#define LIGHTNING_LOOKUP_GOLDEN_MAGIC 0x4C474C4Bu
#define LIGHTNING_LOOKUP_INTERFACE_VERSION 1u
#define LIGHTNING_LOOKUP_CELLS_PER_BLOCK 256
#define LIGHTNING_LOOKUP_BX 8
#define LIGHTNING_LOOKUP_BY 8
#define LIGHTNING_LOOKUP_BZ 4

#define LIGHTNING_CELL_FLAG_VALID_SURFEL (1u << 1)

#define LIGHTNING_SURFEL_MISS_NONE 0u
#define LIGHTNING_SURFEL_MISS_NO_BLOCK 1u
#define LIGHTNING_SURFEL_MISS_EMPTY_CELL 2u
#define LIGHTNING_SURFEL_MISS_SUPPORT_LOW 3u
#define LIGHTNING_SURFEL_MISS_QUALITY_BAD 4u

struct alignas(16) FpgaLookupPointInput {
    float x;
    float y;
    float z;
    float intensity;
};

struct alignas(16) FpgaLookupParams {
    uint32_t magic;
    uint32_t version;
    uint32_t num_points;
    uint32_t num_blocks;

    float cell_resolution;
    float inv_cell_resolution;
    uint32_t min_support;
    uint32_t lookup_nearby_type;
};

struct alignas(16) FpgaLookupCell {
    uint32_t count;
    uint32_t flags;
    float sum[3];
    float nx;
    float ny;
    float nz;
    float d;
    float quality;
};

struct alignas(16) FpgaLookupBlock {
    int32_t bx;
    int32_t by;
    int32_t bz;
    uint32_t valid_cell_count;
    FpgaLookupCell cells[LIGHTNING_LOOKUP_CELLS_PER_BLOCK];
};

struct alignas(16) FpgaLookupResult {
    uint32_t valid;
    uint32_t fallback;
    uint32_t hit_neighbor;
    uint32_t neighbor_level;

    uint32_t miss_reason;
    uint32_t count;
    float quality;
    float reserved0;

    float plane[4];
    float centroid[3];
    float reserved1;
};

struct alignas(64) LookupGoldenHeader {
    uint32_t magic;
    uint32_t version;
    uint32_t frame_id;
    uint32_t num_points;

    uint32_t num_blocks;
    uint32_t cells_per_block;
    uint32_t result_size;
    uint32_t block_size;

    float cell_resolution;
    float inv_cell_resolution;
    uint32_t min_support;
    uint32_t lookup_nearby_type;

    uint32_t hit_count;
    uint32_t fallback_count;
    uint32_t hit_exact;
    uint32_t hit_neighbor;

    uint32_t miss_no_block;
    uint32_t miss_empty_cell;
    uint32_t miss_support_low;
    uint32_t miss_quality_bad;

    uint32_t reserved[16];
};

static_assert(sizeof(FpgaLookupPointInput) == 16, "FpgaLookupPointInput must be 16 bytes");
static_assert(sizeof(FpgaLookupParams) == 32, "FpgaLookupParams must be 32 bytes");
static_assert(sizeof(FpgaLookupCell) == 48, "FpgaLookupCell must be 48 bytes");
static_assert(sizeof(FpgaLookupBlock) == 12304, "FpgaLookupBlock must be 12304 bytes");
static_assert(sizeof(FpgaLookupResult) == 64, "FpgaLookupResult must be 64 bytes");
static_assert(sizeof(LookupGoldenHeader) == 192, "LookupGoldenHeader must be 192 bytes");

constexpr int kFpgaLookupParamsWords = sizeof(FpgaLookupParams) / sizeof(uint32_t);
constexpr int kFpgaLookupPointWords = sizeof(FpgaLookupPointInput) / sizeof(uint32_t);
constexpr int kFpgaLookupCellWords = sizeof(FpgaLookupCell) / sizeof(uint32_t);
constexpr int kFpgaLookupBlockWords = sizeof(FpgaLookupBlock) / sizeof(uint32_t);
constexpr int kFpgaLookupResultWords = sizeof(FpgaLookupResult) / sizeof(uint32_t);
constexpr int kLookupGoldenHeaderWords = sizeof(LookupGoldenHeader) / sizeof(uint32_t);

void lookup_batch_accel(const uint32_t* input, uint32_t* output, int num_points, int num_blocks);

#endif  // LIGHTNING_FPGA_HLS_LOOKUP_BATCH_ACCEL_H_
