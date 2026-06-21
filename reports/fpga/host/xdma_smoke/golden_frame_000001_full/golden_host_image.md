# Golden frame_000001 full Host Image

- marker: `HOST_GOLDEN_IMAGE_PASS`
- golden_dir: `fpga/golden/localization/frame_000001`
- generated_dir: `fpga/vivado/.build/host_golden_frame_000001_full`
- full_scan_count: 6963
- scan_count: 6963
- max_points_arg: 0
- active_blocks: 3719
- obs_cells: 952064

| Segment | Base | Size |
| --- | ---: | ---: |
| `scan_points.bin` | `0x00000000` | 111408 |
| `pose.bin` | `0x01000000` | 32 |
| `map_header.bin` | `0x01001000` | 64 |
| `active_blocks.bin` | `0x02000000` | 119008 |
| `obs_cells.bin` | `0x10000000` | 60932096 |
| `output_zero.bin` | `0x30000000` | 320 |

- expected_counts: 6050/911/2
- expected_residual_sum: -40.188595298682046
- expected_h_upper_entries: 21
- expected_b_entries: 6

## Orin command

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 0 --out-dir fpga/vivado/.build/host_golden_frame_000001_full --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_full
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_full/manifest.json --ctrl-base 0x1000 --hls-timeout-sec 120 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation --save-output-json reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json
```

Expected markers: `HLS_MANIFEST_START_PASS`, `HLS_MANIFEST_DONE_PASS`, `HLS_MANIFEST_NUMERIC_PASS`.

## Orin Result 2026-06-21

- marker: `HLS_MANIFEST_NUMERIC_PASS`
- image_readback: `HOST_IMAGE_READBACK_PASS`
- scan_count_readback: 6963
- status: `0x00000204`
- error: `0x00000000`
- run_count: `13 -> 14`
- actual_counts: 6050/911/2
- output_json: `reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json`
- output_word_27: `0x0000038f000017a2`
- output_word_28: `0x0000000000000002`
- worst_field: `b[4]`
- max_abs: 0.0078906
- max_rel: 3.3955e-05
- residual_sum: -40.188062779666957
- residual_abs_sum: 387.50742023750286
- residual_max_abs: 0.29974957195769858

Actual `H_upper[21]`:

```text
[2611.000025499744,-227.78827856229509,-1428.7479823768633,3348.8489148738131,21131.171393323282,519.95120520570936,1381.3648654438468,206.75677700724265,-10869.373522831964,-1507.7965158880579,2196.4150093804028,2057.6351235310854,-1239.4414546169046,-13397.777979403778,-1841.0523989857595,173506.38350339397,19907.092147133149,5140.8521893909092,252582.97839991559,8544.2979336756653,117999.23303944069]
```

Actual `b[6]`:

```text
[21.198283641147064,72.355072504764735,-30.149875763031595,-675.16240540435683,-232.37616922834553,252.2960493636084]
```
