# Golden frame_000001 full Host Image

- marker: `HOST_GOLDEN_IMAGE_PASS`
- golden_dir: `fpga\golden\localization\frame_000001`
- generated_dir: `fpga\vivado\.build\host_golden_frame_000001_full`
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
