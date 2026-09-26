#!/usr/bin/env bash
set -euo pipefail

repo_root=${1:?usage: build_lightning.sh REPO_ROOT [BUILD_TYPE]}
build_type=${2:-RelWithDebInfo}

cd "$repo_root"
ros_distro=${ROS_DISTRO:-humble}
if [[ -f "/opt/ros/${ros_distro}/setup.bash" ]]; then
    # shellcheck disable=SC1090
    set +u
    source "/opt/ros/${ros_distro}/setup.bash"
    set -u
fi

if command -v colcon >/dev/null 2>&1; then
    colcon build --packages-select lightning --cmake-args "-DCMAKE_BUILD_TYPE=${build_type}"
else
    cmake -S . -B build/nma-r0 -DCMAKE_BUILD_TYPE="$build_type"
    cmake --build build/nma-r0 --parallel "$(nproc)"
fi

echo "ORIN_BUILD_PASS build_type=${build_type}"
