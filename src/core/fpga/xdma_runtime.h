// SPDX-License-Identifier: MIT
#pragma once

#include <array>
#include <cstdint>
#include <string>
#include <vector>

#include "common/point_def.h"
#include "core/localization/surfel_loc/surfel_loc_types.h"
#include "fpga/abi/slam_accel_abi.h"

namespace lightning::fpga {

class XdmaRuntime {
   public:
    struct Options {
        std::string user_dev = "/dev/xdma0_user";
        std::string h2c_dev = "/dev/xdma0_h2c_0";
        std::string c2h_dev = "/dev/xdma0_c2h_0";
        uint32_t ctrl_base = 0x1000;
        double timeout_sec = 120.0;
    };

    struct RunResult {
        uint32_t status = 0;
        uint32_t error = 0;
        uint32_t run_count_before = 0;
        uint32_t run_count_after = 0;
        uint32_t scan_count_readback = 0;
        double elapsed_sec = 0.0;
        SlamNormalEquation output;
        std::array<uint64_t, 40> raw_output_words = {};
    };

    explicit XdmaRuntime(Options options);

    bool ShimSmoke(std::string* error = nullptr) const;
    bool RegSmoke(uint32_t scan_count, std::string* error = nullptr) const;
    bool DdrSmoke(size_t pattern_size, std::string* error = nullptr) const;

    bool RunLocalizationObservation(const std::vector<SlamAccelScanPoint>& scan_points, const SlamAccelPose& pose,
                                    const loc::ActiveMapBuffer& active_map, bool write_full_image,
                                    bool verify_readback, RunResult& result, std::string* error = nullptr) const;
    bool RunMappingObservation(const std::vector<SlamAccelScanPoint>& scan_points, const SlamAccelPose& pose,
                               const loc::ActiveMapBuffer& active_map, bool write_full_image,
                               bool verify_readback, RunResult& result, std::string* error = nullptr) const;

    const Options& GetOptions() const { return options_; }

   private:
    Options options_;
};

std::vector<SlamAccelScanPoint> ToAbiScanPoints(const CloudPtr& cloud);
ActiveMapHeader MakeActiveMapHeader(const loc::ActiveMapBuffer& active_map,
                                    uint32_t mode = LOCALIZATION_OBSERVATION);

}  // namespace lightning::fpga
