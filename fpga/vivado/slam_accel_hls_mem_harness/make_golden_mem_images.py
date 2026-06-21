#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import bisect
import math
import os
import struct
from pathlib import Path


ABI_MAGIC = 0x53414C4D
GOLDEN_VERSION = 1
GOLDEN_SCAN_POINTS = 1
GOLDEN_POSE = 2
GOLDEN_ACTIVE_MAP = 3
GOLDEN_NORMAL_EQUATION = 4

SCAN_POINT_BYTES = 16
POSE_BYTES = 32
ACTIVE_MAP_HEADER_BYTES = 64
ACTIVE_BLOCK_BYTES = 32
OBS_CELL_BYTES = 64
NORMAL_EQUATION_BYTES = 320

POSE_ADDR = 0
MAP_HEADER_ADDR = 64


def read_header(path, expected_type, expected_record_bytes):
    raw = path.read_bytes()
    if len(raw) < 64:
        raise RuntimeError(f"{path} is shorter than a GoldenFileHeader")
    fields = struct.unpack_from("<7I9I", raw, 0)
    magic, version, record_type, record_bytes, record_count, mode, flags = fields[:7]
    if magic != ABI_MAGIC or version != GOLDEN_VERSION:
        raise RuntimeError(f"{path} has bad magic/version")
    if record_type != expected_type or record_bytes != expected_record_bytes:
        raise RuntimeError(
            f"{path} has type/record size {record_type}/{record_bytes}, "
            f"expected {expected_type}/{expected_record_bytes}"
        )
    return raw[64:], record_count, mode, flags


def write_bytes(path, data):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)


def double_bits(value):
    return struct.unpack("<Q", struct.pack("<d", value))[0]


def parse_expected(payload):
    if len(payload) < NORMAL_EQUATION_BYTES:
        raise RuntimeError("loc_expected_obs.bin payload is too short")
    h_upper = struct.unpack_from("<21d", payload, 0)
    b = struct.unpack_from("<6d", payload, 168)
    valid_count, reject_count, miss_count, flags = struct.unpack_from("<4I", payload, 216)
    residual_sum, residual_abs_sum, residual_max_abs = struct.unpack_from("<3d", payload, 232)
    return {
        "h_upper": h_upper,
        "b": b,
        "valid_count": valid_count,
        "reject_count": reject_count,
        "miss_count": miss_count,
        "flags": flags,
        "residual_sum": residual_sum,
        "residual_abs_sum": residual_abs_sum,
        "residual_max_abs": residual_max_abs,
    }


def parse_pose(payload):
    if len(payload) < POSE_BYTES:
        raise RuntimeError("loc_pose.bin payload is too short")
    qx, qy, qz, qw, tx, ty, tz, flags = struct.unpack_from("<7fI", payload, 0)
    return {
        "qx": qx,
        "qy": qy,
        "qz": qz,
        "qw": qw,
        "tx": tx,
        "ty": ty,
        "tz": tz,
        "flags": flags,
    }


def parse_scan_points(payload, count):
    out = []
    for i in range(count):
        out.append(struct.unpack_from("<4f", payload, i * SCAN_POINT_BYTES))
    return out


def parse_active_map(payload):
    if len(payload) < ACTIVE_MAP_HEADER_BYTES:
        raise RuntimeError("loc_active_map.bin payload is too short")
    header = payload[:ACTIVE_MAP_HEADER_BYTES]
    header_fields = struct.unpack_from("<12I", header, 0)
    num_blocks = header_fields[8]
    num_cells = header_fields[9]
    blocks_begin = ACTIVE_MAP_HEADER_BYTES
    blocks_end = blocks_begin + num_blocks * ACTIVE_BLOCK_BYTES
    cells_end = blocks_end + num_cells * OBS_CELL_BYTES
    if len(payload) < cells_end:
        raise RuntimeError(
            f"loc_active_map.bin payload is too short for {num_blocks} blocks and {num_cells} cells"
        )
    return header, payload[blocks_begin:blocks_end], payload[blocks_end:cells_end], num_blocks, num_cells


def parse_map_header(header):
    values = struct.unpack_from("<4I2f10I", header, 0)
    return {
        "magic": values[0],
        "version": values[1],
        "mode": values[2],
        "cells_per_block": values[3],
        "cell_resolution": values[4],
        "inv_cell_resolution": values[5],
        "window_id": values[6],
        "window_version": values[7],
        "num_blocks": values[8],
        "num_cells": values[9],
        "lookup_nearby_type": values[10],
        "flags": values[11],
    }


def parse_active_blocks(payload, count):
    blocks = []
    for i in range(count):
        x, y, z, first_cell, valid_cell_count, flags, r0, r1 = struct.unpack_from("<3i5I", payload, i * ACTIVE_BLOCK_BYTES)
        blocks.append((x, y, z, first_cell, valid_cell_count, flags, r0, r1))
    return blocks


def parse_obs_cells(payload, count):
    cells = []
    for i in range(count):
        cells.append(struct.unpack_from("<8f8I", payload, i * OBS_CELL_BYTES))
    return cells


def floor_div(value, divisor):
    return value // divisor


def positive_mod(value, divisor):
    r = value % divisor
    return r + divisor if r < 0 else r


def rotate_point(pose, point):
    qx = pose["qx"]
    qy = pose["qy"]
    qz = pose["qz"]
    qw = pose["qw"]
    x, y, z, _ = point
    tx = 2.0 * (qy * z - qz * y)
    ty = 2.0 * (qz * x - qx * z)
    tz = 2.0 * (qx * y - qy * x)
    return (
        x + qw * tx + (qy * tz - qz * ty) + pose["tx"],
        y + qw * ty + (qz * tx - qx * tz) + pose["ty"],
        z + qw * tz + (qx * ty - qy * tx) + pose["tz"],
    )


def encode(point, map_header):
    gx = math.floor(point[0] * map_header["inv_cell_resolution"])
    gy = math.floor(point[1] * map_header["inv_cell_resolution"])
    gz = math.floor(point[2] * map_header["inv_cell_resolution"])
    bx_dim = 8
    by_dim = 8
    bz_dim = 4
    block_x = floor_div(gx, bx_dim)
    block_y = floor_div(gy, by_dim)
    block_z = floor_div(gz, bz_dim)
    lx = positive_mod(gx, bx_dim)
    ly = positive_mod(gy, by_dim)
    lz = positive_mod(gz, bz_dim)
    cell_idx = (lz * by_dim + ly) * bx_dim + lx
    return block_x, block_y, block_z, cell_idx


def lookup_cell(map_header, block_keys, blocks, cells, block_x, block_y, block_z, cell_idx):
    idx = bisect.bisect_left(block_keys, (block_x, block_y, block_z))
    if idx >= len(blocks) or block_keys[idx] != (block_x, block_y, block_z):
        return None
    offset = blocks[idx][3] + cell_idx
    if offset >= map_header["num_cells"]:
        return None
    cell = cells[offset]
    flags = cell[9]
    if (flags & 1) == 0:
        return None
    return cell


def lookup_nearest(map_header, block_keys, blocks, cells, point):
    center_bx, center_by, center_bz, center_cell = encode(point, map_header)
    found = lookup_cell(map_header, block_keys, blocks, cells, center_bx, center_by, center_bz, center_cell)
    if found is not None:
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
                candidate = lookup_cell(map_header, block_keys, blocks, cells, nbx, nby, nbz, ncell)
                if candidate is None:
                    continue
                ddx = point[0] - candidate[0]
                ddy = point[1] - candidate[1]
                ddz = point[2] - candidate[2]
                dist2 = ddx * ddx + ddy * ddy + ddz * ddz
                if best is None or dist2 < best_dist2:
                    best = candidate
                    best_dist2 = dist2
    return best


def compute_expected(scan_points, pose, map_header, blocks, cells):
    block_keys = [(b[0], b[1], b[2]) for b in blocks]
    h = [[0.0 for _ in range(6)] for _ in range(6)]
    b = [0.0 for _ in range(6)]
    valid_count = 0
    reject_count = 0
    miss_count = 0
    residual_sum = 0.0
    residual_abs_sum = 0.0
    residual_max_abs = 0.0

    for scan in scan_points:
        if not (math.isfinite(scan[0]) and math.isfinite(scan[1]) and math.isfinite(scan[2])):
            reject_count += 1
            continue
        p = rotate_point(pose, scan)
        cell = lookup_nearest(map_header, block_keys, blocks, cells, p)
        if cell is None:
            miss_count += 1
            continue
        nx = cell[3]
        ny = cell[4]
        nz = cell[5]
        residual = nx * p[0] + ny * p[1] + nz * p[2] + cell[6]
        abs_residual = abs(residual)
        if not math.isfinite(residual) or abs_residual > 0.3:
            reject_count += 1
            continue
        jacobian = [
            nx,
            ny,
            nz,
            nz * p[1] - ny * p[2],
            nx * p[2] - nz * p[0],
            ny * p[0] - nx * p[1],
        ]
        for r in range(6):
            b[r] += jacobian[r] * residual
            for c in range(r, 6):
                h[r][c] += jacobian[r] * jacobian[c]
        valid_count += 1
        residual_sum += residual
        residual_abs_sum += abs_residual
        residual_max_abs = max(residual_max_abs, abs_residual)

    h_upper = []
    for r in range(6):
        for c in range(r, 6):
            h_upper.append(h[r][c])
    return {
        "h_upper": h_upper,
        "b": b,
        "valid_count": valid_count,
        "reject_count": reject_count,
        "miss_count": miss_count,
        "flags": 0,
        "residual_sum": residual_sum,
        "residual_abs_sum": residual_abs_sum,
        "residual_max_abs": residual_max_abs,
    }


def emit_params(path, expected, num_points):
    lines = [
        "// SPDX-License-Identifier: MIT",
        "// Generated by make_golden_mem_images.py; do not edit.",
        f"localparam int GOLDEN_NUM_POINTS = {num_points};",
        f"localparam [31:0] GOLDEN_SCAN_ADDR = 32'd0;",
        f"localparam [31:0] GOLDEN_POSE_ADDR = 32'd{POSE_ADDR};",
        f"localparam [31:0] GOLDEN_MAP_HEADER_ADDR = 32'd{MAP_HEADER_ADDR};",
        f"localparam [31:0] GOLDEN_ACTIVE_BLOCKS_ADDR = 32'd0;",
        f"localparam [31:0] GOLDEN_OBS_CELLS_ADDR = 32'd0;",
        f"localparam [31:0] GOLDEN_OUT_ADDR = 32'd0;",
        f"localparam [31:0] GOLDEN_VALID_COUNT = 32'd{expected['valid_count']};",
        f"localparam [31:0] GOLDEN_REJECT_COUNT = 32'd{expected['reject_count']};",
        f"localparam [31:0] GOLDEN_MISS_COUNT = 32'd{expected['miss_count']};",
        f"localparam [31:0] GOLDEN_FLAGS = 32'd{expected['flags']};",
        f"localparam [63:0] GOLDEN_RESIDUAL_SUM = 64'h{double_bits(expected['residual_sum']):016x};",
        f"localparam [63:0] GOLDEN_RESIDUAL_ABS_SUM = 64'h{double_bits(expected['residual_abs_sum']):016x};",
        f"localparam [63:0] GOLDEN_RESIDUAL_MAX_ABS = 64'h{double_bits(expected['residual_max_abs']):016x};",
    ]
    for i, value in enumerate(expected["h_upper"]):
        lines.append(f"localparam [63:0] GOLDEN_H_{i:02d} = 64'h{double_bits(value):016x};")
    for i, value in enumerate(expected["b"]):
        lines.append(f"localparam [63:0] GOLDEN_B_{i:02d} = 64'h{double_bits(value):016x};")
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(description="Build simulation memory images from Lightning golden files.")
    parser.add_argument("--golden-dir", required=True)
    parser.add_argument("--out-dir", required=True)
    parser.add_argument("--report-dir", required=True)
    parser.add_argument("--max-points", type=int, default=0)
    args = parser.parse_args()

    golden_dir = Path(args.golden_dir)
    out_dir = Path(args.out_dir)
    report_dir = Path(args.report_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    report_dir.mkdir(parents=True, exist_ok=True)

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
    sim_points = num_points if args.max_points <= 0 else min(num_points, args.max_points)
    if sim_points == num_points:
        expected = full_expected
    else:
        scan_points = parse_scan_points(scan_payload, sim_points)
        pose = parse_pose(pose_payload)
        parsed_header = parse_map_header(map_header)
        parsed_blocks = parse_active_blocks(active_blocks, num_blocks)
        parsed_cells = parse_obs_cells(obs_cells, num_cells)
        expected = compute_expected(scan_points, pose, parsed_header, parsed_blocks, parsed_cells)

    gmem1 = bytearray(MAP_HEADER_ADDR + ACTIVE_MAP_HEADER_BYTES)
    gmem1[POSE_ADDR : POSE_ADDR + len(pose_payload)] = pose_payload
    gmem1[MAP_HEADER_ADDR : MAP_HEADER_ADDR + len(map_header)] = map_header

    write_bytes(out_dir / "gmem0_scan.bin", scan_payload)
    write_bytes(out_dir / "gmem1_pose_map_header.bin", bytes(gmem1))
    write_bytes(out_dir / "gmem2_active_blocks.bin", active_blocks)
    write_bytes(out_dir / "gmem3_obs_cells.bin", obs_cells)
    write_bytes(out_dir / "gmem4_output.bin", bytes(NORMAL_EQUATION_BYTES))
    emit_params(out_dir / "golden_frame_000001_params.vh", expected, sim_points)

    summary = [
        "# golden_frame_000001 memory image summary",
        "",
        f"- golden_dir: `{golden_dir}`",
        f"- generated_dir: `{out_dir}`",
        f"- full_scan_points: {num_points}",
        f"- sim_scan_points: {sim_points}",
        f"- active_blocks: {num_blocks}",
        f"- obs_cells: {num_cells}",
        f"- gmem0_scan.bin: {len(scan_payload)} bytes",
        f"- gmem1_pose_map_header.bin: {len(gmem1)} bytes",
        f"- gmem2_active_blocks.bin: {len(active_blocks)} bytes",
        f"- gmem3_obs_cells.bin: {len(obs_cells)} bytes",
        f"- gmem4_output.bin: {NORMAL_EQUATION_BYTES} bytes",
        f"- expected_counts: {expected['valid_count']}/{expected['reject_count']}/{expected['miss_count']}",
        "",
        "Full golden requires the obs cell memory image above; this is simulation-only and is not a BRAM-sized",
        "synthesizable memory image.",
    ]
    (report_dir / "golden_image_summary.md").write_text("\n".join(summary) + "\n", encoding="utf-8")
    print("GOLDEN_IMAGE_PASS")
    print(f"generated_dir={out_dir}")
    print(f"report={report_dir / 'golden_image_summary.md'}")


if __name__ == "__main__":
    main()
