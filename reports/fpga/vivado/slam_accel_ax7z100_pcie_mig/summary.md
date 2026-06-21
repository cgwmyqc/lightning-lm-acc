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
- Full `azmig_wrapper.bit` regenerated with BAR shim and real HLS IP restored:
  PASS
- Full `azmig_wrapper.bit` JTAG programming after HLS restore: PASS
- PCIe PERST#/MIG reset topology review: PASS
- PCIe lane reversal schematic review and bring-up bitstream: PASS
- Orin PCIe enumeration: PASS, observed `0005:01:00.0 Serial controller: Xilinx Device 7024`
- XDMA Linux driver/device nodes with the HLS-restored full
  `azmig_wrapper.bit`: PASS on Orin
- Stage C2 before HLS restore: PASS on Orin with `/dev/xdma0_*`,
  `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`, and `DDR_SMOKE_PASS`
- XDMA Linux driver/device nodes with the X4 XDMA-only diagnostic bitstream:
  PASS, Orin observed `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, and
  `/dev/xdma0_c2h_0`

## Integrated Blocks

- `xdma_0`: Vivado XDMA 4.1, Gen2 x4, 128-bit AXI, 125 MHz AXI target
- `xdma_0`: lane reversal enabled for AX7Z100 carrier/core-board x4 lane order
- `xdma_0`: manual MSI-X BAR indicator overrides remain removed.
- `bar_shim_ctrl`: BAR0 offset `0x0000` provides XDMA-compatible
  identity/scratch registers; `slam_accel_ctrl` is mapped at BAR0
  offset `0x1000`.
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
- XDMA `M_AXI_LITE` maps BAR shim identity/scratch registers at BAR offset
  `0x0000_0000`.
- XDMA `M_AXI_LITE` maps `slam_accel_ctrl` at BAR offset `0x0000_1000`.
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
- Bitstream size: 7,792,811 bytes
- HLS IP export default path: `fpga/vivado/.build/hls_unified_obs`
- HLS IP export uses temporary short-drive mapping to avoid Vivado 2018.3
  Windows path-length failures
- Bitgen flow: `0 Errors`, `0 Critical Warnings`
- Top-level external HLS `m_axi_gmem0..4`: none
- Lane reversal generated-IP check: PASS, generated XDMA XCI has
  `PARAM_VALUE.enable_lane_reversal=true`

## Resource Summary

- Slice LUTs: 55,471 / 277,400 (20.00%)
- Slice Registers: 61,336 / 554,800 (11.06%)
- Block RAM Tile: 52.5 / 755 (6.95%)
- DSPs: 256 / 2,020 (12.67%)
- Bonded IOB: 74 / 362 (20.44%)
- BUFGCTRL: 10 / 32 (31.25%)
- MMCME2_ADV: 3 / 8 (37.50%)

## Post-Implementation Timing

- WNS: 0.108 ns
- TNS: 0.000 ns
- Setup failing endpoints: 0
- WHS: 0.018 ns
- THS: 0.000 ns
- Hold failing endpoints: 0

Timing constraints are met for the HLS-restored `azmig_wrapper.bit`.

## DRC Summary

- Post-bitgen log: DRC finished with `0 Errors`, `826 Warnings/Advisories`
  and no critical warnings.
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

The full HLS-restored `azmig_wrapper.bit` has been generated, programmed over
Windows JTAG, and passed the Orin gate:

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta|Region'
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

Observed Orin result:

- PCIe enumeration: PASS, `0005:01:00.0 [10ee:7024]`.
- XDMA driver bind: PASS, `Kernel driver in use: xdma`.
- Device nodes: PASS, `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, and
  `/dev/xdma0_c2h_0` exist.
- XDMA probe: PASS, `config bar 1, user 0`.
- Shim smoke: PASS, `SHIM_SMOKE_PASS`.
- Register smoke: PASS, `REG_SMOKE_PASS`, `VERSION=0x00020002`,
  `CTRL_BASE=0x00001000`.
- DDR smoke: PASS for `scan_points`, `pose`, `map_header`, `active_blocks`,
  `obs_cells`, and `output` 4KB pattern write/read.
- No new `Failed to detect XDMA config BAR` or `CmpltTO` was observed.
- Link risk remains: PCIe negotiated Gen2 x1, while the endpoint/root path is
  capable of Gen2 x4.

Next step: move to the HLS tiny synthetic host transaction. Do not run full
online SLAM as the first HLS board test.

## Stage 44 Output Words Fix 2026-06-21

Formal board image regenerated with the Stage 44 HLS IP. The BD now connects `ctrl_0/unified_obs_output_addr` to `unified_obs_0/output_words`; old per-field output direct ports are not connected.

Commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Results:

- BD validate: PASS.
- Project synthesis: PASS.
- Implementation/bitstream: PASS.
- Bitstream: `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`.
- Timing: WNS `-0.132 ns`, WHS `0.045 ns`; use as function-validation bitstream only.
- Route status: 0 routing errors.
- DRC: 0 errors; warnings/advisories remain.

Next Orin gate: JTAG program the new bitstream, reboot Orin, run shim/reg, DDR, Stage 42 residual probes, then Stage 41 multi-cell and Stage 40 n64 golden if probes pass.

Stage 44 JTAG result 2026-06-21:

```text
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
```

The programmed image is `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`. Next action is Orin reboot and the Stage 44 residual probe gate.
