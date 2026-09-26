#!/usr/bin/env bash
set -euo pipefail

target_user=${1:-}
if [[ $(id -u) -ne 0 || -z "$target_user" || "$target_user" == -* ]]; then
    echo "usage: sudo $0 USER" >&2
    exit 2
fi
if ! id "$target_user" >/dev/null 2>&1; then
    echo "XDMA_ACCESS_INSTALL_FAIL reason=unknown_user user=$target_user" >&2
    exit 3
fi

groupadd --system --force xdma
usermod --append --groups xdma "$target_user"
cat > /etc/udev/rules.d/99-lightning-xdma.rules <<'RULE'
SUBSYSTEM=="xdma", KERNEL=="xdma*", GROUP="xdma", MODE="0660"
RULE
chmod 0644 /etc/udev/rules.d/99-lightning-xdma.rules
udevadm control --reload-rules
udevadm trigger --subsystem-match=xdma
udevadm settle

shopt -s nullglob
for node in /dev/xdma*; do
    chgrp xdma "$node"
    chmod 0660 "$node"
done

echo "XDMA_ACCESS_INSTALL_PASS user=$target_user group=xdma"
echo "Reconnect the SSH session before running non-root XDMA tests."
