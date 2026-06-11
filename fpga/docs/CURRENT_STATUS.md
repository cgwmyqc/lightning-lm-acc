# Current Status

## Branch

- Current branch: `dev-fpga`

## Interface

- Interface version: 1
- `FpgaCorrInput`: 32 bytes, 32-byte aligned
- `FpgaStateInput`: 64-byte aligned
- `FpgaNormalEqOutput`: 64-byte aligned
- `GoldenHeader`: 64-byte aligned
- Windows HLS top: `normal_eq_accel(const uint32_t* input, uint32_t* output, int num_points)`
- DDR input layout: `FpgaStateInput` at byte offset 0, then `FpgaCorrInput[num_points]` at byte offset 128
- DDR output layout: `FpgaNormalEqOutput` at byte offset 0

## Current Surfel Parameters

`config/default_livox.yaml` currently uses:

```yaml
surfel_min_support: 3
surfel_cell_resolution: 0.8
surfel_lookup_nearby_type: 26
surfel_quality_max: 0.05
```

## Orin Side

- [x] `NormalEquationBackend`
- [x] `CpuNormalEquationBackend`
- [x] `FpgaNormalEquationBackend` compile-only stub
- [x] Golden dump writer
- [x] `cpu` mode preserves legacy CPU path
- [x] `cpu_sim` mode routes surfel-hit points through backend
- [x] XDMA wrapper
- [x] Real FPGA backend
- [x] `normal_eq_replay` host tool
- [x] `colcon build --symlink-install` passed

## Windows HLS Side

- [x] `normal_eq_accel.cpp`
- [x] `testbench.cpp`
- [x] `run_csim.tcl`
- [x] `run_csynth.tcl`
- [x] `export_ip.tcl`
- [x] C simulation passed on Windows Vivado HLS 2018.3
- [x] C synthesis passed on Windows Vivado HLS 2018.3
- [x] IP export passed on Windows Vivado HLS 2018.3

## Latest Golden Files

- `fpga/golden_small/frame_000100.bin`
- `fpga/golden_small/frame_000200.bin`
- `fpga/golden_small/frame_000300.bin`

## Orin Hardware Replay

- `normal_eq_replay` built and ran against the Orin PCIe FPGA through XDMA.
- Hardware replay passed for:
  - `frame_000100.bin`: 620 points, max abs error `0.000244141`
  - `frame_000200.bin`: 732 points, max abs error `0.000488281`
  - `frame_000300.bin`: 951 points, max abs error `0.0078125`, max rel error `1.90632e-7`
- Replay tolerance used on Orin hardware: `abs_error <= 1.0e-3 OR rel_error <= 1.0e-5`.
- PCIe bus mastering must be enabled before DMA. If `lspci -vv -s <bus-id>` shows `BusMaster-`, run:

```bash
sudo setpci -s <bus-id> COMMAND=0006
```

The tested Orin setup used bus id `0005:01:00.0`.

## Orin Online FPGA Backend

- `FpgaNormalEquationBackend` now implements the same XDMA data path verified by `normal_eq_replay`.
- `fpga.mode: fpga` routes surfel-hit effective points through the FPGA backend.
- iVox fallback points remain on the CPU and are added to the FPGA `H/b` result.
- `compare_with_cpu: true` runs a CPU_SIM reference for surfel-hit points and logs the maximum FPGA/CPU error.
- `fallback_to_cpu_on_error: true` keeps SLAM running if XDMA, timeout, output validation, or compare checks fail.

## Surfel-Only Experiment

- `fasterlio.surfel_fallback_mode: none` disables `ObsModel iVox KNN Fallback`.
- In this mode, surfel miss/fallback points are counted for diagnostics but are not sent to CPU iVox KNN, CPU plane fitting, or CPU fallback normal-equation accumulation.
- iVox map maintenance is still kept for compatibility with the existing local map code.
- If effective surfel-hit points fall below `fasterlio.min_pts_when_no_ivox_fallback`, the observation is rejected instead of falling back to CPU iVox.

## Notes

- Phase 1 does not move surfel lookup, iVox fallback, ESKF solve, or map update to FPGA.
- Golden files contain surfel-hit effective points only; fallback CPU contributions are not included.
- Windows HLS C simulation uses `abs_error <= 1.0e-4 OR rel_error <= 1.0e-3` for each checked field to account for cross-platform float32 accumulation rounding.
- Current DDR-buffer HLS interface avoids AXI-Lite struct-field expansion. Synthesized AXI-Lite registers are `control`, `input_r`, `output_r`, and `num_points`.
- HLS clock target is 10 ns, matching the 100 MHz `normal_eq_accel_0/ap_clk` used in Vivado BD.
- Latest 10 ns C synthesis result: 9.151 ns estimated clock, main accumulation loop II=8 and depth=60, BRAM_18K 2, DSP48E 36, FF 10219, LUT 9415.
- Vivado HLS 2018.3 IP export requires compatibility workarounds for unsupported `export_design -output` and oversized date-based `core_revision` values.
