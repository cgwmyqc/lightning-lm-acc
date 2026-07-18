# Stage65C EKF Update XDMA Golden Summary

Status: Windows-side runtime support implemented; Orin golden run pending.

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

Note: this path includes Linux XDMA device access, so final compile/runtime
validation is the Orin `colcon build` and Stage65C golden command.

Risk:

- Stage65B bitstream is still not timing closed. Stage65C is a short functional
  smoke only, not an online `FPGA_FULL` enable gate.
