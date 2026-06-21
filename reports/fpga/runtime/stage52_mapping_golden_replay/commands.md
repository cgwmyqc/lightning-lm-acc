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

## Future Mapping Golden Commands

These commands are placeholders for the Stage 52 code implementation. They should not be marked PASS until the capture/export/replay apps exist.

```bash
ros2 run lightning export_mapping_golden_frame \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config config/default_livox.yaml \
  --frame_index 20 \
  --output_dir fpga/golden_src/mapping/frame_000001
```

```bash
ros2 run lightning build_surfel_mapping_golden \
  --source_dir fpga/golden_src/mapping/frame_000001 \
  --output_dir fpga/golden/mapping/frame_000001
```

```bash
ros2 run lightning run_surfel_mapping_golden_replay \
  --golden_dir fpga/golden/mapping/frame_000001
```

Expected final marker after implementation:

```text
MAPPING_GOLDEN_REPLAY_PASS
```
