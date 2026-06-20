# XDMA Config BAR Diagnostic Bitstream

This is a minimal AX7Z100 PCIe/XDMA diagnostic project. It exists only to
isolate the Orin-side `xdma:map_bars: Failed to detect XDMA config BAR` failure.

It intentionally does not instantiate MIG, HLS, DDR, `slam_accel_ctrl`, XDMA
host runtime logic, implementation-side SLAM data paths, or board-level memory
fabric.

## Design

- XDMA 4.1, Basic mode
- Device ID `10ee:7024`
- Gen2 X4, 64-bit AXI, 250 MHz AXI target
- AXI-Lite master enabled, 64 KB aperture
- Lane reversal enabled for the AX7Z100 carrier/core-board lane ordering
- MSI enabled, MSI-X disabled; no manual MSI-X BAR indicator override is used
- XDMA `M_AXI_LITE` connects to a tiny in-repo AXI-Lite register block
- XDMA `M_AXI` connects to AXI BRAM Controller + BRAM

This diagnostic bitstream keeps the AX7Z100 lane-reversal X4 link shape that
previously enumerated on Orin, while removing MIG, HLS, and the full SLAM memory
fabric. After the XDMA Linux driver binds and `/dev/xdma*` appears, reintroduce
128-bit AXI, MIG, and then `slam_accel_ctrl + HLS IP` one stage at a time.

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_impl_bitstream.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\program_bitstream_jtag.ps1
```

Default generated bitstream:

```text
fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit
```

## Orin Gate

After JTAG programming and Orin reboot/rescan:

```bash
lspci -nnk -s 0005:01:00.0
lspci -vvv -s 0005:01:00.0
lsmod | grep -i xdma
ls -l /dev/xdma*
dmesg | grep -Ei 'xdma|10ee|7024|BAR|probe|0005:01:00'
```

Pass criteria:

```text
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
No "Failed to detect XDMA config BAR"
```
