# Stage 42 Residual Reject Probe

## Windows static validation

```powershell
python fpga\host\xdma_smoke\make_residual_probe_host_images.py --out-dir fpga\vivado\.build\host_residual_probe --report-dir reports\fpga\host\xdma_smoke\residual_probe
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_residual_probe_host_images.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

Expected marker:

```text
HOST_RESIDUAL_PROBE_IMAGES_PASS
```

## Orin gate

```bash
python3 fpga/host/xdma_smoke/make_residual_probe_host_images.py --out-dir fpga/vivado/.build/host_residual_probe --report-dir reports/fpga/host/xdma_smoke/residual_probe
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/valid_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_z_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_x_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/miss_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/invalid_flag_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

Expected counts:

| Case | Expected |
| --- | ---: |
| `valid_only` | `1/0/0` |
| `reject_z_only` | `0/1/0` |
| `reject_x_only` | `0/1/0` |
| `miss_only` | `0/0/1` |
| `invalid_flag_only` | `0/0/1` |

Each probe must print `HLS_MANIFEST_NUMERIC_PASS`.

## Interpretation

- Reject probes that become valid point to residual threshold or `normal/plane_d` field interpretation.
- `invalid_flag_only` becoming valid points to `ObsCellFloat64.flags` packing or offset.
- x/z reject differences point to `normal_x/y/z` field order or packing.
- All probes passing means Stage 41 fixture or expected recompute should be rechecked.

## Orin Result 2026-06-20

XDMA gate:

```text
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
config bar 1, user 0
```

Observed setup markers:

```text
HOST_RESIDUAL_PROBE_IMAGES_PASS
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

Probe results:

| Case | Result | Expected | Actual | Run count |
| --- | --- | ---: | ---: | --- |
| `valid_only` | PASS | `1/0/0` | `1/0/0` | `3 -> 4` |
| `reject_z_only` | FAIL | `0/1/0` | `1/0/0` | `4 -> 5` |
| `reject_x_only` | FAIL | `0/1/0` | `1/0/0` | `5 -> 6` |
| `miss_only` | PASS | `0/0/1` | `0/0/1` | `6 -> 7` |
| `invalid_flag_only` | PASS | `0/0/1` | `0/0/1` | `7 -> 8` |

All probes reached `HLS_MANIFEST_DONE_PASS` with:

```text
STATUS=0x00000204
ERROR=0x00000000
```

The two reject probes failed before `HLS_MANIFEST_NUMERIC_PASS`:

```text
reject_z_only RuntimeError: valid_count mismatch: actual=1 expected=0
reject_x_only RuntimeError: valid_count mismatch: actual=1 expected=0
```

Conclusion: Stage 42 isolates the remaining issue to residual reject counter/classification. The rejected samples are not accumulated into H/b, but they are counted as valid instead of reject.
