# slam_accel_hls_ip_bd Summary

Date: 2026-06-17

## Status

- BD validate: PASS.
- HDL wrapper generation: PASS.
- Non-project OOC synthesis: BLOCKED by Vivado HLS 2018.3 floating-point subcore XCI checkpoint policy.
- Project-managed `synth_1`: PASS.
- No XDMA, DDR interconnect, PS, implementation, bitstream, or board-level project was created.

## Integration Contract

- `slam_accel_ctrl` is instantiated as the only external control register block.
- Real HLS IP `unified_surfel_observation_core` is imported from `%TEMP%\lightning_hls_unified_obs\solution1\impl\ip`.
- `ap_start/ap_done/ap_idle/ap_ready` are directly connected.
- `num_points`, input base addresses, and output field direct addresses are directly connected.
- `unified_obs_error` is tied to `32'd0` with `xlconstant`.
- HLS `m_axi_gmem0..4` are exposed as external AXI master interfaces.
- `aclk` is constrained to 100 MHz by `fpga/vivado/slam_accel_hls_ip_bd/slam_accel_hls_ip_bd.xdc`.

## Project-Managed Synthesis Result

- Command: `powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_project_synth.ps1`
- Status: PASS.
- Synthesis log: `Synthesis finished with 0 errors, 0 critical warnings and 0 warnings.`
- Run status: `synth_design Complete!`
- Final marker: `PROJECT_SYNTH_PASS`

## Resource Summary

Synthesized design: `slam_accel_hls_ip_bd_wrapper`, part `xc7z100ffg900-2`.

| Resource | Used | Available | Utilization |
| --- | ---: | ---: | ---: |
| Slice LUTs | 21292 | 277400 | 7.68% |
| Slice Registers | 25884 | 554800 | 4.67% |
| Block RAM Tile | 24 | 755 | 3.18% |
| DSPs | 256 | 2020 | 12.67% |
| Bonded IOB | 4032 | 362 | 1113.81% |

The IOB count is expected to exceed device pins in this skeleton because every
AXI-Lite and `m_axi_gmem0..4` signal is deliberately exposed externally. The
next memory-fabric stage must internalize these ports through interconnect/DDR
or a simulation memory harness.

## Timing Summary

- Constraint: `aclk` 10.000 ns / 100 MHz.
- Setup WNS: `2.732 ns`, TNS: `0.000 ns`, failing setup endpoints: `0`.
- Hold WHS: `-0.017 ns`, THS: `-2.925 ns`, failing hold endpoints: `170`.
- This is a synthesized/open-run timing estimate before placement and before
  real memory/interconnect integration; hold cleanup is deferred to the next
  real fabric/implementation stage.

## Archived Logs

- `vivado_bd_validate_log.txt`
- `vivado_ooc_synth_log.txt`
- `vivado_project_synth_log.txt`
- `vivado_project_synth_runme_log.txt`
- `slam_accel_hls_ip_bd_project_synth_utilization.txt`
- `slam_accel_hls_ip_bd_project_synth_timing_summary.txt`
