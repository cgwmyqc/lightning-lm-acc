# Stage65B Commands

EKF HLS smoke and IP export:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_ekf_update_core\run_vivado_hls_export_ip.ps1
```

Controller OOC synthesis:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\rtl\slam_accel_ctrl\run_vivado_ooc_synth.ps1
```

Board-level Vivado:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Expected markers:

```text
MAPPING_EKF_UPDATE_HLS_CSIM_PASS
HLS_EKF_UPDATE_EXPORT_IP_PASS
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
```
