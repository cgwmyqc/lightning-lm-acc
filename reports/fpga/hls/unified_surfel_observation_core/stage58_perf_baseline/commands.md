# Stage 58 HLS Performance Baseline Commands

``powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_stage58_perf_baseline.ps1
``

This script runs:

``powershell
powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 -GoldenDir F:\Project_HITZRI\26-06-06_Lightninglm_fpga_acc\lightning-lm-acc\fpga\golden\localization\frame_000001 -Compiler g++ -SyntheticSweep
``
