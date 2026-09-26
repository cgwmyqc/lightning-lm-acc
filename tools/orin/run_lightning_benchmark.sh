#!/usr/bin/env bash
set -euo pipefail

repo_root=${1:?usage: run_lightning_benchmark.sh REPO_ROOT OUTPUT_DIR WARMUP_FRAMES MEASURE_FRAMES EXECUTABLE [ARGS...]}
output_dir=${2:?missing output directory}
warmup_frames=${3:?missing warmup frame count}
measure_frames=${4:?missing measure frame count}
executable=${5:?missing executable}
shift 5

cd "$repo_root"
if [[ -n "${ROS_DISTRO:-}" && -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]]; then
    # shellcheck disable=SC1090
    source "/opt/ros/${ROS_DISTRO}/setup.bash"
fi
if [[ -f install/setup.bash ]]; then
    # shellcheck disable=SC1091
    source install/setup.bash
fi

mkdir -p "$output_dir"
frame_csv="$output_dir/all_frames.csv"
rm -f "$frame_csv" "$output_dir/measured_frames.csv" "$output_dir/frame_summary.csv" \
    "$output_dir/stdout.log" "$output_dir/tegrastats.log"
binary=$(command -v "$executable" || true)
if [[ -z "$binary" && -x "install/lightning/lib/lightning/$executable" ]]; then
    binary="install/lightning/lib/lightning/$executable"
fi
if [[ -z "$binary" && -x "build/lightning/$executable" ]]; then
    binary="build/lightning/$executable"
fi
if [[ -z "$binary" ]]; then
    echo "BENCHMARK_FAIL reason=executable_not_found executable=$executable" >&2
    exit 20
fi

export NMA_WARMUP_FRAMES="$warmup_frames"
export NMA_MEASURE_FRAMES="$measure_frames"
export NMA_LOC_PROFILE_CSV="$frame_csv"
{
    echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "git_commit=$(git rev-parse HEAD)"
    echo "executable=$binary"
    echo "warmup_frames=$warmup_frames"
    echo "measure_frames=$measure_frames"
    printf 'arguments='
    printf '%q ' "$@"
    printf '\n'
} > "$output_dir/run_metadata.txt"

tegrastats_pid=""
if command -v tegrastats >/dev/null 2>&1; then
    tegrastats --interval 1000 > "$output_dir/tegrastats.log" 2>&1 &
    tegrastats_pid=$!
fi

set +e
"$binary" "$@" 2>&1 | tee "$output_dir/stdout.log"
status=${PIPESTATUS[0]}
if [[ -n "$tegrastats_pid" ]]; then
    kill -INT "$tegrastats_pid" 2>/dev/null || true
    wait "$tegrastats_pid" 2>/dev/null || true
fi
set -e
if [[ $status -ne 0 ]]; then
    echo "BENCHMARK_FAIL exit_code=$status" >&2
    exit "$status"
fi

python3 - "$frame_csv" "$output_dir/frame_summary.csv" "$output_dir/measured_frames.csv" \
    "$warmup_frames" "$measure_frames" <<'PY'
import csv
import math
import statistics
import sys

input_path, summary_path, frames_path, warmup_text, measure_text = sys.argv[1:]
warmup = int(warmup_text)
measure = int(measure_text)
with open(input_path, newline="", encoding="utf-8") as stream:
    reader = csv.DictReader(stream)
    fieldnames = reader.fieldnames or []
    records = list(reader)

required_fields = {
    "frame_id", "backend", "candidate_build_ms", "map_export_ms", "pack_scan_ms", "h2c_scan_ms",
    "fpga_cycles", "fpga_kernel_ms", "host_wait_ms", "polling_overhead_ms", "c2h_ms", "eskf_ms",
    "frame_total_ms", "cpu_usage_pct", "fallback_cpu_sim", "fallback_ndt",
}
missing = sorted(required_fields - set(fieldnames))
if missing:
    raise SystemExit(f"BENCHMARK_FAIL reason=missing_frame_csv_fields fields={','.join(missing)}")

required = warmup + measure
if len(records) < required:
    raise SystemExit(
        f"BENCHMARK_FAIL reason=insufficient_frame_csv_samples actual={len(records)} required={required}"
    )

selected = records[warmup:required]
frame_ids = [int(record["frame_id"]) for record in selected]
if any(right <= left for left, right in zip(frame_ids, frame_ids[1:])):
    raise SystemExit("BENCHMARK_FAIL reason=frame_ids_not_strictly_increasing")

with open(frames_path, "w", newline="", encoding="utf-8") as stream:
    writer = csv.DictWriter(stream, fieldnames=fieldnames)
    writer.writeheader()
    writer.writerows(selected)

numeric_metrics = []
for field in fieldnames:
    if field == "backend":
        continue
    values = []
    for record in selected:
        try:
            value = float(record[field])
        except (TypeError, ValueError):
            continue
        if math.isfinite(value):
            values.append(value)
    if values:
        numeric_metrics.append((field, values))

with open(summary_path, "w", newline="", encoding="utf-8") as stream:
    writer = csv.writer(stream)
    writer.writerow(["metric", "samples", "mean", "p50", "p95", "min", "max", "std"])
    for metric, raw_values in numeric_metrics:
        values = sorted(raw_values)
        p50 = values[max(0, math.ceil(0.50 * len(values)) - 1)]
        p95 = values[max(0, math.ceil(0.95 * len(values)) - 1)]
        writer.writerow(
            [metric, len(values), statistics.fmean(values), p50, p95, values[0], values[-1],
             statistics.pstdev(values)]
        )

print(
    f"BENCHMARK_FRAME_SUMMARY_PASS samples={len(selected)} warmup={warmup} "
    f"summary={summary_path}"
)
PY

echo "BENCHMARK_PASS executable=$executable"
