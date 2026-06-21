#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import hashlib
import json
import os
import struct
import time
from pathlib import Path

from address_map import (
    CTRL_ACTIVE_BLOCKS_ADDR_HI,
    CTRL_ACTIVE_BLOCKS_ADDR_LO,
    CTRL_CONTROL,
    CTRL_ERROR,
    CTRL_KERNEL_SEL,
    CTRL_MAP_HEADER_ADDR_HI,
    CTRL_MAP_HEADER_ADDR_LO,
    CTRL_MODE,
    CTRL_OBS_CELLS_ADDR_HI,
    CTRL_OBS_CELLS_ADDR_LO,
    CTRL_OUT_ADDR_HI,
    CTRL_OUT_ADDR_LO,
    CTRL_POSE_ADDR_HI,
    CTRL_POSE_ADDR_LO,
    CTRL_RUN_COUNT,
    CTRL_SCAN_ADDR_HI,
    CTRL_SCAN_ADDR_LO,
    CTRL_SCAN_COUNT,
    CTRL_STATUS,
    CTRL_VERSION,
    CTRL_VERSION_VALUE,
    CTRL_WRITES,
    MODE_LOCALIZATION,
    OUTPUT_BASE,
    REGIONS,
    SCAN_POINTS_BASE,
    XDMA_CTRL_BASE_DEFAULT,
    XDMA_SHIM_MAGIC,
    XDMA_SHIM_MAGIC_OFFSET,
    XDMA_SHIM_SCRATCH0_OFFSET,
    XDMA_SHIM_SCRATCH1_OFFSET,
    XDMA_SHIM_VERSION,
    XDMA_SHIM_VERSION_OFFSET,
    KERNEL_UNIFIED_OBSERVATION,
    validate_layout,
)


DEFAULT_USER = "/dev/xdma0_user"
DEFAULT_H2C = "/dev/xdma0_h2c_0"
DEFAULT_C2H = "/dev/xdma0_c2h_0"
NORMAL_EQUATION_BYTES = 320
HLS_TINY_ABS_TOL = 1.0e-4
HLS_TINY_REL_TOL = 1.0e-3
STATUS_DONE = 1 << 2
STATUS_ERROR = 1 << 3


def read32(fd, offset):
    data = os.pread(fd, 4, offset)
    if len(data) != 4:
        raise RuntimeError(f"short register read at 0x{offset:x}: {len(data)} bytes")
    return struct.unpack("<I", data)[0]


def write32(fd, offset, value):
    data = struct.pack("<I", value & 0xFFFFFFFF)
    written = os.pwrite(fd, data, offset)
    if written != 4:
        raise RuntimeError(f"short register write at 0x{offset:x}: {written} bytes")


def close_many(fds):
    for fd in fds:
        try:
            os.close(fd)
        except OSError:
            pass


def make_pattern(size, seed):
    return bytes(((i * 37 + seed) & 0xFF) for i in range(size))


def shim_smoke(user_path):
    fd = os.open(user_path, os.O_RDWR | os.O_SYNC)
    try:
        magic = read32(fd, XDMA_SHIM_MAGIC_OFFSET)
        if magic != XDMA_SHIM_MAGIC:
            raise RuntimeError(f"bad XDMA shim magic: got 0x{magic:08x}, expected 0x{XDMA_SHIM_MAGIC:08x}")
        version = read32(fd, XDMA_SHIM_VERSION_OFFSET)
        if version != XDMA_SHIM_VERSION:
            raise RuntimeError(
                f"bad XDMA shim version: got 0x{version:08x}, expected 0x{XDMA_SHIM_VERSION:08x}"
            )
        for offset, value in (
            (XDMA_SHIM_SCRATCH0_OFFSET, 0x13579BDF),
            (XDMA_SHIM_SCRATCH1_OFFSET, 0x2468ACE0),
        ):
            write32(fd, offset, value)
            got = read32(fd, offset)
            if got != value:
                raise RuntimeError(f"shim scratch 0x{offset:03x} mismatch: got 0x{got:08x}, expected 0x{value:08x}")
        print("SHIM_SMOKE_PASS")
        print(f"XDMA_SHIM_MAGIC=0x{magic:08x} XDMA_SHIM_VERSION=0x{version:08x}")
    finally:
        os.close(fd)


def reg_smoke(user_path, scan_count, ctrl_base):
    fd = os.open(user_path, os.O_RDWR | os.O_SYNC)
    try:
        version = read32(fd, ctrl_base + CTRL_VERSION)
        if version != CTRL_VERSION_VALUE:
            raise RuntimeError(
                f"bad VERSION at ctrl_base 0x{ctrl_base:x}: got 0x{version:08x}, expected 0x{CTRL_VERSION_VALUE:08x}"
            )

        writes = list(CTRL_WRITES)
        writes.append((CTRL_SCAN_COUNT, scan_count))
        for offset, value in writes:
            write32(fd, ctrl_base + offset, value)
        for offset, value in writes:
            got = read32(fd, ctrl_base + offset)
            if got != value:
                raise RuntimeError(
                    f"register 0x{ctrl_base + offset:03x} mismatch: got 0x{got:08x}, expected 0x{value:08x}"
                )

        print("REG_SMOKE_PASS")
        print(f"VERSION=0x{version:08x}")
        print(f"CTRL_BASE=0x{ctrl_base:08x}")
        print(f"KERNEL_SEL={KERNEL_UNIFIED_OBSERVATION} MODE={MODE_LOCALIZATION} SCAN_COUNT={scan_count}")
    finally:
        os.close(fd)


def ddr_smoke(h2c_path, c2h_path, size):
    h2c = os.open(h2c_path, os.O_WRONLY | os.O_SYNC)
    c2h = os.open(c2h_path, os.O_RDONLY | os.O_SYNC)
    try:
        for idx, region in enumerate(REGIONS):
            payload = make_pattern(size, 17 + idx)
            written = os.pwrite(h2c, payload, region.base)
            if written != len(payload):
                raise RuntimeError(f"{region.name} short H2C write: {written}/{len(payload)}")
            readback = os.pread(c2h, len(payload), region.base)
            if readback != payload:
                for pos, (exp, got) in enumerate(zip(payload, readback)):
                    if exp != got:
                        raise RuntimeError(
                            f"{region.name} DDR mismatch at +0x{pos:x}: got 0x{got:02x}, expected 0x{exp:02x}"
                        )
                raise RuntimeError(f"{region.name} DDR readback length mismatch")
            print(f"DDR_PATTERN_PASS {region.name} base=0x{region.base:08x} size={size}")
        print("DDR_SMOKE_PASS")
    finally:
        os.close(h2c)
        os.close(c2h)


def write_manifest(h2c_path, manifest_path):
    manifest = json.loads(Path(manifest_path).read_text(encoding="utf-8"))
    base_dir = Path(manifest_path).parent
    h2c = os.open(h2c_path, os.O_WRONLY | os.O_SYNC)
    try:
        for segment in manifest["segments"]:
            payload = (base_dir / segment["file"]).read_bytes()
            if len(payload) != segment["size"]:
                raise RuntimeError(f"{segment['file']} size mismatch")
            written = os.pwrite(h2c, payload, segment["base"])
            if written != len(payload):
                raise RuntimeError(f"{segment['file']} short H2C write: {written}/{len(payload)}")
            print(f"IMAGE_WRITE_PASS {segment['file']} base=0x{segment['base']:08x} size={len(payload)}")
        print("HOST_IMAGE_WRITE_PASS")
    finally:
        os.close(h2c)


def parse_normal_equation(data):
    if len(data) != NORMAL_EQUATION_BYTES:
        raise RuntimeError(f"normal equation readback size mismatch: {len(data)}/{NORMAL_EQUATION_BYTES}")
    h_upper = list(struct.unpack_from("<21d", data, 0))
    b = list(struct.unpack_from("<6d", data, 168))
    valid_count, reject_count, miss_count, flags = struct.unpack_from("<4I", data, 216)
    residual_sum, residual_abs_sum, residual_max_abs = struct.unpack_from("<3d", data, 232)
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


def compare_float(name, actual, expected):
    diff = abs(actual - expected)
    rel = diff / max(abs(expected), 1.0e-30)
    if diff <= HLS_TINY_ABS_TOL or rel <= HLS_TINY_REL_TOL:
        return diff, rel
    raise RuntimeError(
        f"{name} mismatch: actual={actual:.17g} expected={expected:.17g} abs={diff:.6g} rel={rel:.6g}"
    )


def compare_normal_equation(actual, expected):
    if len(expected["h_upper"]) != 21:
        raise RuntimeError(f"expected h_upper length mismatch: {len(expected['h_upper'])}/21")
    if len(expected["b"]) != 6:
        raise RuntimeError(f"expected b length mismatch: {len(expected['b'])}/6")
    for key in ("valid_count", "reject_count", "miss_count", "flags"):
        if actual[key] != expected[key]:
            raise RuntimeError(f"{key} mismatch: actual={actual[key]} expected={expected[key]}")

    worst_name = ""
    worst_abs = -1.0
    worst_rel = 0.0
    for idx, (actual_value, expected_value) in enumerate(zip(actual["h_upper"], expected["h_upper"])):
        diff, rel = compare_float(f"h_upper[{idx}]", actual_value, expected_value)
        if diff > worst_abs:
            worst_name, worst_abs, worst_rel = f"h_upper[{idx}]", diff, rel
    for idx, (actual_value, expected_value) in enumerate(zip(actual["b"], expected["b"])):
        diff, rel = compare_float(f"b[{idx}]", actual_value, expected_value)
        if diff > worst_abs:
            worst_name, worst_abs, worst_rel = f"b[{idx}]", diff, rel
    for key in ("residual_sum", "residual_abs_sum", "residual_max_abs"):
        diff, rel = compare_float(key, actual[key], expected[key])
        if diff > worst_abs:
            worst_name, worst_abs, worst_rel = key, diff, rel
    return worst_name, worst_abs, worst_rel


def print_normal_equation_summary(prefix, value):
    print(
        f"{prefix}_COUNTS="
        f"{value['valid_count']}/{value['reject_count']}/{value['miss_count']} "
        f"FLAGS=0x{value['flags']:08x}"
    )
    print(f"{prefix}_RESIDUAL_SUM={value['residual_sum']:.17g}")
    print(f"{prefix}_RESIDUAL_ABS_SUM={value['residual_abs_sum']:.17g}")
    print(f"{prefix}_RESIDUAL_MAX_ABS={value['residual_max_abs']:.17g}")


def print_normal_equation_dump(prefix, value):
    print_normal_equation_summary(prefix, value)
    print(f"{prefix}_H_UPPER=[" + ",".join(f"{item:.17g}" for item in value["h_upper"]) + "]")
    print(f"{prefix}_B=[" + ",".join(f"{item:.17g}" for item in value["b"]) + "]")


def write_manifest_with_fd(h2c, manifest, base_dir):
    for segment in manifest["segments"]:
        payload = (base_dir / segment["file"]).read_bytes()
        if len(payload) != segment["size"]:
            raise RuntimeError(f"{segment['file']} size mismatch")
        written = os.pwrite(h2c, payload, segment["base"])
        if written != len(payload):
            raise RuntimeError(f"{segment['file']} short H2C write: {written}/{len(payload)}")
        print(f"IMAGE_WRITE_PASS {segment['file']} base=0x{segment['base']:08x} size={len(payload)}")
    print("HOST_IMAGE_WRITE_PASS")


def find_output_segment(manifest):
    for segment in manifest["segments"]:
        if segment["base"] == OUTPUT_BASE:
            return segment
    raise RuntimeError("manifest does not contain an output segment at OUTPUT_BASE")


def write_output_zero_with_fd(h2c, manifest, base_dir):
    segment = find_output_segment(manifest)
    payload = (base_dir / segment["file"]).read_bytes()
    if len(payload) != segment["size"]:
        raise RuntimeError(f"{segment['file']} size mismatch")
    if segment["size"] != NORMAL_EQUATION_BYTES:
        raise RuntimeError(f"output segment size mismatch: {segment['size']}/{NORMAL_EQUATION_BYTES}")
    written = os.pwrite(h2c, payload, segment["base"])
    if written != len(payload):
        raise RuntimeError(f"{segment['file']} short H2C write: {written}/{len(payload)}")
    print(f"OUTPUT_ZERO_WRITE_PASS {segment['file']} base=0x{segment['base']:08x} size={len(payload)}")


def verify_manifest_readback_with_fd(c2h, manifest, base_dir):
    for segment in manifest["segments"]:
        payload = (base_dir / segment["file"]).read_bytes()
        readback = os.pread(c2h, len(payload), segment["base"])
        if len(readback) != len(payload):
            raise RuntimeError(
                f"{segment['file']} short C2H readback: {len(readback)}/{len(payload)}"
            )
        if readback != payload:
            for pos, (exp, got) in enumerate(zip(payload, readback)):
                if exp != got:
                    raise RuntimeError(
                        f"{segment['file']} readback mismatch at +0x{pos:x}: "
                        f"got 0x{got:02x}, expected 0x{exp:02x}"
                    )
            raise RuntimeError(f"{segment['file']} readback mismatch")
        digest = hashlib.sha256(readback).hexdigest()
        print(
            f"IMAGE_READBACK_PASS {segment['file']} "
            f"base=0x{segment['base']:08x} size={len(readback)} sha256={digest}"
        )
    print("HOST_IMAGE_READBACK_PASS")


def configure_hls_tiny_registers(user_fd, ctrl_base, scan_count):
    write32(user_fd, ctrl_base + CTRL_CONTROL, 0x2)
    for offset, value in CTRL_WRITES:
        write32(user_fd, ctrl_base + offset, value)
    write32(user_fd, ctrl_base + CTRL_SCAN_COUNT, scan_count)


def read_configured_registers(user_fd, ctrl_base):
    regs = {
        "KERNEL_SEL": CTRL_KERNEL_SEL,
        "MODE": CTRL_MODE,
        "SCAN_ADDR_LO": CTRL_SCAN_ADDR_LO,
        "SCAN_ADDR_HI": CTRL_SCAN_ADDR_HI,
        "SCAN_COUNT": CTRL_SCAN_COUNT,
        "POSE_ADDR_LO": CTRL_POSE_ADDR_LO,
        "POSE_ADDR_HI": CTRL_POSE_ADDR_HI,
        "MAP_HEADER_ADDR_LO": CTRL_MAP_HEADER_ADDR_LO,
        "MAP_HEADER_ADDR_HI": CTRL_MAP_HEADER_ADDR_HI,
        "ACTIVE_BLOCKS_ADDR_LO": CTRL_ACTIVE_BLOCKS_ADDR_LO,
        "ACTIVE_BLOCKS_ADDR_HI": CTRL_ACTIVE_BLOCKS_ADDR_HI,
        "OBS_CELLS_ADDR_LO": CTRL_OBS_CELLS_ADDR_LO,
        "OBS_CELLS_ADDR_HI": CTRL_OBS_CELLS_ADDR_HI,
        "OUT_ADDR_LO": CTRL_OUT_ADDR_LO,
        "OUT_ADDR_HI": CTRL_OUT_ADDR_HI,
        "STATUS": CTRL_STATUS,
        "ERROR": CTRL_ERROR,
        "RUN_COUNT": CTRL_RUN_COUNT,
    }
    values = {}
    for name, offset in regs.items():
        values[name] = read32(user_fd, ctrl_base + offset)
    return values


def print_configured_registers(values):
    print("CONFIG_REGISTER_READBACK_BEGIN")
    for name in sorted(values):
        print(f"{name}_READBACK=0x{values[name]:08x}")
    print(f"SCAN_COUNT_READBACK={values['SCAN_COUNT']}")
    print("CONFIG_REGISTER_READBACK_END")


def dump_raw_output_words(data):
    words = struct.unpack_from("<40Q", data, 0)
    print("OUTPUT_RAW_WORDS_BEGIN")
    for idx, word in enumerate(words):
        print(f"OUTPUT_WORD[{idx:02d}]=0x{word:016x}")
    print("OUTPUT_RAW_WORDS_END")


def normal_equation_raw_words(data):
    return list(struct.unpack_from("<40Q", data, 0))


def write_output_json(
    path,
    manifest_path,
    manifest,
    ctrl_base,
    label,
    scan_count,
    status,
    error,
    run_count_before,
    run_count_after,
    regs_after_config,
    output,
    actual,
):
    out_path = Path(path)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    payload = {
        "label": label,
        "manifest_path": str(manifest_path),
        "manifest_name": manifest.get("name", ""),
        "source_point_index": manifest.get("source_point_index"),
        "ctrl_base": ctrl_base,
        "scan_count": scan_count,
        "status": status,
        "error": error,
        "run_count_before": run_count_before,
        "run_count_after": run_count_after,
        "registers_after_config": regs_after_config or {},
        "raw_output_words": [f"0x{word:016x}" for word in normal_equation_raw_words(output)],
        "actual": actual,
        "expected": manifest["expected"],
    }
    out_path.write_text(json.dumps(payload, indent=2) + "\n", encoding="utf-8")
    print(f"HLS_OUTPUT_JSON={out_path}")


def output_json_path(save_output_json, repeat_output_dir, iteration, repeat_count):
    if repeat_output_dir:
        out_dir = Path(repeat_output_dir)
        out_dir.mkdir(parents=True, exist_ok=True)
        return str(out_dir / f"full_frame_output_iter_{iteration:02d}.json")
    if not save_output_json:
        return ""
    if repeat_count <= 1:
        return save_output_json
    path = Path(save_output_json)
    return str(path.with_name(f"{path.stem}_iter_{iteration:02d}{path.suffix}"))


def hls_manifest(
    user_path,
    h2c_path,
    c2h_path,
    manifest_path,
    ctrl_base,
    timeout_sec,
    label,
    dump_normal_equation,
    verify_image_readback,
    read_regs_after_config,
    dump_output_raw_words,
    save_output_json,
    repeat_count,
    repeat_output_dir,
):
    manifest_file = Path(manifest_path)
    manifest = json.loads(manifest_file.read_text(encoding="utf-8"))
    expected = manifest["expected"]
    scan_count = int(manifest["scan_count"])
    is_tiny = label == "TINY"
    if repeat_count < 1:
        raise RuntimeError("--hls-repeat must be >= 1")

    user = h2c = c2h = None
    try:
        user = os.open(user_path, os.O_RDWR | os.O_SYNC)
        h2c = os.open(h2c_path, os.O_WRONLY | os.O_SYNC)
        c2h = os.open(c2h_path, os.O_RDONLY | os.O_SYNC)
        write_manifest_with_fd(h2c, manifest, manifest_file.parent)
        if verify_image_readback:
            verify_manifest_readback_with_fd(c2h, manifest, manifest_file.parent)

        max_elapsed = 0.0
        max_worst_abs = -1.0
        max_worst_rel = 0.0
        max_worst_name = ""
        for iteration in range(1, repeat_count + 1):
            if iteration > 1:
                write_output_zero_with_fd(h2c, manifest, manifest_file.parent)

            regs = {}
            configure_hls_tiny_registers(user, ctrl_base, scan_count)
            if read_regs_after_config:
                regs = read_configured_registers(user, ctrl_base)
                print_configured_registers(regs)

            run_count_before = read32(user, ctrl_base + CTRL_RUN_COUNT)
            start_time = time.monotonic()
            write32(user, ctrl_base + CTRL_CONTROL, 0x1)
            print(f"HLS_{label}_START_PASS")
            if is_tiny:
                print("HLS_TINY_START_PASS")
            print(
                f"CTRL_BASE=0x{ctrl_base:08x} SCAN_COUNT={scan_count} "
                f"ITERATION={iteration}/{repeat_count} RUN_COUNT_BEFORE={run_count_before}"
            )

            deadline = start_time + timeout_sec
            last_status = 0
            last_error = 0
            while time.monotonic() < deadline:
                last_status = read32(user, ctrl_base + CTRL_STATUS)
                last_error = read32(user, ctrl_base + CTRL_ERROR)
                if last_status & STATUS_ERROR or last_error != 0:
                    raise RuntimeError(
                        f"HLS {label.lower()} entered error on iteration {iteration}: "
                        f"STATUS=0x{last_status:08x} ERROR=0x{last_error:08x}"
                    )
                if last_status & STATUS_DONE:
                    break
                time.sleep(0.001)
            else:
                run_count_timeout = read32(user, ctrl_base + CTRL_RUN_COUNT)
                raise RuntimeError(
                    f"HLS {label.lower()} timeout on iteration {iteration}: "
                    f"STATUS=0x{last_status:08x} ERROR=0x{last_error:08x} RUN_COUNT={run_count_timeout}"
                )

            elapsed = time.monotonic() - start_time
            max_elapsed = max(max_elapsed, elapsed)
            run_count_after = read32(user, ctrl_base + CTRL_RUN_COUNT)
            if run_count_after <= run_count_before:
                raise RuntimeError(
                    f"RUN_COUNT did not increment on iteration {iteration}: "
                    f"before={run_count_before} after={run_count_after}"
                )
            print(f"HLS_{label}_DONE_PASS")
            if is_tiny:
                print("HLS_TINY_DONE_PASS")
            print(
                f"STATUS=0x{last_status:08x} ERROR=0x{last_error:08x} "
                f"RUN_COUNT_AFTER={run_count_after} ELAPSED_SEC={elapsed:.6f}"
            )

            output = os.pread(c2h, NORMAL_EQUATION_BYTES, OUTPUT_BASE)
            if dump_output_raw_words:
                dump_raw_output_words(output)
            actual = parse_normal_equation(output)
            json_path = output_json_path(save_output_json, repeat_output_dir, iteration, repeat_count)
            if json_path:
                write_output_json(
                    json_path,
                    manifest_file,
                    manifest,
                    ctrl_base,
                    label,
                    scan_count,
                    last_status,
                    last_error,
                    run_count_before,
                    run_count_after,
                    regs,
                    output,
                    actual,
                )
            try:
                worst_name, worst_abs, worst_rel = compare_normal_equation(actual, expected)
            except RuntimeError:
                if dump_normal_equation:
                    print_normal_equation_dump("EXPECTED", expected)
                    print_normal_equation_dump("ACTUAL", actual)
                else:
                    print_normal_equation_summary("EXPECTED", expected)
                    print_normal_equation_summary("ACTUAL", actual)
                raise
            print(f"HLS_{label}_NUMERIC_PASS")
            if is_tiny:
                print("HLS_TINY_NUMERIC_PASS")
            if dump_normal_equation:
                print_normal_equation_dump("ACTUAL", actual)
            print(
                "COUNTS="
                f"{actual['valid_count']}/{actual['reject_count']}/{actual['miss_count']} "
                f"FLAGS=0x{actual['flags']:08x}"
            )
            print(f"WORST_FIELD={worst_name} MAX_ABS={worst_abs:.6g} MAX_REL={worst_rel:.6g}")
            if repeat_count > 1:
                print(f"HLS_REPEAT_ITER_PASS {iteration}/{repeat_count}")
            if worst_abs > max_worst_abs:
                max_worst_name, max_worst_abs, max_worst_rel = worst_name, worst_abs, worst_rel

        if repeat_count > 1:
            print(
                f"HLS_REPEAT_STABILITY_PASS ITERATIONS={repeat_count} "
                f"MAX_ELAPSED_SEC={max_elapsed:.6f} "
                f"WORST_FIELD={max_worst_name} MAX_ABS={max_worst_abs:.6g} MAX_REL={max_worst_rel:.6g}"
            )
    finally:
        close_many(fd for fd in (user, h2c, c2h) if fd is not None)


def start_zero(user_path, ctrl_base):
    fd = os.open(user_path, os.O_RDWR | os.O_SYNC)
    try:
        write32(fd, ctrl_base + CTRL_SCAN_ADDR_LO, SCAN_POINTS_BASE)
        write32(fd, ctrl_base + CTRL_SCAN_ADDR_HI, 0)
        write32(fd, ctrl_base + CTRL_SCAN_COUNT, 0)
        write32(fd, ctrl_base + CTRL_CONTROL, 0x2)
        write32(fd, ctrl_base + CTRL_CONTROL, 0x1)
        status = read32(fd, ctrl_base + CTRL_STATUS)
        error = read32(fd, ctrl_base + CTRL_ERROR)
        run_count = read32(fd, ctrl_base + CTRL_RUN_COUNT)
        print("START_ZERO_ISSUED")
        print(f"CTRL_BASE=0x{ctrl_base:08x}")
        print(f"STATUS=0x{status:08x} ERROR=0x{error:08x} RUN_COUNT={run_count}")
    finally:
        os.close(fd)


def main():
    parser = argparse.ArgumentParser(description="Minimal XDMA host smoke for Lightning-LM AX7Z100.")
    parser.add_argument("--user", default=DEFAULT_USER, help="XDMA AXI-Lite/user device")
    parser.add_argument("--h2c", default=DEFAULT_H2C, help="XDMA host-to-card device")
    parser.add_argument("--c2h", default=DEFAULT_C2H, help="XDMA card-to-host device")
    parser.add_argument("--scan-count", type=int, default=1)
    parser.add_argument("--ddr-size", type=lambda value: int(value, 0), default=4096)
    parser.add_argument("--ctrl-base", type=lambda value: int(value, 0), default=XDMA_CTRL_BASE_DEFAULT)
    parser.add_argument("--shim-smoke", action="store_true", help="Run XDMA BAR shim identity/scratch smoke")
    parser.add_argument("--reg-smoke", action="store_true", help="Run AXI-Lite VERSION/config write-read smoke")
    parser.add_argument("--ddr-smoke", action="store_true", help="Run PL DDR pattern write/read smoke")
    parser.add_argument("--write-image", default="", help="Write a generated host image manifest through H2C")
    parser.add_argument("--hls-manifest", default="", help="Write, start, and verify an HLS transaction manifest")
    parser.add_argument("--hls-tiny", default="", help="Write, start, and verify a tiny synthetic HLS transaction")
    parser.add_argument("--hls-timeout-sec", type=float, default=5.0)
    parser.add_argument("--verify-image-readback", action="store_true", help="Read back all manifest segments and compare hashes before start")
    parser.add_argument("--read-regs-after-config", action="store_true", help="Print controller register readback after HLS config")
    parser.add_argument("--dump-output-raw-words", action="store_true", help="Print the 40 raw 64-bit output words read from DDR")
    parser.add_argument("--dump-normal-equation", action="store_true", help="Print H_upper and b after HLS readback")
    parser.add_argument("--save-output-json", default="", help="Save actual/expected HLS output, raw words, and register readback as JSON")
    parser.add_argument("--hls-repeat", type=int, default=1, help="Repeat the selected HLS manifest transaction")
    parser.add_argument("--repeat-output-dir", default="", help="Save one HLS output JSON per repeat iteration")
    parser.add_argument("--start-zero", action="store_true", help="Optionally issue a zero-point accelerator start")
    args = parser.parse_args()

    validate_layout()
    if not any(
        [args.shim_smoke, args.reg_smoke, args.ddr_smoke, args.write_image, args.hls_manifest, args.hls_tiny, args.start_zero]
    ):
        parser.error(
            "select at least one action: --shim-smoke, --reg-smoke, --ddr-smoke, --write-image, --hls-manifest, --hls-tiny, or --start-zero"
        )
    if args.shim_smoke:
        shim_smoke(args.user)
    if args.reg_smoke:
        reg_smoke(args.user, args.scan_count, args.ctrl_base)
    if args.ddr_smoke:
        ddr_smoke(args.h2c, args.c2h, args.ddr_size)
    if args.write_image:
        write_manifest(args.h2c, args.write_image)
    if args.hls_manifest:
        hls_manifest(
            args.user,
            args.h2c,
            args.c2h,
            args.hls_manifest,
            args.ctrl_base,
            args.hls_timeout_sec,
            "MANIFEST",
            args.dump_normal_equation,
            args.verify_image_readback,
            args.read_regs_after_config,
            args.dump_output_raw_words,
            args.save_output_json,
            args.hls_repeat,
            args.repeat_output_dir,
        )
    if args.hls_tiny:
        hls_manifest(
            args.user,
            args.h2c,
            args.c2h,
            args.hls_tiny,
            args.ctrl_base,
            args.hls_timeout_sec,
            "TINY",
            args.dump_normal_equation,
            args.verify_image_readback,
            args.read_regs_after_config,
            args.dump_output_raw_words,
            args.save_output_json,
            args.hls_repeat,
            args.repeat_output_dir,
        )
    if args.start_zero:
        start_zero(args.user, args.ctrl_base)


if __name__ == "__main__":
    main()
