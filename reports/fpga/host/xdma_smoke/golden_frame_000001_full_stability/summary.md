# Stage 49 Full Frame Stability Summary

## Current Status

- Windows-side host tool update: prepared.
- Vivado/HLS/bitstream changes: none.
- Orin execution: PASS on 2026-06-21.

## Expected Input

- Manifest: `fpga/vivado/.build/host_golden_frame_000001_full/manifest.json`
- Scan count: `6963`
- Expected counts: `6050/911/2`
- Control base: `0x1000`

## Expected Output

- `HLS_REPEAT_ITER_PASS i/10` for all 10 iterations.
- `HLS_REPEAT_STABILITY_PASS`.
- Per-iteration JSON files:
  - `full_frame_output_iter_01.json`
  - ...
  - `full_frame_output_iter_10.json`

## Notes

Stage 49 reuses the Stage 44 `azmig_wrapper.bit`. The first iteration writes the
full manifest image; later iterations rewrite only `output_zero.bin` before
starting HLS again.

## Orin Result 2026-06-21

- marker: `HLS_REPEAT_STABILITY_PASS`
- iterations: 10/10
- scan_count: 6963
- counts: 6050/911/2 for every iteration
- status: `0x00000204` for every iteration
- error: `0x00000000` for every iteration
- run_count: `14 -> 24`
- max_elapsed_sec: 1.527302
- worst_field: `b[4]`
- max_abs: 0.0078906
- max_rel: 3.3955e-05
- output_word_27: `0x0000038f000017a2`
- output_word_28: `0x0000000000000002`

Per-iteration JSON files were generated as:

```text
full_frame_output_iter_01.json
full_frame_output_iter_02.json
full_frame_output_iter_03.json
full_frame_output_iter_04.json
full_frame_output_iter_05.json
full_frame_output_iter_06.json
full_frame_output_iter_07.json
full_frame_output_iter_08.json
full_frame_output_iter_09.json
full_frame_output_iter_10.json
```

Kernel log check found no new XDMA config BAR failure, `CmpltTO`, AER fatal, or XDMA offline entry.
