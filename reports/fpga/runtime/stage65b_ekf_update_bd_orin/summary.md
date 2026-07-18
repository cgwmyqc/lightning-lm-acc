# Stage65B Orin EKF Update BD Smoke Summary

Date: 2026-07-18

## Result

Stage65B Orin result: PASS

The Stage65B bitstream still allows the Orin XDMA driver to bind, keeps BAR0
shim/control access working, and preserves the MIG/PL DDR path including the
new EKF update buffer ranges.

## XDMA Gate

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
Kernel modules: xdma
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
```

PCIe link:

```text
LnkCap: Speed 5GT/s, Width x4
LnkSta: Speed 5GT/s, Width x1 (downgraded)
```

The x1 link remains a performance limitation, but it does not block Stage65B
functional smoke.

## Smoke

```text
SHIM_SMOKE_PASS
XDMA_SHIM_MAGIC=0x58444d41
XDMA_SHIM_VERSION=0x00010000
REG_SMOKE_PASS
VERSION=0x00020002
CTRL_BASE=0x00001000
KERNEL_SEL=4
MODE=1
SCAN_COUNT=1
DDR_SMOKE_PASS
```

DDR pattern smoke passed these ranges:

```text
scan_points        base=0x00000000
pose               base=0x01000000
map_header         base=0x01001000
params             base=0x01002000
active_blocks      base=0x02000000
obs_cells          base=0x10000000
output             base=0x30000000
ekf_update_input   base=0x30010000
ekf_update_output  base=0x30020000
```

## Kernel Log

No new `Failed to detect XDMA config BAR`, `CmpltTO`, AER fatal, offline, or
frozen errors were observed in the Stage65B smoke window.

## Next

Proceed to Stage65C: implement/run the EKF update golden transaction using
`KERNEL_SEL=5`, writing Stage64 `update_input.bin` to
`EKF_UPDATE_INPUT_BASE=0x30010000` and comparing the output at
`EKF_UPDATE_OUTPUT_BASE=0x30020000` against `update_expected.bin`.
