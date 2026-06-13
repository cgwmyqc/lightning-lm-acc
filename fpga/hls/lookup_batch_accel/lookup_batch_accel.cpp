#include "lookup_batch_accel.h"

namespace {

constexpr int kInputPointBaseWordOffset = kFpgaLookupParamsWords;
constexpr int kBlockHeaderWords = 4;
constexpr int kResultPlaneWordOffset = 8;
constexpr int kResultCentroidWordOffset = 12;

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

int32_t word_to_int32(uint32_t word) {
#pragma HLS INLINE
    return static_cast<int32_t>(word);
}

float abs_float(float x) {
#pragma HLS INLINE
    return x < 0.0f ? -x : x;
}

int floor_to_int(float x) {
#pragma HLS INLINE
    int i = static_cast<int>(x);
    if (static_cast<float>(i) > x) {
        --i;
    }
    return i;
}

int abs_int(int x) {
#pragma HLS INLINE
    return x < 0 ? -x : x;
}

int div_floor(int a, int b) {
#pragma HLS INLINE
    int q = a / b;
    int r = a - q * b;
    if ((r != 0) && ((r < 0) != (b < 0))) {
        --q;
    }
    return q;
}

int mod_floor(int a, int b) {
#pragma HLS INLINE
    int r = a % b;
    if ((r != 0) && ((r < 0) != (b < 0))) {
        r += b;
    }
    return r;
}

int local_cell_index(int lx, int ly, int lz) {
#pragma HLS INLINE
    return (lz * LIGHTNING_LOOKUP_BY + ly) * LIGHTNING_LOOKUP_BX + lx;
}

void grid_to_block_cell(int gx, int gy, int gz, int* bx, int* by, int* bz, int* cell_idx) {
#pragma HLS INLINE
    *bx = div_floor(gx, LIGHTNING_LOOKUP_BX);
    *by = div_floor(gy, LIGHTNING_LOOKUP_BY);
    *bz = div_floor(gz, LIGHTNING_LOOKUP_BZ);
    *cell_idx = local_cell_index(mod_floor(gx, LIGHTNING_LOOKUP_BX), mod_floor(gy, LIGHTNING_LOOKUP_BY),
                                 mod_floor(gz, LIGHTNING_LOOKUP_BZ));
}

int miss_reason_rank(uint32_t reason) {
#pragma HLS INLINE
    switch (reason) {
        case LIGHTNING_SURFEL_MISS_QUALITY_BAD:
            return 4;
        case LIGHTNING_SURFEL_MISS_SUPPORT_LOW:
            return 3;
        case LIGHTNING_SURFEL_MISS_EMPTY_CELL:
            return 2;
        case LIGHTNING_SURFEL_MISS_NO_BLOCK:
            return 1;
        case LIGHTNING_SURFEL_MISS_NONE:
        default:
            return 0;
    }
}

struct Point {
    float x;
    float y;
    float z;
};

struct ResultLocal {
    uint32_t valid;
    uint32_t fallback;
    uint32_t hit_neighbor;
    uint32_t neighbor_level;
    uint32_t miss_reason;
    uint32_t count;
    float quality;
    float plane[4];
    float centroid[3];
};

void clear_result(ResultLocal* result) {
#pragma HLS INLINE
    result->valid = 0;
    result->fallback = 0;
    result->hit_neighbor = 0;
    result->neighbor_level = 0;
    result->miss_reason = LIGHTNING_SURFEL_MISS_NONE;
    result->count = 0;
    result->quality = 0.0f;
    for (int i = 0; i < 4; ++i) {
#pragma HLS UNROLL
        result->plane[i] = 0.0f;
    }
    for (int i = 0; i < 3; ++i) {
#pragma HLS UNROLL
        result->centroid[i] = 0.0f;
    }
}

bool better_candidate(const ResultLocal& lhs, const ResultLocal& rhs, const Point& point) {
#pragma HLS INLINE
    const float lhs_res =
        abs_float(lhs.plane[0] * point.x + lhs.plane[1] * point.y + lhs.plane[2] * point.z + lhs.plane[3]);
    const float rhs_res =
        abs_float(rhs.plane[0] * point.x + rhs.plane[1] * point.y + rhs.plane[2] * point.z + rhs.plane[3]);
    if (abs_float(lhs_res - rhs_res) > 1.0e-4f) {
        return lhs_res < rhs_res;
    }

    const float lhs_dx = lhs.centroid[0] - point.x;
    const float lhs_dy = lhs.centroid[1] - point.y;
    const float lhs_dz = lhs.centroid[2] - point.z;
    const float rhs_dx = rhs.centroid[0] - point.x;
    const float rhs_dy = rhs.centroid[1] - point.y;
    const float rhs_dz = rhs.centroid[2] - point.z;
    const float lhs_dist = lhs_dx * lhs_dx + lhs_dy * lhs_dy + lhs_dz * lhs_dz;
    const float rhs_dist = rhs_dx * rhs_dx + rhs_dy * rhs_dy + rhs_dz * rhs_dz;
    if (abs_float(lhs_dist - rhs_dist) > 1.0e-4f) {
        return lhs_dist < rhs_dist;
    }

    return lhs.quality < rhs.quality;
}

int find_block(const uint32_t* input, int blocks_base, int num_blocks, int bx, int by, int bz) {
    for (int i = 0; i < num_blocks; ++i) {
#pragma HLS LOOP_TRIPCOUNT min=1 max=512
        const int block_offset = blocks_base + i * kFpgaLookupBlockWords;
        const int32_t block_bx = word_to_int32(input[block_offset + 0]);
        const int32_t block_by = word_to_int32(input[block_offset + 1]);
        const int32_t block_bz = word_to_int32(input[block_offset + 2]);
        if (block_bx == bx && block_by == by && block_bz == bz) {
            return block_offset;
        }
    }
    return -1;
}

bool try_cell(const uint32_t* input, int blocks_base, int num_blocks, int bx, int by, int bz, int cell_idx,
              int neighbor_level, uint32_t min_support, ResultLocal* candidate, uint32_t* miss_reason) {
    const int block_offset = find_block(input, blocks_base, num_blocks, bx, by, bz);
    if (block_offset < 0) {
        *miss_reason = LIGHTNING_SURFEL_MISS_NO_BLOCK;
        return false;
    }

    const int cell_offset = block_offset + kBlockHeaderWords + cell_idx * kFpgaLookupCellWords;
    const uint32_t count = input[cell_offset + 0];
    const uint32_t flags = input[cell_offset + 1];
    if (count == 0) {
        *miss_reason = LIGHTNING_SURFEL_MISS_EMPTY_CELL;
        return false;
    }
    if (count < min_support) {
        *miss_reason = LIGHTNING_SURFEL_MISS_SUPPORT_LOW;
        return false;
    }
    if ((flags & LIGHTNING_CELL_FLAG_VALID_SURFEL) == 0) {
        *miss_reason = LIGHTNING_SURFEL_MISS_QUALITY_BAD;
        return false;
    }

    const float inv_n = 1.0f / static_cast<float>(count);
    candidate->valid = 1;
    candidate->fallback = 0;
    candidate->hit_neighbor = neighbor_level != 0 ? 1u : 0u;
    candidate->neighbor_level = static_cast<uint32_t>(neighbor_level);
    candidate->miss_reason = LIGHTNING_SURFEL_MISS_NONE;
    candidate->count = count;
    candidate->quality = word_to_float(input[cell_offset + 9]);
    candidate->plane[0] = word_to_float(input[cell_offset + 5]);
    candidate->plane[1] = word_to_float(input[cell_offset + 6]);
    candidate->plane[2] = word_to_float(input[cell_offset + 7]);
    candidate->plane[3] = word_to_float(input[cell_offset + 8]);
    candidate->centroid[0] = word_to_float(input[cell_offset + 2]) * inv_n;
    candidate->centroid[1] = word_to_float(input[cell_offset + 3]) * inv_n;
    candidate->centroid[2] = word_to_float(input[cell_offset + 4]) * inv_n;
    return true;
}

void write_result(uint32_t* output, int point_index, const ResultLocal& result) {
    const int offset = point_index * kFpgaLookupResultWords;
    output[offset + 0] = result.valid;
    output[offset + 1] = result.fallback;
    output[offset + 2] = result.hit_neighbor;
    output[offset + 3] = result.neighbor_level;
    output[offset + 4] = result.miss_reason;
    output[offset + 5] = result.count;
    output[offset + 6] = float_to_word(result.quality);
    output[offset + 7] = 0;

    for (int i = 0; i < 4; ++i) {
#pragma HLS UNROLL
        output[offset + kResultPlaneWordOffset + i] = float_to_word(result.plane[i]);
    }
    for (int i = 0; i < 3; ++i) {
#pragma HLS UNROLL
        output[offset + kResultCentroidWordOffset + i] = float_to_word(result.centroid[i]);
    }
    output[offset + 15] = 0;
}

}  // namespace

void lookup_batch_accel(const uint32_t* input, uint32_t* output, int num_points, int num_blocks) {
#pragma HLS INTERFACE m_axi port=input offset=slave bundle=gmem depth=1048576
#pragma HLS INTERFACE m_axi port=output offset=slave bundle=gmem depth=32768
#pragma HLS INTERFACE s_axilite port=input bundle=control
#pragma HLS INTERFACE s_axilite port=output bundle=control
#pragma HLS INTERFACE s_axilite port=num_points bundle=control
#pragma HLS INTERFACE s_axilite port=num_blocks bundle=control
#pragma HLS INTERFACE s_axilite port=return bundle=control

    const float inv_cell_resolution = word_to_float(input[5]);
    const uint32_t min_support = input[6];
    const int lookup_nearby_type = static_cast<int>(input[7]);
    const int blocks_base = kInputPointBaseWordOffset + num_points * kFpgaLookupPointWords;

    for (int i = 0; i < num_points; ++i) {
#pragma HLS LOOP_TRIPCOUNT min=1 max=2048
        const int point_offset = kInputPointBaseWordOffset + i * kFpgaLookupPointWords;
        Point point;
        point.x = word_to_float(input[point_offset + 0]);
        point.y = word_to_float(input[point_offset + 1]);
        point.z = word_to_float(input[point_offset + 2]);

        const int gx = floor_to_int(point.x * inv_cell_resolution);
        const int gy = floor_to_int(point.y * inv_cell_resolution);
        const int gz = floor_to_int(point.z * inv_cell_resolution);

        int bx = 0;
        int by = 0;
        int bz = 0;
        int cell_idx = 0;
        grid_to_block_cell(gx, gy, gz, &bx, &by, &bz, &cell_idx);

        ResultLocal result;
        clear_result(&result);

        ResultLocal exact;
        clear_result(&exact);
        uint32_t exact_miss = LIGHTNING_SURFEL_MISS_NONE;
        if (try_cell(input, blocks_base, num_blocks, bx, by, bz, cell_idx, 0, min_support, &exact, &exact_miss)) {
            write_result(output, i, exact);
            continue;
        }

        uint32_t best_miss = exact_miss;
        if (lookup_nearby_type == 0) {
            result.valid = 0;
            result.miss_reason = best_miss;
            write_result(output, i, result);
            continue;
        }

        bool has_candidate = false;
        ResultLocal best;
        clear_result(&best);
        for (int dx = -1; dx <= 1; ++dx) {
            for (int dy = -1; dy <= 1; ++dy) {
                for (int dz = -1; dz <= 1; ++dz) {
                    if (dx == 0 && dy == 0 && dz == 0) {
                        continue;
                    }
                    const int manhattan = abs_int(dx) + abs_int(dy) + abs_int(dz);
                    if (lookup_nearby_type == 6 && manhattan > 1) {
                        continue;
                    }
                    if (lookup_nearby_type == 18 && manhattan > 2) {
                        continue;
                    }

                    int nb_bx = 0;
                    int nb_by = 0;
                    int nb_bz = 0;
                    int nb_cell_idx = 0;
                    grid_to_block_cell(gx + dx, gy + dy, gz + dz, &nb_bx, &nb_by, &nb_bz, &nb_cell_idx);

                    ResultLocal candidate;
                    clear_result(&candidate);
                    uint32_t miss = LIGHTNING_SURFEL_MISS_NONE;
                    const int neighbor_level = manhattan == 1 ? 6 : (manhattan == 2 ? 18 : 26);
                    if (try_cell(input, blocks_base, num_blocks, nb_bx, nb_by, nb_bz, nb_cell_idx, neighbor_level,
                                 min_support, &candidate, &miss)) {
                        candidate.hit_neighbor = 1;
                        if (!has_candidate || better_candidate(candidate, best, point)) {
                            best = candidate;
                            has_candidate = true;
                        }
                    } else if (miss_reason_rank(miss) > miss_reason_rank(best_miss)) {
                        best_miss = miss;
                    }
                }
            }
        }

        if (has_candidate) {
            write_result(output, i, best);
        } else {
            result.valid = 0;
            result.miss_reason = best_miss;
            write_result(output, i, result);
        }
    }
}
