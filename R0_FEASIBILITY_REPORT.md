# R0 Feasibility Report

Date: 2026-09-26  
Branch: `dev-acc`  
Baseline tag: `baseline_20260926_before_nma_redesign`  
Baseline commit: `5b2657a2d1fb88d621b1612e41983b037c7b7a0d`

## Hardware

- FPGA: AMD/Xilinx XC7Z100-2FFG900I.
- PCIe capability: Gen2 x4.
- Latest checked-in board evidence: Gen2 x1, downgraded from x4. This fails the R0 link gate.
- PL DDR address space: 1 GiB (`0x00000000..0x3fffffff`).
- XDMA: user BAR, H2C, and C2H paths are implemented. The latest checked-in Stage72D report records all three device nodes and the offline iterative Golden as PASS.
- Current Windows toolchain: Vivado, Vivado HLS, XSDB, and hw_server 2018.3 found under `E:\Xilinx\Vivado\2018.3`.
- Orin SSH port `192.168.31.119:22`: reachable during this R0 run.
- Non-interactive Orin control: not executed because `ORIN_USER` and `ORIN_ROOT` are not configured.

## CPU Baseline

- frame mean: not measured in this run.
- frame P95: not measured in this run.
- ESKF mean: not measured in this run.
- candidate/search mean: not measured in this run.

The automation requires one bag, map, and three explicit configs for CPU, FPGA observation, and FPGA full iterative modes. See `tools/windows/34_run_benchmark.ps1`. The remote runner rejects insufficient samples, discards 100 warm-up frames, measures the next 500 frames, and emits raw selected samples plus mean/P95/min/max summaries. The report remains NO-GO until those measurements are collected for each mode.

## FPGA Baseline

- Current checked-in Stage72D localization full-iterative Golden: PASS.
- Historical mean host HLS wait: 236.615 ms over three runs.
- Historical counts: valid/reject/miss = `6124/837/2`.
- Historical numeric comparison: max absolute difference `3.55271e-13`, max relative difference `8.21216e-15`.
- candidate build: not isolated in the checked-in Stage72D report.
- H2C: not isolated in the checked-in Stage72D report.
- FPGA cycle time: not present in the old report.
- C2H: not isolated in the checked-in Stage72D report.

This branch now clears `CYCLE_COUNT` before every kernel launch and records:

- `fpga_cycle_count`;
- `fpga_kernel_sec = fpga_cycle_count / kernel_clock_hz`;
- `polling_overhead_sec = max(0, hls_wait_sec - fpga_kernel_sec)`.

The default clock is 125 MHz and is configurable through `fpga.runtime.kernel_clock_hz`. The new values are emitted by Golden tools and localization/mapping profiling CSV files. A fresh board run is required before they can be reported numerically.

## PCIe Benchmark

Status: not run on the Orin in this R0 pass.

`tools/orin/xdma_benchmark.sh` now measures 4 KiB, 64 KiB, 128 KiB, 512 KiB, 1 MiB, 8 MiB, and 32 MiB payloads and emits:

```text
size_bytes,h2c_MBps,c2h_MBps,h2c_us,c2h_us,round_trip_us,iterations
```

The latest checked-in link evidence is Gen2 x1, so the required Gen2 x4 gate is currently FAIL.

## Current Resource

The HLS rows below are fresh Vivado HLS 2018.3 C synthesis results generated on 2026-09-26. HLS RAM is reported as BRAM18K; the complete implementation reports BRAM tiles (BRAM36 equivalents).

| Core | LUT | FF | BRAM18K | DSP48E | Target | Estimated |
|---|---:|---:|---:|---:|---:|---:|
| unified_surfel_observation_core | 118,553 | 85,420 | 194 | 365 | 8.000 ns | 7.436 ns |
| slam_ekf_update_core | 79,138 | 75,279 | 94 | 407 | 8.000 ns | 7.673 ns |
| slam_loc_iterative_core | 94,725 | 85,804 | 156 | 574 | 8.000 ns | 7.519 ns |

Latest complete Stage72C implementation:

| Resource | Used | Available | Utilization | R0 hard gate | Result |
|---|---:|---:|---:|---:|---|
| LUT | 216,599 | 277,400 | 78.08% | <=72% | FAIL |
| FF | 246,370 | 554,800 | 44.41% | <=65% | PASS |
| BRAM36 tile | 146 | 755 | 19.34% | <=75% | PASS |
| DSP48E1 | 1,386 | 2,020 | 68.61% | <=65% | FAIL |

Timing is closed in the checked-in report: WNS `0.086 ns`, WHS `0.016 ns`, with no failing setup or hold endpoints. This is historical baseline evidence, not a rebuild of the modified host code.

## Accuracy

Rerun on Windows on 2026-09-26:

- unified observation g++ CSim: PASS;
- unified observation Vivado HLS CSim: PASS;
- mapping ESKF update g++ CSim: PASS;
- mapping ESKF update Vivado HLS CSim: PASS;
- localization iterative synthetic and real-Golden g++ CSim: PASS;
- localization iterative Vivado HLS CSim: PASS;
- unified observation Vivado HLS C synthesis: PASS;
- mapping ESKF update Vivado HLS C synthesis: PASS;
- localization iterative Vivado HLS C synthesis: PASS;
- localization iterative real-Golden maximum absolute difference: `2.91323e-13`;
- localization iterative counts: `6124/837/2`.

Board Golden was not rerun after the profiling patch because JTAG programming and Orin execution require configured remote credentials and paths.

The ROS 2 host build was configured in WSL, but configuration stopped before compilation because the local WSL image does not provide `glogConfig.cmake`. The changed host sources therefore still require compilation in the configured Orin build environment.

## Risks

1. PCIe is recorded as Gen2 x1, not the required Gen2 x4.
2. Full-design LUT and DSP utilization exceed the product hard gates.
3. CPU and FPGA wall-clock baselines over the same bag have not been collected.
4. The new cycle counter telemetry has not yet been validated on the board.
5. Non-interactive SSH/scp/build cannot run until `ORIN_USER` and `ORIN_ROOT` are set.
6. No current-run JTAG, XDMA throughput, power, or 500-frame P95 evidence exists.

## GO / NO-GO

`R0_BASELINE_PASS = NO`

R1 and R2 must not begin yet. The minimum unblock sequence is:

1. Configure key-based `ORIN_USER` and `ORIN_ROOT`.
2. Run Orin preflight and confirm Gen2 x4.
3. Run H2C/C2H/round-trip bandwidth tests.
4. Build and run all board Golden tests with cycle telemetry.
5. Collect CPU/FPGA mean and P95 over the same bag.
6. Reduce the complete design below the LUT and DSP hard gates, or approve a revised architecture before further integration.
