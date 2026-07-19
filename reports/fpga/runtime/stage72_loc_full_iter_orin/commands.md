# Stage72A Orin Commands

Date: 2026-07-19

## Build

```bash
colcon build --packages-select lightning
source install/setup.bash
```

## Source Golden Check

```bash
test -f fpga/golden/localization/frame_000001/loc_scan.bin
test -f fpga/golden/localization/frame_000001/loc_active_map.bin
test -f fpga/golden/localization/frame_000001/loc_pose.bin
test -f fpga/golden/localization/frame_000001/loc_expected_obs.bin
```

Result:

```text
SOURCE_LOCALIZATION_GOLDEN_PRESENT
```

## Generate Iterative Golden

```bash
ros2 run lightning build_surfel_loc_iterative_golden \
  --source_golden_dir fpga/golden/localization/frame_000001 \
  --output_dir fpga/golden/localization_iterative/frame_000001 \
  --max_iterations 4 \
  --residual_outlier_th 0.3 \
  --conv_translation 1e-4 \
  --conv_rotation 1e-4 \
  --min_valid_count 300
```

Markers:

```text
LOC_ITER_GOLDEN_BUILD_PASS
scan_count=6963 candidate_count=6963 candidate_valid=6961 candidate_miss=2
iterations_used=4 status=1 flags=0x1 counts=6124/837/2 score=2.25349 dx_norm=0.00349622
```

Full log:

```text
reports/fpga/runtime/stage72_loc_full_iter_orin/build_iterative_golden.log
```

## CPU Replay

```bash
ros2 run lightning run_surfel_loc_iterative_golden_replay \
  --golden_dir fpga/golden/localization_iterative/frame_000001
```

Markers:

```text
LOC_ITER_CPU_REPLAY_PASS
loc_iter_expected.bin parser roundtrip PASS
status_ok=1 values_ok=1 max_abs=0 max_rel=0
actual_counts=6124/837/2 expected_counts=6124/837/2
actual_iterations=4 expected_iterations=4
```

Full log:

```text
reports/fpga/runtime/stage72_loc_full_iter_orin/cpu_replay.log
```

## Not Run In Stage72A

```text
run_surfel_loc_iterative_xdma_golden
```

Reason: Stage72A only generates and validates the real Orin-side CPU golden.
Board replay waits for Windows/HLS real-golden PASS and BD/XDMA integration.
