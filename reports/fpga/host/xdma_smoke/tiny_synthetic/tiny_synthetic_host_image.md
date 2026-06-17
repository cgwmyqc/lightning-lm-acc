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
