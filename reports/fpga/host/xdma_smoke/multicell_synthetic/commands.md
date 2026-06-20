# Stage 41 Multi-cell Synthetic Host Transaction

## Windows static validation

```powershell
python fpga\host\xdma_smoke\make_multicell_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_multicell --report-dir reports\fpga\host\xdma_smoke\multicell_synthetic
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py fpga\host\xdma_smoke\make_multicell_synthetic_host_image.py fpga\host\xdma_smoke\make_golden_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

Observed:

```text
HOST_MULTICELL_SYNTHETIC_IMAGE_PASS
```

Expected counts: `1/1/1`.

## Orin gate

```bash
python3 fpga/host/xdma_smoke/make_multicell_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_multicell --report-dir reports/fpga/host/xdma_smoke/multicell_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_synthetic_multicell/manifest.json --ctrl-base 0x1000
```

Expected markers:

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
```

If this fails after `HLS_MANIFEST_DONE_PASS`, compare the printed `EXPECTED_*` and `ACTUAL_*` summaries. A counts mismatch here points to HLS active-block or obs-cell ABI/stride interpretation, independent of the large real golden dataset.

## Orin Result 2026-06-20

XDMA gate:

```text
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
config bar 1, user 0
```

Observed command markers:

```text
HOST_MULTICELL_SYNTHETIC_IMAGE_PASS
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
```

HLS completed without timeout:

```text
STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT_AFTER=3
```

Numeric comparison failed before `HLS_MANIFEST_NUMERIC_PASS`:

```text
RuntimeError: valid_count mismatch: actual=2 expected=1
```

Printed comparison:

```text
EXPECTED_COUNTS=1/1/1 FLAGS=0x00000000
EXPECTED_RESIDUAL_SUM=0.050000000000000044
EXPECTED_RESIDUAL_ABS_SUM=0.050000000000000044
EXPECTED_RESIDUAL_MAX_ABS=0.050000000000000044
ACTUAL_COUNTS=2/0/1 FLAGS=0x00000000
ACTUAL_RESIDUAL_SUM=0.04999995231628418
ACTUAL_RESIDUAL_ABS_SUM=0.04999995231628418
ACTUAL_RESIDUAL_MAX_ABS=0.04999995231628418
```

Conclusion: Stage 41 passes XDMA, BAR shim, control register, DDR, and HLS start/done gates, but fails the multi-cell numeric contract. The miss path matches, while the residual reject point is counted as valid.
