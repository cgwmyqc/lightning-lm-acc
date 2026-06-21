#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import bisect
import csv
import json
import math
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
    encode,
    lookup_nearest,
    parse_active_blocks,
    parse_active_map,
    parse_expected,
    parse_map_header,
    parse_obs_cells,
    parse_pose,
    parse_scan_points,
    read_header,
    rotate_point,
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


def lookup_cell_trace(map_header, block_keys, blocks, cells, block_x, block_y, block_z, cell_idx):
    block_idx = bisect.bisect_left(block_keys, (block_x, block_y, block_z))
    if block_idx >= len(blocks) or block_keys[block_idx] != (block_x, block_y, block_z):
        return None
    offset = blocks[block_idx][3] + cell_idx
    if offset >= map_header["num_cells"]:
        return None
    cell = cells[offset]
    flags = cell[9]
    if (flags & 1) == 0:
        return None
    return {
        "cell": cell,
        "block_idx": block_idx,
        "cell_offset": offset,
        "block_x": block_x,
        "block_y": block_y,
        "block_z": block_z,
        "cell_idx": cell_idx,
        "neighbor_dx": 0,
        "neighbor_dy": 0,
        "neighbor_dz": 0,
    }


def lookup_nearest_trace(map_header, block_keys, blocks, cells, point):
    center_bx, center_by, center_bz, center_cell = encode(point, map_header)
    center = {
        "center_block_x": center_bx,
        "center_block_y": center_by,
        "center_block_z": center_bz,
        "center_cell_idx": center_cell,
    }
    found = lookup_cell_trace(map_header, block_keys, blocks, cells, center_bx, center_by, center_bz, center_cell)
    if found is not None:
        found.update(center)
        found["lookup_source"] = "center"
        found["dist2"] = 0.0
        return found
    if map_header["lookup_nearby_type"] == 0:
        return None

    lookup_type = map_header["lookup_nearby_type"]
    neighbor_limit = 6 if lookup_type <= 6 else (18 if lookup_type <= 18 else 26)
    bx_dim = 8
    by_dim = 8
    bz_dim = 4
    local = center_cell
    center_lx = local % bx_dim
    local //= bx_dim
    center_ly = local % by_dim
    center_lz = local // by_dim

    best = None
    best_dist2 = 1.0e100
    for dz in range(-1, 2):
        for dy in range(-1, 2):
            for dx in range(-1, 2):
                manhattan = abs(dx) + abs(dy) + abs(dz)
                chessboard = max(abs(dx), abs(dy), abs(dz))
                if manhattan == 0:
                    continue
                if (neighbor_limit == 6 and manhattan != 1) or (
                    neighbor_limit == 18 and (chessboard > 1 or manhattan > 2)
                ):
                    continue
                lx = center_lx + dx
                ly = center_ly + dy
                lz = center_lz + dz
                nbx = center_bx
                nby = center_by
                nbz = center_bz
                if lx < 0:
                    lx += bx_dim
                    nbx -= 1
                elif lx >= bx_dim:
                    lx -= bx_dim
                    nbx += 1
                if ly < 0:
                    ly += by_dim
                    nby -= 1
                elif ly >= by_dim:
                    ly -= by_dim
                    nby += 1
                if lz < 0:
                    lz += bz_dim
                    nbz -= 1
                elif lz >= bz_dim:
                    lz -= bz_dim
                    nbz += 1
                ncell = (lz * by_dim + ly) * bx_dim + lx
                candidate = lookup_cell_trace(map_header, block_keys, blocks, cells, nbx, nby, nbz, ncell)
                if candidate is None:
                    continue
                cell = candidate["cell"]
                ddx = point[0] - cell[0]
                ddy = point[1] - cell[1]
                ddz = point[2] - cell[2]
                dist2 = ddx * ddx + ddy * ddy + ddz * ddz
                if best is None or dist2 < best_dist2:
                    candidate.update(center)
                    candidate["lookup_source"] = "neighbor"
                    candidate["neighbor_dx"] = dx
                    candidate["neighbor_dy"] = dy
                    candidate["neighbor_dz"] = dz
                    candidate["dist2"] = dist2
                    best = candidate
                    best_dist2 = dist2
    return best


def classify_point(scan, pose, map_header, block_keys, blocks, cells):
    if not (math.isfinite(scan[0]) and math.isfinite(scan[1]) and math.isfinite(scan[2])):
        return {"class": "reject", "reason": "nonfinite"}
    point = rotate_point(pose, scan)
    center_bx, center_by, center_bz, center_cell = encode(point, map_header)
    hit = lookup_nearest_trace(map_header, block_keys, blocks, cells, point)
    row = {
        "point_world_x": point[0],
        "point_world_y": point[1],
        "point_world_z": point[2],
        "center_block_x": center_bx,
        "center_block_y": center_by,
        "center_block_z": center_bz,
        "center_cell_idx": center_cell,
    }
    if hit is None:
        row.update({"class": "miss", "reason": "lookup_miss"})
        return row
    cell = hit["cell"]
    residual = cell[3] * point[0] + cell[4] * point[1] + cell[5] * point[2] + cell[6]
    abs_residual = abs(residual)
    row.update(
        {
            "residual": residual,
            "abs_residual": abs_residual,
            "cell_centroid_x": cell[0],
            "cell_centroid_y": cell[1],
            "cell_centroid_z": cell[2],
            "normal_x": cell[3],
            "normal_y": cell[4],
            "normal_z": cell[5],
            "plane_d": cell[6],
            "cell_flags": int(cell[9]),
            "cell_offset": int(hit["cell_offset"]),
            "block_idx": int(hit["block_idx"]),
            "block_x": int(hit["block_x"]),
            "block_y": int(hit["block_y"]),
            "block_z": int(hit["block_z"]),
            "cell_idx": int(hit["cell_idx"]),
            "center_block_x": int(hit["center_block_x"]),
            "center_block_y": int(hit["center_block_y"]),
            "center_block_z": int(hit["center_block_z"]),
            "center_cell_idx": int(hit["center_cell_idx"]),
            "lookup_source": hit["lookup_source"],
            "neighbor_dx": int(hit["neighbor_dx"]),
            "neighbor_dy": int(hit["neighbor_dy"]),
            "neighbor_dz": int(hit["neighbor_dz"]),
            "dist2": hit["dist2"],
        }
    )
    if not math.isfinite(residual) or abs_residual > 0.3:
        row.update({"class": "reject", "reason": "residual_outlier"})
    else:
        row.update({"class": "valid", "reason": "inlier"})
    return row


def expected_to_json(expected):
    return {
        "h_upper": list(expected["h_upper"]),
        "b": list(expected["b"]),
        "valid_count": expected["valid_count"],
        "reject_count": expected["reject_count"],
        "miss_count": expected["miss_count"],
        "flags": expected["flags"],
        "residual_sum": expected["residual_sum"],
        "residual_abs_sum": expected["residual_abs_sum"],
        "residual_max_abs": expected["residual_max_abs"],
    }


def make_manifest(name, golden_dir, scan_count, segments, expected, full_scan_count, num_blocks, num_cells, point_index=None):
    manifest = {
        "name": name,
        "golden_dir": str(golden_dir),
        "scan_count": scan_count,
        "full_scan_count": full_scan_count,
        "active_blocks": num_blocks,
        "obs_cells": num_cells,
        "segments": segments,
        "expected": expected_to_json(expected),
        "regions": [{"name": item.name, "base": item.base, "size": item.size} for item in REGIONS],
    }
    if point_index is not None:
        manifest["source_point_index"] = point_index
    return manifest


def write_manifest(path, manifest):
    path.write_text(json.dumps(manifest, indent=2) + "\n", encoding="utf-8")


def write_trace_csv(path, rows):
    fieldnames = [
        "index",
        "class",
        "reason",
        "scan_x",
        "scan_y",
        "scan_z",
        "point_world_x",
        "point_world_y",
        "point_world_z",
        "center_block_x",
        "center_block_y",
        "center_block_z",
        "center_cell_idx",
        "lookup_source",
        "neighbor_dx",
        "neighbor_dy",
        "neighbor_dz",
        "block_idx",
        "block_x",
        "block_y",
        "block_z",
        "cell_idx",
        "cell_offset",
        "cell_flags",
        "normal_x",
        "normal_y",
        "normal_z",
        "plane_d",
        "residual",
        "abs_residual",
        "dist2",
    ]
    with path.open("w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=fieldnames, extrasaction="ignore")
        writer.writeheader()
        for row in rows:
            writer.writerow(row)


def build(golden_dir, out_dir, report_dir, max_points):
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
    parsed_header = parse_map_header(map_header)
    parsed_blocks = parse_active_blocks(active_blocks, num_blocks)
    parsed_cells = parse_obs_cells(obs_cells, num_cells)
    pose = parse_pose(pose_payload)
    sim_points = num_points if max_points <= 0 else min(num_points, max_points)
    scan_points = parse_scan_points(scan_payload, sim_points)
    full_expected = parse_expected(expected_payload)
    expected = full_expected if sim_points == num_points else compute_expected(
        scan_points, pose, parsed_header, parsed_blocks, parsed_cells
    )

    write_bytes(out_dir / "scan_points_n64.bin", scan_payload[: sim_points * SCAN_POINT_BYTES])
    write_bytes(out_dir / "pose.bin", pose_payload)
    write_bytes(out_dir / "map_header.bin", map_header)
    write_bytes(out_dir / "active_blocks.bin", active_blocks)
    write_bytes(out_dir / "obs_cells.bin", obs_cells)
    write_bytes(out_dir / "output_zero.bin", bytes(NORMAL_EQUATION_BYTES))

    common_segments = [
        {"file": "scan_points_n64.bin", "base": SCAN_POINTS_BASE, "size": sim_points * SCAN_POINT_BYTES},
        {"file": "pose.bin", "base": POSE_BASE, "size": len(pose_payload)},
        {"file": "map_header.bin", "base": MAP_HEADER_BASE, "size": len(map_header)},
        {"file": "active_blocks.bin", "base": ACTIVE_BLOCKS_BASE, "size": len(active_blocks)},
        {"file": "obs_cells.bin", "base": OBS_CELLS_BASE, "size": len(obs_cells)},
        {"file": "output_zero.bin", "base": OUTPUT_BASE, "size": NORMAL_EQUATION_BYTES},
    ]
    n64_manifest = make_manifest(
        f"golden_frame_000001_n{sim_points}_trace",
        golden_dir,
        sim_points,
        common_segments,
        expected,
        num_points,
        num_blocks,
        num_cells,
    )
    write_manifest(out_dir / "manifest.json", n64_manifest)

    block_keys = [(b[0], b[1], b[2]) for b in parsed_blocks]
    trace_rows = []
    selected = {}
    counts = {"valid": 0, "reject": 0, "miss": 0}
    for index, scan in enumerate(scan_points):
        row = classify_point(scan, pose, parsed_header, block_keys, parsed_blocks, parsed_cells)
        row.update({"index": index, "scan_x": scan[0], "scan_y": scan[1], "scan_z": scan[2]})
        trace_rows.append(row)
        cls = row["class"]
        counts[cls] += 1
        selected.setdefault(cls, index)

    write_trace_csv(out_dir / "n64_trace.csv", trace_rows)
    (out_dir / "n64_trace.json").write_text(json.dumps(trace_rows, indent=2) + "\n", encoding="utf-8")

    probe_manifests = {}
    for cls in ("valid", "reject", "miss"):
        if cls not in selected:
            continue
        point_index = selected[cls]
        point_dir = out_dir / f"real_{cls}_point"
        point_dir.mkdir(parents=True, exist_ok=True)
        point_scan = scan_payload[point_index * SCAN_POINT_BYTES : (point_index + 1) * SCAN_POINT_BYTES]
        write_bytes(point_dir / "scan_points.bin", point_scan)
        write_bytes(point_dir / "output_zero.bin", bytes(NORMAL_EQUATION_BYTES))
        point_expected = compute_expected([scan_points[point_index]], pose, parsed_header, parsed_blocks, parsed_cells)
        point_segments = [
            {"file": "scan_points.bin", "base": SCAN_POINTS_BASE, "size": SCAN_POINT_BYTES},
            {"file": "../pose.bin", "base": POSE_BASE, "size": len(pose_payload)},
            {"file": "../map_header.bin", "base": MAP_HEADER_BASE, "size": len(map_header)},
            {"file": "../active_blocks.bin", "base": ACTIVE_BLOCKS_BASE, "size": len(active_blocks)},
            {"file": "../obs_cells.bin", "base": OBS_CELLS_BASE, "size": len(obs_cells)},
            {"file": "output_zero.bin", "base": OUTPUT_BASE, "size": NORMAL_EQUATION_BYTES},
        ]
        manifest = make_manifest(
            f"golden_frame_000001_real_{cls}_point",
            golden_dir,
            1,
            point_segments,
            point_expected,
            num_points,
            num_blocks,
            num_cells,
            point_index=point_index,
        )
        write_manifest(point_dir / "manifest.json", manifest)
        probe_manifests[cls] = str(point_dir / "manifest.json")

    lines = [
        "# Stage 45 Golden n64 Trace",
        "",
        "- marker: `HOST_GOLDEN_TRACE_PASS`",
        f"- golden_dir: `{golden_dir}`",
        f"- generated_dir: `{out_dir}`",
        f"- full_scan_count: {num_points}",
        f"- trace_scan_count: {sim_points}",
        f"- trace_counts: {counts['valid']}/{counts['reject']}/{counts['miss']}",
        f"- expected_counts: {expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}",
        f"- active_blocks: {num_blocks}",
        f"- obs_cells: {num_cells}",
        "",
        "## Selected real points",
        "",
    ]
    for cls in ("valid", "reject", "miss"):
        if cls in selected:
            row = trace_rows[selected[cls]]
            lines.append(
                f"- {cls}: index={selected[cls]}, reason={row['reason']}, "
                f"center=({row.get('center_block_x')},{row.get('center_block_y')},{row.get('center_block_z')})/"
                f"{row.get('center_cell_idx')}, residual={row.get('residual')}"
            )
            lines.append(f"  manifest: `{probe_manifests[cls]}`")
        else:
            lines.append(f"- {cls}: not present in this bounded trace")
    command_lines = []
    for cls in ("valid", "reject", "miss"):
        if cls in probe_manifests:
            command_lines.append(
                "sudo python3 fpga/host/xdma_smoke/xdma_smoke.py "
                f"--hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_{cls}_point/manifest.json "
                "--ctrl-base 0x1000 --verify-image-readback --read-regs-after-config "
                "--dump-output-raw-words --dump-normal-equation"
            )
    lines.extend(
        [
            "",
            "## Orin commands",
            "",
            "```bash",
            *command_lines,
            "```",
        ]
    )
    (report_dir / "golden_trace.md").write_text("\n".join(lines) + "\n", encoding="utf-8")

    return counts, expected, probe_manifests


def main():
    parser = argparse.ArgumentParser(description="Generate Stage 45 n64 trace and real single-point manifests.")
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

    counts, expected, probe_manifests = build(golden_dir, out_dir, report_dir, args.max_points)
    print("HOST_GOLDEN_TRACE_PASS")
    print(f"generated_dir={out_dir}")
    print(f"report={report_dir / 'golden_trace.md'}")
    print(f"trace_counts={counts['valid']}/{counts['reject']}/{counts['miss']}")
    print(f"expected_counts={expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}")
    for cls, path in probe_manifests.items():
        print(f"{cls}_manifest={path}")


if __name__ == "__main__":
    main()
