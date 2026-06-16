# unified_surfel_observation_core V1

This directory contains the portable C++/Vivado HLS CSim source for the shared mapping/localization surfel observation kernel.

## Scope

Implemented in V1:

- read body-frame scan points
- read pose guess
- read active `ObsCellFloat64` map buffer
- lookup exact/nearby surfel cell
- accumulate point-to-plane residual/Jacobian into `H_upper[21]` and `b[6]`
- output valid/reject/miss/residual statistics

Not implemented in V1:

- BatchUpdate
- DirtyRefit
- solve6x6
- AXI-Lite controller
- XDMA host runtime
- online guarded enable

## Files

- `../../abi/slam_accel_abi.h`: shared ABI used by Orin and HLS.
- `unified_surfel_observation_core.h/.cpp`: HLS top-level C++.
- `obs_tb.cpp`: CSim testbench that reads Orin-generated golden replay.

## Generate Golden On Orin/Linux

Build the ROS package first:

```bash
colcon build --packages-select lightning
```

Generate a localization replay frame:

```bash
./bin/build_surfel_loc_golden \
  --map_pcd ./data/example_active_map.pcd \
  --scan_pcd ./data/example_scan_body.pcd \
  --output_dir ./fpga/golden/localization/frame_000001 \
  --tx 0 --ty 0 --tz 0 --qx 0 --qy 0 --qz 0 --qw 1
```

Check the same replay with the Orin CPU implementation:

```bash
./bin/run_surfel_loc_golden_replay \
  --golden_dir ./fpga/golden/localization/frame_000001
```

## Run CSim On Windows Vivado HLS

1. Create a new Vivado HLS project.
2. Add `unified_surfel_observation_core.cpp` as the design source.
3. Add `obs_tb.cpp` as the testbench source.
4. Add the repository `fpga/abi` include path, or keep the relative path layout unchanged.
5. Set top function:

```text
lightning::fpga::hls::unified_surfel_observation_core
```

6. Copy or mount the generated golden directory.
7. Run C Simulation with the golden directory as argv:

```text
obs_tb.exe <repo>/fpga/golden/localization/frame_000001
```

Expected result:

```text
[obs_tb] PASS <golden_dir>
```

The first acceptance target is:

```text
H/b: abs <= 1e-4 or rel <= 1e-3
stats: valid_count/reject_count/miss_count exact match
```
