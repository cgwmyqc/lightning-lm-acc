# Stage 53 Commands

## Completed

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\xdma_smoke.py
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

## Windows JTAG Command

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

## Orin Commands After JTAG

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

## Orin Acceptance Run, 2026-06-21

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
/dev/xdma0_user present
/dev/xdma0_h2c_0 present
/dev/xdma0_c2h_0 present
enable=1
no new Failed to detect XDMA config BAR / CmpltTO / AER fatal
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
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
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

Mapping CPU replay:

```bash
source install/setup.bash
./install/lightning/lib/lightning/run_surfel_mapping_golden_replay \
  --golden_dir fpga/golden/mapping/frame_000001
```

Observed:

```text
MAPPING_CPU_REPLAY_PASS
counts actual=611/0/171 expected=611/0/171
values_ok=1
max_abs=0.0337705
max_rel=2.21971e-05
worst_field=b(3)
```

Mapping XDMA replay:

```bash
source install/setup.bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
    --golden_dir fpga/golden/mapping/frame_000001 \
    --ctrl_base 0x1000 \
    --timeout_sec 120
```

Observed, first run:

```text
STATUS=0x204
ERROR=0x0
RUN_COUNT=0->1
SCAN_COUNT_READBACK=782
counts actual=600/0/182 expected=611/0/171
values_ok=0
max_abs=270562
max_rel=6.38949
worst_field=H(3,3)
MAPPING_XDMA_REPLAY_FAIL
```

Observed, retry:

```text
STATUS=0x204
ERROR=0x0
RUN_COUNT=1->2
SCAN_COUNT_READBACK=782
counts actual=600/0/182 expected=611/0/171
values_ok=0
max_abs=270562
max_rel=6.38949
worst_field=H(3,3)
MAPPING_XDMA_REPLAY_FAIL
```

Online mapping `fpga_obs` smoke was skipped because mapping XDMA replay did not pass.
