# AX7Z100 PCIe/XDMA + PL DDR3/MIG Skeleton

This directory contains the first board-level Vivado skeleton for the AX7Z100
bring-up path. It is script generated only; do not keep Vivado GUI project
state as the source of truth.

## Scope

- Target part: `xc7z100ffg900-2`
- PCIe reference clock: Orin/root-complex 100 MHz into `pcie_ref` (`N8/N7`)
- PL DDR3/MIG system clock: AX7Z100 board 200 MHz into `sys` (`F9/E8`)
- PCIe link: Gen2 x4, matching the ALINX `33_PCIe_test` first-pass setup
- PCIe lane reversal: enabled in XDMA, because the AX7Z100 carrier/core-board
  schematic indicates the x4 slot lane order is reversed into Bank112
- DDR fabric: PL DDR3 through MIG 7-series AXI interface
- Control: XDMA BAR0 starts with a driver-compatible shim identity/scratch page
  at `0x0000`; `slam_accel_ctrl` remains the only accelerator register bank and
  is reached through XDMA AXI-Lite at offset `0x1000`
- Compute: true HLS IP `unified_surfel_observation_core`

Stage 44 HLS output contract: the board-level BD connects
`slam_accel_ctrl.unified_obs_output_addr` directly to the HLS `output_words`
direct port. Older per-field output direct ports are no longer used in this
formal board image because adjacent 32-bit counters alias on a 64-bit HLS AXI
word boundary.

The current scripted flow can also run implementation and generate a bitstream.
Board programming remains a separate manual Windows JTAG step.

## PL DDR3 Buffer Layout

The first host bring-up layout reserves a fixed 1 GB PL DDR3 address space.
All high address registers stay zero to match the current 32-bit HLS direct
address contract.

| Buffer | Base | Notes |
| --- | ---: | --- |
| `SCAN_POINTS_BASE` | `0x00000000` | HLS `scan_points` |
| `POSE_BASE` | `0x01000000` | HLS `pose` |
| `MAP_HEADER_BASE` | `0x01001000` | HLS `map_header` |
| `ACTIVE_BLOCKS_BASE` | `0x02000000` | HLS `active_blocks` |
| `OBS_CELLS_BASE` | `0x10000000` | HLS `obs_cells` |
| `OUTPUT_BASE` | `0x30000000` | HLS `output_words` base, host ABI is 320-byte `SlamNormalEquation` |

The matching host-side constants live in
`fpga/host/xdma_smoke/ax7z100_plddr_layout.h` and
`fpga/host/xdma_smoke/address_map.py`.

## XDMA Host Smoke

The minimum host smoke path targets Orin/Linux as the PCIe root complex. The
default XDMA device nodes are:

- AXI-Lite/user BAR: `/dev/xdma0_user`
- H2C memory write: `/dev/xdma0_h2c_0`
- C2H memory read: `/dev/xdma0_c2h_0`

The first on-board smoke should read the XDMA BAR shim identity, then read
`slam_accel_ctrl.VERSION` at `0x1000`, write/read the
control register bank, then write/read a 4 KB memory pattern at each PL DDR3
buffer base. It does not require launching the accelerator as a hard gate.

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000 --ddr-smoke
python3 fpga/host/xdma_smoke/xdma_smoke.py --write-image fpga/vivado/.build/host_synthetic_tiny/manifest.json
```

Optional start smoke after bitstream bring-up:

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --ctrl-base 0x1000 --start-zero
```

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

## PCIe Lane Mapping

- The schematic path through `AX7Z035B_AX7Z100B_SCH.pdf` pages 2/13 and
  `AC7Z100B_SCH.pdf` pages 8/15 shows the slot PCIe x4 signals going into
  FPGA Bank112.
- `PCIE_CLK_P/N` maps to Bank112 `CLK0`, so the current `N8/N7` refclk
  constraint remains correct.
- The x4 lane order appears reversed between the PCIe slot and Bank112 lanes,
  so XDMA is configured with `enable_lane_reversal=true`.

## Reset Topology

- `pcie_rst_n` is the PCIe PERST# input from the Orin/root complex on `AB22`.
  It only drives XDMA `sys_rst_n`.
- MIG `sys_rst` is not driven by PCIe PERST#. It is held inactive high by
  `mig_rst_hi`, matching the current MIG `SysResetPolarity=ACTIVE LOW`
  configuration derived from the AX7Z100 references.
- MIG AXI-side reset still comes from `mig_7series_0/ui_clk_sync_rst` through
  `rst_mig_ui`.

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

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1

python fpga\host\xdma_smoke\validate_address_map.py --report reports\fpga\host\xdma_smoke\address_map_validation.md

python fpga\host\xdma_smoke\xdma_smoke.py --help

python fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_tiny --report-dir reports\fpga\host\xdma_smoke\tiny_synthetic
```

The Vivado flow also exports XDMA property reports for comparison with
`xdma_config_bar_diag`:

- `reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/ax7z100_pcie_mig_xdma_bd_properties*.txt`
- `reports/fpga/vivado/slam_accel_ax7z100_pcie_mig/ax7z100_pcie_mig_xdma_ip_properties*.txt`

## Windows JTAG Programming

Vivado HLS is not used to program the board. HLS only exports
`unified_surfel_observation_core` as an IP. The Windows script uses
`hw_server` + `xsdb` over JTAG for temporary FPGA programming:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

After programming, the first Orin-side gate is XDMA register and PL DDR3 memory
smoke, not full SLAM.

If `xdma_config_bar_diag` creates `/dev/xdma0_*` but this full image does not,
do not continue modifying the full design directly. Restore the board design in
layers: `xdma64 + diag_regs + BRAM`, then `xdma64 + slam_accel_ctrl + BRAM`,
then `xdma128 + slam_accel_ctrl + BRAM`, then add MIG, and only then add HLS.

The default generated project directories are:

- `fpga/vivado/.build/azmig_bd`
- `fpga/vivado/.build/azmig_syn`
- `fpga/vivado/.build/azmig_impl`

Vivado may temporarily see those paths through a short `subst` drive to avoid
Windows/Vivado 2018.3 path-length issues. The actual files remain under
`fpga/vivado/.build/`, which is ignored by git.
