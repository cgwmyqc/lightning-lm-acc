# AX7Z100 PCIe/XDMA + PL DDR3/MIG Board Skeleton

## Status

- Board profile static validation: PASS
- Fresh Vivado BD creation/validation: PASS
- HDL wrapper generation: PASS
- Project-managed synthesis: PASS
- Implementation, bitstream, host runtime, and board test: not run in this stage

## Integrated Blocks

- `xdma_0`: Vivado XDMA 4.1, Gen2 x4, 128-bit AXI, 125 MHz AXI target
- `mig_7series_0`: PL DDR3 MIG 7-series AXI interface
- `unified_obs_0`: true HLS IP `unified_surfel_observation_core`
- `ctrl_0`: `slam_accel_ctrl` through an AXI-Lite BD wrapper
- `mem_axi_ic`: 6-input / 1-output AXI interconnect

## Clocking

- Orin/root-complex 100 MHz feeds PCIe `pcie_ref` on `N8/N7` and XDMA `sys_clk`.
- AX7Z100 board 200 MHz feeds MIG `SYS_CLK` on `F9/E8`.
- `xdma_0/axi_aclk` clocks XDMA master, AXI-Lite control, `slam_accel_ctrl`, and HLS `ap_clk`.
- `mig_7series_0/ui_clk` clocks MIG S_AXI.
- AXI interconnect performs the HLS/XDMA to MIG clock/data-width crossing.

## Addressing

- XDMA `M_AXI` and HLS `m_axi_gmem0..4` all target PL DDR3 range `0x0000_0000` to `0x3fff_ffff`.
- XDMA `M_AXI_LITE` maps `slam_accel_ctrl` at BAR offset `0x0000_0000`, range `0x0001_0000`.
- HLS direct scalar address registers remain 32-bit; controller still rejects nonzero `*_ADDR_HI`.

## Validation Results

- `BOARD_PROFILE_PASS`
- `BD_VALIDATE_PASS`
- `SYNTH_1_STATUS=synth_design Complete!`
- `PROJECT_SYNTH_PASS`
- Synthesis log: `0 errors`, `0 critical warnings`, `14 warnings`
- Top-level external HLS `m_axi_gmem0..4`: none

## Resource Summary

- Slice LUTs: 61,751 / 277,400 (22.26%)
- Slice Registers: 69,374 / 554,800 (12.50%)
- Block RAM Tile: 64.5 / 755 (8.54%)
- DSPs: 256 / 2,020 (12.67%)
- Bonded IOB: 74 / 362 (20.44%)
- BUFGCTRL: 11 / 32 (34.38%)
- MMCME2_ADV: 3 / 8 (37.50%)

## Timing Snapshot

This is a synthesized/open-run timing snapshot only. Timing closure is not a
goal of this stage.

- WNS: -0.366 ns
- TNS: -4.014 ns
- Setup failing endpoints: 11
- WHS: -0.643 ns
- THS: -501.516 ns
- Hold failing endpoints: 19,045

The negative timing is recorded as the next board-level risk. It should be
handled during the implementation/timing-closure stage after the board-level
I/O, reset, clocking, and host path are fixed.

## Notes

- The Vivado-internal project/design name is shortened to `azmig` to avoid
  Vivado 2018.3 Windows 260-character MIG generated-path failures.
- `12_ddr3_pl/mig_a.prj` is used as the native PL DDR3 board-parameter
  reference.
- The AXI MIG XML is extracted from ALINX `33_PCIe_test` because directly
  modifying the native MIG `.prj` into AXI form caused Vivado 2018.3 MIG
  customization failure/crash.
- Generated Vivado projects remain under `fpga/vivado/.build/` and are not
  tracked by git.

## Next Step

Proceed to board-level address-map and host bring-up preparation: define the
host-visible buffer layout in PL DDR3, add a minimal XDMA host register/memory
smoke tool, and only then move to implementation/bitstream.

