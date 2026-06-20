#!/usr/bin/env python3
# SPDX-License-Identifier: MIT

import argparse
import os
import struct
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
    import json

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
    parser.add_argument("--start-zero", action="store_true", help="Optionally issue a zero-point accelerator start")
    args = parser.parse_args()

    validate_layout()
    if not any([args.shim_smoke, args.reg_smoke, args.ddr_smoke, args.write_image, args.start_zero]):
        parser.error("select at least one action: --shim-smoke, --reg-smoke, --ddr-smoke, --write-image, or --start-zero")
    if args.shim_smoke:
        shim_smoke(args.user)
    if args.reg_smoke:
        reg_smoke(args.user, args.scan_count, args.ctrl_base)
    if args.ddr_smoke:
        ddr_smoke(args.h2c, args.c2h, args.ddr_size)
    if args.write_image:
        write_manifest(args.h2c, args.write_image)
    if args.start_zero:
        start_zero(args.user, args.ctrl_base)


if __name__ == "__main__":
    main()
