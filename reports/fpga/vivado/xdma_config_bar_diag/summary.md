# XDMA Config BAR Diagnostic Summary

## Purpose

Orin enumerates the AX7Z100 endpoint as `10ee:7024`, but the Linux XDMA driver
fails probe with:

```text
xdma:map_bars: Failed to detect XDMA config BAR
xdma: probe of 0005:01:00.0 failed with error -22
```

This diagnostic bitstream isolates the XDMA BAR/driver problem from the full
SLAM/HLS/MIG design.

## Diagnostic Configuration

- XDMA-only board design: no MIG, no HLS, no `slam_accel_ctrl`
- `mode_selection=Basic`
- `pf0_device_id=7024`
- `axilite_master_en=true`
- `enable_lane_reversal=true`
- Diagnostic link width/data width: Gen2 X4, 64-bit AXI, 250 MHz AXI target
- MSI-X is disabled and the diagnostic design does not apply a manual MSI-X
  BAR indicator override
- `M_AXI_LITE` drives a tiny AXI-Lite register block
- `M_AXI` drives AXI BRAM Controller + BRAM

## Expected Outcome

If `/dev/xdma*` appears with this image, the root cause is a full-design XDMA
BAR/config/data-width/MIG/HLS interaction, not the Orin driver installation.
Then restore 128-bit AXI, MIG, and HLS in separate bitstreams.

If the same `Failed to detect XDMA config BAR` remains, the next step is to
clone the ALINX `33_PCIe_test` or previous 7Z015 XDMA IP parameters exactly and
compare generated XDMA `.xci` fields against this diagnostic project.

## Status

- Scripts and diagnostic RTL: prepared
- BD validate: PASS for X4 diagnostic
- Synthesis: PASS for X4 diagnostic
- Implementation/bitstream: PASS for X4 diagnostic
- JTAG programming: PASS for X4 diagnostic
- Orin `/dev/xdma*` retest: PASS

## Validation Notes

The first diagnostic bitstream used Gen2 X1, 64-bit AXI and JTAG programmed
successfully, but Orin did not enumerate the endpoint after reboot. Because the
AX7Z100 PCIe lane order is reversed and the previous full X4 lane-reversal
bitstream did enumerate, the diagnostic design has been changed to Gen2 X4 while
keeping the simpler 64-bit/no-MIG/no-HLS structure.

An initial X4 attempt with `axisten_freq=125` failed Vivado XDMA customization:
for `X4 + 64-bit AXI`, Vivado 2018.3 XDMA 4.1 requires `axisten_freq=250`.
The diagnostic design now uses that valid combination.
- `run_vivado_bd_validate.ps1`: PASS for X4 diagnostic.
- `run_vivado_project_synth.ps1 -Jobs 18`: PASS for X4 diagnostic.
- `run_vivado_impl_bitstream.ps1 -Jobs 18`: PASS for X4 diagnostic.
- Bitstream: `fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit`
- Bitstream size: 3,187,655 bytes
- Bitgen: `0 Errors`, `0 Critical Warnings`, `47 Warnings`
- DRC: `0 Errors`, `24 Warnings`
- `program_bitstream_jtag.ps1`: PASS for X4 diagnostic.
- JTAG status: `FPGA_STATE=FPGA is configured`, `DONE PIN: 1`
- Orin reboot after X4 diagnostic: PASS
- Observed endpoint:
  `0005:01:00.0 Serial controller: Xilinx Corporation Device 7024`
- Observed device nodes:
  `/dev/xdma0_user`, `/dev/xdma0_control`, `/dev/xdma0_h2c_0`,
  `/dev/xdma0_c2h_0`, `/dev/xdma0_xvc`, and `/dev/xdma0_events_*`
- Bring-up conclusion: the previous X1 diagnostic failure was caused by using
  X1 on reversed x4 lane wiring. The X4 lane-reversal diagnostic image proves
  that the Orin root complex, XDMA driver, device ID `10ee:7024`, lane reversal,
  and XDMA config BAR path can work together.
- Added host-side diagnostic smoke:
  `fpga/host/xdma_smoke/xdma_diag_smoke.py --user-smoke --bram-smoke`

- `run_vivado_bd_validate.ps1`: PASS
- `run_vivado_project_synth.ps1 -Jobs 18`: PASS
- Vivado generated the BD wrapper and XDMA property reports.
- Synthesis finished with `0 errors`, `0 critical warnings`, and the wrapper
  flow emitted `XDMA_CONFIG_BAR_DIAG_PROJECT_SYNTH_PASS`.
- `run_vivado_impl_bitstream.ps1 -Jobs 18`: PASS
- Implementation emitted `XDMA_CONFIG_BAR_DIAG_IMPLEMENTATION_BITSTREAM_PASS`.
- Bitstream: `fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit`
- Bitstream size: 3,450,035 bytes
- Bitgen: `0 Errors`, `0 Critical Warnings`, `47 Warnings`
- DRC: `0 Errors`, `24 Warnings`
- `program_bitstream_jtag.ps1`: PASS
- JTAG status: `FPGA_STATE=FPGA is configured`, `DONE PIN: 1`
- Remaining BD warnings are BRAM initialization/address-width warnings and the
  local Tcl store permission warning; no MSI-X BAR override warning remains.

## Resource And Timing

- Slice LUTs: 13,366 / 277,400 (4.82%)
- Slice Registers: 14,780 / 554,800 (2.66%)
- Block RAM Tile: 36.5 / 755 (4.83%)
- DSPs: 0 / 2,020 (0.00%)
- Bonded IOB: 1 / 362 (0.28%)
- BUFGCTRL: 5 / 32 (15.63%)
- PCIE_2_1: 1 / 1 (100.00%)
- WNS: 0.290 ns
- TNS: 0.000 ns
- Setup failing endpoints: 0
- WHS: 0.030 ns
- THS: 0.000 ns
- Hold failing endpoints: 0
