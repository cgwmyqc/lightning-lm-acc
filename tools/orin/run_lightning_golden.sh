#!/usr/bin/env bash
set -euo pipefail

repo_root=${1:?usage: run_lightning_golden.sh REPO_ROOT OUTPUT_DIR EXECUTABLE [ARGS...]}
output_dir=${2:?missing output directory}
executable=${3:?missing executable}
shift 3

cd "$repo_root"
if [[ -n "${ROS_DISTRO:-}" && -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]]; then
    # shellcheck disable=SC1090
    set +u
    source "/opt/ros/${ROS_DISTRO}/setup.bash"
    set -u
elif [[ -f /opt/ros/humble/setup.bash ]]; then
    # shellcheck disable=SC1091
    set +u
    source /opt/ros/humble/setup.bash
    set -u
fi
if [[ -f install/setup.bash ]]; then
    # shellcheck disable=SC1091
    set +u
    source install/setup.bash
    set -u
fi

mkdir -p "$output_dir"
binary=$(command -v "$executable" || true)
if [[ -z "$binary" && -x "install/lightning/lib/lightning/$executable" ]]; then
    binary="install/lightning/lib/lightning/$executable"
fi
if [[ -z "$binary" ]]; then
    echo "GOLDEN_FAIL reason=executable_not_found executable=$executable" >&2
    exit 20
fi

{
    echo "timestamp_utc=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "git_commit=$(git rev-parse HEAD)"
    echo "executable=$binary"
    printf 'arguments='
    printf '%q ' "$@"
    printf '\n'
} > "$output_dir/run_metadata.txt"

set +e
"$binary" "$@" 2>&1 | tee "$output_dir/stdout.log"
status=${PIPESTATUS[0]}
set -e
if [[ $status -ne 0 ]]; then
    echo "GOLDEN_FAIL exit_code=$status" >&2
    exit "$status"
fi
echo "GOLDEN_PASS executable=$executable"
