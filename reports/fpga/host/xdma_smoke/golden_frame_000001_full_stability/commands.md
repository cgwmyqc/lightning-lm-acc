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

## Orin Result 2026-06-21

Base gate:

```text
Kernel driver in use: xdma
/dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable=1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

Repeat result:

```text
HOST_IMAGE_WRITE_PASS
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=6963
HLS_REPEAT_ITER_PASS 1/10
HLS_REPEAT_ITER_PASS 2/10
HLS_REPEAT_ITER_PASS 3/10
HLS_REPEAT_ITER_PASS 4/10
HLS_REPEAT_ITER_PASS 5/10
HLS_REPEAT_ITER_PASS 6/10
HLS_REPEAT_ITER_PASS 7/10
HLS_REPEAT_ITER_PASS 8/10
HLS_REPEAT_ITER_PASS 9/10
HLS_REPEAT_ITER_PASS 10/10
HLS_REPEAT_STABILITY_PASS ITERATIONS=10 MAX_ELAPSED_SEC=1.527302 WORST_FIELD=b[4] MAX_ABS=0.0078906 MAX_REL=3.3955e-05
```

Per-iteration summary:

| Iter | Run Count | Counts | Status | Error |
| ---: | --- | --- | --- | --- |
| 1 | `14 -> 15` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 2 | `15 -> 16` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 3 | `16 -> 17` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 4 | `17 -> 18` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 5 | `18 -> 19` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 6 | `19 -> 20` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 7 | `20 -> 21` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 8 | `21 -> 22` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 9 | `22 -> 23` | `6050/911/2` | `0x00000204` | `0x00000000` |
| 10 | `23 -> 24` | `6050/911/2` | `0x00000204` | `0x00000000` |

Saved JSON files:

```text
reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability/full_frame_output_iter_01.json
...
reports/fpga/host/xdma_smoke/golden_frame_000001_full_stability/full_frame_output_iter_10.json
```

Kernel log check found no new `Failed to detect XDMA config BAR`, `CmpltTO`, AER fatal, or XDMA offline entry.
