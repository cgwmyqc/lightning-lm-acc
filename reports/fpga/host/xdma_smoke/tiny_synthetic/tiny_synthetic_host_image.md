# Tiny Synthetic Host Image

- marker: `HOST_SYNTHETIC_IMAGE_PASS`
- generated_dir: `fpga\vivado\.build\host_synthetic_tiny`

| Segment | Base | Size |
| --- | ---: | ---: |
| `scan_points.bin` | `0x00000000` | 16 |
| `pose.bin` | `0x01000000` | 32 |
| `map_header.bin` | `0x01001000` | 64 |
| `active_blocks.bin` | `0x02000000` | 32 |
| `obs_cells.bin` | `0x10000000` | 16384 |
| `output_zero.bin` | `0x30000000` | 320 |

- expected_counts: 1/0/0
- expected_residual_sum: 0.049999999999999989
- expected_h_upper_entries: 21
- expected_b_entries: 6

## Orin command

```bash
python3 fpga/host/xdma_smoke/make_tiny_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_tiny --report-dir reports/fpga/host/xdma_smoke/tiny_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-tiny fpga/vivado/.build/host_synthetic_tiny/manifest.json --ctrl-base 0x1000
```

Expected markers: `HLS_TINY_START_PASS`, `HLS_TINY_DONE_PASS`, `HLS_TINY_NUMERIC_PASS`.
