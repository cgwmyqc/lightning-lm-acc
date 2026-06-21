# Stage 50 C++ XDMA Golden Replay Summary

## Current Status

- C++ XDMA runtime: implemented.
- C++ golden replay app: implemented.
- Build: PASS.
- Orin execution: PASS on 2026-06-21.

## Expected Input

- Golden dir: `fpga/golden/localization/frame_000001`
- Scan count: `6963`
- Expected counts: `6050/911/2`
- Control base: `0x1000`
- Repeat count: `3`

## Expected Output

- `XDMA_CPP_SHIM_SMOKE_PASS`
- `XDMA_CPP_REG_SMOKE_PASS`
- `XDMA_CPP_DDR_SMOKE_PASS`
- `XDMA_CPP_GOLDEN_NUMERIC_PASS` for all 3 iterations
- `XDMA_CPP_GOLDEN_REPEAT_PASS`
- Per-iteration JSON files:
  - `cpp_full_frame_output_iter_01.json`
  - `cpp_full_frame_output_iter_02.json`
  - `cpp_full_frame_output_iter_03.json`

## Notes

Stage 50 does not modify online localization behavior. It converts the validated
Python XDMA transaction into a C++ runtime and golden replay gate before Stage 51
connects `SURFEL_FPGA_OBS` to `LidarLoc`.

## Orin Result 2026-06-21

- build: `colcon build --packages-select lightning` PASS
- gate: `Kernel driver in use: xdma`, `/dev/xdma0_*` present, `enable=1`
- smoke: `XDMA_CPP_SHIM_SMOKE_PASS`, `XDMA_CPP_REG_SMOKE_PASS`, `XDMA_CPP_DDR_SMOKE_PASS`
- replay marker: `XDMA_CPP_GOLDEN_REPEAT_PASS`
- iterations: 3/3
- scan_count: 6963
- active_blocks: 3719
- active_cells: 952064
- counts: 6050/911/2 for every iteration
- status: `0x00000204` for every iteration
- error: `0x00000000` for every iteration
- run_count: `24 -> 27`
- max_elapsed_sec: 1.52723
- worst_field: `b(4)`
- max_abs: 0.0078906
- max_rel: 4.41926e-05
- output_word_27: `0x0000038f000017a2`
- output_word_28: `0x0000000000000002`

Per-iteration JSON files were generated as:

```text
cpp_full_frame_output_iter_01.json
cpp_full_frame_output_iter_02.json
cpp_full_frame_output_iter_03.json
```

Kernel log check found no new XDMA config BAR failure, `CmpltTO`, AER fatal, or XDMA offline entry.
