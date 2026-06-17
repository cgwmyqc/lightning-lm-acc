#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import struct
from pathlib import Path

from make_golden_mem_images import (
    ACTIVE_BLOCK_BYTES,
    ACTIVE_MAP_HEADER_BYTES,
    MAP_HEADER_ADDR,
    NORMAL_EQUATION_BYTES,
    OBS_CELL_BYTES,
    POSE_ADDR,
    compute_expected,
    emit_params,
    write_bytes,
)


def pack_scan_point(x, y, z, intensity):
    return struct.pack("<4f", x, y, z, intensity)


def pack_pose():
    return struct.pack("<7fI", 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0)


def pack_map_header(num_blocks, num_cells):
    return struct.pack(
        "<4I2f10I",
        0x53414C4D,
        1,
        1,
        256,
        1.0,
        1.0,
        1,
        1,
        num_blocks,
        num_cells,
        0,
        0,
        0,
        0,
        0,
        0,
    )


def pack_active_block(x, y, z, first_cell, valid_cell_count):
    return struct.pack("<3i5I", x, y, z, first_cell, valid_cell_count, 0, 0, 0)


def pack_obs_cell(centroid, normal, plane_d, quality, count, flags):
    return struct.pack(
        "<8f8I",
        centroid[0],
        centroid[1],
        centroid[2],
        normal[0],
        normal[1],
        normal[2],
        plane_d,
        quality,
        count,
        flags,
        0,
        0,
        0,
        0,
        0,
        0,
    )


def main():
    parser = argparse.ArgumentParser(description="Build a tiny synthetic RTL numeric fixture.")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--report-dir", required=True)
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    report_dir = Path(args.report_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    report_dir.mkdir(parents=True, exist_ok=True)

    scan_points = [(0.25, 0.25, 0.25, 1.0)]
    pose = {"qx": 0.0, "qy": 0.0, "qz": 0.0, "qw": 1.0, "tx": 0.0, "ty": 0.0, "tz": 0.0, "flags": 0}
    map_header = {
        "magic": 0x53414C4D,
        "version": 1,
        "mode": 1,
        "cells_per_block": 256,
        "cell_resolution": 1.0,
        "inv_cell_resolution": 1.0,
        "window_id": 1,
        "window_version": 1,
        "num_blocks": 1,
        "num_cells": 256,
        "lookup_nearby_type": 0,
        "flags": 0,
    }
    blocks = [(0, 0, 0, 0, 1, 0, 0, 0)]
    cells = [(0.25, 0.25, 0.20, 0.0, 0.0, 1.0, -0.20, 1.0, 1, 1, 0, 0, 0, 0, 0, 0)]
    cells.extend([(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0)] * 255)
    expected = compute_expected(scan_points, pose, map_header, blocks, cells)
    if expected["valid_count"] != 1 or expected["reject_count"] != 0 or expected["miss_count"] != 0:
        raise RuntimeError(f"synthetic expected counts are not 1/0/0: {expected}")

    scan_payload = b"".join(pack_scan_point(*point) for point in scan_points)
    pose_payload = pack_pose()
    header_payload = pack_map_header(num_blocks=1, num_cells=256)
    block_payload = pack_active_block(0, 0, 0, 0, 1)
    cells_payload = bytearray()
    cells_payload.extend(pack_obs_cell((0.25, 0.25, 0.20), (0.0, 0.0, 1.0), -0.20, 1.0, 1, 1))
    cells_payload.extend(bytes(255 * OBS_CELL_BYTES))

    if len(header_payload) != ACTIVE_MAP_HEADER_BYTES:
        raise RuntimeError("bad ActiveMapHeader size")
    if len(block_payload) != ACTIVE_BLOCK_BYTES:
        raise RuntimeError("bad ActiveBlockRecord size")

    gmem1 = bytearray(MAP_HEADER_ADDR + ACTIVE_MAP_HEADER_BYTES)
    gmem1[POSE_ADDR : POSE_ADDR + len(pose_payload)] = pose_payload
    gmem1[MAP_HEADER_ADDR : MAP_HEADER_ADDR + len(header_payload)] = header_payload

    write_bytes(out_dir / "gmem0_scan.bin", scan_payload)
    write_bytes(out_dir / "gmem1_pose_map_header.bin", bytes(gmem1))
    write_bytes(out_dir / "gmem2_active_blocks.bin", block_payload)
    write_bytes(out_dir / "gmem3_obs_cells.bin", bytes(cells_payload))
    write_bytes(out_dir / "gmem4_output.bin", bytes(NORMAL_EQUATION_BYTES))
    emit_params(out_dir / "golden_frame_000001_params.vh", expected, len(scan_points))

    summary = [
        "# synthetic_tiny memory image summary",
        "",
        f"- generated_dir: `{out_dir}`",
        "- scan_points: 1",
        "- active_blocks: 1",
        "- obs_cells: 256",
        "- valid_cells: 1",
        f"- gmem0_scan.bin: {len(scan_payload)} bytes",
        f"- gmem1_pose_map_header.bin: {len(gmem1)} bytes",
        f"- gmem2_active_blocks.bin: {len(block_payload)} bytes",
        f"- gmem3_obs_cells.bin: {len(cells_payload)} bytes",
        f"- gmem4_output.bin: {NORMAL_EQUATION_BYTES} bytes",
        f"- expected_counts: {expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}",
        f"- expected_residual_sum: {expected['residual_sum']:.17g}",
        "",
        "This fixture is intentionally tiny so Vivado 2018.3 XSim can run the generated",
        "HLS floating-point RTL to completion. It validates the real HLS RTL, controller",
        "direct-control ports, and behavioral AXI memory model numeric path.",
    ]
    (report_dir / "synthetic_image_summary.md").write_text("\n".join(summary) + "\n", encoding="utf-8")
    print("SYNTHETIC_IMAGE_PASS")
    print(f"generated_dir={out_dir}")
    print(f"report={report_dir / 'synthetic_image_summary.md'}")


if __name__ == "__main__":
    main()
