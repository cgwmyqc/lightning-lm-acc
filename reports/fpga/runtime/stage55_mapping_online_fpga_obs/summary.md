# Stage55 Mapping Online FPGA_OBS Summary

## Result

Stage55 implemented the online mapping FPGA observation path in `LaserMapping`.

Key behavior:

```text
mapping_backend=FPGA_OBS
LaserMapping::ObsModelFpgaObservation()
  -> export BlockSurfelMap active map
  -> XdmaRuntime::RunMappingObservation()
  -> convert SlamNormalEquation to ESKF HTH/HTr
  -> CPU EKF update remains unchanged
```

The online path only covers surfel plane observation. If `enable_icp_part=true`,
or if XDMA/HLS/active-map export fails, the code logs
`mapping FPGA_OBS failed -> CPU fallback` and falls back to `ObsModelCpu()` when
`fpga.mapping.fallback=cpu`.

## Configuration

All default config files now include a shared runtime block:

```yaml
fpga:
  runtime:
    user_dev: /dev/xdma0_user
    h2c_dev: /dev/xdma0_h2c_0
    c2h_dev: /dev/xdma0_c2h_0
    ctrl_base: 0x1000
    timeout_sec: 120.0
    verify_readback: false
```

Localization keeps the old `lidar_loc.surfel_fpga_*` keys as compatibility
defaults, but `fpga.runtime.*` takes priority.

## XDMA Arbitration

Stage55 also added process-local and cross-process XDMA observation locking.
This is required because localization and mapping share the same PL DDR layout
and control registers. Concurrent golden replay had previously corrupted the
mapping output; after adding the lock, concurrent localization/mapping replay
passes by serializing hardware transactions.

## Verification

Build:

```text
colcon build --packages-select lightning
PASS
```

Stage54 golden replay regression:

```text
localization XDMA replay PASS, counts 6050/911/2
mapping XDMA replay PASS, counts 611/0/171
```

Concurrent two-process replay after XDMA locking:

```text
localization XDMA replay PASS, RUN_COUNT=681->682, counts 6050/911/2
mapping XDMA replay PASS, RUN_COUNT=682->683, counts 611/0/171
```

Stage55 online mapping smoke is recorded in
`reports/fpga/runtime/stage56_mapping_online_smoke/summary.md`.

