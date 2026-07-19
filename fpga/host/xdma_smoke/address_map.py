#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

from dataclasses import dataclass


PLDDR_BASE = 0x00000000
PLDDR_SIZE = 0x40000000

XDMA_SHIM_MAGIC = 0x58444D41
XDMA_SHIM_VERSION = 0x00010000
XDMA_SHIM_MAGIC_OFFSET = 0x000
XDMA_SHIM_VERSION_OFFSET = 0x004
XDMA_SHIM_SCRATCH0_OFFSET = 0x008
XDMA_SHIM_SCRATCH1_OFFSET = 0x00C
XDMA_CTRL_BASE_DEFAULT = 0x00000000
XDMA_CTRL_BASE_A2 = 0x00001000

SCAN_POINTS_BASE = 0x00000000
POSE_BASE = 0x01000000
MAP_HEADER_BASE = 0x01001000
PARAMS_BASE = 0x01002000
ACTIVE_BLOCKS_BASE = 0x02000000
OBS_CELLS_BASE = 0x10000000
OUTPUT_BASE = 0x30000000
EKF_UPDATE_INPUT_BASE = 0x30010000
EKF_UPDATE_OUTPUT_BASE = 0x30020000
LOC_ITER_INPUT_BASE = 0x30030000
LOC_ITER_OUTPUT_BASE = 0x30040000

CTRL_VERSION = 0x000
CTRL_CONTROL = 0x004
CTRL_STATUS = 0x008
CTRL_KERNEL_SEL = 0x00C
CTRL_MODE = 0x010
CTRL_ERROR = 0x014
CTRL_CYCLE_COUNT = 0x018
CTRL_RUN_COUNT = 0x01C
CTRL_SCAN_ADDR_LO = 0x020
CTRL_SCAN_ADDR_HI = 0x024
CTRL_SCAN_COUNT = 0x028
CTRL_POSE_ADDR_LO = 0x02C
CTRL_POSE_ADDR_HI = 0x030
CTRL_MAP_HEADER_ADDR_LO = 0x034
CTRL_MAP_HEADER_ADDR_HI = 0x038
CTRL_ACTIVE_BLOCKS_ADDR_LO = 0x03C
CTRL_ACTIVE_BLOCKS_ADDR_HI = 0x040
CTRL_OBS_CELLS_ADDR_LO = 0x044
CTRL_OBS_CELLS_ADDR_HI = 0x048
CTRL_OUT_ADDR_LO = 0x04C
CTRL_OUT_ADDR_HI = 0x050
CTRL_PARAMS_ADDR_LO = 0x054
CTRL_PARAMS_ADDR_HI = 0x058
CTRL_EKF_INPUT_ADDR_LO = 0x05C
CTRL_EKF_INPUT_ADDR_HI = 0x060
CTRL_EKF_OUTPUT_ADDR_LO = 0x064
CTRL_EKF_OUTPUT_ADDR_HI = 0x068
CTRL_LOC_ITER_INPUT_ADDR_LO = 0x06C
CTRL_LOC_ITER_INPUT_ADDR_HI = 0x070
CTRL_LOC_ITER_OUTPUT_ADDR_LO = 0x074
CTRL_LOC_ITER_OUTPUT_ADDR_HI = 0x078

CTRL_VERSION_VALUE = 0x00020002
KERNEL_UNIFIED_OBSERVATION = 4
KERNEL_EKF_UPDATE = 5
KERNEL_LOC_ITERATIVE = 6
MODE_MAPPING = 0
MODE_LOCALIZATION = 1


@dataclass(frozen=True)
class Region:
    name: str
    base: int
    size: int


REGIONS = (
    Region("scan_points", SCAN_POINTS_BASE, 0x01000000),
    Region("pose", POSE_BASE, 0x00001000),
    Region("map_header", MAP_HEADER_BASE, 0x00001000),
    Region("params", PARAMS_BASE, 0x00001000),
    Region("active_blocks", ACTIVE_BLOCKS_BASE, 0x01000000),
    Region("obs_cells", OBS_CELLS_BASE, 0x20000000),
    Region("output", OUTPUT_BASE, 0x00010000),
    Region("ekf_update_input", EKF_UPDATE_INPUT_BASE, 0x00010000),
    Region("ekf_update_output", EKF_UPDATE_OUTPUT_BASE, 0x00010000),
    Region("loc_iter_input", LOC_ITER_INPUT_BASE, 0x00010000),
    Region("loc_iter_output", LOC_ITER_OUTPUT_BASE, 0x00010000),
)


CTRL_WRITES = (
    (CTRL_KERNEL_SEL, KERNEL_UNIFIED_OBSERVATION),
    (CTRL_MODE, MODE_LOCALIZATION),
    (CTRL_SCAN_ADDR_LO, SCAN_POINTS_BASE),
    (CTRL_SCAN_ADDR_HI, 0),
    (CTRL_POSE_ADDR_LO, POSE_BASE),
    (CTRL_POSE_ADDR_HI, 0),
    (CTRL_MAP_HEADER_ADDR_LO, MAP_HEADER_BASE),
    (CTRL_MAP_HEADER_ADDR_HI, 0),
    (CTRL_PARAMS_ADDR_LO, PARAMS_BASE),
    (CTRL_PARAMS_ADDR_HI, 0),
    (CTRL_ACTIVE_BLOCKS_ADDR_LO, ACTIVE_BLOCKS_BASE),
    (CTRL_ACTIVE_BLOCKS_ADDR_HI, 0),
    (CTRL_OBS_CELLS_ADDR_LO, OBS_CELLS_BASE),
    (CTRL_OBS_CELLS_ADDR_HI, 0),
    (CTRL_OUT_ADDR_LO, OUTPUT_BASE),
    (CTRL_OUT_ADDR_HI, 0),
)


def validate_layout():
    errors = []
    ordered = sorted(REGIONS, key=lambda item: item.base)
    for region in ordered:
        if region.base % 4096 != 0:
            errors.append(f"{region.name} base is not 4KB aligned: 0x{region.base:08x}")
        if region.size <= 0 or region.size % 4096 != 0:
            errors.append(f"{region.name} size is not positive 4KB multiple: 0x{region.size:x}")
        if region.base < PLDDR_BASE or region.base + region.size > PLDDR_BASE + PLDDR_SIZE:
            errors.append(f"{region.name} exceeds PL DDR window")
    for prev, cur in zip(ordered, ordered[1:]):
        if prev.base + prev.size > cur.base:
            errors.append(f"{prev.name} overlaps {cur.name}")
    hi_values = [value >> 32 for _, value in CTRL_WRITES if value > 0xFFFFFFFF]
    if any(hi_values):
        errors.append("one or more controller base addresses exceed 32 bits")
    if errors:
        raise RuntimeError("; ".join(errors))


def region_table():
    validate_layout()
    return "\n".join(
        f"{region.name}: base=0x{region.base:08x} size=0x{region.size:08x}"
        for region in REGIONS
    )
