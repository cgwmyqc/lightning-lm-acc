# XDMA Restore Chain Stage B2 Summary

## Purpose

Stage B2 is the next gate after Stage A2 passed on Orin. It verifies whether
the target `128_bit` XDMA AXI width and `125` MHz AXI clock still allow the XDMA
driver to bind when the BAR shim is preserved.

Stage B2 includes:

- Gen2 X4
- `enable_lane_reversal=true`
- `pf0_device_id=7024`
- `128_bit` XDMA AXI
- `125` MHz AXI target
- XDMA BAR shim at `0x0000`
- `slam_accel_ctrl` at BAR offset `0x1000`
- BRAM data target
- no MIG
- no HLS

## Windows Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage B2
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage B2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage B2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage B2
```

## Orin Gate

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
```

## Acceptance

- `Kernel driver in use: xdma`
- `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, `/dev/xdma0_c2h_0` exist
- no `Failed to detect XDMA config BAR`
- no new `CmpltTO`
- `SHIM_SMOKE_PASS`
- `REG_SMOKE_PASS` with `CTRL_BASE=0x00001000`

## Windows Results

- BD validate: PASS (`XDMA_RESTORE_STAGE_B2_BD_VALIDATE_PASS`)
- Project synthesis: PASS (`XDMA_RESTORE_STAGE_B2_PROJECT_SYNTH_PASS`)
- Implementation + bitstream: PASS (`XDMA_RESTORE_STAGE_B2_IMPLEMENTATION_BITSTREAM_PASS`)
- Bitstream:
  `fpga/vivado/.build/xdma_restore_stage_b2_impl/xdma_restore_stage_b2.runs/impl_1/xdma_restore_stage_b2_wrapper.bit`
- Bitstream size: 3,632,963 bytes
- Post-implementation timing: PASS
  - WNS: 0.844 ns
  - TNS: 0.000 ns
  - WHS: 0.029 ns
  - THS: 0.000 ns
- DRC: 0 errors, 0 critical warnings, 24 warnings
  - Main warnings: BRAM async-control checks, no-routable-load diagnostics, and PL-only Zynq PS7-required warning.
- JTAG programming: not run automatically in this Windows pass; use `program_bitstream_jtag.ps1 -Stage B2` for the next Orin gate.

## Next Gate

Program Stage B2, reboot Orin, and run the Orin gate above. Only if Stage B2
passes should Stage C2 be generated and tested with MIG-backed PL DDR3.
