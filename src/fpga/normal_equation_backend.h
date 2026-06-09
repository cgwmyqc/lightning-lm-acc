#pragma once

#include <Eigen/Core>

#include <string>
#include <vector>

#include "fpga/fpga_types.h"

namespace lightning::fpga {

struct NormalEquationState {
    Eigen::Matrix3f R_wi = Eigen::Matrix3f::Identity();
    Eigen::Vector3f t_wi = Eigen::Vector3f::Zero();
};

struct NormalEquationResult {
    Eigen::Matrix<float, 6, 6> H = Eigen::Matrix<float, 6, 6>::Zero();
    Eigen::Matrix<float, 6, 1> b = Eigen::Matrix<float, 6, 1>::Zero();
    float residual_sum = 0.0f;
    float residual_abs_sum = 0.0f;
    int valid_count = 0;
};

class NormalEquationBackend {
   public:
    virtual ~NormalEquationBackend() = default;

    virtual bool Accumulate(const std::vector<FpgaCorrInput>& corr, const NormalEquationState& state,
                            NormalEquationResult* result) = 0;
    virtual std::string Name() const = 0;
};

void MatrixToUpper21(const Eigen::Matrix<float, 6, 6>& H, float out[21]);
void Upper21ToMatrix(const float upper[21], Eigen::Matrix<float, 6, 6>* H);

}  // namespace lightning::fpga
