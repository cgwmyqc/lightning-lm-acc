#!/usr/bin/env bash
set -uo pipefail

expected_speed=${PCIE_EXPECTED_SPEED:-5.0 GT/s}
expected_width=${PCIE_EXPECTED_WIDTH:-4}

emit() {
    printf '%s=%s\n' "$1" "$2"
}

read_property() {
    local path=$1
    if [[ -r "$path" ]]; then
        cat "$path"
    fi
}

read_dt_string() {
    local path=$1
    if [[ -r "$path" ]]; then
        tr '\0' ',' < "$path" | sed 's/,$//'
    fi
}

read_dt_u32() {
    local path=$1 hex
    if [[ ! -r "$path" ]]; then
        return
    fi
    hex=$(od -An -tx1 "$path" | tr -d ' \n')
    if [[ -n "$hex" ]]; then
        printf '%d' "$((16#$hex))"
    fi
}

find_xilinx_bdf() {
    lspci -Dn -d 10ee: 2>/dev/null | awk 'NR == 1 { print $1 }'
}

read_driver() {
    local path=$1
    if [[ -L "$path/driver" ]]; then
        basename "$(readlink -f "$path/driver")"
    else
        printf 'unbound'
    fi
}

emit TIMESTAMP_UTC "$(date -u +%Y-%m-%dT%H:%M:%SZ)"
emit HOSTNAME "$(hostname)"
emit KERNEL "$(uname -r)"
emit PLATFORM_MODEL "$(read_dt_string /proc/device-tree/model)"

bdf=$(find_xilinx_bdf)
if [[ -z "$bdf" ]]; then
    emit ENDPOINT_BDF missing
    emit DIAG_STATUS FAIL
    emit DIAG_REASON xilinx_endpoint_missing
    exit 12
fi

endpoint_path="/sys/bus/pci/devices/$bdf"
endpoint_sysfs=$(readlink -f "$endpoint_path")
root_path=$(dirname "$endpoint_sysfs")
root_bdf=$(basename "$root_path")
root_sysfs="/sys/bus/pci/devices/$root_bdf"
platform_path=$endpoint_sysfs
root_of_node=""
while [[ "$platform_path" != "/" ]]; do
    if [[ -d "$platform_path/of_node" ]]; then
        root_of_node="$platform_path/of_node"
        break
    fi
    platform_path=$(dirname "$platform_path")
done

emit ENDPOINT_BDF "$bdf"
emit ROOT_BDF "$root_bdf"
emit ENDPOINT_SYSFS "$endpoint_sysfs"
emit PLATFORM_SYSFS "$platform_path"
emit ROOT_OF_NODE "$(readlink "$root_of_node" 2>/dev/null || true)"
emit ENDPOINT_DRIVER "$(read_driver "$endpoint_path")"
emit ROOT_DRIVER "$(read_driver "$root_sysfs")"

endpoint_current_speed=$(read_property "$endpoint_path/current_link_speed")
endpoint_current_width=$(read_property "$endpoint_path/current_link_width")
endpoint_max_speed=$(read_property "$endpoint_path/max_link_speed")
endpoint_max_width=$(read_property "$endpoint_path/max_link_width")
root_current_speed=$(read_property "$root_sysfs/current_link_speed")
root_current_width=$(read_property "$root_sysfs/current_link_width")
root_max_speed=$(read_property "$root_sysfs/max_link_speed")
root_max_width=$(read_property "$root_sysfs/max_link_width")

emit ENDPOINT_CURRENT_SPEED "$endpoint_current_speed"
emit ENDPOINT_CURRENT_WIDTH "$endpoint_current_width"
emit ENDPOINT_MAX_SPEED "$endpoint_max_speed"
emit ENDPOINT_MAX_WIDTH "$endpoint_max_width"
emit ROOT_CURRENT_SPEED "$root_current_speed"
emit ROOT_CURRENT_WIDTH "$root_current_width"
emit ROOT_MAX_SPEED "$root_max_speed"
emit ROOT_MAX_WIDTH "$root_max_width"

dt_status=$(read_dt_string "$root_of_node/status")
dt_num_lanes=$(read_dt_u32 "$root_of_node/num-lanes")
dt_domain=$(read_dt_u32 "$root_of_node/linux,pci-domain")
dt_phy_names=$(read_dt_string "$root_of_node/phy-names")
emit DT_STATUS "$dt_status"
emit DT_NUM_LANES "$dt_num_lanes"
emit DT_DOMAIN "$dt_domain"
emit DT_PHY_NAMES "$dt_phy_names"

nodes_ok=true
for node in /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 /dev/xdma0_events_0; do
    key=$(basename "$node" | tr '[:lower:]' '[:upper:]')
    if [[ -c "$node" ]]; then
        emit "${key}_NODE" present
        emit "${key}_MODE" "$(stat -c '%a:%U:%G' "$node")"
    else
        emit "${key}_NODE" missing
        nodes_ok=false
    fi
done
emit XDMA_NODES_OK "$nodes_ok"

if [[ "$dt_status" != "okay" ]]; then
    emit DIAG_STATUS FAIL
    emit DIAG_REASON root_port_disabled
    exit 13
fi
if [[ -z "$dt_num_lanes" || "$dt_num_lanes" -lt "$expected_width" ]]; then
    emit DIAG_STATUS FAIL
    emit DIAG_REASON device_tree_width_below_x4
    exit 13
fi
if [[ "$endpoint_current_speed" != "$expected_speed"* ||
      "$endpoint_current_width" != "$expected_width" ||
      "$root_current_speed" != "$expected_speed"* ||
      "$root_current_width" != "$expected_width" ]]; then
    emit DIAG_STATUS FAIL
    emit DIAG_REASON link_not_gen2_x4
    exit 14
fi
if [[ "$nodes_ok" != true ]]; then
    emit DIAG_STATUS FAIL
    emit DIAG_REASON xdma_nodes_missing
    exit 15
fi

emit DIAG_STATUS PASS
emit DIAG_REASON none
exit 0
