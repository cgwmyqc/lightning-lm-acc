#!/usr/bin/env bash
set -euo pipefail

output_csv=${1:-./pcie_xdma.csv}
h2c_dev=${H2C_DEV:-/dev/xdma0_h2c_0}
c2h_dev=${C2H_DEV:-/dev/xdma0_c2h_0}
benchmark_base=${XDMA_BENCHMARK_BASE:-0x34000000}

mkdir -p "$(dirname "$output_csv")"
python3 - "$h2c_dev" "$c2h_dev" "$benchmark_base" "$output_csv" <<'PY'
import csv
import os
import sys
import time

h2c_path, c2h_path, base_text, output_path = sys.argv[1:]
base = int(base_text, 0)
sizes = [4 << 10, 64 << 10, 128 << 10, 512 << 10, 1 << 20, 8 << 20, 32 << 20]

def timed(iterations, fn):
    start = time.perf_counter_ns()
    for _ in range(iterations):
        fn()
    return (time.perf_counter_ns() - start) / iterations / 1000.0

rows = []
h2c = os.open(h2c_path, os.O_WRONLY | os.O_SYNC)
c2h = os.open(c2h_path, os.O_RDONLY | os.O_SYNC)
try:
    for size in sizes:
        iterations = max(3, min(128, (64 << 20) // size))
        seed = bytes(range(256))
        payload = (seed * ((size + len(seed) - 1) // len(seed)))[:size]
        written = os.pwrite(h2c, payload, base)
        if written != size:
            raise RuntimeError(f"short H2C write: {written}/{size}")
        actual = os.pread(c2h, size, base)
        if actual != payload:
            raise RuntimeError(f"C2H verification mismatch for {size} bytes")

        h2c_us = timed(iterations, lambda: os.pwrite(h2c, payload, base))
        c2h_us = timed(iterations, lambda: os.pread(c2h, size, base))
        round_trip_us = timed(
            iterations,
            lambda: (os.pwrite(h2c, payload, base), os.pread(c2h, size, base)),
        )
        h2c_mbps = size / h2c_us if h2c_us else 0.0
        c2h_mbps = size / c2h_us if c2h_us else 0.0
        rows.append(
            {
                "size_bytes": size,
                "h2c_MBps": f"{h2c_mbps:.3f}",
                "c2h_MBps": f"{c2h_mbps:.3f}",
                "h2c_us": f"{h2c_us:.3f}",
                "c2h_us": f"{c2h_us:.3f}",
                "round_trip_us": f"{round_trip_us:.3f}",
                "iterations": iterations,
            }
        )
finally:
    os.close(h2c)
    os.close(c2h)

with open(output_path, "w", newline="", encoding="utf-8") as stream:
    writer = csv.DictWriter(stream, fieldnames=rows[0].keys())
    writer.writeheader()
    writer.writerows(rows)

for row in rows:
    print(",".join(str(row[key]) for key in row))
print(f"XDMA_BENCHMARK_PASS output={output_path}")
PY

