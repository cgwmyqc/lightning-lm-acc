# XDMA Config BAR Diagnostic Commands

## Windows Build

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Default bitstream:

```text
fpga/vivado/.build/xdma_diag_impl/xdma_diag.runs/impl_1/xdma_diag_wrapper.bit
```

Observed Windows result for the previous X1 diagnostic bitstream:

```text
XDMA_CONFIG_BAR_DIAG_BD_VALIDATE_PASS
VIVADO_RUN_JOBS=18
XDMA_CONFIG_BAR_DIAG_PROJECT_SYNTH_PASS
IMPL_1_STATUS=write_bitstream Complete!
XDMA_CONFIG_BAR_DIAG_IMPLEMENTATION_BITSTREAM_PASS
```

The X1 diagnostic bitstream JTAG programmed successfully, but Orin did not
enumerate the FPGA after reboot. The current diagnostic configuration is now X4
with lane reversal enabled.

Observed Windows result for the current X4 diagnostic bitstream:

```text
VIVADO_RUN_JOBS=18
SYNTH_1_STATUS=synth_design Complete!
IMPL_1_STATUS=write_bitstream Complete!
XDMA_CONFIG_BAR_DIAG_IMPLEMENTATION_BITSTREAM_PASS
BITSTREAM_SIZE_BYTES=3187655
```

## Windows JTAG

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\xdma_config_bar_diag\program_bitstream_jtag.ps1
```

This is temporary JTAG programming only. It is not Flash programming and is lost
after FPGA power-off.

Observed result:

```text
FPGA_STATE=FPGA is configured
DONE PIN: 1
JTAG_PROGRAM_PASS
```

Observed result for the current X4 diagnostic bitstream is also:

```text
FPGA_STATE=FPGA is configured
DONE PIN: 1
JTAG_PROGRAM_PASS
```

## Orin Retest

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
lspci -vvv -s 0005:01:00.0
lsmod | grep -i xdma
ls -l /dev/xdma*
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe'
```

Pass criteria:

```text
Kernel driver in use: xdma
/dev/xdma0_user exists
/dev/xdma0_h2c_0 exists
/dev/xdma0_c2h_0 exists
dmesg no longer reports "Failed to detect XDMA config BAR"
```

Observed Orin result after X4 lane-reversal diagnostic bitstream and reboot:

```text
0005:01:00.0 Serial controller: Xilinx Corporation Device 7024
/dev/xdma0_user
/dev/xdma0_control
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/dev/xdma0_xvc
/dev/xdma0_events_0..15
```

Diagnostic smoke command for this bitstream:

```bash
python3 fpga/host/xdma_smoke/xdma_diag_smoke.py --user-smoke --bram-smoke
```
