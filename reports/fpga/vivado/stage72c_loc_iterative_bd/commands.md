# Stage72C Localization Iterative BD Commands

Date: 2026-07-19

## HLS

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_export_ip.ps1
```

## Controller / Vivado

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\rtl\slam_accel_ctrl\run_vivado_ooc_synth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

## JTAG For Stage72D

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

## Orin Stage72D Gate

```bash
sudo reboot
lspci -nnk -s 0005:01:00.0
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

The Stage72D localization iterative XDMA replay must write
`loc_iter_scan.bin`, `loc_iter_candidates.bin`, `loc_iter_input.bin`, clear
the output buffer, set `KERNEL_SEL=6`, and compare against
`loc_iter_expected.bin`.
