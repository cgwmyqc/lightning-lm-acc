# Stage 47 Python bounded golden floor_div fix

## Summary

Stage 46 showed that the board classified scan index `19` as valid by using
cell offset `459031`, block `(-1,1,3)`, cell `23`. This was not an HLS lookup
error. The Python bounded expected/trace code encoded the negative x coordinate
with the wrong block key.

The failing point:

```text
point_world.x=-0.7580843194753806
old Python encode: (0,1,3)/23
C++/HLS encode:   (-1,1,3)/23
```

## Change

`make_golden_mem_images.py` now implements `floor_div` using integer floor
division. This matches the C++/HLS behavior for the positive block dimensions
used by the ABI.

## Regenerated artifacts

```powershell
python fpga\host\xdma_smoke\make_golden_host_image.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_frame_000001_n64 --report-dir reports\fpga\host\xdma_smoke\golden_frame_000001_n64
python fpga\host\xdma_smoke\make_golden_trace_host_images.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_trace_n64 --report-dir reports\fpga\host\xdma_smoke\golden_trace_n64
```

Results:

```text
HOST_GOLDEN_IMAGE_PASS
HOST_GOLDEN_TRACE_PASS
expected_counts=52/12/0
trace_counts=52/12/0
```

scan index `19` is now:

```text
class=valid
reason=inlier
center=(-1,1,3)/23
cell_offset=459031
residual=-0.028110894923855767
```

## Orin next command

The current Stage 44 bitstream can be reused:

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```

Expected markers:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
COUNTS=52/12/0
```

## Next

After n64 passes on Orin, proceed to full `frame_000001` host transaction.
Full-frame expected should continue to use `loc_expected_obs.bin`.

## Orin result 2026-06-21

XDMA/base gate:

```text
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/sys/bus/pci/devices/0005:01:00.0/enable = 1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

Regenerated host artifacts:

```text
HOST_GOLDEN_IMAGE_PASS
expected_counts=52/12/0
HOST_GOLDEN_TRACE_PASS
trace_counts=52/12/0
expected_counts=52/12/0
```

n64 board transaction:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=12 -> 13
COUNTS=52/12/0
```

Raw count words:

```text
OUTPUT_WORD[27]=0x0000000c00000034
OUTPUT_WORD[28]=0x0000000000000000
```

Actual summary:

```text
ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
ACTUAL_B=[-0.70513185009762902,-0.42457526330019862,-0.079899540579997208,2.0415549834711988,-5.1626863669195044,2.7286869496388286]
```

Conclusion: Stage 47 n64 bounded golden passes on Orin. The next gate is full `frame_000001` host transaction using `loc_expected_obs.bin`.
