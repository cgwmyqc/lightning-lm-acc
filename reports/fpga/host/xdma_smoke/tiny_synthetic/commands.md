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

## Orin results

Basic XDMA gate passed:

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
```

Shim/register smoke passed:

```text
SHIM_SMOKE_PASS
XDMA_SHIM_MAGIC=0x58444d41 XDMA_SHIM_VERSION=0x00010000
REG_SMOKE_PASS
VERSION=0x00020002
CTRL_BASE=0x00001000
KERNEL_SEL=4 MODE=1 SCAN_COUNT=1
```

DDR smoke passed for all six 4 KB regions:

```text
DDR_PATTERN_PASS scan_points base=0x00000000 size=4096
DDR_PATTERN_PASS pose base=0x01000000 size=4096
DDR_PATTERN_PASS map_header base=0x01001000 size=4096
DDR_PATTERN_PASS active_blocks base=0x02000000 size=4096
DDR_PATTERN_PASS obs_cells base=0x10000000 size=4096
DDR_PATTERN_PASS output base=0x30000000 size=4096
DDR_SMOKE_PASS
```

HLS tiny transaction passed:

```text
HOST_IMAGE_WRITE_PASS
HLS_TINY_START_PASS
CTRL_BASE=0x00001000 SCAN_COUNT=1 RUN_COUNT_BEFORE=0
HLS_TINY_DONE_PASS
STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT_AFTER=1
HLS_TINY_NUMERIC_PASS
COUNTS=1/0/0 FLAGS=0x00000000
WORST_FIELD=b[2] MAX_ABS=2.98023e-09 MAX_REL=5.96046e-08
```
