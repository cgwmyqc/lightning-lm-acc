// SPDX-License-Identifier: MIT

#include "slam_loc_iterative_core.h"

#include <cmath>

namespace lightning {
namespace fpga {
namespace hls {
namespace {

constexpr uint32_t kMaxScanPoints = 8192u;
constexpr double kSolveDamping = 1e-6;
constexpr double kMinPivot = 1e-12;

struct PoseD {
    double qx;
    double qy;
    double qz;
    double qw;
    double tx;
    double ty;
    double tz;
};

struct SolveResult {
    uint32_t status;
    double dx[6];
};

uint32_t Low32(uint64_t v) {
    return static_cast<uint32_t>(v & 0xffffffffULL);
}

uint32_t High32(uint64_t v) {
    return static_cast<uint32_t>((v >> 32) & 0xffffffffULL);
}

uint64_t Pack32(uint32_t lo, uint32_t hi) {
    return static_cast<uint64_t>(lo) | (static_cast<uint64_t>(hi) << 32);
}

double BitsToDouble(uint64_t bits) {
    union {
        uint64_t u;
        double d;
    } v;
    v.u = bits;
    return v.d;
}

uint64_t DoubleToBits(double value) {
    union {
        uint64_t u;
        double d;
    } v;
    v.d = value;
    return v.u;
}

bool CellValid(const ObsCellFloat64& cell) {
    return (cell.flags & OBS_CELL_VALID) != 0u;
}

void NormalizePose(PoseD& pose) {
    const double n2 = pose.qx * pose.qx + pose.qy * pose.qy + pose.qz * pose.qz + pose.qw * pose.qw;
    if (n2 > 0.0 && std::isfinite(n2)) {
        const double inv = 1.0 / std::sqrt(n2);
        pose.qx *= inv;
        pose.qy *= inv;
        pose.qz *= inv;
        pose.qw *= inv;
    } else {
        pose.qx = 0.0;
        pose.qy = 0.0;
        pose.qz = 0.0;
        pose.qw = 1.0;
    }
}

void RotateByQuat(const PoseD& pose, double x, double y, double z, double& ox, double& oy, double& oz) {
    const double qx = pose.qx;
    const double qy = pose.qy;
    const double qz = pose.qz;
    const double qw = pose.qw;
    const double tx = 2.0 * (qy * z - qz * y);
    const double ty = 2.0 * (qz * x - qx * z);
    const double tz = 2.0 * (qx * y - qy * x);
    ox = x + qw * tx + (qy * tz - qz * ty);
    oy = y + qw * ty + (qz * tx - qx * tz);
    oz = z + qw * tz + (qx * ty - qy * tx);
}

void TransformPoint(const PoseD& pose, const SlamAccelScanPoint& scan, double& x, double& y, double& z) {
    RotateByQuat(pose, static_cast<double>(scan.x), static_cast<double>(scan.y), static_cast<double>(scan.z), x, y, z);
    x += pose.tx;
    y += pose.ty;
    z += pose.tz;
}

void LeftUpdatePose(const double dx[6], PoseD& pose) {
    const double rho0 = dx[0];
    const double rho1 = dx[1];
    const double rho2 = dx[2];
    const double w0 = dx[3];
    const double w1 = dx[4];
    const double w2 = dx[5];
    const double theta2 = w0 * w0 + w1 * w1 + w2 * w2;
    const double theta = std::sqrt(theta2);

    double a;
    double b;
    double c;
    double half_scale;
    double dq_w;
    if (theta < 1e-12) {
        a = 1.0 - theta2 / 6.0;
        b = 0.5 - theta2 / 24.0;
        c = 1.0 / 6.0 - theta2 / 120.0;
        half_scale = 0.5 - theta2 / 48.0;
        dq_w = 1.0 - theta2 / 8.0;
    } else {
        a = std::sin(theta) / theta;
        b = (1.0 - std::cos(theta)) / theta2;
        c = (theta - std::sin(theta)) / (theta2 * theta);
        half_scale = std::sin(0.5 * theta) / theta;
        dq_w = std::cos(0.5 * theta);
    }

    const double wxrho0 = w1 * rho2 - w2 * rho1;
    const double wxrho1 = w2 * rho0 - w0 * rho2;
    const double wxrho2 = w0 * rho1 - w1 * rho0;
    const double wdotrho = w0 * rho0 + w1 * rho1 + w2 * rho2;
    const double w2rho0 = w0 * wdotrho - theta2 * rho0;
    const double w2rho1 = w1 * wdotrho - theta2 * rho1;
    const double w2rho2 = w2 * wdotrho - theta2 * rho2;
    const double dt0 = rho0 + b * wxrho0 + c * w2rho0;
    const double dt1 = rho1 + b * wxrho1 + c * w2rho1;
    const double dt2 = rho2 + b * wxrho2 + c * w2rho2;

    PoseD delta;
    delta.qx = half_scale * w0;
    delta.qy = half_scale * w1;
    delta.qz = half_scale * w2;
    delta.qw = dq_w;
    delta.tx = dt0;
    delta.ty = dt1;
    delta.tz = dt2;
    NormalizePose(delta);

    double rt0;
    double rt1;
    double rt2;
    RotateByQuat(delta, pose.tx, pose.ty, pose.tz, rt0, rt1, rt2);
    const double qx = delta.qw * pose.qx + delta.qx * pose.qw + delta.qy * pose.qz - delta.qz * pose.qy;
    const double qy = delta.qw * pose.qy - delta.qx * pose.qz + delta.qy * pose.qw + delta.qz * pose.qx;
    const double qz = delta.qw * pose.qz + delta.qx * pose.qy - delta.qy * pose.qx + delta.qz * pose.qw;
    const double qw = delta.qw * pose.qw - delta.qx * pose.qx - delta.qy * pose.qy - delta.qz * pose.qz;
    pose.qx = qx;
    pose.qy = qy;
    pose.qz = qz;
    pose.qw = qw;
    pose.tx = rt0 + delta.tx;
    pose.ty = rt1 + delta.ty;
    pose.tz = rt2 + delta.tz;
    NormalizePose(pose);
    (void)a;
}

void Accumulate(double h[6][6], double b[6], const double j[6], double residual) {
    for (int r = 0; r < 6; ++r) {
        b[r] += j[r] * residual;
        for (int c = r; c < 6; ++c) {
            h[r][c] += j[r] * j[c];
        }
    }
}

void Solve6x6(double h[6][6], double b[6], SolveResult& solve) {
    solve.status = SLAM_SOLVE6X6_SUCCESS;
    double a[6][6];
    double l[6][6];
    double d[6];
    double rhs[6];
    double y[6];
    double z[6];

    for (int r = 0; r < 6; ++r) {
        rhs[r] = -b[r];
        y[r] = 0.0;
        z[r] = 0.0;
        solve.dx[r] = 0.0;
        for (int c = 0; c < 6; ++c) {
#pragma HLS UNROLL
            const double value = (r <= c) ? h[r][c] : h[c][r];
            a[r][c] = value + ((r == c) ? kSolveDamping : 0.0);
            l[r][c] = (r == c) ? 1.0 : 0.0;
            if (!std::isfinite(a[r][c])) {
                solve.status = SLAM_SOLVE6X6_NON_FINITE_INPUT;
            }
        }
        if (!std::isfinite(rhs[r])) {
            solve.status = SLAM_SOLVE6X6_NON_FINITE_INPUT;
        }
    }
    if (solve.status != SLAM_SOLVE6X6_SUCCESS) {
        return;
    }

    for (int i = 0; i < 6; ++i) {
        for (int j = 0; j < i; ++j) {
            double sum = a[i][j];
            for (int k = 0; k < j; ++k) {
                sum -= l[i][k] * d[k] * l[j][k];
            }
            if (std::fabs(d[j]) <= kMinPivot) {
                solve.status = SLAM_SOLVE6X6_NON_POSITIVE_PIVOT;
                return;
            }
            l[i][j] = sum / d[j];
        }
        double diag = a[i][i];
        for (int k = 0; k < i; ++k) {
            diag -= l[i][k] * l[i][k] * d[k];
        }
        d[i] = diag;
        if (!std::isfinite(diag) || diag <= kMinPivot) {
            solve.status = SLAM_SOLVE6X6_NON_POSITIVE_PIVOT;
            return;
        }
    }
    for (int i = 0; i < 6; ++i) {
        double sum = rhs[i];
        for (int k = 0; k < i; ++k) {
            sum -= l[i][k] * y[k];
        }
        y[i] = sum;
        z[i] = y[i] / d[i];
    }
    for (int i = 5; i >= 0; --i) {
        double sum = z[i];
        for (int k = i + 1; k < 6; ++k) {
            sum -= l[k][i] * solve.dx[k];
        }
        solve.dx[i] = sum;
        if (!std::isfinite(solve.dx[i])) {
            solve.status = SLAM_SOLVE6X6_NON_FINITE_OUTPUT;
            return;
        }
    }
}

void StoreOutput(uint32_t status, uint32_t flags, uint32_t iterations, uint32_t valid_count, uint32_t reject_count,
                 uint32_t miss_count, const PoseD& pose, const double last_dx[6], double residual_sum,
                 double residual_abs_sum, double residual_max_abs, double score, uint64_t* output_words) {
    for (int i = 0; i < static_cast<int>(LOC_ITER_OUTPUT_WORDS); ++i) {
        output_words[i] = 0u;
    }
    output_words[LOC_ITER_OUT_MAGIC_VERSION] = Pack32(SLAM_LOC_ITER_MAGIC, SLAM_LOC_ITER_VERSION);
    output_words[LOC_ITER_OUT_STATUS_FLAGS] = Pack32(status, flags);
    output_words[LOC_ITER_OUT_ITERATIONS_COUNTS0] = Pack32(iterations, valid_count);
    output_words[LOC_ITER_OUT_COUNTS1] = Pack32(reject_count, miss_count);
    output_words[LOC_ITER_OUT_FINAL_POSE_QX] = DoubleToBits(pose.qx);
    output_words[LOC_ITER_OUT_FINAL_POSE_QY] = DoubleToBits(pose.qy);
    output_words[LOC_ITER_OUT_FINAL_POSE_QZ] = DoubleToBits(pose.qz);
    output_words[LOC_ITER_OUT_FINAL_POSE_QW] = DoubleToBits(pose.qw);
    output_words[LOC_ITER_OUT_FINAL_POSE_TX] = DoubleToBits(pose.tx);
    output_words[LOC_ITER_OUT_FINAL_POSE_TY] = DoubleToBits(pose.ty);
    output_words[LOC_ITER_OUT_FINAL_POSE_TZ] = DoubleToBits(pose.tz);
    for (int i = 0; i < 6; ++i) {
        output_words[LOC_ITER_OUT_LAST_DX0 + i] = DoubleToBits(last_dx[i]);
    }
    output_words[LOC_ITER_OUT_RESIDUAL_SUM] = DoubleToBits(residual_sum);
    output_words[LOC_ITER_OUT_RESIDUAL_ABS_SUM] = DoubleToBits(residual_abs_sum);
    output_words[LOC_ITER_OUT_RESIDUAL_MAX_ABS] = DoubleToBits(residual_max_abs);
    output_words[LOC_ITER_OUT_SCORE] = DoubleToBits(score);
}

void RunLocIter(const SlamAccelScanPoint* scan_points, const ObsCellFloat64* candidate_cells,
                const uint64_t* input_words, uint64_t* output_words) {
    const uint64_t magic_version = input_words[LOC_ITER_IN_MAGIC_VERSION];
    const uint32_t magic = Low32(magic_version);
    const uint32_t version = High32(magic_version);
    if (magic != SLAM_LOC_ITER_MAGIC || version != SLAM_LOC_ITER_VERSION) {
        PoseD identity = {0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0};
        double zero_dx[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
        StoreOutput(SLAM_LOC_ITER_BAD_MAGIC, 0u, 0u, 0u, 0u, 0u, identity, zero_dx, 0.0, 0.0, 0.0, 0.0,
                    output_words);
        return;
    }

    const uint64_t count_word = input_words[LOC_ITER_IN_NUM_POINTS_MAX_ITERS];
    const uint32_t num_points = Low32(count_word);
    const uint32_t max_iterations = High32(count_word);
    const uint32_t min_valid_count = Low32(input_words[LOC_ITER_IN_MIN_VALID_COUNT_RESERVED]);

    PoseD pose;
    pose.qx = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_QX]);
    pose.qy = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_QY]);
    pose.qz = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_QZ]);
    pose.qw = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_QW]);
    pose.tx = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_TX]);
    pose.ty = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_TY]);
    pose.tz = BitsToDouble(input_words[LOC_ITER_IN_INITIAL_POSE_TZ]);
    NormalizePose(pose);

    const double residual_outlier_th = BitsToDouble(input_words[LOC_ITER_IN_RESIDUAL_OUTLIER_TH]);
    const double conv_trans = BitsToDouble(input_words[LOC_ITER_IN_CONVERGENCE_TRANSLATION]);
    const double conv_rot = BitsToDouble(input_words[LOC_ITER_IN_CONVERGENCE_ROTATION]);
    double last_dx[6] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
    uint32_t status = SLAM_LOC_ITER_SUCCESS;
    uint32_t flags = SLAM_ACCEL_OBS_FLAG_CANDIDATE_ABI_V2;
    uint32_t iterations_done = 0u;
    uint32_t valid_count = 0u;
    uint32_t reject_count = 0u;
    uint32_t miss_count = 0u;
    double residual_sum = 0.0;
    double residual_abs_sum = 0.0;
    double residual_max_abs = 0.0;

    if (num_points == 0u || num_points > kMaxScanPoints || max_iterations == 0u) {
        StoreOutput(SLAM_LOC_ITER_INVALID_COUNT, flags, 0u, 0u, 0u, 0u, pose, last_dx, 0.0, 0.0, 0.0, 0.0,
                    output_words);
        return;
    }

    for (uint32_t iter = 0; iter < max_iterations; ++iter) {
#pragma HLS LOOP_TRIPCOUNT min = 1 max = 8 avg = 4
        double h[6][6] = {{0.0}};
        double b[6] = {0.0};
        valid_count = 0u;
        reject_count = 0u;
        miss_count = 0u;
        residual_sum = 0.0;
        residual_abs_sum = 0.0;
        residual_max_abs = 0.0;

        for (uint32_t i = 0; i < num_points; ++i) {
#pragma HLS LOOP_TRIPCOUNT min = 1 max = 8192 avg = 1024
            const SlamAccelScanPoint scan = scan_points[i];
            if (!std::isfinite(scan.x) || !std::isfinite(scan.y) || !std::isfinite(scan.z)) {
                ++reject_count;
                continue;
            }
            const ObsCellFloat64 cell = candidate_cells[i];
            if (!CellValid(cell)) {
                ++miss_count;
                continue;
            }
            double px;
            double py;
            double pz;
            TransformPoint(pose, scan, px, py, pz);
            const double nx = cell.normal_x;
            const double ny = cell.normal_y;
            const double nz = cell.normal_z;
            const double residual = nx * px + ny * py + nz * pz + cell.plane_d;
            const double abs_residual = std::fabs(residual);
            if (!std::isfinite(residual) || abs_residual > residual_outlier_th) {
                ++reject_count;
                continue;
            }
            double j[6];
            j[0] = nx;
            j[1] = ny;
            j[2] = nz;
            j[3] = nz * py - ny * pz;
            j[4] = nx * pz - nz * px;
            j[5] = ny * px - nx * py;
            Accumulate(h, b, j, residual);
            ++valid_count;
            residual_sum += residual;
            residual_abs_sum += abs_residual;
            if (abs_residual > residual_max_abs) {
                residual_max_abs = abs_residual;
            }
        }

        iterations_done = iter + 1u;
        if (valid_count == 0u) {
            status = SLAM_LOC_ITER_NO_VALID_OBSERVATION;
            break;
        }

        SolveResult solve;
        Solve6x6(h, b, solve);
        if (solve.status != SLAM_SOLVE6X6_SUCCESS) {
            status = SLAM_LOC_ITER_SOLVE_FAILED;
            break;
        }
        for (int i = 0; i < 6; ++i) {
            last_dx[i] = solve.dx[i];
        }
        const double trans_step =
            std::sqrt(last_dx[0] * last_dx[0] + last_dx[1] * last_dx[1] + last_dx[2] * last_dx[2]);
        const double rot_step =
            std::sqrt(last_dx[3] * last_dx[3] + last_dx[4] * last_dx[4] + last_dx[5] * last_dx[5]);
        LeftUpdatePose(last_dx, pose);
        if (!std::isfinite(pose.tx) || !std::isfinite(pose.ty) || !std::isfinite(pose.tz) ||
            !std::isfinite(pose.qw)) {
            status = SLAM_LOC_ITER_NON_FINITE;
            break;
        }
        if (trans_step < conv_trans && rot_step < conv_rot) {
            flags |= 0x100u;
            break;
        }
    }

    const double mean_abs =
        valid_count > 0u ? residual_abs_sum / static_cast<double>(valid_count) : 0.0;
    const double inlier_ratio = static_cast<double>(valid_count) / static_cast<double>(num_points);
    const double score = 4.0 * inlier_ratio / (1.0 + 10.0 * mean_abs);
    if (valid_count < min_valid_count) {
        flags |= 0x200u;
    }
    StoreOutput(status, flags, iterations_done, valid_count, reject_count, miss_count, pose, last_dx, residual_sum,
                residual_abs_sum, residual_max_abs, score, output_words);
}

}  // namespace
}  // namespace hls
}  // namespace fpga
}  // namespace lightning

extern "C" void slam_loc_iterative_core(const lightning::fpga::SlamAccelScanPoint* scan_points,
                                         const lightning::fpga::ObsCellFloat64* candidate_cells,
                                         const uint64_t* input_words, uint64_t* output_words) {
#pragma HLS INTERFACE ap_ctrl_hs port = return
#pragma HLS INTERFACE m_axi port = scan_points offset = direct bundle = gmem0 depth = 8192
#pragma HLS INTERFACE m_axi port = candidate_cells offset = direct bundle = gmem1 depth = 8192
#pragma HLS INTERFACE m_axi port = input_words offset = direct bundle = gmem2 depth = 16
#pragma HLS INTERFACE m_axi port = output_words offset = direct bundle = gmem3 depth = 32
#pragma HLS DATA_PACK variable = scan_points
#pragma HLS DATA_PACK variable = candidate_cells
    lightning::fpga::hls::RunLocIter(scan_points, candidate_cells, input_words, output_words);
}
