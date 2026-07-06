// SPDX-License-Identifier: MIT

#include "core/lio/mapping_eskf_update.h"

#include <Eigen/Eigenvalues>
#include <cmath>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include <sstream>

#include <yaml-cpp/yaml.h>

#include "core/lightning_math.hpp"

namespace lightning::mapping_update {
namespace {

constexpr uint32_t kMagic = 0x53455550u;  // SEUP
constexpr uint32_t kVersion = 1u;

struct FileHeader {
    uint32_t magic = kMagic;
    uint32_t version = kVersion;
};

std::string JoinPath(const std::string& dir, const std::string& name) {
    return (std::filesystem::path(dir) / name).string();
}

void SetError(std::string* error, const std::string& message) {
    if (error) {
        *error = message;
    }
}

template <typename T>
bool WriteRaw(std::ofstream& ofs, const T& value) {
    ofs.write(reinterpret_cast<const char*>(&value), sizeof(T));
    return static_cast<bool>(ofs);
}

template <typename T>
bool ReadRaw(std::ifstream& ifs, T& value) {
    ifs.read(reinterpret_cast<char*>(&value), sizeof(T));
    return static_cast<bool>(ifs);
}

bool WriteMatrix(std::ofstream& ofs, const double* data, int count) {
    ofs.write(reinterpret_cast<const char*>(data), static_cast<std::streamsize>(sizeof(double) * count));
    return static_cast<bool>(ofs);
}

bool ReadMatrix(std::ifstream& ifs, double* data, int count) {
    ifs.read(reinterpret_cast<char*>(data), static_cast<std::streamsize>(sizeof(double) * count));
    return static_cast<bool>(ifs);
}

void SymmetrizeAndFloorCovariance(ESKF::CovType& P, double min_cov_diag) {
    P = 0.5 * (P + P.transpose()).eval();
    for (int i = 0; i < P.rows(); ++i) {
        if (P(i, i) < min_cov_diag) {
            P(i, i) = min_cov_diag;
        } else if (P(i, i) > 100.0) {
            P(i, i) = 100.0;
        }
        for (int j = 0; j < P.cols(); ++j) {
            if (std::isnan(P(i, j)) || std::isinf(P(i, j))) {
                P(i, j) = 1.0;
            }
        }
    }
}

bool IsFiniteMatrix(const ESKF::StateVecType& v) {
    for (int i = 0; i < v.rows(); ++i) {
        if (!std::isfinite(v(i))) {
            return false;
        }
    }
    return true;
}

double StateMaxAbsDiff(const NavState& a, const NavState& b) {
    double max_abs = 0.0;
    max_abs = std::max(max_abs, (a.pos_ - b.pos_).cwiseAbs().maxCoeff());
    max_abs = std::max(max_abs, (a.rot_.inverse() * b.rot_).log().cwiseAbs().maxCoeff());
    max_abs = std::max(max_abs, (a.vel_ - b.vel_).cwiseAbs().maxCoeff());
    max_abs = std::max(max_abs, (a.bg_ - b.bg_).cwiseAbs().maxCoeff());
    max_abs = std::max(max_abs, std::fabs(a.timestamp_ - b.timestamp_));
    return max_abs;
}

bool WriteNavState(std::ofstream& ofs, const NavState& state) {
    const Quatd q = state.rot_.unit_quaternion();
    return WriteRaw(ofs, state.timestamp_) && WriteMatrix(ofs, state.pos_.data(), 3) &&
           WriteMatrix(ofs, q.coeffs().data(), 4) && WriteMatrix(ofs, state.vel_.data(), 3) &&
           WriteMatrix(ofs, state.bg_.data(), 3) && WriteMatrix(ofs, state.grav_.data(), 3);
}

bool ReadNavState(std::ifstream& ifs, NavState& state) {
    Eigen::Matrix<double, 4, 1> q_coeffs;
    if (!ReadRaw(ifs, state.timestamp_) || !ReadMatrix(ifs, state.pos_.data(), 3) ||
        !ReadMatrix(ifs, q_coeffs.data(), 4) || !ReadMatrix(ifs, state.vel_.data(), 3) ||
        !ReadMatrix(ifs, state.bg_.data(), 3) || !ReadMatrix(ifs, state.grav_.data(), 3)) {
        return false;
    }
    state.rot_ = SO3(Quatd(q_coeffs[3], q_coeffs[0], q_coeffs[1], q_coeffs[2]).normalized());
    return true;
}

bool WriteInput(std::ofstream& ofs, const UpdateInput& input) {
    const uint8_t finish = input.finish_update ? 1 : 0;
    return WriteNavState(ofs, input.start_state) && WriteNavState(ofs, input.current_state) &&
           WriteMatrix(ofs, input.propagated_cov.data(), ESKF::state_dim_ * ESKF::state_dim_) &&
           WriteMatrix(ofs, input.HTH.data(), 36) && WriteMatrix(ofs, input.HTr.data(), 6) &&
           WriteMatrix(ofs, input.dx_from_start.data(), ESKF::state_dim_) && WriteRaw(ofs, input.params.R) &&
           WriteRaw(ofs, input.params.degeneracy_threshold_ratio) &&
           WriteRaw(ofs, input.params.degeneracy_cov_inflation) && WriteRaw(ofs, input.params.min_cov_diag) &&
           WriteRaw(ofs, input.params.max_update_translation_step) &&
           WriteRaw(ofs, input.params.max_update_rotation_step_deg) &&
           WriteMatrix(ofs, input.params.limit.data(), ESKF::state_dim_) && WriteRaw(ofs, input.frame_index) &&
           WriteRaw(ofs, input.iteration_index) && WriteRaw(ofs, finish);
}

bool ReadInput(std::ifstream& ifs, UpdateInput& input) {
    uint8_t finish = 0;
    if (!ReadNavState(ifs, input.start_state) || !ReadNavState(ifs, input.current_state) ||
        !ReadMatrix(ifs, input.propagated_cov.data(), ESKF::state_dim_ * ESKF::state_dim_) ||
        !ReadMatrix(ifs, input.HTH.data(), 36) || !ReadMatrix(ifs, input.HTr.data(), 6) ||
        !ReadMatrix(ifs, input.dx_from_start.data(), ESKF::state_dim_) || !ReadRaw(ifs, input.params.R) ||
        !ReadRaw(ifs, input.params.degeneracy_threshold_ratio) ||
        !ReadRaw(ifs, input.params.degeneracy_cov_inflation) || !ReadRaw(ifs, input.params.min_cov_diag) ||
        !ReadRaw(ifs, input.params.max_update_translation_step) ||
        !ReadRaw(ifs, input.params.max_update_rotation_step_deg) ||
        !ReadMatrix(ifs, input.params.limit.data(), ESKF::state_dim_) || !ReadRaw(ifs, input.frame_index) ||
        !ReadRaw(ifs, input.iteration_index) || !ReadRaw(ifs, finish)) {
        return false;
    }
    input.finish_update = finish != 0;
    return true;
}

bool WriteOutput(std::ofstream& ofs, const UpdateOutput& output) {
    const uint8_t success = output.success ? 1 : 0;
    const uint8_t rejected = output.rejected ? 1 : 0;
    const uint8_t converged = output.converged ? 1 : 0;
    const uint8_t cov_final = output.covariance_finalized ? 1 : 0;
    return WriteRaw(ofs, success) && WriteRaw(ofs, rejected) && WriteRaw(ofs, converged) &&
           WriteRaw(ofs, cov_final) && WriteRaw(ofs, output.nullity) &&
           WriteMatrix(ofs, output.dx_current.data(), ESKF::state_dim_) &&
           WriteMatrix(ofs, output.K_r.data(), ESKF::state_dim_) &&
           WriteMatrix(ofs, output.K_H.data(), ESKF::state_dim_ * ESKF::state_dim_) &&
           WriteMatrix(ofs, output.HTH_eff.data(), 36) && WriteMatrix(ofs, output.HTr_eff.data(), 6) &&
           WriteNavState(ofs, output.updated_state) &&
           WriteMatrix(ofs, output.working_cov.data(), ESKF::state_dim_ * ESKF::state_dim_) &&
           WriteMatrix(ofs, output.updated_cov.data(), ESKF::state_dim_ * ESKF::state_dim_) &&
           WriteRaw(ofs, output.dx_translation) && WriteRaw(ofs, output.dx_rotation_deg) &&
           WriteRaw(ofs, output.dx_norm);
}

bool ReadOutput(std::ifstream& ifs, UpdateOutput& output) {
    uint8_t success = 0, rejected = 0, converged = 0, cov_final = 0;
    if (!ReadRaw(ifs, success) || !ReadRaw(ifs, rejected) || !ReadRaw(ifs, converged) ||
        !ReadRaw(ifs, cov_final) || !ReadRaw(ifs, output.nullity) ||
        !ReadMatrix(ifs, output.dx_current.data(), ESKF::state_dim_) ||
        !ReadMatrix(ifs, output.K_r.data(), ESKF::state_dim_) ||
        !ReadMatrix(ifs, output.K_H.data(), ESKF::state_dim_ * ESKF::state_dim_) ||
        !ReadMatrix(ifs, output.HTH_eff.data(), 36) || !ReadMatrix(ifs, output.HTr_eff.data(), 6) ||
        !ReadNavState(ifs, output.updated_state) ||
        !ReadMatrix(ifs, output.working_cov.data(), ESKF::state_dim_ * ESKF::state_dim_) ||
        !ReadMatrix(ifs, output.updated_cov.data(), ESKF::state_dim_ * ESKF::state_dim_) ||
        !ReadRaw(ifs, output.dx_translation) || !ReadRaw(ifs, output.dx_rotation_deg) ||
        !ReadRaw(ifs, output.dx_norm)) {
        return false;
    }
    output.success = success != 0;
    output.rejected = rejected != 0;
    output.converged = converged != 0;
    output.covariance_finalized = cov_final != 0;
    output.status = output.success ? "ok" : (output.rejected ? "rejected" : "failed");
    return true;
}

}  // namespace

bool RunUpdateStep(const UpdateInput& input, UpdateOutput& output) {
    output = UpdateOutput();
    output.updated_state = input.current_state;
    output.working_cov = input.propagated_cov;
    output.updated_cov = input.propagated_cov;

    ESKF::StateVecType dx_current = input.dx_from_start;
    ESKF::CovType P = input.propagated_cov;

    for (const auto& so3_state : NavState::SO3_states_) {
        const int idx = so3_state.idx_;
        const Vec3d seg_so3 = input.dx_from_start.block<3, 1>(idx, 0);
        const Mat3d J_so3 = math::A_matrix(seg_so3).transpose();
        dx_current.block<3, 1>(idx, 0) = J_so3 * input.dx_from_start.block<3, 1>(idx, 0);
        for (int j = 0; j < ESKF::state_dim_; ++j) {
            P.block<3, 1>(idx, j) = J_so3 * P.block<3, 1>(idx, j);
        }
        for (int j = 0; j < ESKF::state_dim_; ++j) {
            P.block<1, 3>(j, idx) = P.block<1, 3>(j, idx) * J_so3.transpose();
        }
    }

    output.working_cov = P;

    const Mat6d HTH_sym = 0.5 * (input.HTH + input.HTH.transpose());
    Eigen::SelfAdjointEigenSolver<Mat6d> eigen_solver(HTH_sym);
    if (eigen_solver.info() != Eigen::Success) {
        output.status = "eigen_failed";
        return false;
    }

    const Vec6d eigen_values = eigen_solver.eigenvalues();
    const Mat6d eigen_vectors = eigen_solver.eigenvectors();
    const double max_eigen_value = std::max(1e-12, eigen_values.maxCoeff());
    const double degeneracy_threshold = max_eigen_value * input.params.degeneracy_threshold_ratio;

    Vec6d observable_mask = Vec6d::Zero();
    for (int k = 0; k < observable_mask.size(); ++k) {
        if (eigen_values(k) > degeneracy_threshold) {
            observable_mask(k) = 1.0;
        } else {
            ++output.nullity;
        }
    }

    const Mat6d observable_projector = eigen_vectors * observable_mask.asDiagonal() * eigen_vectors.transpose();
    output.HTH_eff = observable_projector * HTH_sym * observable_projector;
    output.HTr_eff = observable_projector * input.HTr;

    ESKF::CovType P_temp = (P / input.params.R).inverse();
    P_temp.block<ESKF::pose_obs_dim_, ESKF::pose_obs_dim_>(0, 0) += output.HTH_eff;
    const ESKF::CovType Q_inv = P_temp.inverse();

    output.K_r = Q_inv.template block<ESKF::state_dim_, ESKF::pose_obs_dim_>(0, 0) * output.HTr_eff;
    output.K_H.setZero();
    output.K_H.template block<ESKF::state_dim_, ESKF::pose_obs_dim_>(0, 0) =
        Q_inv.template block<ESKF::state_dim_, ESKF::pose_obs_dim_>(0, 0) * output.HTH_eff;

    dx_current = output.K_r + (output.K_H - ESKF::CovType::Identity()) * dx_current;
    output.dx_current = dx_current;
    output.dx_norm = dx_current.norm();

    if (!IsFiniteMatrix(dx_current)) {
        output.status = "nan_dx";
        return false;
    }

    output.dx_translation = dx_current.head<3>().norm();
    output.dx_rotation_deg = dx_current.segment<3>(3).norm() * 180.0 / M_PI;
    if (output.dx_translation > input.params.max_update_translation_step ||
        output.dx_rotation_deg > input.params.max_update_rotation_step_deg) {
        output.rejected = true;
        output.status = "step_rejected";
        return false;
    }

    NavState current_state = input.current_state;
    output.updated_state = current_state.boxplus(dx_current);
    output.converged = true;
    for (int j = 0; j < ESKF::state_dim_; ++j) {
        if (std::fabs(dx_current[j]) > input.params.limit[j]) {
            output.converged = false;
            break;
        }
    }

    if (input.finish_update) {
        ESKF::CovType L = P;
        ESKF::CovType K_H_final = output.K_H;
        ESKF::CovType P_final_input = P;
        for (const auto& so3_state : NavState::SO3_states_) {
            const int idx = so3_state.idx_;
            const Vec3d seg_so3 = dx_current.block<3, 1>(idx, 0);
            const Mat3d J_so3 = math::A_matrix(seg_so3).transpose();
            for (int j = 0; j < ESKF::state_dim_; ++j) {
                L.block<3, 1>(idx, j) = J_so3 * P.block<3, 1>(idx, j);
            }
            for (int j = 0; j < ESKF::pose_obs_dim_; ++j) {
                K_H_final.block<3, 1>(idx, j) = J_so3 * K_H_final.block<3, 1>(idx, j);
            }
            for (int j = 0; j < ESKF::state_dim_; ++j) {
                L.block<1, 3>(j, idx) = L.block<1, 3>(j, idx) * J_so3.transpose();
                P_final_input.block<1, 3>(j, idx) = P_final_input.block<1, 3>(j, idx) * J_so3.transpose();
            }
        }
        ESKF::CovType P_updated =
            L - K_H_final.block<ESKF::state_dim_, ESKF::pose_obs_dim_>(0, 0) *
                    P_final_input.template block<ESKF::pose_obs_dim_, ESKF::state_dim_>(0, 0);
        if (output.nullity > 0) {
            P_updated.block<ESKF::pose_obs_dim_, ESKF::pose_obs_dim_>(0, 0) *=
                input.params.degeneracy_cov_inflation;
        }
        SymmetrizeAndFloorCovariance(P_updated, input.params.min_cov_diag);
        output.updated_cov = P_updated;
        output.covariance_finalized = true;
    } else {
        output.updated_cov = P;
    }

    output.success = true;
    output.status = "ok";
    return true;
}

bool WriteGoldenFrame(const std::string& output_dir, const GoldenFrame& frame, const std::string& bag,
                      const std::string& config, std::string* error) {
    std::error_code ec;
    std::filesystem::create_directories(output_dir, ec);
    if (ec) {
        SetError(error, "failed to create " + output_dir + ": " + ec.message());
        return false;
    }

    {
        std::ofstream ofs(JoinPath(output_dir, "update_input.bin"), std::ios::binary);
        if (!ofs || !WriteRaw(ofs, FileHeader{}) || !WriteInput(ofs, frame.input)) {
            SetError(error, "failed to write update_input.bin");
            return false;
        }
    }
    {
        std::ofstream ofs(JoinPath(output_dir, "update_expected.bin"), std::ios::binary);
        if (!ofs || !WriteRaw(ofs, FileHeader{}) || !WriteOutput(ofs, frame.expected)) {
            SetError(error, "failed to write update_expected.bin");
            return false;
        }
    }
    {
        std::ofstream ofs(JoinPath(output_dir, "update_meta.yaml"));
        if (!ofs) {
            SetError(error, "failed to write update_meta.yaml");
            return false;
        }
        ofs << std::setprecision(18);
        ofs << "bag: " << bag << "\n";
        ofs << "config: " << config << "\n";
        ofs << "frame_index: " << frame.input.frame_index << "\n";
        ofs << "iteration_index: " << frame.input.iteration_index << "\n";
        ofs << "timestamp: " << frame.input.current_state.timestamp_ << "\n";
        ofs << "R: " << frame.input.params.R << "\n";
        ofs << "finish_update: " << (frame.input.finish_update ? 1 : 0) << "\n";
        ofs << "nullity: " << frame.expected.nullity << "\n";
        ofs << "converged: " << (frame.expected.converged ? 1 : 0) << "\n";
        ofs << "success: " << (frame.expected.success ? 1 : 0) << "\n";
        ofs << "rejected: " << (frame.expected.rejected ? 1 : 0) << "\n";
        ofs << "dx_norm: " << frame.expected.dx_norm << "\n";
        ofs << "dx_translation: " << frame.expected.dx_translation << "\n";
        ofs << "dx_rotation_deg: " << frame.expected.dx_rotation_deg << "\n";
        ofs << "hth_trace: " << frame.input.HTH.trace() << "\n";
        ofs << "htr_norm: " << frame.input.HTr.norm() << "\n";
    }
    return true;
}

bool ReadGoldenFrame(const std::string& golden_dir, GoldenFrame& frame, std::string* error) {
    FileHeader header;
    {
        std::ifstream ifs(JoinPath(golden_dir, "update_input.bin"), std::ios::binary);
        if (!ifs || !ReadRaw(ifs, header) || header.magic != kMagic || header.version != kVersion ||
            !ReadInput(ifs, frame.input)) {
            SetError(error, "failed to read update_input.bin");
            return false;
        }
    }
    {
        std::ifstream ifs(JoinPath(golden_dir, "update_expected.bin"), std::ios::binary);
        if (!ifs || !ReadRaw(ifs, header) || header.magic != kMagic || header.version != kVersion ||
            !ReadOutput(ifs, frame.expected)) {
            SetError(error, "failed to read update_expected.bin");
            return false;
        }
    }
    return true;
}

bool CompareUpdateOutput(const UpdateOutput& actual, const UpdateOutput& expected, double dx_abs_tol,
                         double cov_abs_tol, double state_abs_tol, std::string* report) {
    const double dx_max_abs = (actual.dx_current - expected.dx_current).cwiseAbs().maxCoeff();
    const double cov_max_abs = (actual.updated_cov - expected.updated_cov).cwiseAbs().maxCoeff();
    const double state_max_abs = StateMaxAbsDiff(actual.updated_state, expected.updated_state);
    const bool flags_ok = actual.success == expected.success && actual.rejected == expected.rejected &&
                          actual.converged == expected.converged &&
                          actual.covariance_finalized == expected.covariance_finalized &&
                          actual.nullity == expected.nullity;
    const bool pass = flags_ok && dx_max_abs <= dx_abs_tol && cov_max_abs <= cov_abs_tol &&
                      state_max_abs <= state_abs_tol;
    if (report != nullptr) {
        std::ostringstream oss;
        oss << "flags_ok=" << (flags_ok ? 1 : 0) << " dx_max_abs=" << dx_max_abs
            << " cov_max_abs=" << cov_max_abs << " state_max_abs=" << state_max_abs
            << " actual_nullity=" << actual.nullity << " expected_nullity=" << expected.nullity
            << " actual_success=" << (actual.success ? 1 : 0)
            << " expected_success=" << (expected.success ? 1 : 0);
        *report = oss.str();
    }
    return pass;
}

}  // namespace lightning::mapping_update
