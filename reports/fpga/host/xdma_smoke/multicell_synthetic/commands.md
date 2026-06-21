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

## Stage 43 Orin Retest 2026-06-20

Stage 41 multi-cell was not rerun because Stage 43 failed earlier at the Stage 42 residual probe gate:

```text
valid_only expected=1/0/0 actual=0/0/0 FAIL
reject_z_only expected=0/1/0 actual=1/0/0 FAIL
reject_x_only expected=0/1/0 actual=1/0/0 FAIL
```

Per the Stage 43 failure branch, do not rerun multi-cell until residual probe counters pass.

## Stage 43 Orin Reboot Retest 2026-06-20 23:34

Stage 41 multi-cell was not rerun after reboot because Stage 43 still failed at the Stage 42 residual probe gate:

```text
valid_only expected=1/0/0 actual=0/0/0 FAIL
reject_z_only expected=0/1/0 actual=1/0/0 FAIL
reject_x_only expected=0/1/0 actual=1/0/0 FAIL
```

## Stage 44 Orin Retest 2026-06-21 09:48

Stage 41 was rerun after all Stage 42 residual probes passed.

Command sequence:

```bash
python3 fpga/host/xdma_smoke/make_multicell_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_multicell --report-dir reports/fpga/host/xdma_smoke/multicell_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_synthetic_multicell/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

Observed markers:

```text
HOST_MULTICELL_SYNTHETIC_IMAGE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
```

Result:

```text
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=5 -> 6
ACTUAL_COUNTS=1/1/1 FLAGS=0x00000000
ACTUAL_RESIDUAL_SUM=0.04999995231628418
ACTUAL_RESIDUAL_ABS_SUM=0.04999995231628418
ACTUAL_RESIDUAL_MAX_ABS=0.04999995231628418
WORST_FIELD=b[4] MAX_ABS=5.36442e-07 MAX_REL=9.53674e-07
```

Normal equation dump:

```text
ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,1,2.25,-11.25,0,5.0625,-25.3125,0,126.5625,0,0]
ACTUAL_B=[0,0,0.04999995231628418,0.1124998927116394,-0.56249946355819702,0]
```

Conclusion: Stage 44 passes the multi-cell synthetic gate. The small fixture covers nonzero block, nonzero `first_cell`, nonzero cell index, valid/reject/miss classification, and H/b accumulation.
