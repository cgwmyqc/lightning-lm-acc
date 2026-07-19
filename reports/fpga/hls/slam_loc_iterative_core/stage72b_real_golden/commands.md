# Stage72B Real Localization Iterative Golden Commands

Windows commands executed:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_gpp_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csim.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_csynth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\hls\slam_loc_iterative_core\run_vivado_hls_export_ip.ps1
```

Golden input:

```text
fpga/golden/localization_iterative/frame_000001/
```

Generated local HLS/IP paths:

```text
fpga/vivado/.build/hls_slam_loc_iterative_csim/
fpga/vivado/.build/hls_slam_loc_iterative_csynth/
fpga/vivado/.build/hls_slam_loc_iterative_export/solution1/impl/ip/
```

