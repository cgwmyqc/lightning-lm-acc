# Stage 49 Full frame_000001 Repeated Stability Gate

## Base Gates

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

Expected base markers: `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`, `DDR_SMOKE_PASS`.

## 10-Iteration Full Frame Stability

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_frame_000001_full/manifest.json \
  --ctrl-base 0x1000 \
  --hls-timeout-sec 120 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --hls-repeat 10 \
  --repeat-output-dir reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability
```

The first iteration writes and optionally reads back the full manifest image.
Iterations 2..10 rewrite only `output_zero.bin`, then restart the accelerator.

## Kernel Log Check

```bash
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 160
```

## Acceptance

- `HLS_REPEAT_ITER_PASS i/10` for every iteration.
- `HLS_REPEAT_STABILITY_PASS`.
- Every iteration reports `HLS_MANIFEST_NUMERIC_PASS`.
- Every iteration reports counts `6050/911/2`.
- `RUN_COUNT` increases on every iteration.
- No new `Failed to detect XDMA config BAR`, `CmpltTO`, AER fatal, or XDMA offline log.

## Failure Branch

- Timeout: keep the per-iteration JSON and rerun `--hls-repeat 3 --hls-timeout-sec 300`.
- Numeric mismatch: compare the failing `full_frame_output_iter_XX.json` with the Stage 48 PASS JSON.
- AER/CmpltTO: stop runtime integration and debug PCIe link stability first.
