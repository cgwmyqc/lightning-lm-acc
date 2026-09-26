# Stage R0 Changelog

## Added

- `tools/windows`: reproducible local/remote R0 orchestration scripts.
- `tools/orin`: PCIe recovery, XDMA bandwidth, build, benchmark, and tegrastats scripts.
- `reports/nma/r0`: preflight, CSim status, collected baseline evidence, and artifact manifest.
- `R0_FEASIBILITY_REPORT.md` and `CURRENT_STATUS.md`.

## Changed

- `XdmaRuntime` now resets and reads `LIGHTNING_CTRL_CYCLE_COUNT` for observation, ESKF update, and localization iterative kernels.
- Runtime results now expose FPGA cycles, kernel seconds, and host polling overhead.
- FPGA profiling logs, CSV traces, and Golden JSON/stdout include the new timing fields.
- `fpga.runtime.kernel_clock_hz` defaults to 125 MHz in all shipped YAML configurations.

## Validation

- PowerShell parse: PASS for all Windows R0 scripts.
- Bash parse: PASS for all Orin R0 scripts.
- Local Windows preflight: PASS.
- Full preflight: FAIL because Orin user/repository variables are unset.
- Three g++ CSim suites: PASS.
- Three Vivado HLS 2018.3 CSim suites: PASS.
- Three Vivado HLS 2018.3 C synthesis flows: PASS.
- Benchmark frame analyzer synthetic warm-up/measurement/P95 self-test: PASS.
- WSL ROS 2 CMake configure: BLOCKED before compilation because `glogConfig.cmake` is absent from the local image.
- Board/JTAG/XDMA regression: not run in this pass.
