#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import bisect
import json
import math
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
REPO_ROOT = SCRIPT_DIR.parents[2]
MEM_HARNESS_DIR = REPO_ROOT / "fpga" / "vivado" / "slam_accel_hls_mem_harness"
sys.path.insert(0, str(MEM_HARNESS_DIR))
sys.path.insert(0, str(SCRIPT_DIR))

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
    parse_active_blocks,
    parse_active_map,
    parse_expected,
    parse_map_header,
    parse_obs_cells,
    parse_pose,
    parse_scan_points,
    read_header,
    rotate_point,
)
from make_golden_trace_host_images import lookup_cell_trace, lookup_nearest_trace  # noqa: E402


def load_golden(golden_dir, point_index):
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
    if point_index < 0 or point_index >= num_points:
        raise RuntimeError(f"point index {point_index} outside scan count {num_points}")

    map_header, active_blocks, obs_cells, num_blocks, num_cells = parse_active_map(active_payload)
    parsed_header = parse_map_header(map_header)
    parsed_blocks = parse_active_blocks(active_blocks, num_blocks)
    parsed_cells = parse_obs_cells(obs_cells, num_cells)
    pose = parse_pose(pose_payload)
    scan = parse_scan_points(scan_payload[point_index * SCAN_POINT_BYTES : (point_index + 1) * SCAN_POINT_BYTES], 1)[0]
    full_expected = parse_expected(expected_payload)
    point_expected = compute_expected([scan], pose, parsed_header, parsed_blocks, parsed_cells)
    point_world = rotate_point(pose, scan)
    block_keys = [(b[0], b[1], b[2]) for b in parsed_blocks]
    return {
        "num_points": num_points,
        "num_blocks": num_blocks,
        "num_cells": num_cells,
        "map_header": parsed_header,
        "blocks": parsed_blocks,
        "cells": parsed_cells,
        "block_keys": block_keys,
        "pose": pose,
        "scan": scan,
        "point_world": point_world,
        "full_expected": full_expected,
        "point_expected": point_expected,
    }


def infer_actual_jacobian(actual):
    residual = float(actual["residual_sum"])
    if actual["valid_count"] != 1 or actual["reject_count"] != 0 or actual["miss_count"] != 0:
        raise RuntimeError("actual output must be a single valid-point normal equation")
    if abs(residual) < 1.0e-12:
        raise RuntimeError("cannot infer jacobian from near-zero residual")
    return [float(value) / residual for value in actual["b"]], residual


def local_neighbor_positions(map_header, point):
    center_bx, center_by, center_bz, center_cell = encode(point, map_header)
    lookup_type = map_header["lookup_nearby_type"]
    neighbor_limit = 0 if lookup_type <= 0 else (6 if lookup_type <= 6 else (18 if lookup_type <= 18 else 26))
    bx_dim = 8
    by_dim = 8
    bz_dim = 4
    local = center_cell
    center_lx = local % bx_dim
    local //= bx_dim
    center_ly = local % by_dim
    center_lz = local // by_dim
    out = [(0, 0, 0, center_bx, center_by, center_bz, center_cell)]
    if neighbor_limit == 0:
        return out
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
                out.append((dx, dy, dz, nbx, nby, nbz, ncell))
    return out


def summarize_cell(cell, point):
    residual = cell[3] * point[0] + cell[4] * point[1] + cell[5] * point[2] + cell[6]
    jacobian = [
        cell[3],
        cell[4],
        cell[5],
        cell[5] * point[1] - cell[4] * point[2],
        cell[3] * point[2] - cell[5] * point[0],
        cell[4] * point[0] - cell[3] * point[1],
    ]
    return residual, jacobian


def block_for_offset(blocks, offset):
    first_cells = [b[3] for b in blocks]
    idx = bisect.bisect_right(first_cells, offset) - 1
    if idx < 0:
        return None
    block = blocks[idx]
    local = offset - block[3]
    if local < 0 or local >= 256:
        return None
    return idx, block, local


def cell_to_json(offset, cell, point, blocks, actual_j, actual_residual, legal_offsets):
    residual, jacobian = summarize_cell(cell, point)
    jacobian_l2 = math.sqrt(sum((a - b) * (a - b) for a, b in zip(jacobian, actual_j)))
    normal_l2 = math.sqrt(sum((cell[i + 3] - actual_j[i]) * (cell[i + 3] - actual_j[i]) for i in range(3)))
    residual_abs_diff = abs(residual - actual_residual)
    block_info = block_for_offset(blocks, offset)
    block_idx = None
    block_x = block_y = block_z = cell_idx = None
    if block_info is not None:
        block_idx, block, cell_idx = block_info
        block_x, block_y, block_z = block[0], block[1], block[2]
    return {
        "offset": offset,
        "block_idx": block_idx,
        "block_x": block_x,
        "block_y": block_y,
        "block_z": block_z,
        "cell_idx": cell_idx,
        "legal_cpu_neighbor": offset in legal_offsets,
        "score": jacobian_l2 + residual_abs_diff,
        "jacobian_l2": jacobian_l2,
        "normal_l2": normal_l2,
        "residual": residual,
        "residual_abs_diff": residual_abs_diff,
        "centroid": [cell[0], cell[1], cell[2]],
        "normal": [cell[3], cell[4], cell[5]],
        "plane_d": cell[6],
        "quality": cell[7],
        "count": int(cell[8]),
        "flags": int(cell[9]),
        "jacobian": jacobian,
    }


def collect_legal_neighbors(data):
    rows = []
    legal_offsets = set()
    for dx, dy, dz, bx, by, bz, cell_idx in local_neighbor_positions(data["map_header"], data["point_world"]):
        hit = lookup_cell_trace(data["map_header"], data["block_keys"], data["blocks"], data["cells"], bx, by, bz, cell_idx)
        row = {
            "neighbor_dx": dx,
            "neighbor_dy": dy,
            "neighbor_dz": dz,
            "block_x": bx,
            "block_y": by,
            "block_z": bz,
            "cell_idx": cell_idx,
            "hit": hit is not None,
        }
        if hit is not None:
            cell = hit["cell"]
            residual, jacobian = summarize_cell(cell, data["point_world"])
            row.update(
                {
                    "block_idx": hit["block_idx"],
                    "cell_offset": hit["cell_offset"],
                    "flags": int(cell[9]),
                    "residual": residual,
                    "normal": [cell[3], cell[4], cell[5]],
                    "plane_d": cell[6],
                    "jacobian": jacobian,
                }
            )
            legal_offsets.add(hit["cell_offset"])
        rows.append(row)
    return rows, legal_offsets


def scan_best_candidates(data, actual_j, actual_residual, legal_offsets, max_candidates):
    best = []
    for offset, cell in enumerate(data["cells"]):
        if (int(cell[9]) & 1) == 0:
            continue
        item = cell_to_json(offset, cell, data["point_world"], data["blocks"], actual_j, actual_residual, legal_offsets)
        best.append(item)
        best.sort(key=lambda entry: entry["score"])
        if len(best) > max_candidates:
            best.pop()
    return best


def write_report(report_dir, payload):
    lines = [
        "# Stage 46 Lookup Mismatch Analysis",
        "",
        "- marker: `LOOKUP_MISMATCH_ANALYSIS_PASS`",
        f"- golden_dir: `{payload['golden_dir']}`",
        f"- point_index: {payload['point_index']}",
        f"- point_world: {payload['point_world']}",
        f"- point_expected_counts: {payload['point_expected_counts']}",
        f"- actual_counts: {payload['actual_counts']}",
        f"- actual_residual: {payload['actual_residual']:.17g}",
        f"- cpu_lookup_result: {payload['cpu_lookup_result']}",
        "",
        "## Best inferred HLS candidates",
        "",
        "| Rank | Offset | Block/Cell | Legal CPU neighbor | Score | Residual | Normal |",
        "| ---: | ---: | --- | --- | ---: | ---: | --- |",
    ]
    for rank, item in enumerate(payload["best_candidates"], start=1):
        lines.append(
            f"| {rank} | {item['offset']} | "
            f"({item['block_x']},{item['block_y']},{item['block_z']})/{item['cell_idx']} | "
            f"{item['legal_cpu_neighbor']} | {item['score']:.6g} | {item['residual']:.17g} | "
            f"{item['normal']} |"
        )
    lines.extend(
        [
            "",
            "## CPU legal neighbor probes",
            "",
            "| dxyz | Block/Cell | Hit | Cell offset | Residual |",
            "| --- | --- | --- | ---: | ---: |",
        ]
    )
    for item in payload["cpu_neighbor_probes"]:
        lines.append(
            f"| ({item['neighbor_dx']},{item['neighbor_dy']},{item['neighbor_dz']}) | "
            f"({item['block_x']},{item['block_y']},{item['block_z']})/{item['cell_idx']} | "
            f"{item['hit']} | {item.get('cell_offset')} | {item.get('residual')} |"
        )
    lines.extend(
        [
            "",
            "## Conclusion",
            "",
            payload["conclusion"],
        ]
    )
    (report_dir / "lookup_mismatch_analysis.md").write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Infer which real map cell HLS used for a CPU lookup miss.")
    parser.add_argument("--golden-dir", required=True)
    parser.add_argument("--point-index", type=int, required=True)
    parser.add_argument("--actual-json", required=True)
    parser.add_argument("--report-dir", required=True)
    parser.add_argument("--max-candidates", type=int, default=12)
    args = parser.parse_args()

    golden_dir = Path(args.golden_dir)
    report_dir = Path(args.report_dir)
    report_dir.mkdir(parents=True, exist_ok=True)
    actual_json_path = Path(args.actual_json)
    actual_payload = json.loads(actual_json_path.read_text(encoding="utf-8"))
    actual = actual_payload["actual"]
    data = load_golden(golden_dir, args.point_index)
    actual_j, actual_residual = infer_actual_jacobian(actual)
    cpu_hit = lookup_nearest_trace(
        data["map_header"], data["block_keys"], data["blocks"], data["cells"], data["point_world"]
    )
    cpu_neighbors, legal_offsets = collect_legal_neighbors(data)
    best = scan_best_candidates(data, actual_j, actual_residual, legal_offsets, args.max_candidates)

    if best and best[0]["legal_cpu_neighbor"]:
        conclusion = (
            "The best inferred HLS cell is in the CPU legal neighbor set. Recheck CPU/Python trace and "
            "expected recomputation for this point."
        )
    elif best:
        conclusion = (
            "The best inferred HLS cell is not in the CPU legal neighbor set. The next fix should target "
            "HLS lookup/address/packed AXI reading or synthesized neighbor selection."
        )
    else:
        conclusion = "No valid cells were available for inference; generate a Stage 46 debug bitstream."

    payload = {
        "golden_dir": str(golden_dir),
        "actual_json": str(actual_json_path),
        "point_index": args.point_index,
        "point_world": list(data["point_world"]),
        "scan": list(data["scan"]),
        "map_header": data["map_header"],
        "num_blocks": data["num_blocks"],
        "num_cells": data["num_cells"],
        "point_expected_counts": (
            f"{data['point_expected']['valid_count']}/"
            f"{data['point_expected']['reject_count']}/"
            f"{data['point_expected']['miss_count']}"
        ),
        "actual_counts": f"{actual['valid_count']}/{actual['reject_count']}/{actual['miss_count']}",
        "actual_residual": actual_residual,
        "actual_jacobian": actual_j,
        "cpu_lookup_result": "hit" if cpu_hit is not None else "miss",
        "cpu_neighbor_probes": cpu_neighbors,
        "best_candidates": best,
        "conclusion": conclusion,
    }
    (report_dir / "lookup_mismatch_analysis.json").write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    write_report(report_dir, payload)

    print("LOOKUP_MISMATCH_ANALYSIS_PASS")
    print(f"report={report_dir / 'lookup_mismatch_analysis.md'}")
    print(f"json={report_dir / 'lookup_mismatch_analysis.json'}")
    print(f"cpu_lookup_result={payload['cpu_lookup_result']}")
    if best:
        top = best[0]
        print(
            "best_candidate="
            f"offset={top['offset']} block=({top['block_x']},{top['block_y']},{top['block_z']})/"
            f"{top['cell_idx']} legal_cpu_neighbor={top['legal_cpu_neighbor']} score={top['score']:.6g}"
        )
    print(f"conclusion={conclusion}")


if __name__ == "__main__":
    main()
