# Current Status

## Branch

- Current branch: `dev-fpga`

## Interface

- Interface version: 1
- `FpgaCorrInput`: 32 bytes, 32-byte aligned
- `FpgaStateInput`: 64-byte aligned
- `FpgaNormalEqOutput`: 64-byte aligned
- `GoldenHeader`: 64-byte aligned

## Current Surfel Parameters

`config/default_livox.yaml` currently uses:

```yaml
surfel_min_support: 3
surfel_cell_resolution: 0.8
surfel_lookup_nearby_type: 26
surfel_quality_max: 0.05
```

## Orin Side

- [x] `NormalEquationBackend`
- [x] `CpuNormalEquationBackend`
- [x] `FpgaNormalEquationBackend` compile-only stub
- [x] Golden dump writer
- [x] `cpu` mode preserves legacy CPU path
- [x] `cpu_sim` mode routes surfel-hit points through backend
- [ ] XDMA wrapper
- [ ] Real FPGA backend
- [ ] `normal_eq_replay` host tool
- [x] `colcon build --symlink-install` passed

## Windows HLS Side

- [ ] `normal_eq_accel.cpp`
- [ ] `testbench.cpp`
- [ ] `run_csim.tcl`
- [ ] `run_csynth.tcl`
- [ ] `export_ip.tcl`
- [ ] C simulation passed
- [ ] C synthesis passed

## Latest Golden Files

- TBD after running Orin with `fpga.mode: cpu_sim` and `fpga.golden_dump_enable: true`.

## Notes

- Phase 1 does not move surfel lookup, iVox fallback, ESKF solve, or map update to FPGA.
- Golden files contain surfel-hit effective points only; fallback CPU contributions are not included.
