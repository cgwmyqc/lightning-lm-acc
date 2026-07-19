# Stage71 Localization Full Iterative HLS Commands

Windows commands executed:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_export_ip.ps1
```

Generated local HLS/IP paths:

```text
fpga/vivado/.build/hls_slam_loc_iterative_csim/
fpga/vivado/.build/hls_slam_loc_iterative_csynth/
fpga/vivado/.build/hls_slam_loc_iterative_export/solution1/impl/ip/
```

These are generated artifacts and are not intended for git.

