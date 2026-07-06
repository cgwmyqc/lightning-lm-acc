# Stage64 Mapping ESKF Update CPU Golden Commands

## Build

```bash
colcon build --packages-select lightning
```

Result:

```text
PASS
```

## Export Golden

```bash
source install/setup.bash
ros2 run lightning export_mapping_eskf_update_golden \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config config/default_livox.yaml \
  --frame_index 20 \
  --output_dir fpga/golden/mapping_update/frame_000001
```

Observed:

```text
MAPPING_ESKF_UPDATE_GOLDEN_EXPORT_PASS
frame_index=20
iteration_index=0
nullity=0
dx_norm=0.00471868
cov_finalized=1
```

## CPU Replay

```bash
source install/setup.bash
ros2 run lightning run_mapping_eskf_update_golden_replay \
  --golden_dir fpga/golden/mapping_update/frame_000001
```

Observed:

```text
MAPPING_ESKF_UPDATE_CPU_REPLAY_PASS
flags_ok=1
dx_max_abs=0
cov_max_abs=0
state_max_abs=6.50049e-20
actual_nullity=0
expected_nullity=0
actual_success=1
expected_success=1
```

## Observation Regression

```bash
source install/setup.bash
ros2 run lightning run_surfel_mapping_golden_replay \
  --golden_dir fpga/golden/mapping/frame_000001

ros2 run lightning run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates
```

Observed:

```text
MAPPING_CPU_REPLAY_PASS counts actual=611/0/171 expected=611/0/171
MAPPING_XDMA_REPLAY_PASS counts actual=611/0/171 expected=611/0/171
```
