# XDMA Device Node Debug Guide

This guide covers the case where the FPGA PCIe endpoint is visible in
`lspci`, but `/dev/xdma*` is missing on the Orin host.

## Current Expected FPGA Layout

The current Vivado block design keeps the XDMA endpoint as the host-facing
PCIe device and adds two HLS accelerators behind the XDMA AXI masters.

Expected AXI-Lite map behind `xdma_0/M_AXI_LITE`:

```text
axi_gpio_0             0x0000_0000 / 4K
normal_eq_accel_0      0x0000_1000 / 4K
lookup_batch_accel_0   0x0000_2000 / 4K
```

Expected accelerator DDR windows:

```text
normal_eq_accel_0/Data_m_axi_gmem       0x0200_0000 / 32M
lookup_batch_accel_0/Data_m_axi_gmem    0x0400_0000 / 32M
xdma_0/M_AXI -> PS HP0 DDR              0x0000_0000 / 1G
```

These address segments should not by themselves prevent `/dev/xdma*` from
being created. Device-node creation happens earlier, during Linux XDMA driver
probe and bind.

## Symptom Meaning

If `lspci` shows `Xilinx Corporation Device 7021`, PCIe enumeration succeeded
far enough for the Orin to read the endpoint configuration space.

If `/dev/xdma*` is missing, one of these is more likely:

- The `xdma` Linux driver is not loaded.
- The `xdma` driver is loaded but not bound to the endpoint.
- Driver probe failed after reading PCIe BAR, MSI, or XDMA engine registers.
- The new bitstream changed XDMA BAR/MSI/IP settings compared with the working
  bitstream.
- The flashed BOOT image does not contain the bitstream that was intended.

The normal-equation and lookup HLS math is not the first suspect for this
symptom.

## Orin Diagnostic Commands

Run the helper script after booting with the new firmware:

```bash
cd <repo-root>
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh
```

The script prints:

- Xilinx PCIe devices from `lspci`.
- The selected BDF for device id `7021`.
- `lspci -nnk` driver binding status.
- `lspci -vv` BAR, MSI/MSI-X, command, and link information.
- `lsmod` status for `xdma`.
- `/dev/xdma*` and `/sys/bus/pci/devices/<BDF>/resource*`.
- Recent `dmesg` lines related to PCIe, Xilinx, XDMA, BAR, MSI, and probe.

Manual equivalent:

```bash
lspci -nn | grep -i xilinx
lspci -nnk | grep -A5 -i xilinx
lsmod | grep -i xdma
dmesg -T | grep -Ei "xdma|xilinx|7021|pci|bar|msi|probe"
```

If the BDF is known, for example `0005:01:00.0`:

```bash
sudo lspci -vv -s 0005:01:00.0
ls /sys/bus/pci/devices/0005:01:00.0/
cat /sys/bus/pci/devices/0005:01:00.0/vendor
cat /sys/bus/pci/devices/0005:01:00.0/device
```

## Optional Recovery Commands

If the driver is not loaded:

```bash
sudo modprobe xdma
ls /dev/xdma*
dmesg -T | grep -Ei "xdma|probe|bar|msi"
```

The helper script can do this explicitly:

```bash
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh --try-modprobe
```

If the driver is loaded but not bound, perform a PCIe rescan:

```bash
BDF=$(lspci -D | grep -i "Xilinx Corporation Device 7021" | awk '{print $1; exit}')
echo 1 | sudo tee /sys/bus/pci/devices/$BDF/remove
echo 1 | sudo tee /sys/bus/pci/rescan
ls /dev/xdma*
dmesg -T | grep -Ei "xdma|xilinx|7021|probe|bar|msi"
```

The helper script can do this explicitly:

```bash
bash fpga/host_tools/xdma_diag/xdma_diagnose.sh --rescan
```

Do not use `--rescan` while a replay or SLAM process is using XDMA.

## Vivado Checks

Compare the latest bitstream against the last working bitstream and keep the
XDMA IP configuration identical unless there is a deliberate reason to change
it.

Check:

- Vendor/device id remains `10ee:7021`.
- XDMA BAR layout is unchanged.
- MSI/MSI-X settings are unchanged.
- AXI-Lite Master and AXI Memory Mapped interfaces are still enabled.
- PCIe link width, link speed, refclk, and reset constraints are unchanged.
- Implementation has no timing violation.

The current local BD handoff shows:

```text
CONFIG.axilite_master_en true
CONFIG.axilite_master_size 64 KB
CONFIG.mode_selection Basic
CONFIG.pf0_device_id 7021
CONFIG.pf0_msix_cap_pba_bir BAR_1
CONFIG.pf0_msix_cap_table_bir BAR_1
CONFIG.pl_link_cap_max_link_speed 5.0_GT/s
```

The current `impl_1/runme.log` shows `write_bitstream completed successfully`
and router-estimated timing around:

```text
WNS=0.478 ns, TNS=0.000 ns, WHS=0.012 ns, THS=0.000 ns
```

However, the routed timing summary report in the local tree is older than the
latest bitstream. Re-open implemented design or re-run timing summary before
signing off the latest image.

## Boot Image Check

The SDK boot image currently points to:

```text
ch06_xdma_test.sdk/fsbl/Debug/fsbl.elf
ch06_xdma_test.sdk/design_1_wrapper_hw_platform_0/design_1_wrapper.bit
```

The latest implementation bitstream is normally generated at:

```text
ch06_xdma_test.runs/impl_1/design_1_wrapper.bit
```

If programming through BOOT.bin, regenerate/export the hardware platform and
rebuild BOOT.bin after generating the latest bitstream. If programming through
JTAG or Hardware Manager, download the bitstream from `impl_1` directly.

## Interpretation

- `Kernel driver in use: xdma` exists but `/dev/xdma*` is missing: check driver
  logs and udev/device creation.
- No `Kernel driver in use`: check `modprobe xdma`, device id binding, and
  rescan.
- Probe failure in `dmesg`: check BAR/MSI-X settings and whether XDMA register
  access times out.
- Old firmware works and new firmware fails with unchanged Orin software:
  compare XDMA IP customization and flashed image contents first.
