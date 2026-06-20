# XDMA Restore Chain Stage A2 Summary

## Purpose

Stage A2 is the corrective gate after Stage A failed on Orin with PCIe
enumeration present but no `/dev/xdma0_*` device nodes.

Stage A2 keeps the Stage A XDMA settings and data target:

- Gen2 X4
- `enable_lane_reversal=true`
- `pf0_device_id=7024`
- `64_bit` XDMA AXI
- `250` MHz AXI target
- BRAM data target
- no MIG
- no HLS

The only intended functional change is the AXI-Lite BAR layout:

- `0x0000`: XDMA-compatible BAR shim
- `0x0000`: magic `0x58444d41`
- `0x0004`: shim version `0x00010000`
- `0x0008/0x000c`: scratch registers
- `0x1000`: `slam_accel_ctrl` register bank
- `0x1000 + 0x000`: `slam_accel_ctrl.VERSION = 0x00020002`

## Current Hypothesis

`xdma_config_bar_diag` and Stage A use the same relevant XDMA IP parameters, but
the passing diagnostic bitstream exposes an XDMA identity page at BAR0 offset
`0x0000`. Stage A exposes `slam_accel_ctrl.VERSION` at that address instead.

The current working assumption is that the Orin XDMA Linux driver probes BAR0
content before creating `/dev/xdma0_*`, and Stage A/full `azmig` failed because
the BAR0 first page no longer matched the driver-compatible identity.

## Windows Commands

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_bd_validate.ps1 -Stage A2
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_project_synth.ps1 -Stage A2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\run_vivado_impl_bitstream.ps1 -Stage A2 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_restore_chain\program_bitstream_jtag.ps1 -Stage A2
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
- `SHIM_SMOKE_PASS`
- `REG_SMOKE_PASS` with `CTRL_BASE=0x00001000`

## Windows Results

- BD validate: PASS, log contains `XDMA_RESTORE_STAGE_A2_BD_VALIDATE_PASS`.
- Project synthesis: PASS, log contains `XDMA_RESTORE_STAGE_A2_PROJECT_SYNTH_PASS`.
- Implementation + bitstream: PASS, log contains `XDMA_RESTORE_STAGE_A2_IMPLEMENTATION_BITSTREAM_PASS`.
- Bitstream:
  `fpga/vivado/.build/xdma_restore_stage_a2_impl/xdma_restore_stage_a2.runs/impl_1/xdma_restore_stage_a2_wrapper.bit`
- Bitstream size: 3,582,735 bytes.
- Post-implementation timing: PASS, WNS 0.269 ns, TNS 0.000 ns, WHS 0.045 ns, THS 0.000 ns.
- DRC: 0 errors, 0 critical warnings, 25 warnings. Warnings are the same class
  as the prior BRAM/XDMA diagnostic path: RAMB async-control checks, no
  routable loads, and PS7-required warning for the PL-only diagnostic design.

## Orin Results

- Driver bind: PASS.
- `lspci -nnk -s 0005:01:00.0` reports `Kernel driver in use: xdma`.
- `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, and `/dev/xdma0_c2h_0` exist.
- Kernel log reports `config bar 1, user 0` and successful `probe_one`.
- No new `Failed to detect XDMA config BAR` or `CmpltTO` was observed.
- BAR shim and control-register smoke: PASS.

```text
SHIM_SMOKE_PASS
XDMA_SHIM_MAGIC=0x58444d41 XDMA_SHIM_VERSION=0x00010000
REG_SMOKE_PASS
VERSION=0x00020002
CTRL_BASE=0x00001000
KERNEL_SEL=4 MODE=1 SCAN_COUNT=1
```

## Conclusion

Stage A2 proves the BAR identity/shim hypothesis. XDMA driver probe succeeds,
the device nodes are created, BAR0 offset `0x0000` exposes the shim identity,
and `slam_accel_ctrl` is reachable at BAR0 offset `0x1000`. The next stage can
keep the shim and restore `128_bit + 125 MHz`, then MIG, then HLS.
