# HLS Tiny Synthetic Host Transaction

## Windows static validation

```powershell
python fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_tiny --report-dir reports\fpga\host\xdma_smoke\tiny_synthetic
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

## Orin gate

```bash
python3 fpga/host/xdma_smoke/make_tiny_synthetic_host_image.py --out-dir fpga/vivado/.build/host_synthetic_tiny --report-dir reports/fpga/host/xdma_smoke/tiny_synthetic
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-tiny fpga/vivado/.build/host_synthetic_tiny/manifest.json --ctrl-base 0x1000
```

Expected markers:

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
HOST_SYNTHETIC_IMAGE_PASS
HLS_TINY_START_PASS
HLS_TINY_DONE_PASS
HLS_TINY_NUMERIC_PASS
```

## Notes

- This stage reuses the already-programmed HLS-restored `azmig_wrapper.bit`.
- It does not rerun Vivado or regenerate a bitstream.
- The current PCIe Gen2 x1 link is recorded as a performance risk, not a functional blocker for this tiny transaction.
