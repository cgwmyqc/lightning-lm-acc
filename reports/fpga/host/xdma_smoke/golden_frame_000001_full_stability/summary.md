# Stage 49 Full Frame Stability Summary

## Current Status

- Windows-side host tool update: prepared.
- Vivado/HLS/bitstream changes: none.
- Orin execution: pending.

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
