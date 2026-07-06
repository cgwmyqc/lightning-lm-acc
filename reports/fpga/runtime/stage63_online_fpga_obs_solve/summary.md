# Stage63 Online FPGA_OBS_SOLVE Summary

## Result

Stage63 online smoke: PASS.

The online localization path entered `SURFEL_FPGA_OBS_SOLVE`, used Candidate ABI V2, and received FPGA solve6x6 status `1` on all captured localization calls. Mapping FPGA was disabled for this test, so no XDMA contention from mapping was present.

## Evidence

```text
mapping_backend=CPU
backend=SURFEL_FPGA_OBS_SOLVE
candidate_abi_v2=1
fpga_solve_status=1
fallback_cpu_sim=0
fallback_ndt=0
```

Parsed from `loc_online.log`:

```text
online solve calls: 46
online solve success lines: 46
loc_profile lines: 4
mapping FPGA_OBS success lines: 0
fallback_cpu_sim: false
fallback_ndt: false
```

Timing over the 46 FPGA solve calls:

```text
xdma total mean: 121.033 ms
xdma total min/max: 53.583 / 130.214 ms
hls_wait mean: 118.972 ms
hls_wait min/max: 52.329 / 128.054 ms
h2c_map mean: 1.166 ms
h2c_candidate mean: 1.166 ms
mutex_wait mean: 0.0007 ms
fpga_solve mean: 0.00009 ms
dx_norm mean/min/max: 0.02036 / 0.00702 / 0.08871
```

Representative profile line:

```text
[loc_profile] frame=30 backend=SURFEL_FPGA_OBS_SOLVE success=1 loc_total_ms=139.070 lio_frontend_ms=4.602 lidar_loc_ms=137.723 pgo_ms=1.303 scan_points=7033 active_blocks=663 active_cells=169728 iterations=1 valid/reject/miss=6545/482/6 xdma_total_ms=127.545 hls_wait_ms=125.315 h2c_map_ms=1.289 h2c_candidate_ms=1.289 mutex_wait_ms=0.001 fpga_solve_status=1 dx_norm=0.017 fallback_cpu_sim=0 fallback_ndt=0 status=0x204 error=0x0
```

## Notes

- This is a smoke test, not a long stability run.
- The dominant online latency is still HLS observation time, not solve6x6.
- The test intentionally disables mapping FPGA with `fpga.mapping.enable=false`.
