// SPDX-License-Identifier: MIT
#pragma once

#include <cstdint>

#include "../../abi/slam_accel_abi.h"

namespace lightning {
namespace fpga {
namespace hls {

void unified_surfel_observation_core(const SlamAccelScanPoint* scan_points, uint32_t num_points,
                                     const SlamAccelPose* pose, const ActiveMapHeader* map_header,
                                     const ActiveBlockRecord* active_blocks, const ObsCellFloat64* obs_cells,
                                     uint64_t* output_words);

}  // namespace hls
}  // namespace fpga
}  // namespace lightning
