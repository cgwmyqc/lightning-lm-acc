# Stage65C EKF Update XDMA Golden Summary

Status: Orin golden run PASS on 2026-07-18.

Implemented:

- Added EKF update XDMA transaction support in `XdmaRuntime`.
- Added `run_mapping_ekf_update_xdma_golden`.
- Reuses Stage64 `update_input.bin` and `update_expected.bin`.
- Dispatches `slam_accel_ctrl` with `KERNEL_SEL=5`.
- Writes input to `EKF_UPDATE_INPUT_BASE=0x30010000`.
- Clears and reads output at `EKF_UPDATE_OUTPUT_BASE=0x30020000`.

Expected PASS markers:

```text
MAPPING_EKF_UPDATE_XDMA_START_PASS
MAPPING_EKF_UPDATE_XDMA_DONE_PASS
MAPPING_EKF_UPDATE_XDMA_NUMERIC_PASS
MAPPING_EKF_UPDATE_XDMA_PASS
```

Acceptance:

- `STATUS.error=0`, `ERROR=0`, and `RUN_COUNT` increments.
- `dx_current` and `updated_state` max abs <= `1e-9`.
- `updated_cov` max abs <= `1e-8`.
- No new XDMA config BAR failure, `CmpltTO`, AER fatal, or XDMA offline.

Windows validation:

```text
git diff --check: PASS
```

Orin validation:

```text
colcon build --packages-select lightning: PASS
XDMA gate: PASS
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
MAPPING_EKF_UPDATE_XDMA_START_PASS
MAPPING_EKF_UPDATE_XDMA_DONE_PASS
MAPPING_EKF_UPDATE_XDMA_NUMERIC_PASS
MAPPING_EKF_UPDATE_XDMA_PASS
```

EKF transaction:

```text
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=0->1
elapsed_sec=0.003196015
hls_wait_sec=0.003196015
flags_ok=1
dx_max_abs=4.96565e-17
cov_max_abs=1.53144e-18
state_max_abs=4.94396e-17
actual_nullity=0
expected_nullity=0
actual_success=1
expected_success=1
```

Kernel log:

```text
No new Failed to detect XDMA config BAR
No new CmpltTO
No new AER fatal, offline, or frozen errors
```

Risk:

- Stage65B bitstream is still not timing closed. Stage65C is a short functional
  smoke only, not an online `FPGA_FULL` enable gate.
