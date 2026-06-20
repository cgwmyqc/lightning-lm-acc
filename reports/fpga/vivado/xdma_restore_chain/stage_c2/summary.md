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
