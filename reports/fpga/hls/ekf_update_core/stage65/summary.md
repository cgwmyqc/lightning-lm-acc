# Stage 65 Mapping EKF Update HLS Plan

Status: planned after Stage64 CPU golden PASS.

Scope:

- Add a separate HLS IP, tentatively `slam_ekf_update_core`.
- Do not merge EKF update into `unified_surfel_observation_core`.
- First version only targets fixed-dimension lidar/surfel pose observation update.

Pipeline target:

```text
FPGA observation V2 -> FPGA EKF update -> CPU policy/fallback/remaining runtime glue
```

Fallback:

- If full 23D covariance update is too expensive for timing/resources, implement `solve/update dx` first and keep covariance update on CPU.
- In that case the mode is recorded as `FPGA_OBS_SOLVE_PARTIAL`, not `FPGA_FULL`.
