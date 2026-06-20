# XDMA Restore Chain Stage C2 Summary

## Purpose

Stage C2 is allowed only after Stage B2 passes on Orin. It verifies whether the
MIG-backed PL DDR3 data path can be added without breaking XDMA driver probe or
BAR/register access.

Stage C2 includes:

- Gen2 X4
- `enable_lane_reversal=true`
- `pf0_device_id=7024`
- `128_bit` XDMA AXI
- `125` MHz AXI target
- XDMA BAR shim at `0x0000`
- `slam_accel_ctrl` at BAR offset `0x1000`
- MIG-backed PL DDR3
- no HLS

## Windows Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage C2
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage C2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage C2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage C2
```

## Orin Gate

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

## Acceptance

- `Kernel driver in use: xdma`
- `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, `/dev/xdma0_c2h_0` exist
- no `Failed to detect XDMA config BAR`
- no new `CmpltTO`
- `SHIM_SMOKE_PASS`
- `REG_SMOKE_PASS` with `CTRL_BASE=0x00001000`
- `DDR_SMOKE_PASS`

## Windows Results

- BD validate: PASS (`XDMA_RESTORE_STAGE_C2_BD_VALIDATE_PASS`)
- Project synthesis: PASS (`XDMA_RESTORE_STAGE_C2_PROJECT_SYNTH_PASS`)
- Implementation + bitstream: PASS (`XDMA_RESTORE_STAGE_C2_IMPLEMENTATION_BITSTREAM_PASS`)
- JTAG programming: PASS (`JTAG_PROGRAM_PASS`)
- FPGA state after programming: `FPGA is configured`
- Bitstream:
  `fpga/vivado/.build/xdma_restore_stage_c2_impl/xdma_restore_stage_c2.runs/impl_1/xdma_restore_stage_c2_wrapper.bit`
- Bitstream size: 4,625,939 bytes
- Post-implementation timing: PASS
  - WNS: 0.183 ns
  - TNS: 0.000 ns
  - WHS: 0.030 ns
  - THS: 0.000 ns
- DRC: 0 errors, 0 critical warnings, 26 warnings
  - Main warnings: MIG clock placer/clock buffering warnings, BRAM async-control checks, no-routable-load diagnostics, and PL-only Zynq PS7-required warning.

## Current Status

C2 is programmed on FPGA through Windows JTAG and has passed Orin-side
enumeration, XDMA driver binding, shim/register smoke, and DDR smoke.

## Orin Results

- PCIe enumeration: PASS (`0005:01:00.0 [10ee:7024]`)
- XDMA driver bind: PASS (`Kernel driver in use: xdma`)
- Device nodes: PASS
  - `/dev/xdma0_user`
  - `/dev/xdma0_h2c_0`
  - `/dev/xdma0_c2h_0`
- XDMA probe: PASS
  - `config bar 1, pos 1`
  - `2 BARs: config 1, user 0, bypass -1`
  - `probe_one ... usr 16, ch 1,1`
- Shim smoke: PASS
  - `SHIM_SMOKE_PASS`
  - `XDMA_SHIM_MAGIC=0x58444d41`
  - `XDMA_SHIM_VERSION=0x00010000`
- Register smoke: PASS
  - `REG_SMOKE_PASS`
  - `VERSION=0x00020002`
  - `CTRL_BASE=0x00001000`
- DDR smoke: PASS
  - `scan_points` at `0x00000000`, 4KB pattern
  - `pose` at `0x01000000`, 4KB pattern
  - `map_header` at `0x01001000`, 4KB pattern
  - `active_blocks` at `0x02000000`, 4KB pattern
  - `obs_cells` at `0x10000000`, 4KB pattern
  - `output` at `0x30000000`, 4KB pattern
- No new `Failed to detect XDMA config BAR` or `CmpltTO` was observed.
- Risk: the link currently negotiates as Gen2 x1. Kernel log reports available
  bandwidth limited by `5.0 GT/s PCIe x1`, while the endpoint is capable of
  `5.0 GT/s PCIe x4`. This is a performance/link bring-up risk, not a blocker
  for the current functional gate.

## Next Step

Return to the formal `slam_accel_ax7z100_pcie_mig` / `azmig_wrapper.bit` flow,
restore the real HLS IP on top of the C2-proven XDMA + BAR shim + MIG path, and
keep `slam_accel_ctrl` at BAR0 offset `0x1000`.
