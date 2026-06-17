#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import json
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parents[2]
MEM_HARNESS_DIR = REPO_ROOT / "fpga" / "vivado" / "slam_accel_hls_mem_harness"
sys.path.insert(0, str(MEM_HARNESS_DIR))

from make_golden_mem_images import NORMAL_EQUATION_BYTES, OBS_CELL_BYTES, compute_expected, write_bytes  # noqa: E402
from make_synthetic_mem_images import (  # noqa: E402
    pack_active_block,
    pack_map_header,
    pack_obs_cell,
    pack_pose,
    pack_scan_point,
)

from address_map import (  # noqa: E402
    ACTIVE_BLOCKS_BASE,
    MAP_HEADER_BASE,
    OBS_CELLS_BASE,
    OUTPUT_BASE,
    POSE_BASE,
    REGIONS,
    SCAN_POINTS_BASE,
)


def build_fixture():
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
    if (expected["valid_count"], expected["reject_count"], expected["miss_count"]) != (1, 0, 0):
        raise RuntimeError(f"unexpected synthetic counts: {expected}")

    obs_payload = bytearray()
    obs_payload.extend(pack_obs_cell((0.25, 0.25, 0.20), (0.0, 0.0, 1.0), -0.20, 1.0, 1, 1))
    obs_payload.extend(bytes(255 * OBS_CELL_BYTES))
    files = {
        "scan_points.bin": (SCAN_POINTS_BASE, b"".join(pack_scan_point(*point) for point in scan_points)),
        "pose.bin": (POSE_BASE, pack_pose()),
        "map_header.bin": (MAP_HEADER_BASE, pack_map_header(num_blocks=1, num_cells=256)),
        "active_blocks.bin": (ACTIVE_BLOCKS_BASE, pack_active_block(0, 0, 0, 0, 1)),
        "obs_cells.bin": (OBS_CELLS_BASE, bytes(obs_payload)),
        "output_zero.bin": (OUTPUT_BASE, bytes(NORMAL_EQUATION_BYTES)),
    }
    return files, expected, len(scan_points)


def main():
    parser = argparse.ArgumentParser(description="Generate tiny synthetic host-write images for XDMA smoke.")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--report-dir", required=True)
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    report_dir = Path(args.report_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    report_dir.mkdir(parents=True, exist_ok=True)

    files, expected, scan_count = build_fixture()
    manifest = {
        "name": "tiny_synthetic_host_image",
        "scan_count": scan_count,
        "segments": [],
        "expected": {
            "valid_count": expected["valid_count"],
            "reject_count": expected["reject_count"],
            "miss_count": expected["miss_count"],
            "residual_sum": expected["residual_sum"],
            "residual_abs_sum": expected["residual_abs_sum"],
            "residual_max_abs": expected["residual_max_abs"],
        },
        "regions": [{"name": item.name, "base": item.base, "size": item.size} for item in REGIONS],
    }

    for name, (base, payload) in files.items():
        write_bytes(out_dir / name, payload)
        manifest["segments"].append({"file": name, "base": base, "size": len(payload)})

    (out_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")

    lines = ["# Tiny Synthetic Host Image", "", "- marker: `HOST_SYNTHETIC_IMAGE_PASS`", f"- generated_dir: `{out_dir}`", ""]
    lines.append("| Segment | Base | Size |")
    lines.append("| --- | ---: | ---: |")
    for segment in manifest["segments"]:
        lines.append(f"| `{segment['file']}` | `0x{segment['base']:08x}` | {segment['size']} |")
    lines.extend(
        [
            "",
            f"- expected_counts: {expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}",
            f"- expected_residual_sum: {expected['residual_sum']:.17g}",
        ]
    )
    (report_dir / "tiny_synthetic_host_image.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    print("HOST_SYNTHETIC_IMAGE_PASS")
    print(f"generated_dir={out_dir}")
    print(f"manifest={out_dir / 'manifest.json'}")
    print(f"report={report_dir / 'tiny_synthetic_host_image.md'}")


if __name__ == "__main__":
    main()

