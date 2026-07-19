# Stage72A Orin Commands

Date: 2026-07-19

## Build

```bash
colcon build --packages-select lightning
source install/setup.bash
```

## Source Golden Check

```bash
test -f fpga/golden/localization/frame_000001/loc_scan.bin
test -f fpga/golden/localization/frame_000001/loc_active_map.bin
test -f fpga/golden/localization/frame_000001/loc_pose.bin
test -f fpga/golden/localization/frame_000001/loc_expected_obs.bin
```

Result:

```text
SOURCE_LOCALIZATION_GOLDEN_PRESENT
```

## Generate Iterative Golden

```bash
ros2 run lightning build_surfel_loc_iterative_golden \
  --source_golden_dir fpga/golden/localization/frame_000001 \
  --output_dir fpga/golden/localization_iterative/frame_000001 \
  --max_iterations 4 \
  --residual_outlier_th 0.3 \
  --conv_translation 1e-4 \
  --conv_rotation 1e-4 \
  --min_valid_count 300
```

Markers:

```text
LOC_ITER_GOLDEN_BUILD_PASS
scan_count=6963 candidate_count=6963 candidate_valid=6961 candidate_miss=2
iterations_used=4 status=1 flags=0x1 counts=6124/837/2 score=2.25349 dx_norm=0.00349622
```

Full log:

```text
reports/fpga/runtime/stage72_loc_full_iter_orin/build_iterative_golden.log
```

## CPU Replay

```bash
ros2 run lightning run_surfel_loc_iterative_golden_replay \
  --golden_dir fpga/golden/localization_iterative/frame_000001
```

Markers:

```text
LOC_ITER_CPU_REPLAY_PASS
loc_iter_expected.bin parser roundtrip PASS
status_ok=1 values_ok=1 max_abs=0 max_rel=0
actual_counts=6124/837/2 expected_counts=6124/837/2
actual_iterations=4 expected_iterations=4
```

Full log:

```text
reports/fpga/runtime/stage72_loc_full_iter_orin/cpu_replay.log
```

## Stage72B Windows HLS

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_export_ip.ps1
```

## Not Run In Stage72A/B

```text
run_surfel_loc_iterative_xdma_golden
```

Reason: Stage72A generated and validated the real Orin-side CPU golden.
Stage72B validated the standalone HLS core against that real golden. Board
replay waits for BD/XDMA integration.

## Stage72C Windows BD Integration

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_export_ip.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\rtl\slam_accel_ctrl\run_vivado_ooc_synth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Result:

```text
LOC_ITER_EXPORT_IP_PASS
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
```

## Stage72D Orin Prep

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

Then run the Stage72D loc iterative XDMA replay once the Orin executable is
available. Expected final marker:

```text
LOC_ITER_XDMA_PASS
```
