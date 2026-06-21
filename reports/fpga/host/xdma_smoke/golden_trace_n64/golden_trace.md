# Stage 45 Golden n64 Trace

- marker: `HOST_GOLDEN_TRACE_PASS`
- golden_dir: `fpga/golden/localization/frame_000001`
- generated_dir: `fpga/vivado/.build/host_golden_trace_n64`
- full_scan_count: 6963
- trace_scan_count: 64
- trace_counts: 14/33/17
- expected_counts: 14/33/17
- active_blocks: 3719
- obs_cells: 952064

## Selected real points

- valid: index=0, reason=inlier, center=(1,0,2)/96, residual=-0.16512951532430886
  manifest: `fpga/vivado/.build/host_golden_trace_n64/real_valid_point/manifest.json`
- reject: index=1, reason=residual_outlier, center=(0,0,2)/111, residual=0.3914022876054659
  manifest: `fpga/vivado/.build/host_golden_trace_n64/real_reject_point/manifest.json`
- miss: index=19, reason=lookup_miss, center=(0,1,3)/23, residual=None
  manifest: `fpga/vivado/.build/host_golden_trace_n64/real_miss_point/manifest.json`

## Orin commands

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_valid_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_reject_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_miss_point/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```

## Orin result 2026-06-21 10:19

Trace generation:

```text
HOST_GOLDEN_TRACE_PASS
trace_counts=14/33/17
expected_counts=14/33/17
```

All three single-point runs passed image readback and controller register readback:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=1
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
STATUS=0x00000204
ERROR=0x00000000
```

Single-point results:

| Case | Scan index | Expected | Actual | Result |
| --- | ---: | ---: | ---: | --- |
| `real_valid_point` | 0 | `1/0/0` | `1/0/0` | PASS |
| `real_reject_point` | 1 | `0/1/0` | `0/1/0` | PASS |
| `real_miss_point` | 19 | `0/0/1` | `1/0/0` | FAIL |

`real_valid_point` raw count words:

```text
OUTPUT_WORD[27]=0x0000000000000001
OUTPUT_WORD[28]=0x0000000000000000
ACTUAL_RESIDUAL_SUM=-0.16512951532430886
ACTUAL_RESIDUAL_ABS_SUM=0.16512951532430886
ACTUAL_RESIDUAL_MAX_ABS=0.16512951532430886
```

`real_reject_point` raw count words:

```text
OUTPUT_WORD[27]=0x0000000100000000
OUTPUT_WORD[28]=0x0000000000000000
ACTUAL_RESIDUAL_SUM=0
ACTUAL_RESIDUAL_ABS_SUM=0
ACTUAL_RESIDUAL_MAX_ABS=0
```

`real_miss_point` failed by becoming valid on board:

```text
EXPECTED_COUNTS=0/0/1
ACTUAL_COUNTS=1/0/0
OUTPUT_WORD[27]=0x0000000000000001
OUTPUT_WORD[28]=0x0000000000000000
ACTUAL_RESIDUAL_SUM=-0.028110894923855767
ACTUAL_RESIDUAL_ABS_SUM=0.028110894923855767
ACTUAL_RESIDUAL_MAX_ABS=0.028110894923855767
```

`real_miss_point` actual H/b:

```text
ACTUAL_H_UPPER=[0.019623200984142386,0.11275901918210707,0.080768408914622114,-0.44052758749668092,0.25704130905596101,-0.25182078962863075,0.64793692003590664,0.46411217912265457,-2.5313637020243016,1.477013149987962,-1.4470149529189622,0.33243994615716943,-1.813196142355004,1.0579730378626071,-1.036485562491281,9.8895463335706779,-5.7704035063859402,5.6532063767912417,3.3669448024608104,-3.29856201676558,3.231568088225365]
ACTUAL_B=[-0.0039378538876799242,-0.022627732469134739,-0.016208068872310272,0.08840215592022474,-0.051581345927115052,0.05053372669622435]
```

Conclusion: the real valid and real reject paths pass, but a CPU lookup miss at scan index `19`, center `(0,1,3)/23`, is classified as valid on the board. The next debug target is HLS real-map lookup/neighbor selection for this point.
