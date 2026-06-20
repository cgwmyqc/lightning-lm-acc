#!/usr/bin/env python3
"""Minimal XDMA-only diagnostic smoke for the AX7Z100 bring-up bitstream."""

from __future__ import annotations

import argparse
import os
import struct
from pathlib import Path


DEFAULT_USER = "/dev/xdma0_user"
DEFAULT_H2C = "/dev/xdma0_h2c_0"
DEFAULT_C2H = "/dev/xdma0_c2h_0"

MAGIC_OFFSET = 0x00
VERSION_OFFSET = 0x04
SCRATCH0_OFFSET = 0x08
SCRATCH1_OFFSET = 0x0C

EXPECTED_MAGIC = 0x58444D41
EXPECTED_VERSION = 0x00010000


def read_u32(path: str, offset: int) -> int:
    with open(path, "rb", buffering=0) as f:
        f.seek(offset)
        data = f.read(4)
    if len(data) != 4:
        raise RuntimeError(f"short read from {path} at 0x{offset:x}")
    return struct.unpack("<I", data)[0]


def write_u32(path: str, offset: int, value: int) -> None:
    with open(path, "r+b", buffering=0) as f:
        f.seek(offset)
        written = f.write(struct.pack("<I", value & 0xFFFFFFFF))
    if written != 4:
        raise RuntimeError(f"short write to {path} at 0x{offset:x}")


def require_device(path: str) -> None:
    if not Path(path).exists():
        raise FileNotFoundError(f"missing XDMA device node: {path}")


def user_smoke(user: str) -> None:
    require_device(user)

    magic = read_u32(user, MAGIC_OFFSET)
    version = read_u32(user, VERSION_OFFSET)
    if magic != EXPECTED_MAGIC:
        raise RuntimeError(
            f"bad XDMA diag magic: got 0x{magic:08x}, expected 0x{EXPECTED_MAGIC:08x}"
        )
    if version != EXPECTED_VERSION:
        raise RuntimeError(
            "bad XDMA diag version: "
            f"got 0x{version:08x}, expected 0x{EXPECTED_VERSION:08x}"
        )

    scratch0 = 0x13579BDF
    scratch1 = 0x2468ACE0
    write_u32(user, SCRATCH0_OFFSET, scratch0)
    write_u32(user, SCRATCH1_OFFSET, scratch1)

    got0 = read_u32(user, SCRATCH0_OFFSET)
    got1 = read_u32(user, SCRATCH1_OFFSET)
    if got0 != scratch0 or got1 != scratch1:
        raise RuntimeError(
            "scratch mismatch: "
            f"got 0x{got0:08x}/0x{got1:08x}, "
            f"expected 0x{scratch0:08x}/0x{scratch1:08x}"
        )

    print(f"magic=0x{magic:08x}")
    print(f"version=0x{version:08x}")
    print("XDMA_DIAG_USER_SMOKE_PASS")


def make_pattern(size: int) -> bytes:
    return bytes(((i * 17 + 29) & 0xFF) for i in range(size))


def write_device(path: str, offset: int, data: bytes) -> None:
    with open(path, "wb", buffering=0) as f:
        f.seek(offset)
        written = f.write(data)
    if written != len(data):
        raise RuntimeError(f"short write to {path}: {written} != {len(data)}")


def read_device(path: str, offset: int, size: int) -> bytes:
    with open(path, "rb", buffering=0) as f:
        f.seek(offset)
        data = f.read(size)
    if len(data) != size:
        raise RuntimeError(f"short read from {path}: {len(data)} != {size}")
    return data


def bram_smoke(h2c: str, c2h: str, offset: int, size: int) -> None:
    require_device(h2c)
    require_device(c2h)
    if offset < 0 or size <= 0:
        raise ValueError("BRAM offset must be nonnegative and size must be positive")

    pattern = make_pattern(size)
    write_device(h2c, offset, pattern)
    readback = read_device(c2h, offset, size)
    if readback != pattern:
        for idx, (expected, got) in enumerate(zip(pattern, readback)):
            if expected != got:
                raise RuntimeError(
                    f"BRAM mismatch at +0x{idx:x}: got 0x{got:02x}, "
                    f"expected 0x{expected:02x}"
                )
        raise RuntimeError("BRAM mismatch")

    print(f"bram_offset=0x{offset:x}")
    print(f"bram_size={size}")
    print("XDMA_DIAG_BRAM_SMOKE_PASS")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Smoke-test the AX7Z100 XDMA-only diagnostic bitstream."
    )
    parser.add_argument("--user", default=DEFAULT_USER)
    parser.add_argument("--h2c", default=DEFAULT_H2C)
    parser.add_argument("--c2h", default=DEFAULT_C2H)
    parser.add_argument("--user-smoke", action="store_true")
    parser.add_argument("--bram-smoke", action="store_true")
    parser.add_argument("--bram-offset", type=lambda text: int(text, 0), default=0)
    parser.add_argument("--bram-size", type=lambda text: int(text, 0), default=4096)
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    if not args.user_smoke and not args.bram_smoke:
        raise SystemExit("select at least one smoke: --user-smoke or --bram-smoke")

    if args.user_smoke:
        user_smoke(os.fspath(args.user))
    if args.bram_smoke:
        bram_smoke(os.fspath(args.h2c), os.fspath(args.c2h), args.bram_offset, args.bram_size)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
