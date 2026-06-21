# Stage 52 Mapping Golden/Replay Commands

## Config Comment Verification

```bash
rg -n "Quick switch guide|Localization FPGA observation|Mapping fpga_obs|surfel_fpga_user_dev" config/default*.yaml
```

Expected:

```text
All config/default*.yaml files contain the same FPGA switching comments.
```

Observed:

```text
PASS
```

## Build

```bash
colcon build --packages-select lightning
```

Expected:

```text
PASS
```

Observed:

```text
Summary: 1 package finished
```

## YAML Parse Check

```bash
python3 - <<'PY'
import glob, yaml
for path in sorted(glob.glob('config/default*.yaml')):
    with open(path, 'r', encoding='utf-8') as f:
        data = yaml.safe_load(f)
    fpga = data['fpga']
    loc = data['lidar_loc']
    print(path, 'fpga.enable=', fpga['enable'], 'mapping.mode=', fpga['mapping']['mode'],
          'localization.mode=', fpga['localization']['mode'], 'ctrl_base=', loc['surfel_fpga_ctrl_base'])
PY
```

Observed:

```text
config/default.yaml fpga.enable= False mapping.mode= cpu_sim localization.mode= cpu_sim ctrl_base= 4096
config/default_livox.yaml fpga.enable= False mapping.mode= cpu_sim localization.mode= cpu_sim ctrl_base= 4096
config/default_nclt.yaml fpga.enable= False mapping.mode= cpu_sim localization.mode= cpu_sim ctrl_base= 4096
config/default_robosense.yaml fpga.enable= False mapping.mode= cpu_sim localization.mode= cpu_sim ctrl_base= 4096
config/default_utbm.yaml fpga.enable= False mapping.mode= cpu_sim localization.mode= cpu_sim ctrl_base= 4096
config/default_vbr.yaml fpga.enable= False mapping.mode= cpu_sim localization.mode= cpu_sim ctrl_base= 4096
```

## Default Backend Check

```bash
source install/setup.bash
./install/lightning/lib/lightning/run_loc_offline \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config config/default_livox.yaml \
  --map_path /home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/
```

Expected startup marker:

```text
[LaserMapping] mapping_backend=CPU fpga_global_enable=0
[LidarLoc] backend=NDT_OMP fpga_global_enable=0
```

## Mapping Golden Export

```bash
source install/setup.bash
./install/lightning/lib/lightning/export_mapping_golden_frame \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config config/default_livox.yaml \
  --frame_index 20 \
  --output_dir fpga/golden_src/mapping/frame_000001
```

Observed:

```text
MAPPING_GOLDEN_EXPORT_PASS
frame_index=20
timestamp=1773380976.68870282
scan_points=782
active_blocks=73
active_cells=18688
effect_feat_surf=667
surfel_only_expected_counts=611/0/171
plane_icp_weight=300
```

Note: default `surfel_fallback_mode=ivox` means full `ObsModelCpu()` has iVox fallback plane terms. Stage 52 golden intentionally captures only surfel-map plane observation terms for the unified FPGA observation kernel.

## Mapping Golden Build

```bash
source install/setup.bash
./install/lightning/lib/lightning/build_surfel_mapping_golden \
  --source_dir fpga/golden_src/mapping/frame_000001 \
  --output_dir fpga/golden/mapping/frame_000001
```

Observed:

```text
MAPPING_GOLDEN_BUILD_PASS
scan_points=782
active_blocks=73
active_cells=18688
expected_counts=611/0/171
```

## CPU Replay

```bash
source install/setup.bash
./install/lightning/lib/lightning/run_surfel_mapping_golden_replay \
  --golden_dir fpga/golden/mapping/frame_000001
```

Observed:

```text
counts actual=611/0/171 expected=611/0/171 values_ok=1 max_abs=0.0337705 max_rel=2.21971e-05 worst_field=b(3)
MAPPING_CPU_REPLAY_PASS
```

## XDMA Replay

```bash
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120
```

Observed:

```text
STATUS=0x204
ERROR=0x0
RUN_COUNT=145->146
SCAN_COUNT_READBACK=782
counts actual=585/68/129 expected=611/0/171
values_ok=0
max_abs=4.49101e+06
max_rel=1.01612
worst_field=H(3,3)
MAPPING_XDMA_REPLAY_FAIL
```

Interpretation:

```text
Orin/XDMA transport is healthy, but the current HLS mapping mode is not numerically aligned with Stage 52 mapping golden.
The nonzero reject_count=68 strongly suggests the hardware path is still applying localization-style residual reject semantics instead of mapping surfel-only plane observation semantics.
```
