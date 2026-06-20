# Golden frame_000001 n64 Host Transaction

## Windows static validation

```powershell
python fpga\host\xdma_smoke\make_golden_host_image.py --golden-dir fpga\golden\localization\frame_000001 --max-points 64 --out-dir fpga\vivado\.build\host_golden_frame_000001_n64 --report-dir reports\fpga\host\xdma_smoke\golden_frame_000001_n64
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_golden_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

## Orin gate

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000
```

Expected markers:

```text
HOST_GOLDEN_IMAGE_PASS
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
```

Expected bounded counts: `14/33/17`.

## Notes

- This stage reuses the already-programmed HLS-restored `azmig_wrapper.bit`.
- It does not rerun Vivado or regenerate a bitstream.
- PCIe Gen2 x1 remains a performance risk only; it is not a functional blocker for this n64 gate.

## Orin Result 2026-06-20

Before generating the n64 host image, `fpga/golden/localization/frame_000001/loc_scan.bin` was missing locally. It was regenerated from `fpga/golden_src/localization/frame_000001`:

```bash
bin/build_surfel_loc_golden --map_pcd fpga/golden_src/localization/frame_000001/active_map.pcd --scan_pcd fpga/golden_src/localization/frame_000001/scan_body_undistorted.pcd --output_dir fpga/golden/localization/frame_000001 --tx 4.73688388768225899 --ty 1.39379087436528137 --tz 6.33753036326788166 --qx 0.0628099684803903463 --qy 0.0363431132556296249 --qz -0.0640026197406848296 --qw 0.995307867267565816
```

Regenerated full golden counts:

```text
valid=6050 reject=911 miss=2
```

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
HOST_GOLDEN_IMAGE_PASS
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
```

HLS completed without timeout:

```text
STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT_AFTER=2
```

Numeric comparison failed before `HLS_MANIFEST_NUMERIC_PASS`:

```text
RuntimeError: valid_count mismatch: actual=64 expected=14
```

Post-run output buffer readback:

```text
ACTUAL_COUNTS=64/0/0 FLAGS=0x00000000
ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
```

Conclusion: Stage 40 passes XDMA, BAR shim, control register, DDR, and HLS start/done gates, but fails the real golden numeric contract. Do not proceed to full-frame transaction until the HLS-side reject/miss or active-map ABI mismatch is resolved.
