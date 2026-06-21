# Stage 52 Mapping Observation Golden/Replay Summary

## Current Status

- Config comments were updated in all `config/default*.yaml` files.
- Default behavior remains unchanged: `fpga.enable=false` keeps mapping/localization on CPU paths.
- Localization `fpga_obs` was completed in Stage 51.
- Mapping FPGA online path is still guarded: `LaserMapping::ObsModelFpgaObservation()` logs a warning and falls back to `ObsModelCpu()`.
- YAML parse check passed for all `config/default*.yaml`.
- Stage 52 implementation build passed:
  `colcon build --packages-select lightning`.
- Mapping source/golden generation passed for `frame_000001`.
- Mapping CPU replay passed.
- Mapping XDMA replay ran on Orin but failed numeric comparison; do not enable online `mapping.mode=fpga_obs` yet.

## Stage 52 Goal

Stage 52 prepares mapping for the unified observation runtime without changing online mapping behavior.

The required golden source must come from the mapping frontend, not from localization golden:

```text
LaserMapping::ObsModelCpu
  scan_down_body
  ESKF state pose used by ObsModel
  BlockSurfelMap active surfel cells
  CPU expected mapping observation
```

## Required Implementation Gates

1. Add a `BlockSurfelMap -> ActiveMapBuffer` export utility.
   - Preserve block/cell floor-div encoding.
   - Export 64B `ObsCellFloat64` cells compatible with `slam_accel_abi.h`.
   - Keep lookup settings aligned with `surfel_lookup_nearby_type`.

2. Add a mapping golden capture hook in `LaserMapping`.
   - Trigger inside `ObsModelCpu()` after surfel lookup/valid check.
   - Capture one valid frame only.
   - Save body-frame downsampled scan, pose, active surfel map buffer, and CPU expected observation.

3. Add a mapping golden builder/replay app.
   - Output directory:
     `fpga/golden/mapping/frame_000001`
   - Reuse the same 320B `SlamNormalEquation` ABI when possible.
   - If mapping expected output needs a different schema, document that before touching HLS.

4. Add Orin host replay.
   - Run against the current Stage 44/47/48/49/50 bitstream only after the mapping golden is deterministic.
   - Do not connect online `mapping.mode=fpga_obs` until replay passes.

## Config Switching Notes

Current safe settings:

```yaml
fpga:
  enable: false
```

Localization FPGA_OBS:

```yaml
fpga:
  enable: true
  localization:
    enable: true
    mode: fpga_obs
```

Mapping modes:

```yaml
fpga:
  enable: true
  mapping:
    enable: true
    mode: cpu_sim
```

`mapping.mode=fpga_obs`, `fpga_obs_update`, and `fpga_full` remain reserved until Stage 52/53 pass.

## Acceptance

- All default YAML files explain CPU/FPGA switching. PASS.
- `git diff --check` passes. PASS.
- `colcon build --packages-select lightning` passes. PASS.
- Stage 52 implementation must not change default CPU/NDT behavior.
- Mapping golden must be generated from `LaserMapping::ObsModelCpu`, not from localization source data. PASS.
- Mapping CPU host replay must pass before Stage 53 online mapping `FPGA_OBS`. PASS.
- Mapping XDMA replay must pass before Stage 53 online mapping `FPGA_OBS`. FAIL in current bitstream.

## Orin Results

Golden source:

```text
fpga/golden_src/mapping/frame_000001
frame_index=20
timestamp=1773380976.68870282
scan_points=782
active_blocks=73
active_cells=18688
effect_feat_surf=667
plane_icp_weight=300
surfel_only_expected_counts=611/0/171
```

Golden ABI:

```text
fpga/golden/mapping/frame_000001
map_scan.bin
map_pose.txt
map_active_map.bin
map_expected_obs.bin
map_meta.yaml
```

CPU replay:

```text
MAPPING_CPU_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
max_abs=0.0337705
max_rel=2.21971e-05
worst_field=b(3)
```

XDMA replay:

```text
MAPPING_XDMA_REPLAY_FAIL
STATUS=0x204
ERROR=0x0
RUN_COUNT=145->146
SCAN_COUNT_READBACK=782
counts actual=585/68/129 expected=611/0/171
max_abs=4.49101e+06
max_rel=1.01612
worst_field=H(3,3)
```

## Conclusion

Stage 52 proved the Orin-side mapping golden source, ABI builder, and CPU replay path. The current FPGA/HLS bitstream does not yet implement mapping observation semantics for the unified kernel: the hardware output contains localization-style residual rejects (`reject_count=68`) while mapping surfel-only golden expects no reject bucket (`611/0/171`).

Stage 53 should not connect online mapping `FPGA_OBS` yet. The next Windows/HLS task is to add or fix mapping-mode observation semantics in `unified_surfel_observation_core` and rerun this same `fpga/golden/mapping/frame_000001` XDMA replay until `MAPPING_XDMA_REPLAY_PASS`.
