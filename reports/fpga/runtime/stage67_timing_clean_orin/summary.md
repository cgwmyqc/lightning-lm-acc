# Stage67 Timing-Clean Orin Regression Summary

Date: 2026-07-19

## Result

Stage67 Orin result: PASS.

The Stage67 timing-clean bitstream preserved XDMA/BAR/MIG access and all three
hardware golden paths: localization observation V2, mapping observation V2,
and mapping EKF update `KERNEL_SEL=5` repeat stability.

## XDMA Gate

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
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

The x1 link remains a performance limitation, but it does not block Stage67
functional regression.

## Smoke

```text
SHIM_SMOKE_PASS
XDMA_SHIM_MAGIC=0x58444d41
XDMA_SHIM_VERSION=0x00010000
REG_SMOKE_PASS
VERSION=0x00020002
CTRL_BASE=0x00001000
KERNEL_SEL=4
DDR_SMOKE_PASS
```

DDR pattern smoke passed the observation buffers and the EKF update buffers:

```text
ekf_update_input  base=0x30010000
ekf_update_output base=0x30020000
```

## Golden Regressions

Localization observation V2:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
COUNTS=6050/911/2
HLS_WAIT_SEC=0.134540319
```

Mapping observation V2:

```text
MAPPING_XDMA_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
hls_wait_sec=0.0171922
max_abs=0.268571
max_rel=1.99295e-05
worst_field=H(3,3)
```

Mapping EKF update repeat:

```text
MAPPING_EKF_UPDATE_REPEAT_PASS repeat=50
iterations=50/50
RUN_COUNT monotonic=true
EKF hls_wait min=0.003391264
EKF hls_wait mean=0.00426241396
EKF hls_wait max=0.004391836
dx_max_abs=4.96565e-17
cov_max_abs=1.53144e-18
state_max_abs=4.94396e-17
```

## Kernel Log

No new `Failed to detect XDMA config BAR`, `CmpltTO`, AER fatal, offline, or
frozen errors were observed.

## Conclusion

Stage67 provides a timing-clean engineering bitstream that passes the existing
Orin golden regression gates. This clears the timing-risk blocker from
Stage66B. The next stage can plan an online `FPGA_FULL` smoke, but default YAML
should not enable `FPGA_FULL` until the online smoke and fallback behavior are
verified.
