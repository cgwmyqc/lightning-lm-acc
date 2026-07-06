// SPDX-License-Identifier: MIT
#pragma once

#include <memory>
#include <string>

#include "core/fpga/xdma_runtime.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"

namespace lightning::loc {

struct SurfelLocXdmaOptions {
    std::string user_dev = "/dev/xdma0_user";
    std::string h2c_dev = "/dev/xdma0_h2c_0";
    std::string c2h_dev = "/dev/xdma0_c2h_0";
    uint32_t ctrl_base = 0x1000;
    double timeout_sec = 120.0;
    bool verify_readback = false;
    bool candidate_abi_v2 = false;
};

class SurfelLocXdmaBackend {
   public:
    explicit SurfelLocXdmaBackend(SurfelLocXdmaOptions options = SurfelLocXdmaOptions());

    void SetOptions(const SurfelLocXdmaOptions& options);

    bool ComputeObservation(const CloudPtr& scan_body, const SE3& pose_guess, const ActiveMapBuffer& map,
                            LocNormalEquation& out, double* elapsed_sec = nullptr,
                            std::string* error = nullptr,
                            fpga::XdmaRuntime::RunResult* run_result = nullptr,
                            double* pack_scan_sec = nullptr) const;

    bool ComputeObservationAndSolve6x6(const CloudPtr& scan_body, const SE3& pose_guess,
                                       const ActiveMapBuffer& map, LocNormalEquation& out,
                                       double* elapsed_sec = nullptr, std::string* error = nullptr,
                                       fpga::XdmaRuntime::RunResult* run_result = nullptr,
                                       double* pack_scan_sec = nullptr) const;

   private:
    SurfelLocXdmaOptions options_;
    std::unique_ptr<fpga::XdmaRuntime> runtime_;
};

}  // namespace lightning::loc
