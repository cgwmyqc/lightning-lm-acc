#include "fpga/cpu_normal_equation_backend.h"

#include <cmath>

#include "core/lightning_math.hpp"

namespace lightning::fpga {

void MatrixToUpper21(const Eigen::Matrix<float, 6, 6>& H, float out[21]) {
    int k = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            out[k++] = H(r, c);
        }
    }
}

void Upper21ToMatrix(const float upper[21], Eigen::Matrix<float, 6, 6>* H) {
    H->setZero();
    int k = 0;
    for (int r = 0; r < 6; ++r) {
        for (int c = r; c < 6; ++c) {
            (*H)(r, c) = upper[k];
            (*H)(c, r) = upper[k];
            ++k;
        }
    }
}

bool CpuNormalEquationBackend::Accumulate(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state,
                                          NormalEquationResult* result) {
    if (result == nullptr) {
        return false;
    }

    result->H.setZero();
    result->b.setZero();
    result->residual_sum = 0.0f;
    result->residual_abs_sum = 0.0f;
    result->valid_count = 0;

    const Eigen::Matrix3f Rt = state.R_wi.transpose();

    for (const auto& c : corr) {
        const Eigen::Vector3f p_imu(c.px, c.py, c.pz);
        const Eigen::Vector3f n(c.nx, c.ny, c.nz);
        const float residual = n.dot(state.R_wi * p_imu + state.t_wi) + c.d;
        const float weight = c.weight;

        const Eigen::Matrix3f point_crossmat = math::SKEW_SYM_MATRIX(p_imu);
        const Eigen::Vector3f C = Rt * n;
        const Eigen::Vector3f A = point_crossmat * C;

        Eigen::Matrix<float, 1, 6> J;
        J << n.x(), n.y(), n.z(), A.x(), A.y(), A.z();

        result->H.noalias() += (J.transpose() * J) * weight;
        result->b.noalias() += J.transpose() * (-residual) * weight;
        result->residual_sum += residual;
        result->residual_abs_sum += std::abs(residual);
        ++result->valid_count;
    }

    return true;
}

}  // namespace lightning::fpga
