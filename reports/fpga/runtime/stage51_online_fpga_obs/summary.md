# Stage 51 Online FPGA_OBS Localization Summary

## Current Status

- `SurfelLocXdmaBackend` implemented.
- `fpga.localization.mode=fpga_obs` now invokes the C++ XDMA runtime instead of warning fallback.
- CPU still performs iteration, LDLT solve, pose update, and quality/fallback checks.
- Mapping observation is not connected in this stage; it remains a Stage 52 follow-up after mapping golden/replay.
- Default YAML behavior is unchanged because `fpga.enable=false`.

## Implementation

- Added `src/core/localization/surfel_loc/surfel_loc_xdma_backend.h`.
- Added `src/core/localization/surfel_loc/surfel_loc_xdma_backend.cc`.
- Updated `LidarLoc` backend selection for `SURFEL_FPGA_OBS`.
- Added FPGA device/runtime options under `lidar_loc` in all default YAML files:
  - `surfel_fpga_user_dev`
  - `surfel_fpga_h2c_dev`
  - `surfel_fpga_c2h_dev`
  - `surfel_fpga_ctrl_base`
  - `surfel_fpga_timeout_sec`
  - `surfel_fpga_verify_readback`

## Orin Verification

Build:

```text
colcon build --packages-select lightning
PASS
```

Stage 50 C++ golden regression:

```text
XDMA_CPP_GOLDEN_NUMERIC_PASS
scan_count=6963
COUNTS=6050/911/2
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=27->28
```

Default config startup check:

```text
backend=NDT_OMP
fpga_global_enable=0
fpga_localization_enable=0
```

Online/offline short bag smoke:

```text
backend=SURFEL_FPGA_OBS
surfel FPGA_OBS success=1 frames: 35
localization FPGA_OBS failure/fallback markers: 0
```

Aggregate over 35 successful FPGA_OBS localization frames:

```text
avg_valid=5866.14
avg_reject=733.94
avg_miss=2.17
avg_mean_abs_residual=0.061855
avg_xdma_elapsed_sum=4.395882
max_xdma_elapsed=1.483520
```

## Notes

- The first online version rewrites scan, pose, active map, and output buffers for every FPGA observation call. This keeps correctness simple and leaves active-map cache/performance work for a later stage.
- The smoke test used `sudo` because `/dev/xdma0_*` is root-owned on the current Orin image.
- The temporary smoke config was `/tmp/lightning_stage51_fpga_obs.yaml`; default repo configs still keep FPGA disabled.

## Next Step

Stage 52 should create mapping observation golden and host replay before connecting mapping `FPGA_OBS`. After that, the unified runtime can serve both localization and mapping paths.
