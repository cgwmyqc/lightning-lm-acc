#!/usr/bin/env bash
set -euo pipefail

output=${1:-./tegrastats.log}
duration_sec=${2:-30}
interval_ms=${3:-1000}

mkdir -p "$(dirname "$output")"
if ! command -v tegrastats >/dev/null 2>&1; then
    echo "TEGRASTATS_FAIL reason=command_not_found" >&2
    exit 30
fi

timeout --signal=INT "${duration_sec}s" tegrastats --interval "$interval_ms" > "$output" 2>&1 || status=$?
status=${status:-0}
if [[ $status -ne 0 && $status -ne 124 && $status -ne 130 ]]; then
    echo "TEGRASTATS_FAIL exit_code=$status" >&2
    exit "$status"
fi
echo "TEGRASTATS_PASS output=$output"

