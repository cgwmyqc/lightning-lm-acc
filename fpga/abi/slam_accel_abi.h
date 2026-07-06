// SPDX-License-Identifier: MIT
#pragma once

#include <cstdint>

namespace lightning {
namespace fpga {

constexpr uint32_t SLAM_ACCEL_ABI_MAGIC = 0x53414C4Du;  // "SLAM"
constexpr uint32_t SLAM_ACCEL_GOLDEN_VERSION = 1u;
constexpr uint32_t SLAM_ACCEL_BLOCK_DIM_X = 8u;
constexpr uint32_t SLAM_ACCEL_BLOCK_DIM_Y = 8u;
constexpr uint32_t SLAM_ACCEL_BLOCK_DIM_Z = 4u;
constexpr uint32_t SLAM_ACCEL_CELLS_PER_BLOCK =
    SLAM_ACCEL_BLOCK_DIM_X * SLAM_ACCEL_BLOCK_DIM_Y * SLAM_ACCEL_BLOCK_DIM_Z;

enum SlamAccelMode : uint32_t {
    MAPPING_OBSERVATION = 0u,
    LOCALIZATION_OBSERVATION = 1u,
};

enum SlamAccelCellFlag : uint32_t {
    OBS_CELL_VALID = 1u << 0,
};

enum SlamAccelObservationFlag : uint32_t {
    SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2 = 1u << 0,
    SLAM_ACCEL_OBS_FLAG_SOLVE6X6 = 1u << 1,
};

struct alignas(16) SlamAccelScanPoint {
    float x = 0.0f;
    float y = 0.0f;
    float z = 0.0f;
    float intensity = 0.0f;
};
static_assert(sizeof(SlamAccelScanPoint) == 16, "SlamAccelScanPoint must be exactly 16B");

struct alignas(32) ActiveBlockRecord {
    int32_t x = 0;
    int32_t y = 0;
    int32_t z = 0;
    uint32_t first_cell = 0;
    uint32_t valid_cell_count = 0;
    uint32_t flags = 0;
    uint32_t reserved[2] = {0, 0};
};
static_assert(sizeof(ActiveBlockRecord) == 32, "ActiveBlockRecord must be exactly 32B");

struct alignas(64) ObsCellFloat64 {
    float centroid_x = 0.0f;
    float centroid_y = 0.0f;
    float centroid_z = 0.0f;
    float normal_x = 0.0f;
    float normal_y = 0.0f;
    float normal_z = 0.0f;
    float plane_d = 0.0f;
    float quality = 0.0f;
    uint32_t count = 0;
    uint32_t flags = 0;
    uint32_t reserved[6] = {0, 0, 0, 0, 0, 0};
};
static_assert(sizeof(ObsCellFloat64) == 64, "ObsCellFloat64 must be exactly 64B");

struct alignas(16) SlamAccelPose {
    float qx = 0.0f;
    float qy = 0.0f;
    float qz = 0.0f;
    float qw = 1.0f;
    float tx = 0.0f;
    float ty = 0.0f;
    float tz = 0.0f;
    uint32_t flags = 0;
};
static_assert(sizeof(SlamAccelPose) == 32, "SlamAccelPose must be exactly 32B");

struct alignas(64) ActiveMapHeader {
    uint32_t magic = SLAM_ACCEL_ABI_MAGIC;
    uint32_t version = SLAM_ACCEL_GOLDEN_VERSION;
    uint32_t mode = LOCALIZATION_OBSERVATION;
    uint32_t cells_per_block = SLAM_ACCEL_CELLS_PER_BLOCK;
    float cell_resolution = 0.5f;
    float inv_cell_resolution = 2.0f;
    uint32_t window_id = 0;
    uint32_t window_version = 0;
    uint32_t num_blocks = 0;
    uint32_t num_cells = 0;
    uint32_t lookup_nearby_type = 26;
    uint32_t flags = 0;
    uint32_t reserved[4] = {0, 0, 0, 0};
};
static_assert(sizeof(ActiveMapHeader) == 64, "ActiveMapHeader must be exactly 64B");

struct alignas(64) SlamAccelObservationParams {
    uint32_t magic = SLAM_ACCEL_ABI_MAGIC;
    uint32_t version = SLAM_ACCEL_GOLDEN_VERSION;
    uint32_t mode = LOCALIZATION_OBSERVATION;
    uint32_t flags = 0;
    float plane_icp_weight = 1.0f;
    float residual_outlier_th = 0.3f;
    float mapping_gate_scale = 81.0f;
    float reserved_scalar = 0.0f;
    float extrinsic_R[9] = {1.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 1.0f};
    float extrinsic_T[3] = {0.0f, 0.0f, 0.0f};
    uint32_t reserved[12] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
};
static_assert(sizeof(SlamAccelObservationParams) == 128, "SlamAccelObservationParams must be exactly 128B");

struct alignas(64) SlamNormalEquation {
    double h_upper[21] = {0.0};
    double b[6] = {0.0};
    uint32_t valid_count = 0;
    uint32_t reject_count = 0;
    uint32_t miss_count = 0;
    uint32_t flags = 0;
    double residual_sum = 0.0;
    double residual_abs_sum = 0.0;
    double residual_max_abs = 0.0;
    uint32_t reserved[4] = {0, 0, 0, 0};
};
static_assert(sizeof(SlamNormalEquation) == 320, "SlamNormalEquation must be exactly 320B");

constexpr uint32_t SLAM_ACCEL_SOLVE6X6_MAGIC = 0x53365836u;  // "S6X6"
constexpr uint32_t SLAM_ACCEL_SOLVE6X6_VERSION = 1u;

enum SlamSolve6x6Status : uint32_t {
    SLAM_SOLVE6X6_DISABLED = 0u,
    SLAM_SOLVE6X6_SUCCESS = 1u,
    SLAM_SOLVE6X6_NON_FINITE_INPUT = 2u,
    SLAM_SOLVE6X6_NON_POSITIVE_PIVOT = 3u,
    SLAM_SOLVE6X6_NON_FINITE_OUTPUT = 4u,
};

struct alignas(64) SlamSolve6x6Result {
    uint32_t magic = SLAM_ACCEL_SOLVE6X6_MAGIC;
    uint32_t version = SLAM_ACCEL_SOLVE6X6_VERSION;
    uint32_t status = SLAM_SOLVE6X6_DISABLED;
    uint32_t flags = 0;
    double dx[6] = {0.0};
    double damping = 0.0;
    double min_pivot = 0.0;
    double max_diag = 0.0;
    double residual_norm = 0.0;
    uint32_t reserved[8] = {0, 0, 0, 0, 0, 0, 0, 0};
};
static_assert(sizeof(SlamSolve6x6Result) == 128, "SlamSolve6x6Result must be exactly 128B");

struct alignas(64) GoldenFileHeader {
    uint32_t magic = SLAM_ACCEL_ABI_MAGIC;
    uint32_t version = SLAM_ACCEL_GOLDEN_VERSION;
    uint32_t record_type = 0;
    uint32_t record_bytes = 0;
    uint32_t record_count = 0;
    uint32_t mode = LOCALIZATION_OBSERVATION;
    uint32_t flags = 0;
    uint32_t reserved[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
};
static_assert(sizeof(GoldenFileHeader) == 64, "GoldenFileHeader must be exactly 64B");

enum GoldenRecordType : uint32_t {
    GOLDEN_SCAN_POINTS = 1u,
    GOLDEN_POSE = 2u,
    GOLDEN_ACTIVE_MAP = 3u,
    GOLDEN_NORMAL_EQUATION = 4u,
};

}  // namespace fpga
}  // namespace lightning
