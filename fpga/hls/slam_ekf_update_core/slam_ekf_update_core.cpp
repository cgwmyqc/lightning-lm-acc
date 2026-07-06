// SPDX-License-Identifier: MIT
#include "slam_ekf_update_core.h"

#include <math.h>

namespace slam_ekf_update_hls {
namespace {

union U64Double {
    uint64_t u;
    double d;
};

uint64_t pack_u32_pair(uint32_t lo, uint32_t hi) {
    return (static_cast<uint64_t>(hi) << 32) | static_cast<uint64_t>(lo);
}

double u64_to_double(uint64_t v) {
    U64Double c;
    c.u = v;
    return c.d;
}

uint64_t double_to_u64(double v) {
    U64Double c;
    c.d = v;
    return c.u;
}

double absd(double v) {
    return v < 0.0 ? -v : v;
}

bool finite_double(double v) {
    return isfinite(v) != 0;
}

int idx(int row, int col, int rows) {
    return row + col * rows;
}

void set_zero_12(double a[STATE_DIM][STATE_DIM]) {
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            a[r][c] = 0.0;
        }
    }
}

void set_identity_12(double a[STATE_DIM][STATE_DIM]) {
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            a[r][c] = (r == c) ? 1.0 : 0.0;
        }
    }
}

void set_identity_6(double a[OBS_DIM][OBS_DIM]) {
    for (int r = 0; r < OBS_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            a[r][c] = (r == c) ? 1.0 : 0.0;
        }
    }
}

void mat12_copy(double dst[STATE_DIM][STATE_DIM], const double src[STATE_DIM][STATE_DIM]) {
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            dst[r][c] = src[r][c];
        }
    }
}

void mat6_vec_mul(const double a[OBS_DIM][OBS_DIM], const double x[OBS_DIM], double y[OBS_DIM]) {
    for (int r = 0; r < OBS_DIM; ++r) {
        double s = 0.0;
        for (int c = 0; c < OBS_DIM; ++c) {
            s += a[r][c] * x[c];
        }
        y[r] = s;
    }
}

void skew(const double v[3], double s[3][3]) {
    s[0][0] = 0.0;
    s[0][1] = -v[2];
    s[0][2] = v[1];
    s[1][0] = v[2];
    s[1][1] = 0.0;
    s[1][2] = -v[0];
    s[2][0] = -v[1];
    s[2][1] = v[0];
    s[2][2] = 0.0;
}

void so3_a_matrix_transpose(const double v[3], double jt[3][3]) {
    double norm2 = v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
    double norm = sqrt(norm2);
    double a[3][3];
    double vx[3][3];
    double vx2[3][3];
    skew(v, vx);
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            double s = 0.0;
            for (int k = 0; k < 3; ++k) {
                s += vx[r][k] * vx[k][c];
            }
            vx2[r][c] = s;
        }
    }
    if (norm < 1e-5) {
        for (int r = 0; r < 3; ++r) {
            for (int c = 0; c < 3; ++c) {
                a[r][c] = (r == c) ? 1.0 : 0.0;
            }
        }
    } else {
        const double c1 = (1.0 - cos(norm)) / norm2;
        const double c2 = (1.0 - sin(norm) / norm) / norm2;
        for (int r = 0; r < 3; ++r) {
            for (int c = 0; c < 3; ++c) {
                a[r][c] = ((r == c) ? 1.0 : 0.0) + c1 * vx[r][c] + c2 * vx2[r][c];
            }
        }
    }
    for (int r = 0; r < 3; ++r) {
        for (int c = 0; c < 3; ++c) {
            jt[r][c] = a[c][r];
        }
    }
}

void quat_normalize(double q[4]) {
    double n = sqrt(q[0] * q[0] + q[1] * q[1] + q[2] * q[2] + q[3] * q[3]);
    if (n < 1e-30) {
        q[0] = q[1] = q[2] = 0.0;
        q[3] = 1.0;
        return;
    }
    for (int i = 0; i < 4; ++i) {
        q[i] /= n;
    }
}

void quat_mul_xyzw(const double a[4], const double b[4], double out[4]) {
    const double ax = a[0], ay = a[1], az = a[2], aw = a[3];
    const double bx = b[0], by = b[1], bz = b[2], bw = b[3];
    out[0] = aw * bx + ax * bw + ay * bz - az * by;
    out[1] = aw * by - ax * bz + ay * bw + az * bx;
    out[2] = aw * bz + ax * by - ay * bx + az * bw;
    out[3] = aw * bw - ax * bx - ay * by - az * bz;
}

void so3_exp_quat(const double v[3], double q[4]) {
    const double theta = sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
    if (theta < 1e-12) {
        q[0] = 0.5 * v[0];
        q[1] = 0.5 * v[1];
        q[2] = 0.5 * v[2];
        q[3] = 1.0;
        quat_normalize(q);
        return;
    }
    const double half = 0.5 * theta;
    const double scale = sin(half) / theta;
    q[0] = scale * v[0];
    q[1] = scale * v[1];
    q[2] = scale * v[2];
    q[3] = cos(half);
}

bool invert12(const double a[STATE_DIM][STATE_DIM], double inv[STATE_DIM][STATE_DIM]) {
    double aug[STATE_DIM][STATE_DIM * 2];
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            aug[r][c] = a[r][c];
            aug[r][c + STATE_DIM] = (r == c) ? 1.0 : 0.0;
        }
    }

    for (int col = 0; col < STATE_DIM; ++col) {
        int pivot = col;
        double best = absd(aug[col][col]);
        for (int r = col + 1; r < STATE_DIM; ++r) {
            double v = absd(aug[r][col]);
            if (v > best) {
                best = v;
                pivot = r;
            }
        }
        if (best < 1e-24) {
            return false;
        }
        if (pivot != col) {
            for (int c = 0; c < STATE_DIM * 2; ++c) {
                double tmp = aug[col][c];
                aug[col][c] = aug[pivot][c];
                aug[pivot][c] = tmp;
            }
        }
        double diag = aug[col][col];
        for (int c = 0; c < STATE_DIM * 2; ++c) {
            aug[col][c] /= diag;
        }
        for (int r = 0; r < STATE_DIM; ++r) {
            if (r == col) {
                continue;
            }
            double factor = aug[r][col];
            for (int c = 0; c < STATE_DIM * 2; ++c) {
                aug[r][c] -= factor * aug[col][c];
            }
        }
    }

    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            inv[r][c] = aug[r][c + STATE_DIM];
        }
    }
    return true;
}

void jacobi_eigen6(const double in[OBS_DIM][OBS_DIM], double values[OBS_DIM], double vectors[OBS_DIM][OBS_DIM]) {
    double a[OBS_DIM][OBS_DIM];
    for (int r = 0; r < OBS_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            a[r][c] = in[r][c];
        }
    }
    set_identity_6(vectors);

    for (int sweep = 0; sweep < 80; ++sweep) {
        int p = 0;
        int q = 1;
        double max_off = absd(a[0][1]);
        for (int i = 0; i < OBS_DIM; ++i) {
            for (int j = i + 1; j < OBS_DIM; ++j) {
                double v = absd(a[i][j]);
                if (v > max_off) {
                    max_off = v;
                    p = i;
                    q = j;
                }
            }
        }
        if (max_off < 1e-12) {
            break;
        }

        const double app = a[p][p];
        const double aqq = a[q][q];
        const double apq = a[p][q];
        const double tau = (aqq - app) / (2.0 * apq);
        const double t = (tau >= 0.0 ? 1.0 : -1.0) / (absd(tau) + sqrt(1.0 + tau * tau));
        const double cs = 1.0 / sqrt(1.0 + t * t);
        const double sn = t * cs;

        for (int k = 0; k < OBS_DIM; ++k) {
            if (k != p && k != q) {
                const double akp = a[k][p];
                const double akq = a[k][q];
                a[k][p] = cs * akp - sn * akq;
                a[p][k] = a[k][p];
                a[k][q] = sn * akp + cs * akq;
                a[q][k] = a[k][q];
            }
        }
        a[p][p] = app - t * apq;
        a[q][q] = aqq + t * apq;
        a[p][q] = 0.0;
        a[q][p] = 0.0;

        for (int k = 0; k < OBS_DIM; ++k) {
            const double vkp = vectors[k][p];
            const double vkq = vectors[k][q];
            vectors[k][p] = cs * vkp - sn * vkq;
            vectors[k][q] = sn * vkp + cs * vkq;
        }
    }

    for (int i = 0; i < OBS_DIM; ++i) {
        values[i] = a[i][i];
    }
}

void symmetrize_floor(double p[STATE_DIM][STATE_DIM], double min_cov_diag) {
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = r + 1; c < STATE_DIM; ++c) {
            double v = 0.5 * (p[r][c] + p[c][r]);
            p[r][c] = v;
            p[c][r] = v;
        }
    }
    for (int r = 0; r < STATE_DIM; ++r) {
        if (p[r][r] < min_cov_diag) {
            p[r][r] = min_cov_diag;
        } else if (p[r][r] > 100.0) {
            p[r][r] = 100.0;
        }
        for (int c = 0; c < STATE_DIM; ++c) {
            if (!finite_double(p[r][c])) {
                p[r][c] = 1.0;
            }
        }
    }
}

void write_mat12(uint64_t* out, int base, const double a[STATE_DIM][STATE_DIM]) {
    for (int c = 0; c < STATE_DIM; ++c) {
        for (int r = 0; r < STATE_DIM; ++r) {
            out[base + idx(r, c, STATE_DIM)] = double_to_u64(a[r][c]);
        }
    }
}

void write_mat6(uint64_t* out, int base, const double a[OBS_DIM][OBS_DIM]) {
    for (int c = 0; c < OBS_DIM; ++c) {
        for (int r = 0; r < OBS_DIM; ++r) {
            out[base + idx(r, c, OBS_DIM)] = double_to_u64(a[r][c]);
        }
    }
}

}  // namespace

void slam_ekf_update_core_impl(const uint64_t* input_words, uint64_t* output_words) {
    double current_state[17];
    double p_in[STATE_DIM][STATE_DIM];
    double p_work[STATE_DIM][STATE_DIM];
    double hth[OBS_DIM][OBS_DIM];
    double hth_sym[OBS_DIM][OBS_DIM];
    double htr[OBS_DIM];
    double dx_current[STATE_DIM];
    double limit[STATE_DIM];

    for (int i = 0; i < 17; ++i) {
        current_state[i] = u64_to_double(input_words[IN_CURRENT_STATE + i]);
    }
    for (int c = 0; c < STATE_DIM; ++c) {
        for (int r = 0; r < STATE_DIM; ++r) {
            p_in[r][c] = u64_to_double(input_words[IN_PROPAGATED_COV + idx(r, c, STATE_DIM)]);
        }
    }
    for (int c = 0; c < OBS_DIM; ++c) {
        for (int r = 0; r < OBS_DIM; ++r) {
            hth[r][c] = u64_to_double(input_words[IN_HTH + idx(r, c, OBS_DIM)]);
        }
    }
    for (int i = 0; i < OBS_DIM; ++i) {
        htr[i] = u64_to_double(input_words[IN_HTR + i]);
    }
    for (int i = 0; i < STATE_DIM; ++i) {
        dx_current[i] = u64_to_double(input_words[IN_DX_FROM_START + i]);
        limit[i] = u64_to_double(input_words[IN_LIMIT + i]);
    }

    const double R = u64_to_double(input_words[IN_PARAMS + 0]);
    const double degeneracy_threshold_ratio = u64_to_double(input_words[IN_PARAMS + 1]);
    const double degeneracy_cov_inflation = u64_to_double(input_words[IN_PARAMS + 2]);
    const double min_cov_diag = u64_to_double(input_words[IN_PARAMS + 3]);
    const double max_update_translation_step = u64_to_double(input_words[IN_PARAMS + 4]);
    const double max_update_rotation_step_deg = u64_to_double(input_words[IN_PARAMS + 5]);
    const bool finish_update = (input_words[IN_FLAGS] & 1u) != 0;

    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            p_work[r][c] = p_in[r][c];
        }
    }

    double j_so3[3][3];
    so3_a_matrix_transpose(&dx_current[3], j_so3);
    double dx_rot[3] = {dx_current[3], dx_current[4], dx_current[5]};
    for (int r = 0; r < 3; ++r) {
        double s = 0.0;
        for (int c = 0; c < 3; ++c) {
            s += j_so3[r][c] * dx_rot[c];
        }
        dx_current[3 + r] = s;
    }

    for (int c = 0; c < STATE_DIM; ++c) {
        double old_col[3] = {p_work[3][c], p_work[4][c], p_work[5][c]};
        for (int r = 0; r < 3; ++r) {
            p_work[3 + r][c] = j_so3[r][0] * old_col[0] + j_so3[r][1] * old_col[1] + j_so3[r][2] * old_col[2];
        }
    }
    for (int r = 0; r < STATE_DIM; ++r) {
        double old_row[3] = {p_work[r][3], p_work[r][4], p_work[r][5]};
        for (int c = 0; c < 3; ++c) {
            p_work[r][3 + c] = old_row[0] * j_so3[c][0] + old_row[1] * j_so3[c][1] + old_row[2] * j_so3[c][2];
        }
    }

    for (int r = 0; r < OBS_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            hth_sym[r][c] = 0.5 * (hth[r][c] + hth[c][r]);
        }
    }

    double eigen_values[OBS_DIM];
    double eigen_vectors[OBS_DIM][OBS_DIM];
    jacobi_eigen6(hth_sym, eigen_values, eigen_vectors);
    double max_eigen = 1e-12;
    for (int i = 0; i < OBS_DIM; ++i) {
        if (eigen_values[i] > max_eigen) {
            max_eigen = eigen_values[i];
        }
    }
    const double degeneracy_threshold = max_eigen * degeneracy_threshold_ratio;
    double mask[OBS_DIM];
    int nullity = 0;
    for (int i = 0; i < OBS_DIM; ++i) {
        if (eigen_values[i] > degeneracy_threshold) {
            mask[i] = 1.0;
        } else {
            mask[i] = 0.0;
            ++nullity;
        }
    }

    double projector[OBS_DIM][OBS_DIM];
    for (int r = 0; r < OBS_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            double s = 0.0;
            for (int k = 0; k < OBS_DIM; ++k) {
                s += eigen_vectors[r][k] * mask[k] * eigen_vectors[c][k];
            }
            projector[r][c] = s;
        }
    }

    double tmp6[OBS_DIM][OBS_DIM];
    double hth_eff[OBS_DIM][OBS_DIM];
    for (int r = 0; r < OBS_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            double s = 0.0;
            for (int k = 0; k < OBS_DIM; ++k) {
                s += projector[r][k] * hth_sym[k][c];
            }
            tmp6[r][c] = s;
        }
    }
    for (int r = 0; r < OBS_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            double s = 0.0;
            for (int k = 0; k < OBS_DIM; ++k) {
                s += tmp6[r][k] * projector[k][c];
            }
            hth_eff[r][c] = s;
        }
    }
    double htr_eff[OBS_DIM];
    mat6_vec_mul(projector, htr, htr_eff);

    double p_scaled[STATE_DIM][STATE_DIM];
    double p_scaled_inv[STATE_DIM][STATE_DIM];
    double q_inv[STATE_DIM][STATE_DIM];
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            p_scaled[r][c] = p_work[r][c] / R;
        }
    }
    if (!invert12(p_scaled, p_scaled_inv)) {
        output_words[OUT_MAGIC_VERSION] = pack_u32_pair(SLAM_EKF_UPDATE_OUT_MAGIC, SLAM_EKF_UPDATE_VERSION);
        output_words[OUT_STATUS] = STATUS_INVERSE_FAILED;
        output_words[OUT_NULLITY] = static_cast<uint64_t>(nullity);
        return;
    }
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < STATE_DIM; ++c) {
            p_scaled_inv[r][c] += (r < OBS_DIM && c < OBS_DIM) ? hth_eff[r][c] : 0.0;
        }
    }
    if (!invert12(p_scaled_inv, q_inv)) {
        output_words[OUT_MAGIC_VERSION] = pack_u32_pair(SLAM_EKF_UPDATE_OUT_MAGIC, SLAM_EKF_UPDATE_VERSION);
        output_words[OUT_STATUS] = STATUS_INVERSE_FAILED;
        output_words[OUT_NULLITY] = static_cast<uint64_t>(nullity);
        return;
    }

    double k_r[STATE_DIM];
    for (int r = 0; r < STATE_DIM; ++r) {
        double s = 0.0;
        for (int c = 0; c < OBS_DIM; ++c) {
            s += q_inv[r][c] * htr_eff[c];
        }
        k_r[r] = s;
    }
    double k_h[STATE_DIM][STATE_DIM];
    set_zero_12(k_h);
    for (int r = 0; r < STATE_DIM; ++r) {
        for (int c = 0; c < OBS_DIM; ++c) {
            double s = 0.0;
            for (int k = 0; k < OBS_DIM; ++k) {
                s += q_inv[r][k] * hth_eff[k][c];
            }
            k_h[r][c] = s;
        }
    }

    double dx_new[STATE_DIM];
    for (int r = 0; r < STATE_DIM; ++r) {
        double s = k_r[r] - dx_current[r];
        for (int c = 0; c < STATE_DIM; ++c) {
            s += k_h[r][c] * dx_current[c];
        }
        dx_new[r] = s;
    }
    for (int i = 0; i < STATE_DIM; ++i) {
        dx_current[i] = dx_new[i];
    }

    uint32_t status = 0;
    for (int i = 0; i < STATE_DIM; ++i) {
        if (!finite_double(dx_current[i])) {
            status |= STATUS_NAN_DX;
        }
    }

    double dx_translation = sqrt(dx_current[0] * dx_current[0] + dx_current[1] * dx_current[1] +
                                 dx_current[2] * dx_current[2]);
    double dx_rotation_norm = sqrt(dx_current[3] * dx_current[3] + dx_current[4] * dx_current[4] +
                                   dx_current[5] * dx_current[5]);
    double dx_rotation_deg = dx_rotation_norm * 180.0 / 3.14159265358979323846;
    double dx_norm = 0.0;
    for (int i = 0; i < STATE_DIM; ++i) {
        dx_norm += dx_current[i] * dx_current[i];
    }
    dx_norm = sqrt(dx_norm);

    if (dx_translation > max_update_translation_step || dx_rotation_deg > max_update_rotation_step_deg) {
        status |= STATUS_STEP_REJECTED | STATUS_REJECTED;
    }

    double updated_state[17];
    for (int i = 0; i < 17; ++i) {
        updated_state[i] = current_state[i];
    }
    updated_state[1] += dx_current[0];
    updated_state[2] += dx_current[1];
    updated_state[3] += dx_current[2];
    double dq[4];
    so3_exp_quat(&dx_current[3], dq);
    double q_cur[4] = {current_state[4], current_state[5], current_state[6], current_state[7]};
    double q_new[4];
    quat_mul_xyzw(q_cur, dq, q_new);
    quat_normalize(q_new);
    updated_state[4] = q_new[0];
    updated_state[5] = q_new[1];
    updated_state[6] = q_new[2];
    updated_state[7] = q_new[3];
    for (int i = 0; i < 3; ++i) {
        updated_state[8 + i] += dx_current[6 + i];
        updated_state[11 + i] += dx_current[9 + i];
    }

    bool converged = true;
    for (int i = 0; i < STATE_DIM; ++i) {
        if (absd(dx_current[i]) > limit[i]) {
            converged = false;
        }
    }

    double updated_cov[STATE_DIM][STATE_DIM];
    mat12_copy(updated_cov, p_work);
    if (finish_update && ((status & (STATUS_NAN_DX | STATUS_STEP_REJECTED)) == 0)) {
        double j_final[3][3];
        so3_a_matrix_transpose(&dx_current[3], j_final);
        double l_mat[STATE_DIM][STATE_DIM];
        double k_h_final[STATE_DIM][STATE_DIM];
        double p_final_input[STATE_DIM][STATE_DIM];
        mat12_copy(l_mat, p_work);
        mat12_copy(k_h_final, k_h);
        mat12_copy(p_final_input, p_work);
        for (int c = 0; c < STATE_DIM; ++c) {
            double old_col[3] = {l_mat[3][c], l_mat[4][c], l_mat[5][c]};
            for (int r = 0; r < 3; ++r) {
                l_mat[3 + r][c] =
                    j_final[r][0] * old_col[0] + j_final[r][1] * old_col[1] + j_final[r][2] * old_col[2];
            }
        }
        for (int c = 0; c < OBS_DIM; ++c) {
            double old_col[3] = {k_h_final[3][c], k_h_final[4][c], k_h_final[5][c]};
            for (int r = 0; r < 3; ++r) {
                k_h_final[3 + r][c] =
                    j_final[r][0] * old_col[0] + j_final[r][1] * old_col[1] + j_final[r][2] * old_col[2];
            }
        }
        for (int r = 0; r < STATE_DIM; ++r) {
            double old_l[3] = {l_mat[r][3], l_mat[r][4], l_mat[r][5]};
            double old_p[3] = {p_final_input[r][3], p_final_input[r][4], p_final_input[r][5]};
            for (int c = 0; c < 3; ++c) {
                l_mat[r][3 + c] = old_l[0] * j_final[c][0] + old_l[1] * j_final[c][1] + old_l[2] * j_final[c][2];
                p_final_input[r][3 + c] =
                    old_p[0] * j_final[c][0] + old_p[1] * j_final[c][1] + old_p[2] * j_final[c][2];
            }
        }
        for (int r = 0; r < STATE_DIM; ++r) {
            for (int c = 0; c < STATE_DIM; ++c) {
                double s = l_mat[r][c];
                for (int k = 0; k < OBS_DIM; ++k) {
                    s -= k_h_final[r][k] * p_final_input[k][c];
                }
                updated_cov[r][c] = s;
            }
        }
        if (nullity > 0) {
            for (int r = 0; r < OBS_DIM; ++r) {
                for (int c = 0; c < OBS_DIM; ++c) {
                    updated_cov[r][c] *= degeneracy_cov_inflation;
                }
            }
        }
        symmetrize_floor(updated_cov, min_cov_diag);
        status |= STATUS_COVARIANCE_FINALIZED;
    }

    if ((status & (STATUS_NAN_DX | STATUS_STEP_REJECTED)) == 0) {
        status |= STATUS_SUCCESS;
    }
    if (converged) {
        status |= STATUS_CONVERGED;
    }

    output_words[OUT_MAGIC_VERSION] = pack_u32_pair(SLAM_EKF_UPDATE_OUT_MAGIC, SLAM_EKF_UPDATE_VERSION);
    output_words[OUT_STATUS] = static_cast<uint64_t>(status);
    output_words[OUT_NULLITY] = static_cast<uint64_t>(nullity);
    for (int i = 0; i < STATE_DIM; ++i) {
        output_words[OUT_DX_CURRENT + i] = double_to_u64(dx_current[i]);
        output_words[OUT_K_R + i] = double_to_u64(k_r[i]);
    }
    write_mat12(output_words, OUT_K_H, k_h);
    write_mat6(output_words, OUT_HTH_EFF, hth_eff);
    for (int i = 0; i < OBS_DIM; ++i) {
        output_words[OUT_HTR_EFF + i] = double_to_u64(htr_eff[i]);
    }
    for (int i = 0; i < 17; ++i) {
        output_words[OUT_UPDATED_STATE + i] = double_to_u64(updated_state[i]);
    }
    write_mat12(output_words, OUT_WORKING_COV, p_work);
    write_mat12(output_words, OUT_UPDATED_COV, updated_cov);
    output_words[OUT_DIAGNOSTICS + 0] = double_to_u64(dx_translation);
    output_words[OUT_DIAGNOSTICS + 1] = double_to_u64(dx_rotation_deg);
    output_words[OUT_DIAGNOSTICS + 2] = double_to_u64(dx_norm);
    output_words[OUT_DIAGNOSTICS + 3] = pack_u32_pair(STATE_DIM, OBS_DIM);
}

}  // namespace slam_ekf_update_hls

void slam_ekf_update_core(const uint64_t* input_words, uint64_t* output_words) {
#pragma HLS INTERFACE m_axi port = input_words offset = direct bundle = gmem0
#pragma HLS INTERFACE m_axi port = output_words offset = direct bundle = gmem1
#pragma HLS INTERFACE ap_ctrl_hs port = return
    slam_ekf_update_hls::slam_ekf_update_core_impl(input_words, output_words);
}
