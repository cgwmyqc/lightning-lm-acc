# Stage 45 Golden n64 Trace

- marker: `HOST_GOLDEN_TRACE_PASS`
- golden_dir: `fpga\golden\localization\frame_000001`
- generated_dir: `fpga\vivado\.build\host_golden_trace_n64`
- full_scan_count: 6963
- trace_scan_count: 64
- trace_counts: 14/33/17
- expected_counts: 14/33/17
- active_blocks: 3719
- obs_cells: 952064

## Selected real points

- valid: index=0, reason=inlier, center=(1,0,2)/96, residual=-0.16512951532430886
  manifest: `fpga\vivado\.build\host_golden_trace_n64\real_valid_point\manifest.json`
- reject: index=1, reason=residual_outlier, center=(0,0,2)/111, residual=0.3914022876054659
  manifest: `fpga\vivado\.build\host_golden_trace_n64\real_reject_point\manifest.json`
- miss: index=19, reason=lookup_miss, center=(0,1,3)/23, residual=None
  manifest: `fpga\vivado\.build\host_golden_trace_n64\real_miss_point\manifest.json`

## Orin commands

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_valid_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_reject_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_miss_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```
