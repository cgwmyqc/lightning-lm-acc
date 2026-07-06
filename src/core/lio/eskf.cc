//
// Created by xiang on 2022/2/15.
//

#include "core/lio/eskf.hpp"
#include "core/lightning_math.hpp"
#include "core/lio/mapping_eskf_update.h"
#include "utils/perf_monitor.h"

#include <Eigen/Eigenvalues>
#include <algorithm>

namespace {

using CovType = lightning::ESKF::CovType;

void SymmetrizeAndFloorCovariance(CovType& P, double min_cov_diag) {
    P = 0.5 * (P + P.transpose()).eval();

    for (int i = 0; i < P.rows(); ++i) {
        if (P(i, i) < min_cov_diag) {
            P(i, i) = min_cov_diag;
        } else if (P(i, i) > 100.0) {
            P(i, i) = 100.0;
        }

        for (int j = 0; j < P.cols(); ++j) {
            if (std::isnan(P(i, j)) || std::isinf(P(i, j))) {
                LOG(WARNING) << "find nan or inf in P: " << P(i, j);
                P(i, j) = 1.0;
            }
        }
    }
}

}  // namespace

namespace lightning {

void ESKF::Predict(const double& dt, const ESKF::ProcessNoiseType& Q, const Vec3d& gyro, const Vec3d& acce) {
    Eigen::Matrix<double, NavState::full_dim, 1> f_ = x_.get_f(gyro, acce);  // 调用get_f 获取 速度 角速度 加速度
    Eigen::Matrix<double, NavState::full_dim, state_dim_> f_x_ = x_.df_dx(acce);
    Eigen::Matrix<double, NavState::full_dim, process_noise_dim_> f_w_ = x_.df_dw();
    Eigen::Matrix<double, state_dim_, process_noise_dim_> f_w_final =
        Eigen::Matrix<double, state_dim_, process_noise_dim_>::Zero();

    NavState x_before = x_;
    x_.oplus(f_, dt);

    F_x1_ = CovType::Identity();

    // set f_x_final
    CovType f_x_final = CovType::Zero();
    for (auto st : x_.vect_states_) {
        int idx = st.idx_;
        int dim = st.dim_;
        int dof = st.dof_;

        for (int i = 0; i < state_dim_; i++) {
            for (int j = 0; j < dof; j++) {
                f_x_final(idx + j, i) = f_x_(dim + j, i);
            }
        }

        for (int i = 0; i < process_noise_dim_; i++) {
            for (int j = 0; j < dof; j++) {
                f_w_final(idx + j, i) = f_w_(dim + j, i);
            }
        }
    }

    Mat3d res_temp_SO3;
    Vec3d seg_SO3;
    for (auto st : x_.SO3_states_) {
        int idx = st.idx_;
        int dim = st.dim_;
        for (int i = 0; i < 3; i++) {
            seg_SO3(i) = -1 * f_(dim + i) * dt;
        }

        F_x1_.block<3, 3>(idx, idx) = math::exp(seg_SO3, 0.5).matrix();

        res_temp_SO3 = math::A_matrix(seg_SO3);
        for (int i = 0; i < state_dim_; i++) {
            f_x_final.template block<3, 1>(idx, i) = res_temp_SO3 * (f_x_.block<3, 1>(dim, i));
        }

        for (int i = 0; i < process_noise_dim_; i++) {
            f_w_final.template block<3, 1>(idx, i) = res_temp_SO3 * (f_w_.block<3, 1>(dim, i));
        }
    }

    F_x1_ += f_x_final * dt;
    P_ = (F_x1_)*P_ * (F_x1_).transpose() + (dt * f_w_final) * Q * (dt * f_w_final).transpose();
    P_ *= options_.predict_cov_inflation_;
    SymmetrizeAndFloorCovariance(P_, options_.min_cov_diag_);
}

/**
 * 原版的迭代过程中，收敛次数大于1才会结果，所以需要两次收敛。
 * 在未收敛时，实际上不会计算最近邻，也就回避了一次ObsModel的计算
 * 如果这边对每次迭代都计算最近邻的话，时间明显会变长一些，并不是非常合理。。
 *
 * @param obs
 * @param R
 */
void ESKF::Update(ESKF::ObsType obs, const double& R) {
    custom_obs_model_.valid_ = true;
    custom_obs_model_.converge_ = true;

    CovType P_propagated = P_;

    Eigen::Matrix<double, state_dim_, 1> K_r;
    Eigen::Matrix<double, state_dim_, state_dim_> K_H;

    StateVecType dx_current = StateVecType::Zero();  // 本轮迭代的dx

    NavState start_x = x_;  // 迭代的起点
    NavState last_x = x_;

    int converged_times = 0;
    double last_lidar_res = 0;

    double init_res = 0.0;
    static double iterated_num = 0;
    static double update_num = 0;
    update_num += 1;
    {
    ScopedPerfStage iter_loop_perf("ESKF Iter Loop total");
    for (int i = -1; i < maximum_iter_; i++) {
        custom_obs_model_.valid_ = true;

        /// 计算observation function，主要是residual_, h_x_, s_
        /// x_ 在每次迭代中都是更新的，线性化点也会更新
        {
            ScopedPerfStage perf("ESKF ObsModel call");
            if (obs == ObsType::LIDAR || obs == ObsType::WHEEL_SPEED_AND_LIDAR) {
                lidar_obs_func_(x_, custom_obs_model_);
            } else if (obs == ObsType::WHEEL_SPEED) {
                wheelspeed_obs_func_(x_, custom_obs_model_);
            } else if (obs == ObsType::ACC_AS_GRAVITY) {
                acc_as_gravity_obs_func_(x_, custom_obs_model_);
            } else if (obs == ObsType::GPS) {
                gps_obs_func_(x_, custom_obs_model_);
            } else if (obs == ObsType::BIAS) {
                bias_obs_func_(x_, custom_obs_model_);
            }
        }

        {
            ScopedPerfStage perf("ESKF Convergence Check");
            if (custom_obs_model_.valid_ == false) {
                x_ = last_x;
                P_ = P_propagated;
                return;
            }

            if (use_aa_ && i > -1 && (obs == ObsType::LIDAR || obs == ObsType::WHEEL_SPEED_AND_LIDAR) &&
                custom_obs_model_.lidar_residual_mean_ >= last_lidar_res * 1.01) {
                x_ = last_x;
                break;
            }
            iterated_num += 1;

            if (!custom_obs_model_.valid_) {
                continue;
            }

            if (i == -1) {
                init_res = custom_obs_model_.lidar_residual_mean_;
                if (init_res < 1e-9) {
                    init_res = 1e-9;  // 可能有零
                }
            }

            iterations_ = i + 2;  // i从-1开始计
            final_res_ = custom_obs_model_.lidar_residual_mean_ / init_res;
        }

        mapping_update::UpdateInput update_input;
        update_input.start_state = start_x;
        update_input.current_state = x_;
        update_input.propagated_cov = P_propagated;
        update_input.HTH = custom_obs_model_.HTH_;
        update_input.HTr = custom_obs_model_.HTr_;
        update_input.dx_from_start = x_.boxminus(start_x);
        update_input.params.R = R;
        update_input.params.degeneracy_threshold_ratio = options_.degeneracy_threshold_ratio_;
        update_input.params.degeneracy_cov_inflation = options_.degeneracy_cov_inflation_;
        update_input.params.min_cov_diag = options_.min_cov_diag_;
        update_input.params.max_update_translation_step = options_.max_update_translation_step_;
        update_input.params.max_update_rotation_step_deg = options_.max_update_rotation_step_deg_;
        update_input.params.limit = limit_;
        update_input.iteration_index = i;
        update_input.finish_update = false;

        mapping_update::UpdateOutput update_output;
        {
            ScopedPerfStage perf("ESKF Solve Matrix");
            if (!mapping_update::RunUpdateStep(update_input, update_output)) {
                if (update_output.status == "eigen_failed") {
                    LOG(WARNING) << "Failed to decompose ESKF observation information matrix.";
                    continue;
                }
                if (update_output.rejected) {
                    LOG(ERROR) << "Reject ESKF iter update, dtrans: " << update_output.dx_translation
                               << ", drot_deg: " << update_output.dx_rotation_deg
                               << ", dvel: "
                               << update_output.dx_current.segment<NavState::kBlockDim>(NavState::kVelIdx).norm();
                    x_ = start_x;
                    P_ = P_propagated;
                }
                return;
            }
            P_ = update_output.working_cov;
            dx_current = update_output.dx_current;
            K_r = update_output.K_r;
            K_H = update_output.K_H;
        }

        {
        ScopedPerfStage perf("ESKF State Update");
        // Vec3d dv = dx_current.middleRows(NavState::kVelIdx, NavState::kBlockDim);
        // if (dv.norm() > options_.vel_clip_norm_) {
        //     dv = dv / dv.norm() * options_.vel_clip_norm_;
        // }

        // dv = dv * options_.dv_ratio_;
        // dx_current.middleRows(NavState::kVelIdx, NavState::kBlockDim) = dv;

        // dx_current.middleRows(18, 5).setZero();

        // LOG(INFO) << "iter " << iterations_ << ", dx: " << dx_current.transpose();
        if (!use_aa_) {
            x_ = update_output.updated_state;
        } else {
            // 转到起点的线性空间
            x_ = x_.boxplus(dx_current);

            if (i == -1) {
                aa_.init(dx_current);  // 初始化AA
            } else {
                // 利用AA计算dx from start
                auto dx_all = x_.boxminus(start_x);
                auto new_dx_all = aa_.compute(dx_all);
                x_ = start_x.boxplus(new_dx_all);
            }
        }

        last_x = x_;
        }

        bool should_finish_update = false;
        {
            ScopedPerfStage perf("ESKF Convergence Check");
            // update last res
            last_lidar_res = custom_obs_model_.lidar_residual_mean_;
            custom_obs_model_.converge_ = true;

            for (int j = 0; j < state_dim_; j++) {
                if (std::fabs(dx_current[j]) > limit_[j]) {
                    custom_obs_model_.converge_ = false;
                    break;
                }
            }

            if (custom_obs_model_.converge_) {
                converged_times++;
            }

            if (!converged_times && i == maximum_iter_ - 2) {
                custom_obs_model_.converge_ = true;
            }

            should_finish_update = converged_times > 0 || i == maximum_iter_ - 1;
        }

        if (should_finish_update) {
            ScopedPerfStage perf("ESKF Covariance Update");
            update_input.finish_update = true;
            mapping_update::UpdateOutput final_output;
            if (!mapping_update::RunUpdateStep(update_input, final_output)) {
                x_ = start_x;
                P_ = P_propagated;
                return;
            }
            final_output.updated_state = x_;
            P_ = final_output.updated_cov;

            if (mapping_update_golden_callback_ && !mapping_update_golden_captured_ &&
                obs == ObsType::LIDAR) {
                const int capture_index = mapping_update_golden_count_++;
                if (capture_index >= mapping_update_golden_target_index_) {
                    final_output.updated_state = x_;
                    mapping_update::GoldenFrame frame;
                    frame.input = update_input;
                    frame.input.frame_index = capture_index;
                    frame.expected = final_output;
                    mapping_update_golden_captured_ = mapping_update_golden_callback_(frame);
                }
            }

            break;
        }
    }
    }

    {
        ScopedPerfStage perf("ESKF Covariance Update");
        SymmetrizeAndFloorCovariance(P_, options_.min_cov_diag_);
    }

}

}  // namespace lightning
