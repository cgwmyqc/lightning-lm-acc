# AX7Z100 PCIe/XDMA + PL DDR3/MIG Skeleton

This directory contains the first board-level Vivado skeleton for the AX7Z100
bring-up path. It is script generated only; do not keep Vivado GUI project
state as the source of truth.

## Scope

- Target part: `xc7z100ffg900-2`
- PCIe reference clock: Orin/root-complex 100 MHz into `pcie_ref` (`N8/N7`)
- PL DDR3/MIG system clock: AX7Z100 board 200 MHz into `sys` (`F9/E8`)
- PCIe link: Gen2 x4, matching the ALINX `33_PCIe_test` first-pass setup
- DDR fabric: PL DDR3 through MIG 7-series AXI interface
- Control: `slam_accel_ctrl` remains the only register bank, reached through
  XDMA AXI-Lite
- Compute: true HLS IP `unified_surfel_observation_core`

This stage does not run implementation, generate a bitstream, write host
runtime code, or go on board.

## Clocking

- `pcie_ref` is the PCIe endpoint reference clock from the Orin/root complex.
  It feeds XDMA `sys_clk` through `util_ds_buf`.
- `xdma_0/axi_aclk` clocks XDMA AXI-Lite, XDMA AXI master, `slam_accel_ctrl`,
  and the HLS core control/datapath side.
- `sys` is the AX7Z100 PL DDR3 200 MHz differential clock and feeds MIG
  `SYS_CLK`.
- `mig_7series_0/ui_clk` clocks the MIG S_AXI memory side.
- The shared AXI interconnect performs the clock/data-width crossing between
  XDMA/HLS masters and MIG S_AXI.

## Reference Inputs

- `cource_s1_ALINX_ZYNQ(AX7Z100)2023开发平台FPGA教程V1.01.docx`
- `..\12_ddr3_pl\mig_a.prj`
- `..\33_PCIe_test\Vivado\auto_create_project\pl_config.tcl`
- `..\33_PCIe_test\Vivado\auto_create_project\src\constraints\pcie.xdc`
- `..\ch06_xdma_test` only for the prior XDMA/AXI-Lite host-access shape

## Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
```

The default generated project directories are:

- `fpga/vivado/.build/azmig_bd`
- `fpga/vivado/.build/azmig_syn`

Vivado may temporarily see those paths through a short `subst` drive to avoid
Windows/Vivado 2018.3 path-length issues. The actual files remain under
`fpga/vivado/.build/`, which is ignored by git.
