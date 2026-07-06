# Stage64 Mapping ESKF Update CPU Golden Summary

## Result

Stage64 CPU golden refactor: PASS.

The mapping lidar/surfel update math from `ESKF::Update()` is now available as a standalone CPU helper and is exercised by a golden replay app. The exported golden came from the real online `LaserMapping + ESKF::Update()` path.

## Key Evidence

```text
MAPPING_ESKF_UPDATE_GOLDEN_EXPORT_PASS
MAPPING_ESKF_UPDATE_CPU_REPLAY_PASS
dx_max_abs=0
cov_max_abs=0
state_max_abs=6.50049e-20
flags_ok=1
nullity=0
```

Golden files:

```text
fpga/golden/mapping_update/frame_000001/update_input.bin
fpga/golden/mapping_update/frame_000001/update_expected.bin
fpga/golden/mapping_update/frame_000001/update_meta.yaml
```

Observation regression remained valid:

```text
MAPPING_CPU_REPLAY_PASS counts 611/0/171
MAPPING_XDMA_REPLAY_PASS counts 611/0/171
```

## Boundary

- Stage64 is CPU-only for the EKF update.
- No FPGA bitstream change is required.
- No XDMA mapping update path is introduced in this stage.
- Stage65 may now start a separate mapping EKF update HLS core.
