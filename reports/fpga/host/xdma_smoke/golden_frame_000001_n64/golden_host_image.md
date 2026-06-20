# Golden frame_000001 n64 Host Image

- marker: `HOST_GOLDEN_IMAGE_PASS`
- golden_dir: `fpga/golden/localization/frame_000001`
- generated_dir: `fpga/vivado/.build/host_golden_frame_000001_n64`
- full_scan_count: 6963
- scan_count: 64
- active_blocks: 3719
- obs_cells: 952064

| Segment | Base | Size |
| --- | ---: | ---: |
| `scan_points.bin` | `0x00000000` | 1024 |
| `pose.bin` | `0x01000000` | 32 |
| `map_header.bin` | `0x01001000` | 64 |
| `active_blocks.bin` | `0x02000000` | 119008 |
| `obs_cells.bin` | `0x10000000` | 60932096 |
| `output_zero.bin` | `0x30000000` | 320 |

- expected_counts: 14/33/17
- expected_residual_sum: 0.87436966027431406
- expected_h_upper_entries: 21
- expected_b_entries: 6

## Orin command

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000
```

Expected markers: `HLS_MANIFEST_START_PASS`, `HLS_MANIFEST_DONE_PASS`, `HLS_MANIFEST_NUMERIC_PASS`.

## Orin Result 2026-06-20

- XDMA gate: PASS.
- Host image generation: PASS, marker `HOST_GOLDEN_IMAGE_PASS`.
- BAR shim/control register: PASS, markers `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`.
- DDR path: PASS, marker `DDR_SMOKE_PASS`.
- HLS start/done: PASS, markers `HLS_MANIFEST_START_PASS`, `HLS_MANIFEST_DONE_PASS`.
- Numeric compare: FAIL, `valid_count mismatch: actual=64 expected=14`.

Run status:

```text
STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT_AFTER=2
```

Expected vs actual:

```text
EXPECTED_COUNTS=14/33/17 FLAGS=0x00000000
ACTUAL_COUNTS=64/0/0 FLAGS=0x00000000
EXPECTED_RESIDUAL_SUM=0.87436966027431406
ACTUAL_RESIDUAL_SUM=0.44294171614182876
EXPECTED_RESIDUAL_ABS_SUM=1.3874737319668577
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
EXPECTED_RESIDUAL_MAX_ABS=0.29527878422266252
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
```

Stage 40 result: HLS transaction is alive and completes on real golden n64 data, but `HLS_MANIFEST_NUMERIC_PASS` is blocked by counts/H-b mismatch.
