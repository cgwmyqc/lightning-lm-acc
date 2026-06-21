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

## Stage 45 Orin Diagnostic 2026-06-21 10:19

The n64 transaction was rerun with image readback, register readback, raw output words, and normal-equation dump:

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```

Image readback passed for every segment, including the full `obs_cells.bin` payload:

```text
HOST_IMAGE_READBACK_PASS
scan_points.bin sha256=be192efd2fdfc6e98eb7bee8d54fba79f109aba21bfb87e93bcb1e594828eae2
pose.bin sha256=be72a104b86c7ff877c0b1b0991b92478781c5c72373532375a77b11ca9ab2d8
map_header.bin sha256=b3278cff43a3137f61d306e7224bfa833aa907aa78fa52e8ad86fb34ab6e7fbe
active_blocks.bin sha256=6fb2ba1ea213840cacc6e710ddd2a6bc83d3af80887cde1c131fb57eff7f05aa
obs_cells.bin sha256=6e4dcbbdebd851e86f62cde58d6c8959803966dbcec60c80e1fb5699544f34f8
output_zero.bin sha256=7b6436b0c98f62380866d9432c2af0ee08ce16a171bda6951aecd95ee1307d61
```

Controller register readback matched the expected PL DDR layout:

```text
SCAN_ADDR_LO_READBACK=0x00000000
POSE_ADDR_LO_READBACK=0x01000000
MAP_HEADER_ADDR_LO_READBACK=0x01001000
ACTIVE_BLOCKS_ADDR_LO_READBACK=0x02000000
OBS_CELLS_ADDR_LO_READBACK=0x10000000
OUT_ADDR_LO_READBACK=0x30000000
SCAN_COUNT_READBACK=64
STATUS_READBACK=0x00000201
```

HLS still completed but failed numeric comparison:

```text
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=7 -> 8
EXPECTED_COUNTS=14/33/17
ACTUAL_COUNTS=52/12/0
```

Raw output count words:

```text
OUTPUT_WORD[27]=0x0000000c00000034
OUTPUT_WORD[28]=0x0000000000000000
```

Actual normal-equation summary:

```text
ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
ACTUAL_B=[-0.70513185009762902,-0.42457526330019862,-0.079899540579997208,2.0415549834711988,-5.1626863669195044,2.7286869496388286]
```

Conclusion: Stage 45 rules out host image corruption and register misconfiguration for the n64 mismatch. The remaining failure is in real active-map lookup/classification.

## Stage 47 Orin Retest 2026-06-21

Stage 47 fixed the Python bounded expected/trace negative-coordinate `floor_div` behavior and regenerated the n64 host image.

Command sequence:

```bash
python3 fpga/host/xdma_smoke/make_golden_host_image.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_frame_000001_n64 --report-dir reports/fpga/host/xdma_smoke/golden_frame_000001_n64
python3 fpga/host/xdma_smoke/make_golden_trace_host_images.py --golden-dir fpga/golden/localization/frame_000001 --max-points 64 --out-dir fpga/vivado/.build/host_golden_trace_n64 --report-dir reports/fpga/host/xdma_smoke/golden_trace_n64
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_golden_frame_000001_n64/manifest.json --ctrl-base 0x1000 --verify-image-readback --read-regs-after-config --dump-output-raw-words --dump-normal-equation
```

Regeneration markers:

```text
HOST_GOLDEN_IMAGE_PASS
expected_counts=52/12/0
HOST_GOLDEN_TRACE_PASS
trace_counts=52/12/0
expected_counts=52/12/0
```

Board transaction markers:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=64
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
RUN_COUNT=12 -> 13
COUNTS=52/12/0
```

Raw output count words:

```text
OUTPUT_WORD[27]=0x0000000c00000034
OUTPUT_WORD[28]=0x0000000000000000
```

Actual normal-equation summary:

```text
ACTUAL_COUNTS=52/12/0 FLAGS=0x00000000
ACTUAL_RESIDUAL_SUM=0.44294171614182876
ACTUAL_RESIDUAL_ABS_SUM=2.2681722148352881
ACTUAL_RESIDUAL_MAX_ABS=0.29527878422266252
ACTUAL_H_UPPER=[22.308839796978894,-0.99128400979866615,-13.275552831385616,-3.4098071411650048,155.48506130137977,-44.920637163007697,12.662832448417323,3.9792651883529979,-89.965664521418461,-8.9334766051646479,7.2901425436713687,17.028327752175187,14.789327132602782,-102.95922140370193,12.343283746329648,899.31166650661078,-70.981223553152176,-2.7401610172118964,1129.7830234766566,-325.2047832840538,387.06256730310366]
ACTUAL_B=[-0.70513185009762902,-0.42457526330019862,-0.079899540579997208,2.0415549834711988,-5.1626863669195044,2.7286869496388286]
```

Conclusion: Stage 47 n64 bounded golden passes on Orin. The earlier n64 mismatch was caused by Python bounded expected/trace encoding of negative grid coordinates, not by HLS lookup corruption.
