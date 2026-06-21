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

from make_golden_mem_images import (  # noqa: E402
    ACTIVE_MAP_HEADER_BYTES,
    GOLDEN_ACTIVE_MAP,
    GOLDEN_NORMAL_EQUATION,
    GOLDEN_POSE,
    GOLDEN_SCAN_POINTS,
    NORMAL_EQUATION_BYTES,
    POSE_BYTES,
    SCAN_POINT_BYTES,
    compute_expected,
    parse_active_blocks,
    parse_active_map,
    parse_expected,
    parse_map_header,
    parse_obs_cells,
    parse_pose,
    parse_scan_points,
    read_header,
    write_bytes,
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


def build_manifest(golden_dir, out_dir, max_points):
    scan_payload, num_points, _, _ = read_header(golden_dir / "loc_scan.bin", GOLDEN_SCAN_POINTS, SCAN_POINT_BYTES)
    pose_payload, pose_count, _, _ = read_header(golden_dir / "loc_pose.bin", GOLDEN_POSE, POSE_BYTES)
    active_payload, _, _, _ = read_header(golden_dir / "loc_active_map.bin", GOLDEN_ACTIVE_MAP, ACTIVE_MAP_HEADER_BYTES)
    expected_payload, expected_count, _, _ = read_header(
        golden_dir / "loc_expected_obs.bin", GOLDEN_NORMAL_EQUATION, NORMAL_EQUATION_BYTES
    )
    if pose_count != 1:
        raise RuntimeError("loc_pose.bin must contain exactly one pose")
    if expected_count != 1:
        raise RuntimeError("loc_expected_obs.bin must contain exactly one normal equation")

    map_header, active_blocks, obs_cells, num_blocks, num_cells = parse_active_map(active_payload)
    full_expected = parse_expected(expected_payload)
    sim_points = num_points if max_points <= 0 else min(num_points, max_points)
    scan_bytes = scan_payload[: sim_points * SCAN_POINT_BYTES]
    if sim_points == num_points:
        expected = full_expected
    else:
        scan_points = parse_scan_points(scan_payload, sim_points)
        pose = parse_pose(pose_payload)
        parsed_header = parse_map_header(map_header)
        parsed_blocks = parse_active_blocks(active_blocks, num_blocks)
        parsed_cells = parse_obs_cells(obs_cells, num_cells)
        expected = compute_expected(scan_points, pose, parsed_header, parsed_blocks, parsed_cells)

    files = {
        "scan_points.bin": (SCAN_POINTS_BASE, scan_bytes),
        "pose.bin": (POSE_BASE, pose_payload),
        "map_header.bin": (MAP_HEADER_BASE, map_header),
        "active_blocks.bin": (ACTIVE_BLOCKS_BASE, active_blocks),
        "obs_cells.bin": (OBS_CELLS_BASE, obs_cells),
        "output_zero.bin": (OUTPUT_BASE, bytes(NORMAL_EQUATION_BYTES)),
    }

    manifest = {
        "name": "golden_frame_000001_host_image",
        "golden_dir": str(golden_dir),
        "max_points": max_points,
        "full_scan_count": num_points,
        "scan_count": sim_points,
        "active_blocks": num_blocks,
        "obs_cells": num_cells,
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
        write_bytes(out_dir / name, payload)
        manifest["segments"].append({"file": name, "base": base, "size": len(payload)})
    return manifest


def write_report(report_dir, out_dir, manifest):
    frame_label = "full" if manifest["scan_count"] == manifest["full_scan_count"] else f"n{manifest['scan_count']}"
    command_out_dir = (
        "fpga/vivado/.build/host_golden_frame_000001_full"
        if frame_label == "full"
        else f"fpga/vivado/.build/host_golden_frame_000001_{frame_label}"
    )
    command_report_dir = (
        "reports/fpga/host/xdma_smoke/golden_frame_000001_full"
        if frame_label == "full"
        else f"reports/fpga/host/xdma_smoke/golden_frame_000001_{frame_label}"
    )
    hls_command = (
        "sudo python3 fpga/host/xdma_smoke/xdma_smoke.py "
        f"--hls-manifest {command_out_dir}/manifest.json --ctrl-base 0x1000"
    )
    if frame_label == "full":
        hls_command += (
            " --hls-timeout-sec 120 --verify-image-readback --read-regs-after-config "
            "--dump-output-raw-words --dump-normal-equation "
            "--save-output-json reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json"
        )
    lines = [
        f"# Golden frame_000001 {frame_label} Host Image",
        "",
        "- marker: `HOST_GOLDEN_IMAGE_PASS`",
        f"- golden_dir: `{manifest['golden_dir']}`",
        f"- generated_dir: `{out_dir}`",
        f"- full_scan_count: {manifest['full_scan_count']}",
        f"- scan_count: {manifest['scan_count']}",
        f"- max_points_arg: {manifest['max_points']}",
        f"- active_blocks: {manifest['active_blocks']}",
        f"- obs_cells: {manifest['obs_cells']}",
        "",
        "| Segment | Base | Size |",
        "| --- | ---: | ---: |",
    ]
    for segment in manifest["segments"]:
        lines.append(f"| `{segment['file']}` | `0x{segment['base']:08x}` | {segment['size']} |")
    expected = manifest["expected"]
    lines.extend(
        [
            "",
            f"- expected_counts: {expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}",
            f"- expected_residual_sum: {expected['residual_sum']:.17g}",
            f"- expected_h_upper_entries: {len(expected['h_upper'])}",
            f"- expected_b_entries: {len(expected['b'])}",
            "",
            "## Orin command",
            "",
            "```bash",
            "python3 fpga/host/xdma_smoke/make_golden_host_image.py "
            f"--golden-dir fpga/golden/localization/frame_000001 --max-points {manifest['max_points']} "
            f"--out-dir {command_out_dir} --report-dir {command_report_dir}",
            hls_command,
            "```",
            "",
            "Expected markers: `HLS_MANIFEST_START_PASS`, `HLS_MANIFEST_DONE_PASS`, `HLS_MANIFEST_NUMERIC_PASS`.",
        ]
    )
    (report_dir / "golden_host_image.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Generate a host-write golden image manifest for XDMA/HLS board smoke.")
    parser.add_argument("--golden-dir", required=True)
    parser.add_argument("--max-points", type=int, default=64)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--report-dir", required=True)
    args = parser.parse_args()

    golden_dir = Path(args.golden_dir)
    out_dir = Path(args.out_dir)
    report_dir = Path(args.report_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    report_dir.mkdir(parents=True, exist_ok=True)

    manifest = build_manifest(golden_dir, out_dir, args.max_points)
    (out_dir / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")
    write_report(report_dir, out_dir, manifest)

    print("HOST_GOLDEN_IMAGE_PASS")
    print(f"generated_dir={out_dir}")
    print(f"manifest={out_dir / 'manifest.json'}")
    print(f"report={report_dir / 'golden_host_image.md'}")


if __name__ == "__main__":
    main()
