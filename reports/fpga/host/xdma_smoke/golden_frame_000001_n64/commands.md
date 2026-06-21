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

## Stage 43 Orin Retest 2026-06-20

Stage 40 n64 golden was not rerun because Stage 43 failed earlier at the Stage 42 residual probe gate:

```text
valid_only expected=1/0/0 actual=0/0/0 FAIL
reject_z_only expected=0/1/0 actual=1/0/0 FAIL
reject_x_only expected=0/1/0 actual=1/0/0 FAIL
```

Per the Stage 43 failure branch, do not rerun n64 golden until residual probe counters pass.

## Stage 43 Orin Reboot Retest 2026-06-20 23:34

Stage 40 n64 golden was not rerun after reboot because Stage 43 still failed at the Stage 42 residual probe gate:

```text
valid_only expected=1/0/0 actual=0/0/0 FAIL
reject_z_only expected=0/1/0 actual=1/0/0 FAIL
reject_x_only expected=0/1/0 actual=1/0/0 FAIL
```

## Stage 44 Orin Retest 2026-06-21 09:48

Stage 40 n64 golden was rerun after Stage 42 residual probes and Stage 41 multi-cell both passed.

Command sequence:

```bash
test -f fpga/golden/localization/frame_000001/loc_scan.bin || bin/build_surfel_loc_golden --map_pcd fpga/golden_src/localization/frame_000001/active_map.pcd --scan_pcd fpga/golden_src/localization/frame_000001/scan_body_undistorted.pcd --output_dir fpga/golden/localization/frame_000001 --tx 4.73688388768225899 --ty 1.39379087436528137 --tz 6.33753036326788166 --qx 0.0628099684803903463 --qy 0.0363431132556296249 --qz -0.0640026197406848296 --qw 0.995307867267565816
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

Observed markers:

```text
HOST_GOLDEN_IMAGE_PASS
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
```

HLS completed without timeout or hardware error:

```text
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=6 -> 7
```

Numeric comparison failed before `HLS_MANIFEST_NUMERIC_PASS`:

```text
RuntimeError: valid_count mismatch: actual=52 expected=14
```

Expected vs actual:

```text
EXPECTED_COUNTS=14/33/17 FLAGS=0x00000000
ACTUAL_COUNTS=52/12/0 FLAGS=0x00000000

EXPECTED_RESIDUAL_SUM=0.87436966027431406
EXPECTED_RESIDUAL_ABS_SUM=1.3874737319668577
EXPECTED_RESIDUAL_MAX_ABS=0.29527878422266252

ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
```

Normal equation actual dump:

```text
ACTUAL_H_UPPER=[22.308839796978894,-0.99128400979866615,-13.275552831385616,-3.4098071411650048,155.48506130137977,-44.920637163007697,12.662832448417323,3.9792651883529979,-89.965664521418461,-8.9334766051646479,7.2901425436713687,17.028327752175187,14.789327132602782,-102.95922140370193,12.343283746329648,899.31166650661078,-70.981223553152176,-2.7401610172118964,1129.7830234766566,-325.2047832840538,387.06256730310366]
ACTUAL_B=[-0.70513185009762902,-0.42457526330019862,-0.079899540579997208,2.0415549834711988,-5.1626863669195044,2.7286869496388286]
```

Conclusion: Stage 44 fixes the synthetic output counter issue, but n64 real golden still fails. The remaining issue is now focused on real active-map lookup/classification or expected-vs-HLS lookup logic: HLS returns no misses (`miss=0`) while CPU expected has `miss=17`, and HLS counts too many valid points.
