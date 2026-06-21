# Stage 52 Mapping Observation Golden/Replay Summary

## Current Status

- Config comments were updated in all `config/default*.yaml` files.
- Default behavior remains unchanged: `fpga.enable=false` keeps mapping/localization on CPU paths.
- Localization `fpga_obs` was completed in Stage 51.
- Mapping FPGA online path is still guarded: `LaserMapping::ObsModelFpgaObservation()` logs a warning and falls back to `ObsModelCpu()`.
- YAML parse check passed for all `config/default*.yaml`.
- Incremental build passed:
  `colcon build --packages-select lightning`.

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
- Mapping golden must be generated from `LaserMapping::ObsModelCpu`, not from localization source data.
- Mapping host replay must pass before Stage 53 online mapping `FPGA_OBS`.
