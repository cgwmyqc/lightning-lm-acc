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

set +e
"$binary" "$@" 2>&1 | tee "$output_dir/stdout.log"
status=${PIPESTATUS[0]}
set -e
if [[ $status -ne 0 ]]; then
    echo "BENCHMARK_FAIL exit_code=$status" >&2
    exit "$status"
fi

python3 - "$output_dir/stdout.log" "$output_dir/frame_summary.csv" "$output_dir/measured_frames.csv" \
    "$warmup_frames" "$measure_frames" <<'PY'
import csv
import math
import re
import sys

log_path, summary_path, frames_path, warmup_text, measure_text = sys.argv[1:]
warmup = int(warmup_text)
measure = int(measure_text)
records = []

with open(log_path, encoding="utf-8", errors="replace") as stream:
    for line in stream:
        if "[loc_profile]" not in line:
            continue
        record = {}
        for key, value in re.findall(r"([A-Za-z0-9_/]+)=([^\s]+)", line):
            try:
                record[key] = float(value)
            except ValueError:
                continue
        if "frame" in record:
            records.append(record)

required = warmup + measure
if len(records) < required:
    raise SystemExit(
        f"BENCHMARK_FAIL reason=insufficient_loc_profile_samples actual={len(records)} "
        f"required={required}; set profile.enable=true and profile.log_every_n_frames=1"
    )

selected = records[warmup:required]
common_fields = set.intersection(*(set(record) for record in selected))
if "loc_total_ms" not in common_fields:
    raise SystemExit("BENCHMARK_FAIL reason=loc_total_ms_missing_from_profile")
metrics = sorted(common_fields - {"frame"})
with open(frames_path, "w", newline="", encoding="utf-8") as stream:
    writer = csv.DictWriter(stream, fieldnames=["frame"] + metrics)
    writer.writeheader()
    for record in selected:
        writer.writerow({key: record[key] for key in writer.fieldnames})

with open(summary_path, "w", newline="", encoding="utf-8") as stream:
    writer = csv.writer(stream)
    writer.writerow(["metric", "samples", "mean", "p95", "min", "max"])
    for metric in metrics:
        values = sorted(record[metric] for record in selected)
        p95 = values[max(0, math.ceil(0.95 * len(values)) - 1)]
        writer.writerow(
            [metric, len(values), sum(values) / len(values), p95, values[0], values[-1]]
        )

print(
    f"BENCHMARK_FRAME_SUMMARY_PASS samples={len(selected)} warmup={warmup} "
    f"summary={summary_path}"
)
PY

echo "BENCHMARK_PASS executable=$executable"
