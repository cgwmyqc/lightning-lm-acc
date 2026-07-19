# Stage66A EKF Update Stability Summary

Status: Orin-side repeat gate is ready, not yet run in this workspace.

Windows-side code update:

- `run_mapping_ekf_update_xdma_golden` now supports `--repeat N`.
- Each iteration writes `ekf_update_xdma_output_iter_XX.json` when `--output_dir` is set.
- Each iteration checks `STATUS/ERROR`, `RUN_COUNT`, and numeric parity with Stage64 expected.
- New markers:
  - `MAPPING_EKF_UPDATE_REPEAT_ITER_PASS i/N`
  - `MAPPING_EKF_UPDATE_REPEAT_PASS repeat=N`

Acceptance:

- 50/50 iterations numeric PASS.
- `RUN_COUNT` increases each iteration.
- `dx/state <= 1e-9`, `cov <= 1e-8`.
- No new XDMA config BAR failure, `CmpltTO`, AER fatal, offline, or frozen.

Next after PASS:

- Run combined sequence smoke: mapping observation V2 golden, then EKF update golden.
- Use timing-closed bitstream once Stage66B timing is actually closed.
