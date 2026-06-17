# slam_accel_hls_mem_harness summary

Date: 2026-06-17

## Status

- BD validate: PASS (`BD_VALIDATE_PASS`)
- Project-managed synthesis: PASS (`PROJECT_SYNTH_PASS`, `SYNTH_1_STATUS=synth_design Complete!`)
- Behavioral simulation: PASS (`[tb_lmem_bd_smoke] PASS`)
- Golden memory image generation: PASS (`GOLDEN_IMAGE_PASS`)
- Golden RTL elaboration/preload smoke: PASS
- Golden RTL numeric simulation with `-RunNumeric`: BLOCKED by Vivado 2018.3 XSim runtime
- Tiny synthetic RTL numeric simulation: PASS (`[tb_lmem_golden] PASS`)

## Generated Project Location

- BD validate project: `fpga/vivado/.build/lmem_bd`
- Project-managed synthesis project: `fpga/vivado/.build/lmem_syn`
- Behavioral simulation project: `fpga/vivado/.build/lmem_sim`
- Golden RTL simulation project: `fpga/vivado/.build/lmem_golden_sim`
- Golden image directory: `fpga/vivado/.build/golden_frame_000001_n64`
- Tiny synthetic RTL simulation project: `fpga/vivado/.build/lmem_synthetic_sim`
- Tiny synthetic image directory: `fpga/vivado/.build/synthetic_tiny`

The PowerShell entry points temporarily map `fpga/vivado/.build` to an unused
short drive letter during Vivado execution. This keeps generated projects under
the repository's `fpga/vivado` tree while avoiding Vivado 2018.3 Windows path
length failures.

## Integration

- Real HLS IP: `unified_surfel_observation_core`
- Controller: `slam_accel_ctrl`
- External control: single AXI-Lite register block from `slam_accel_ctrl`
- Internal memory targets:
  - `m_axi_gmem0 -> axi_bram_ctrl_0 + blk_mem_0`, 128-bit
  - `m_axi_gmem1 -> axi_bram_ctrl_1 + blk_mem_1`, 512-bit
  - `m_axi_gmem2 -> axi_bram_ctrl_2 + blk_mem_2`, 256-bit
  - `m_axi_gmem3 -> axi_bram_ctrl_3 + blk_mem_3`, 512-bit
  - `m_axi_gmem4 -> axi_bram_ctrl_4 + blk_mem_4`, 64-bit
- Top-level `m_axi_gmem0..4`: not exposed

## Resource Summary

- Part: `xc7z100ffg900-2`
- Clock constraint: `aclk = 10.000 ns / 100 MHz`
- Slice LUTs: 23027 / 277400 (8.30%)
- Slice Registers: 31014 / 554800 (5.59%)
- Block RAM Tile: 47 / 755 (6.23%)
- DSPs: 256 / 2020 (12.67%)
- Bonded IOB: 204 / 362 (56.35%)

The previous real-HLS-IP BD skeleton exposed all HLS AXI masters and used 4032
IOB. This harness internalizes those memory ports and reduces IOB to 204.

## Timing Summary

- Setup WNS: 2.732 ns
- Setup TNS: 0.000 ns
- Setup failing endpoints: 0
- Hold WHS: -0.095 ns
- Hold THS: -142.802 ns
- Hold failing endpoints: 1647

The hold result is from synthesized/open-run timing on this intermediate
harness. It is recorded for tracking, not optimized in this stage.

## Simulation Summary

`tb_lmem_bd_smoke` uses the real BD wrapper, writes `KERNEL_SEL=4`, zero base
addresses, and `SCAN_COUNT=0`, starts the controller, and waits for controller
DONE. The run completed at 14235 ns with `ERROR=0` and `RUN_COUNT=1`.

Vivado XSim reports expected behavioral-model warnings for BRAM and DSP48
OPMODE warnings from uninitialized datapath activity; the testbench still
completed PASS.

## Golden Simulation Summary

The new golden image generator reads
`fpga/golden/localization/frame_000001` and emits simulation-only memory images
for the five HLS AXI bundles. The default bounded run uses the first 64 scan
points and computes a matching expected normal equation in the generator:

- full scan points: 6963
- bounded scan points: 64
- active blocks: 3719
- obs cells: 952064
- obs-cell image: 60,932,096 bytes
- bounded expected counts: 14 / 33 / 17

The generated HLS RTL plus behavioral AXI memory testbench elaborates and
starts in Vivado 2018.3 XSim, and all five memory images load. This default
preload smoke is the script's normal return-fast behavior. The numeric run with
`-RunNumeric` does not complete in a practical time: the 64-point bounded run
exceeded 15 minutes and had advanced only to roughly 4.4 ms of simulation time
while still emitting HLS floating-point DSP48 OPMODE warnings. Full-frame RTL
numeric simulation is therefore not a usable per-change gate in this tool flow.

Next validation should move to a faster path: either suppress/replace the
floating-point RTL simulation model warning path, use a smaller dedicated
synthetic vector with known early completion, or move golden numeric checking to
a higher-level co-sim/RTL wrapper strategy that does not require full Vivado
floating-point event simulation.

## Tiny Synthetic RTL Numeric Summary

The new synthetic flow generates a deliberately small fixture:

- scan points: 1
- active blocks: 1
- obs cells: 256
- valid cells: 1
- expected counts: 1 / 0 / 0

`run_vivado_synthetic_sim.ps1` reuses the real generated HLS RTL,
`slam_accel_ctrl`, `tb_lmem_golden.sv`, and the five behavioral AXI memory
models. Vivado 2018.3 XSim completed the numeric run quickly:

- marker: `[tb_lmem_golden] PASS`
- counts: 1 / 0 / 0
- max_abs: `2.980232227667301e-09`
- max_rel: `2.980232227667301e-09`
- finish time: `29995 ns`

This becomes the fast RTL numeric gate for the current harness. Full/bounded
golden RTL numeric simulation remains a runtime-limited long-run path, not a
per-change gate.

The synthetic generator imports shared Python helpers from the golden image
generator, so Python `__pycache__/` is treated as a local generated artifact and
is ignored together with `fpga/vivado/.build/` and `fpga/golden/`.
