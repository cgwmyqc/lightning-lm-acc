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


SCAN_POINT = (1.25, 2.25, 1.25, 1.0)
CELL_IDX = (1 * 8 + 2) * 8 + 1
NUM_CELLS = 256


def base_pose():
    return {"qx": 0.0, "qy": 0.0, "qz": 0.0, "qw": 1.0, "tx": 0.0, "ty": 0.0, "tz": 0.0, "flags": 0}


def base_header():
    return {
        "magic": 0x53414C4D,
        "version": 1,
        "mode": 1,
        "cells_per_block": 256,
        "cell_resolution": 1.0,
        "inv_cell_resolution": 1.0,
        "window_id": 1,
        "window_version": 1,
        "num_blocks": 1,
        "num_cells": NUM_CELLS,
        "lookup_nearby_type": 0,
        "flags": 0,
    }


def empty_cell():
    return (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0, 0, 0)


def make_case(case_name):
    scan_points = [SCAN_POINT]
    pose = base_pose()
    map_header = base_header()
    blocks = [(0, 0, 0, 0, 1, 0, 0, 0)]
    cells = [empty_cell() for _ in range(NUM_CELLS)]

    if case_name == "valid_only":
        cells[CELL_IDX] = (1.25, 2.25, 1.20, 0.0, 0.0, 1.0, -1.20, 1.0, 1, 1, 0, 0, 0, 0, 0, 0)
    elif case_name == "reject_z_only":
        cells[CELL_IDX] = (1.25, 2.25, 0.80, 0.0, 0.0, 1.0, -0.80, 1.0, 1, 1, 0, 0, 0, 0, 0, 0)
    elif case_name == "reject_x_only":
        cells[CELL_IDX] = (0.80, 2.25, 1.25, 1.0, 0.0, 0.0, -0.80, 1.0, 1, 1, 0, 0, 0, 0, 0, 0)
    elif case_name == "miss_only":
        blocks = [(0, 0, 0, 0, 0, 0, 0, 0)]
    elif case_name == "invalid_flag_only":
        blocks = [(0, 0, 0, 0, 1, 0, 0, 0)]
        cells[CELL_IDX] = (1.25, 2.25, 1.20, 0.0, 0.0, 1.0, -1.20, 1.0, 1, 0, 0, 0, 0, 0, 0, 0)
    else:
        raise RuntimeError(f"unknown residual probe case: {case_name}")

    expected = compute_expected(scan_points, pose, map_header, blocks, cells)
    expected_counts = {
        "valid_only": (1, 0, 0),
        "reject_z_only": (0, 1, 0),
        "reject_x_only": (0, 1, 0),
        "miss_only": (0, 0, 1),
        "invalid_flag_only": (0, 0, 1),
    }[case_name]
    got_counts = (expected["valid_count"], expected["reject_count"], expected["miss_count"])
    if got_counts != expected_counts:
        raise RuntimeError(f"{case_name} expected counts {got_counts}, want {expected_counts}")

    obs_payload = bytearray(NUM_CELLS * OBS_CELL_BYTES)
    if case_name in ("valid_only", "reject_z_only", "reject_x_only", "invalid_flag_only"):
        cell = cells[CELL_IDX]
        obs_payload[CELL_IDX * OBS_CELL_BYTES : (CELL_IDX + 1) * OBS_CELL_BYTES] = pack_obs_cell(
            (cell[0], cell[1], cell[2]),
            (cell[3], cell[4], cell[5]),
            cell[6],
            cell[7],
            cell[8],
            cell[9],
        )

    files = {
        "scan_points.bin": (SCAN_POINTS_BASE, pack_scan_point(*SCAN_POINT)),
        "pose.bin": (POSE_BASE, pack_pose()),
        "map_header.bin": (MAP_HEADER_BASE, pack_map_header(num_blocks=1, num_cells=NUM_CELLS)),
        "active_blocks.bin": (ACTIVE_BLOCKS_BASE, pack_active_block(*blocks[0][:5])),
        "obs_cells.bin": (OBS_CELLS_BASE, bytes(obs_payload)),
        "output_zero.bin": (OUTPUT_BASE, bytes(NORMAL_EQUATION_BYTES)),
    }
    return files, expected


def write_manifest(case_dir, case_name, files, expected):
    manifest = {
        "name": f"residual_probe_{case_name}",
        "scan_count": 1,
        "segments": [],
        "expected": {
            "h_upper": expected["h_upper"],
            "b": expected["b"],
            "valid_count": expected["valid_count"],
            "reject_count": expected["reject_count"],
            "miss_count": expected["miss_count"],
            "flags": expected["flags"],
            "residual_sum": expected["residual_sum"],
            "residual_abs_sum": expected["residual_abs_sum"],
            "residual_max_abs": expected["residual_max_abs"],
        },
        "regions": [{"name": item.name, "base": item.base, "size": item.size} for item in REGIONS],
    }
    for name, (base, payload) in files.items():
        write_bytes(case_dir / name, payload)
        manifest["segments"].append({"file": name, "base": base, "size": len(payload)})
    (case_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    return manifest


def write_report(report_dir, out_dir, manifests):
    lines = [
        "# Stage 42 Residual Probe Host Images",
        "",
        "- marker: `HOST_RESIDUAL_PROBE_IMAGES_PASS`",
        f"- generated_dir: `{out_dir}`",
        "",
        "| Case | Expected counts | Purpose |",
        "| --- | ---: | --- |",
    ]
    purpose = {
        "valid_only": "baseline valid cell",
        "reject_z_only": "residual > 0.3 through normal_z/plane_d",
        "reject_x_only": "residual > 0.3 through normal_x/plane_d",
        "miss_only": "no valid cell at target index",
        "invalid_flag_only": "cell present but flags=0",
    }
    for case_name, manifest in manifests.items():
        expected = manifest["expected"]
        counts = f"{expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}"
        lines.append(f"| `{case_name}` | `{counts}` | {purpose[case_name]} |")

    lines.extend(["", "## Orin commands", "", "```bash"])
    lines.append("sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000")
    lines.append("sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke")
    for case_name in manifests:
        lines.append(
            "sudo python3 fpga/host/xdma_smoke/xdma_smoke.py "
            f"--hls-manifest fpga/vivado/.build/host_residual_probe/{case_name}/manifest.json "
            "--ctrl-base 0x1000 --dump-normal-equation"
        )
    lines.extend(["```", "", "Each probe must print `HLS_MANIFEST_NUMERIC_PASS`."])
    (report_dir / "residual_probe_host_images.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Generate residual reject probe manifests for XDMA/HLS board debug.")
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--report-dir", required=True)
    args = parser.parse_args()

    out_dir = Path(args.out_dir)
    report_dir = Path(args.report_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    report_dir.mkdir(parents=True, exist_ok=True)

    case_names = ["valid_only", "reject_z_only", "reject_x_only", "miss_only", "invalid_flag_only"]
    manifests = {}
    for case_name in case_names:
        case_dir = out_dir / case_name
        case_dir.mkdir(parents=True, exist_ok=True)
        files, expected = make_case(case_name)
        manifests[case_name] = write_manifest(case_dir, case_name, files, expected)

    write_report(report_dir, out_dir, manifests)
    print("HOST_RESIDUAL_PROBE_IMAGES_PASS")
    print(f"generated_dir={out_dir}")
    print(f"report={report_dir / 'residual_probe_host_images.md'}")


if __name__ == "__main__":
    main()
