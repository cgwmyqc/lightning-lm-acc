#!/usr/bin/env bash
set -euo pipefail

xdma_module_path=${1:-}

find_xilinx_bdf() {
    lspci -Dn -d 10ee: 2>/dev/null | awk 'NR == 1 { print $1 }'
}

bdf=$(find_xilinx_bdf)
if [[ -z "$bdf" ]]; then
    echo "PCIE_RESCAN_FAIL reason=xilinx_endpoint_not_found_before_rescan" >&2
    exit 10
fi
echo "PCIE_BDF_BEFORE=$bdf"

if lsmod | awk '{print $1}' | grep -qx xdma; then
    modprobe -r xdma
fi

remove_path="/sys/bus/pci/devices/${bdf}/remove"
if [[ ! -w "$remove_path" ]]; then
    echo "PCIE_RESCAN_FAIL reason=remove_path_not_writable path=$remove_path" >&2
    exit 11
fi
printf '1\n' > "$remove_path"
printf '1\n' > /sys/bus/pci/rescan

new_bdf=""
for _ in $(seq 1 20); do
    new_bdf=$(find_xilinx_bdf)
    [[ -n "$new_bdf" ]] && break
    sleep 0.25
done
if [[ -z "$new_bdf" ]]; then
    echo "PCIE_RESCAN_FAIL reason=xilinx_endpoint_not_found_after_rescan" >&2
    exit 12
fi
echo "PCIE_BDF_AFTER=$new_bdf"

if [[ -n "$xdma_module_path" ]]; then
    insmod "$xdma_module_path"
else
    modprobe xdma
fi

for _ in $(seq 1 20); do
    if [[ -c /dev/xdma0_user && -c /dev/xdma0_h2c_0 && -c /dev/xdma0_c2h_0 ]]; then
        break
    fi
    sleep 0.25
done
for node in /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0; do
    [[ -c "$node" ]] || { echo "PCIE_RESCAN_FAIL reason=missing_device node=$node" >&2; exit 13; }
done

link_status=$(lspci -s "$new_bdf" -vv | grep -m1 'LnkSta:' || true)
echo "PCIE_LINK_STATUS=$link_status"
if [[ "$link_status" != *"Speed 5GT/s"* || "$link_status" != *"Width x4"* ]]; then
    echo "PCIE_RESCAN_FAIL reason=link_not_gen2_x4" >&2
    exit 14
fi

ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
echo "PCIE_RESCAN_PASS"

