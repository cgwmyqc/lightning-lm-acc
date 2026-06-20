# AX7Z100 PCIe/XDMA + PL DDR3/MIG Board Skeleton

## Status

- Board profile static validation: PASS
- Fresh Vivado BD creation/validation: PASS
- HDL wrapper generation: PASS
- Project-managed synthesis: PASS
- Implementation: PASS
- Bitstream generation: PASS
- Windows JTAG programming script: uses `hw_server` + `xsdb`, because this Vivado 2018.3 batch install does not expose FPGA programming commands
- Windows JTAG temporary programming: PASS
- PCIe PERST#/MIG reset topology review: PASS
- PCIe lane reversal schematic review and bring-up bitstream: PASS
- Orin PCIe enumeration: PASS, observed `0005:01:00.0 Serial controller: Xilinx Device 7024`
- XDMA Linux driver/device nodes: pending, `/dev/xdma*` not yet present on Orin

## Integrated Blocks

- `xdma_0`: Vivado XDMA 4.1, Gen2 x4, 128-bit AXI, 125 MHz AXI target
- `xdma_0`: lane reversal enabled for AX7Z100 carrier/core-board x4 lane order
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
- PCIe `pcie_rst_n` / PERST# only drives XDMA `sys_rst_n`.
- MIG `sys_rst` is held inactive high by `mig_rst_hi`; it is no longer driven
  by PCIe PERST#.

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
- Bitstream size: 7,638,099 bytes
- Bitgen flow: `0 Errors`, `1 Critical Warning`
- Top-level external HLS `m_axi_gmem0..4`: none
- Lane reversal generated-IP check: PASS, generated XDMA XCI has
  `PARAM_VALUE.enable_lane_reversal=true`

## Resource Summary

- Slice LUTs: 55,269 / 277,400 (19.92%)
- Slice Registers: 61,162 / 554,800 (11.02%)
- Block RAM Tile: 52.5 / 755 (6.95%)
- DSPs: 256 / 2,020 (12.67%)
- Bonded IOB: 74 / 362 (20.44%)
- BUFGCTRL: 10 / 32 (31.25%)
- MMCME2_ADV: 3 / 8 (37.50%)

## Post-Implementation Timing

- WNS: -0.234 ns
- TNS: -3.143 ns
- Setup failing endpoints: 193
- WHS: 0.038 ns
- THS: 0.000 ns
- Hold failing endpoints: 0

Timing constraints are not met. This bitstream is acceptable for PCIe
enumeration/reset experiments, but it is not a reliable functional-validation
bitstream until timing is closed.

## DRC Summary

- Post-bitgen log: DRC finished with `0 Errors`, `513 Warnings`, `312 Advisories`.
- The one critical warning in the bitstream flow is the timing failure:
  `Timing 38-282`.
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
- Board-level Vivado synthesis/implementation/bitstream scripts default to
  `-jobs 18`; pass `-Jobs N` only when machine resources require a lower value.

## Next Step

The lane-reversal bitstream has enumerated on Orin as `10ee:7024`. The next
step is XDMA Linux driver bring-up on Orin: confirm BAR allocation with
`lspci -vvv`, load or build the Xilinx XDMA driver, and get
`/dev/xdma0_user`, `/dev/xdma0_h2c_0`, and `/dev/xdma0_c2h_0` created before
running `xdma_smoke.py --reg-smoke --ddr-smoke`. Do not run full online SLAM as
the first board test.
