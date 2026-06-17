# slam_accel_hls_mem_harness

Script-generated Vivado memory harness for the real
`unified_surfel_observation_core` HLS IP and the single AXI-Lite
`slam_accel_ctrl` controller.

This stage is not a board project. It does not instantiate XDMA, DDR, PS,
implementation runs, bitstream generation, or board files.

## Contract

- `slam_accel_ctrl` remains the only external control register block.
- The HLS IP is imported from:

```text
%TEMP%\lightning_hls_unified_obs\solution1\impl\ip
```

- `ap_start`, `ap_done`, `ap_idle`, and `ap_ready` are directly connected.
- `num_points`, input base addresses, and output field base addresses are
  connected as 32-bit direct scalar ports.
- `unified_obs_error` is tied to `32'd0` through `xlconstant` because the
  current HLS IP has no error output.
- HLS `m_axi_gmem0..4` are internal, not top-level ports. Each HLS AXI master
  is connected to an independent AXI BRAM Controller plus Block Memory
  Generator target:

```text
gmem0 -> axi_bram_ctrl_0 + blk_mem_0, 128-bit
gmem1 -> axi_bram_ctrl_1 + blk_mem_1, 512-bit
gmem2 -> axi_bram_ctrl_2 + blk_mem_2, 256-bit
gmem3 -> axi_bram_ctrl_3 + blk_mem_3, 512-bit
gmem4 -> axi_bram_ctrl_4 + blk_mem_4,  64-bit
```

This deliberately favors a reliable internal response target for each HLS
master over a shared memory fabric. A later stage can replace the five local
BRAM targets with SmartConnect plus DDR/XDMA-facing memory.

## Run BD Validate

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_bd_validate.ps1
```

Default generated project directory:

```text
fpga\vivado\.build\lmem_bd
```

Expected TCL marker:

```text
BD_VALIDATE_PASS
```

## Run Project-Managed Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_project_synth.ps1
```

Default generated project directory:

```text
fpga\vivado\.build\lmem_syn
```

The generated project stays under `fpga/vivado/.build`. During Vivado execution
the PowerShell entry point temporarily maps `fpga/vivado/.build` to an unused
short drive letter such as `V:\`, so Vivado sees paths like `V:\lmem_syn` while
the actual files remain in the repository tree. The generated project and BD
names are intentionally short (`lmem` and `lmem_bd`) because Vivado 2018.3 IP
sub-runs can hit the Windows 260-character path limit when long project, BD,
and IP instance names are combined.

Expected TCL marker:

```text
PROJECT_SYNTH_PASS
```

This uses Vivado project-managed `synth_1`, so the BD, module reference, HLS IP,
HLS floating-point subcores, AXI BRAM controllers, and BRAM IP are synthesized
through Vivado's normal IP run dependency graph.

## Run Behavioral Simulation

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_sim.ps1
```

Default generated project directory:

```text
fpga\vivado\.build\lmem_sim
```

Expected testbench marker:

```text
[tb_lmem_bd_smoke] PASS
```

The simulation configures `KERNEL_SEL=4`, zero base addresses, and
`SCAN_COUNT=0`, then checks that the controller reaches DONE with
`ERROR=0` and `RUN_COUNT=1`. This is a data-plane smoke test that verifies the
real HLS IP has responsive internal AXI BRAM targets; it is not a golden
numeric comparison.

## Run Golden RTL Simulation

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_golden_sim.ps1
```

Default generated project directory:

```text
fpga\vivado\.build\lmem_golden_sim
```

Default generated image directory:

```text
fpga\vivado\.build\golden_frame_000001_n64
```

The golden flow creates simulation-only memory images from
`fpga/golden/localization/frame_000001`, then instantiates `slam_accel_ctrl`,
the generated HLS RTL top, and five behavioral AXI memory models. The default
run is bounded to `-MaxPoints 64` and stops after elaboration plus memory
preload smoke. Add `-RunNumeric` for the long numeric run; use `-FullFrame`
only for an explicit full-frame long run.

The full frame requires a 60,932,096-byte obs-cell image, so it is not a
synthesizable BRAM preload for 7Z100. It is kept as a simulator memory image
only. Vivado 2018.3 XSim can elaborate the generated HLS floating-point RTL and
load the memory images, but the numeric run is currently blocked by simulator
runtime: even the bounded 64-point run exceeded 15 minutes while still inside
the HLS floating-point datapath. The existing BD smoke simulation remains the
fast RTL integration check for this harness.

## Run Tiny Synthetic RTL Numeric Simulation

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_synthetic_sim.ps1
```

Default generated project directory:

```text
fpga\vivado\.build\lmem_synthetic_sim
```

Default generated image directory:

```text
fpga\vivado\.build\synthetic_tiny
```

This flow builds a one-point synthetic fixture with one active block, 256 obs
cells, one valid cell, and identity pose. It reuses `tb_lmem_golden.sv` and the
behavioral AXI memory model, but runs with `-RunNumeric` by default. Expected
testbench marker:

```text
[tb_lmem_golden] PASS
```

This is the current fast numeric RTL gate for the real generated HLS RTL plus
`slam_accel_ctrl` direct-control path. It does not replace full golden replay;
the full/bounded golden numeric run remains documented as an XSim runtime-limited
long-run path.

## Reports

The PowerShell entry points copy text-friendly logs and report summaries to:

```text
reports/fpga/vivado/slam_accel_hls_mem_harness
```
