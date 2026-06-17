# slam_accel_hls_ip_bd

Script-generated Vivado block design skeleton for integrating the real
`unified_surfel_observation_core` HLS IP with the single AXI-Lite
`slam_accel_ctrl` controller.

This is not a board-level project. It does not instantiate XDMA, DDR
interconnect, PS, implementation runs, bitstream generation, or board files.

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
- HLS `m_axi_gmem0..4` ports are exposed as external AXI master interfaces.
  They are intentionally not connected to DDR, SmartConnect, or XDMA in this
  stage.

## Run BD Validate

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_bd_validate.ps1
```

Default generated project directory:

```text
%TEMP%\lightning_slam_accel_hls_ip_bd
```

Expected TCL marker:

```text
BD_VALIDATE_PASS
```

## Run OOC Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_ooc_synth.ps1
```

Default generated project directory:

```text
%TEMP%\lightning_slam_accel_hls_ip_bd_ooc
```

OOC synthesis is attempted only to check whether Vivado 2018.3 accepts this
external-memory-interface skeleton without project-managed IP runs. Current
Vivado HLS 2018.3 exports floating-point subcore XCI files with synthesis
checkpoint generation locked off, so this path may be blocked by unresolved
HLS floating-point subcores.

## Run Project-Managed Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_ip_bd\run_vivado_project_synth.ps1
```

Default generated project directory:

```text
%TEMP%\lightning_slam_accel_hls_ip_bd_project_synth
```

Expected TCL marker:

```text
PROJECT_SYNTH_PASS
```

This uses Vivado project-managed `synth_1`, so the BD, module reference, HLS IP,
and HLS floating-point subcores are synthesized through Vivado's normal IP run
dependency graph.

## Reports

The PowerShell entry points copy text-friendly logs and report summaries to:

```text
reports/fpga/vivado/slam_accel_hls_ip_bd
```
