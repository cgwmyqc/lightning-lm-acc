# Multi-cell Synthetic Host Image

- marker: `HOST_MULTICELL_SYNTHETIC_IMAGE_PASS`
- generated_dir: `fpga/vivado/.build/host_synthetic_multicell`
- purpose: nonzero block, nonzero `first_cell`, nonzero cell index, valid/reject/miss coverage

| Segment | Base | Size |
| --- | ---: | ---: |
| `scan_points.bin` | `0x00000000` | 48 |
| `pose.bin` | `0x01000000` | 32 |
| `map_header.bin` | `0x01001000` | 64 |
| `active_blocks.bin` | `0x02000000` | 64 |
| `obs_cells.bin` | `0x10000000` | 32768 |
| `output_zero.bin` | `0x30000000` | 320 |

- expected_counts: 1/1/1
- expected_residual_sum: 0.050000000000000044
- expected_residual_abs_sum: 0.050000000000000044
- expected_residual_max_abs: 0.050000000000000044

## Orin command

```bash
python3 fpga/host/xdma_smoke/make_multicell_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_multicell --report-dir reports/fpga/host/xdma_smoke/multicell_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_synthetic_multicell/manifest.json --ctrl-base 0x1000
```

Expected markers: `HLS_MANIFEST_START_PASS`, `HLS_MANIFEST_DONE_PASS`, `HLS_MANIFEST_NUMERIC_PASS`.

## Orin Result 2026-06-20

- XDMA gate: PASS.
- Host image generation: PASS, marker `HOST_MULTICELL_SYNTHETIC_IMAGE_PASS`.
- BAR shim/control register: PASS, markers `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`.
- DDR path: PASS, marker `DDR_SMOKE_PASS`.
- HLS start/done: PASS, markers `HLS_MANIFEST_START_PASS`, `HLS_MANIFEST_DONE_PASS`.
- Numeric compare: FAIL, `valid_count mismatch: actual=2 expected=1`.

Run status:

```text
STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT_AFTER=3
```

Expected vs actual:

```text
EXPECTED_COUNTS=1/1/1 FLAGS=0x00000000
ACTUAL_COUNTS=2/0/1 FLAGS=0x00000000
EXPECTED_RESIDUAL_SUM=0.050000000000000044
ACTUAL_RESIDUAL_SUM=0.04999995231628418
EXPECTED_RESIDUAL_ABS_SUM=0.050000000000000044
ACTUAL_RESIDUAL_ABS_SUM=0.04999995231628418
EXPECTED_RESIDUAL_MAX_ABS=0.050000000000000044
ACTUAL_RESIDUAL_MAX_ABS=0.04999995231628418
```

Stage 41 result: HLS transaction is alive and completes on multi-cell synthetic data, but `HLS_MANIFEST_NUMERIC_PASS` is blocked by residual reject handling.
