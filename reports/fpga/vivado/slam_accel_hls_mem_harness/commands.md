# slam_accel_hls_mem_harness commands

Run from the repository root.

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_bd_validate.ps1
```

Generated project:

```text
fpga\vivado\.build\lmem_bd
```

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_project_synth.ps1
```

Generated project:

```text
fpga\vivado\.build\lmem_syn
```

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_sim.ps1
```

Generated project:

```text
fpga\vivado\.build\lmem_sim
```

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_golden_sim.ps1 -MaxPoints 64
```

Generated project and images:

```text
fpga\vivado\.build\lmem_golden_sim
fpga\vivado\.build\golden_frame_000001_n64
```

Full-frame long-run entry:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_golden_sim.ps1 -FullFrame -RunNumeric
```

The default golden command performs elaboration plus memory preload smoke only.
Use `-RunNumeric` for the currently runtime-blocked numeric comparison.

Tiny synthetic RTL numeric entry:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_synthetic_sim.ps1
```

Generated project and images:

```text
fpga\vivado\.build\lmem_synthetic_sim
fpga\vivado\.build\synthetic_tiny
```

Expected marker:

```text
[tb_lmem_golden] PASS
```

The PowerShell scripts temporarily map `fpga\vivado\.build` to an unused short
drive letter while Vivado is running. The mapping is removed after the command
exits; the actual project files remain under `fpga\vivado\.build`.

All generated Vivado projects are local build artifacts and are ignored by git.
