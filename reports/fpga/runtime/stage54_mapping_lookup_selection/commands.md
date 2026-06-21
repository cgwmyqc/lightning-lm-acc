# Stage 54 Mapping Lookup Selection Commands

## Windows HLS

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
```

## Windows Vivado

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Generated bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

## JTAG Download

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

## Orin Acceptance

```bash
./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120

./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120
```

## Orin Result

XDMA gate:

```bash
lspci -nnk -s 0005:01:00.0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
cat /sys/bus/pci/devices/0005:01:00.0/enable
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link|offline|reset|recovery|frozen' | tail -n 120
```

Observed:

```text
0005:01:00.0 Serial controller [0700]: Xilinx Corporation Device [10ee:7024]
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
enable=1
xdma:map_bars: config bar 1, pos 1.
xdma:identify_bars: 2 BARs: config 1, user 0, bypass -1.
xdma:probe_one: 0005:01:00.0 xdma0 ... usr 16, ch 1,1.
```

Build:

```bash
colcon build --packages-select lightning
```

Observed:

```text
Summary: 1 package finished
```

C++ XDMA runtime smoke:

```bash
source install/setup.bash
sudo -E env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
    --golden_dir fpga/golden/localization/frame_000001 \
    --ctrl_base 0x1000 \
    --shim_smoke \
    --reg_smoke \
    --ddr_smoke
```

Observed:

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
CTRL_BASE=0x00001000
XDMA_CPP_DDR_SMOKE_PASS
```

Localization XDMA replay:

```bash
source install/setup.bash
sudo -E env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
    --golden_dir fpga/golden/localization/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120 \
    --repeat 1
```

Observed:

```text
XDMA_CPP_GOLDEN_LOAD_PASS
scan_count=6963
expected_counts=6050/911/2
XDMA_CPP_HLS_DONE_PASS
ITER=1/1 STATUS=0x00000204 ERROR=0x00000000 RUN_COUNT=0->1 ELAPSED_SEC=1.54172
SCAN_COUNT_READBACK=6963
COUNTS=6050/911/2
OUTPUT_WORD[27]=0x0000038f000017a2
OUTPUT_WORD[28]=0x0000000000000002
XDMA_CPP_COMPARE counts_ok=1 values_ok=1 max_abs=0.0078906 max_rel=4.41926e-05 worst_field=b(4) actual_counts=6050/911/2 expected_counts=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
```

Mapping CPU replay:

```bash
source install/setup.bash
./install/lightning/lib/lightning/run_surfel_mapping_golden_replay \
  --golden_dir fpga/golden/mapping/frame_000001
```

Observed:

```text
counts actual=611/0/171 expected=611/0/171 values_ok=1 max_abs=0.0337705 max_rel=2.21971e-05 worst_field=b(3)
MAPPING_CPU_REPLAY_PASS golden_dir=fpga/golden/mapping/frame_000001
```

Mapping XDMA replay:

```bash
source install/setup.bash
sudo -E env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120
```

Observed:

```text
[mapping_xdma_golden] STATUS=0x204 ERROR=0x0 RUN_COUNT=1->2 SCAN_COUNT_READBACK=782 counts actual=611/0/171 expected=611/0/171 values_ok=1 max_abs=0.268571 max_rel=1.99295e-05 worst_field=H(3,3)
MAPPING_XDMA_REPLAY_PASS golden_dir=fpga/golden/mapping/frame_000001
```
