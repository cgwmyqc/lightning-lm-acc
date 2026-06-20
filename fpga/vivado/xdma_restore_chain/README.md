# XDMA Restore Chain

This directory contains staged AX7Z100 board-level diagnostic bitstreams for
isolating why the full `azmig_wrapper.bit` enumerates as `10ee:7024` on Orin
but the Linux XDMA driver fails with `Failed to detect XDMA config BAR`.

All stages keep:

- XDMA 4.1 Basic mode
- Gen2 X4
- `enable_lane_reversal=true`
- `pf0_device_id=7024`
- AXI-Lite master enabled
- No manual MSI-X BAR override
- JTAG-only temporary programming

## Stages

- Stage A: `64_bit` XDMA AXI, `250` MHz AXI target, `slam_accel_ctrl`, BRAM data target, no MIG/HLS.
- Stage A2: `64_bit` XDMA AXI, `250` MHz AXI target, XDMA BAR shim at `0x0000`,
  `slam_accel_ctrl` remapped to `0x1000`, BRAM data target, no MIG/HLS.
- Stage B: `128_bit` XDMA AXI, `125` MHz AXI target, `slam_accel_ctrl`, BRAM data target, no MIG/HLS.
- Stage B2: `128_bit` XDMA AXI, `125` MHz AXI target, XDMA BAR shim at `0x0000`,
  `slam_accel_ctrl` remapped to `0x1000`, BRAM data target, no MIG/HLS.
- Stage C: `128_bit` XDMA AXI, `125` MHz AXI target, `slam_accel_ctrl`, MIG-backed PL DDR3, no HLS.
- Stage C2: `128_bit` XDMA AXI, `125` MHz AXI target, XDMA BAR shim at `0x0000`,
  `slam_accel_ctrl` remapped to `0x1000`, MIG-backed PL DDR3, no HLS.

Stage A failed on Orin with PCIe enumeration present but no `/dev/xdma0_*`.
Because the XDMA IP settings match the passing `xdma_config_bar_diag` flow, the
current working assumption is that the Linux XDMA driver expects a compatible
identity page at BAR0 offset `0x0000`. Stage A2 has passed on Orin, so Stage
B2 is the next gate.

Stage C uses the ALINX-confirmed PL DDR3 parameters:

- 200 MHz differential PL DDR input clock on `F9/E8`
- `MT41K256M16XX-125`
- 32-bit physical DDR data width
- 256-bit MIG AXI data width
- XDMA memory address offset `0x00000000`

## Windows Commands

Run one stage at a time. Do not proceed to the next stage until Orin creates
`/dev/xdma0_user`, `/dev/xdma0_h2c_0`, and `/dev/xdma0_c2h_0`.

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage A2
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage A2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage A2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage A2
```

Replace `A2` with `B2` for the next run. Use `C2` only after B2 passes on
Orin. Keep old `B`/`C` only as direct-ctrl comparison images.

Generated Vivado projects and bitstreams stay under `fpga/vivado/.build/`.
Reports are copied to `reports/fpga/vivado/xdma_restore_chain/stage_*`.

## Orin Gate

After each JTAG download, reboot Orin for a reliable PCIe enumeration gate:

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0 | grep -Ei 'Region|LnkSta|LnkCap'
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 120
```

Passing criteria:

- `Kernel driver in use: xdma`
- `/dev/xdma0_user` exists
- `/dev/xdma0_h2c_0` exists
- `/dev/xdma0_c2h_0` exists
- No `Failed to detect XDMA config BAR`
- No new `CmpltTO`

After Stage A2/B2/C2 creates `/dev/xdma0_*`, verify both BAR sub-windows:

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
```

After C2 passes the BAR/register smoke, add DDR smoke:

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```
