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
