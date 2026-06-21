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
