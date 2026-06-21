# Stage 48 Full frame_000001 Host Transaction

## Generate Manifest

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py \
  --golden-dir fpga/golden/localization/frame_000001 \
  --max-points 0 \
  --out-dir fpga/vivado/.build/host_golden_frame_000001_full \
  --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_full
```

Expected generation marker: `HOST_GOLDEN_IMAGE_PASS`.

## Base Gates

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

Expected base markers: `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`, `DDR_SMOKE_PASS`.

## Full Transaction

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_frame_000001_full/manifest.json \
  --ctrl-base 0x1000 \
  --hls-timeout-sec 120 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --dump-normal-equation \
  --save-output-json reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json
```

Acceptance:

- `HOST_IMAGE_READBACK_PASS`
- `SCAN_COUNT_READBACK=6963`
- `HLS_MANIFEST_DONE_PASS`
- `HLS_MANIFEST_NUMERIC_PASS`
- counts `6050/911/2`
- `STATUS.error=0` and `ERROR=0x00000000`

If the transaction times out at 120 seconds, rerun once with `--hls-timeout-sec 300` before changing HLS or Vivado.

## Orin Result 2026-06-21

XDMA/base gate:

```text
Kernel driver in use: xdma
/dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable=1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

Full transaction:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=6963
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT_BEFORE=13
RUN_COUNT_AFTER=14
ACTUAL_COUNTS=6050/911/2
OUTPUT_WORD[27]=0x0000038f000017a2
OUTPUT_WORD[28]=0x0000000000000002
WORST_FIELD=b[4] MAX_ABS=0.0078906 MAX_REL=3.3955e-05
```

Output JSON:

```text
reports/fpga/host/xdma_smoke/golden_frame_000001_full/full_frame_output.json
```

No 120 second timeout occurred, so the 300 second retry was not run.
