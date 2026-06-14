#!/usr/bin/env bash
set -u

usage() {
  cat <<'EOF'
Usage:
  xdma_diagnose.sh [--try-modprobe] [--rescan] [--bdf <domain:bus:dev.fn>]

Default mode is read-only diagnostics. Optional actions:
  --try-modprobe   Run "sudo modprobe xdma" before collecting final status.
  --rescan         Remove the selected PCIe function and rescan the bus.
  --bdf            Use a known PCIe BDF instead of auto-detecting device 7021.

Do not use --rescan while XDMA is used by replay or SLAM processes.
EOF
}

TRY_MODPROBE=0
DO_RESCAN=0
BDF=""

while [ "$#" -gt 0 ]; do
  case "$1" in
    --try-modprobe)
      TRY_MODPROBE=1
      shift
      ;;
    --rescan)
      DO_RESCAN=1
      shift
      ;;
    --bdf)
      if [ "$#" -lt 2 ]; then
        echo "ERROR: --bdf requires an argument" >&2
        exit 2
      fi
      BDF="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "ERROR: unknown argument: $1" >&2
      usage
      exit 2
      ;;
  esac
done

section() {
  printf '\n==== %s ====\n' "$1"
}

run_cmd() {
  printf '+ %s\n' "$*"
  "$@" 2>&1 || true
}

run_shell() {
  printf '+ %s\n' "$*"
  sh -c "$*" 2>&1 || true
}

section "Host"
run_cmd uname -a
run_cmd date

section "Xilinx PCIe devices"
run_shell "lspci -Dnn | grep -i xilinx"

if [ -z "$BDF" ]; then
  BDF="$(lspci -Dnn 2>/dev/null | awk 'BEGIN{IGNORECASE=1} /Xilinx Corporation/ && /7021/ {print $1; exit}')"
fi

if [ -z "$BDF" ]; then
  section "Auto-detect result"
  echo "No Xilinx device with device id 7021 was found."
  echo "Run again with --bdf <domain:bus:dev.fn> if lspci uses a different id."
else
  section "Selected BDF"
  echo "$BDF"
fi

section "XDMA kernel module"
run_shell "lsmod | grep -i xdma"

if [ "$TRY_MODPROBE" -eq 1 ]; then
  section "Try modprobe xdma"
  run_cmd sudo modprobe xdma
  run_shell "lsmod | grep -i xdma"
fi

if [ -n "$BDF" ]; then
  section "PCI driver binding"
  run_cmd lspci -nnk -s "$BDF"

  section "PCI verbose status"
  run_cmd sudo lspci -vv -s "$BDF"

  section "Sysfs PCI device"
  DEVPATH="/sys/bus/pci/devices/$BDF"
  run_cmd ls -la "$DEVPATH"
  run_shell "cat '$DEVPATH/vendor'"
  run_shell "cat '$DEVPATH/device'"
  run_shell "ls -l '$DEVPATH'/resource*"
  run_shell "cat '$DEVPATH/enable'"

  if [ "$DO_RESCAN" -eq 1 ]; then
    section "PCI remove and rescan"
    echo "Removing $BDF and rescanning PCI bus."
    run_shell "echo 1 | sudo tee '$DEVPATH/remove'"
    sleep 1
    run_shell "echo 1 | sudo tee /sys/bus/pci/rescan"
    sleep 1
    run_shell "lspci -Dnn | grep -i xilinx"
    run_shell "lspci -Dnnk | grep -A5 -i xilinx"
  fi
fi

section "XDMA character devices"
run_shell "ls -l /dev/xdma*"

section "Recent kernel messages"
run_shell "dmesg -T | grep -Ei 'xdma|xilinx|7021|pci|bar|msi|probe' | tail -n 200"

section "Next interpretation"
cat <<'EOF'
Check these first:
  1. "Kernel driver in use: xdma" should appear in lspci -nnk.
  2. BAR regions should appear in lspci -vv.
  3. dmesg should not contain xdma probe failures, BAR failures, or MSI errors.
  4. If previous firmware works and this one fails, compare XDMA IP BAR/MSI
     customization and confirm BOOT.bin contains the intended latest bitstream.
EOF
