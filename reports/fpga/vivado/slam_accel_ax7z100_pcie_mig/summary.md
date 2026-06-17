# AX7Z100 PCIe/XDMA + PL DDR3/MIG Board Skeleton

## Status

- Board profile static validation: PASS
- Fresh Vivado BD creation/validation: PASS
- HDL wrapper generation: PASS
- Project-managed synthesis: PASS
- Implementation: PASS
- Bitstream generation: PASS
- Windows JTAG programming script: prepared, not run
- Host runtime and board test: not run in this stage

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
- `IMPL_1_STATUS=write_bitstream Complete!`
- `IMPLEMENTATION_BITSTREAM_PASS`
- Bitstream: `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`
- Bitstream size: 7,738,631 bytes
- Bitgen: `0 Errors`, `0 Critical Warnings`
- Top-level external HLS `m_axi_gmem0..4`: none

## Resource Summary

- Slice LUTs: 55,295 / 277,400 (19.93%)
- Slice Registers: 61,162 / 554,800 (11.02%)
- Block RAM Tile: 52.5 / 755 (6.95%)
- DSPs: 256 / 2,020 (12.67%)
- Bonded IOB: 74 / 362 (20.44%)
- BUFGCTRL: 10 / 32 (31.25%)
- MMCME2_ADV: 3 / 8 (37.50%)

## Post-Implementation Timing

- WNS: 0.085 ns
- TNS: 0.000 ns
- Setup failing endpoints: 0
- WHS: 0.032 ns
- THS: 0.000 ns
- Hold failing endpoints: 0

All user specified timing constraints are met.

## DRC Summary

- Post-bitgen log: DRC finished with `0 Errors`, `513 Warnings`, `312 Advisories`.
- Reported warning classes include HLS DSP pipeline advisories/warnings
  (`DPIP`, `DPOP`, `AVAL`), one clock placer warning, one clock output buffering
  warning, RAMB async control warnings, one no-routable-load warning, and one
  PS7-required warning.
- These warnings did not block bitstream generation; board smoke is still
  required before functional claims.

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

Program the bitstream over Windows JTAG, then run the Orin XDMA smoke sequence:
device-node detection, `VERSION` read, AXI-Lite register write/read, and PL DDR3
4 KB pattern write/read. Do not run full online SLAM as the first board test.
