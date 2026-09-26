#!/usr/bin/env bash
set -euo pipefail

repo_root=${1:?usage: build_lightning.sh REPO_ROOT [BUILD_TYPE]}
build_type=${2:-RelWithDebInfo}

cd "$repo_root"
if [[ -n "${ROS_DISTRO:-}" && -f "/opt/ros/${ROS_DISTRO}/setup.bash" ]]; then
    # shellcheck disable=SC1090
    source "/opt/ros/${ROS_DISTRO}/setup.bash"
fi

if command -v colcon >/dev/null 2>&1; then
    colcon build --packages-select lightning --cmake-args "-DCMAKE_BUILD_TYPE=${build_type}"
else
    cmake -S . -B build/nma-r0 -DCMAKE_BUILD_TYPE="$build_type"
    cmake --build build/nma-r0 --parallel "$(nproc)"
fi

echo "ORIN_BUILD_PASS build_type=${build_type}"

