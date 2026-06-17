# slam_accel_wrapper_sim

Minimal Vivado RTL wrapper simulation/OOC project for the `slam_accel_ctrl` to HLS observation direct-control contract.

This is not the board-level Vivado project. It does not create block design, XDMA, DDR interconnect, or bitstream outputs.

## What It Verifies

- AXI-Lite register writes configure `slam_accel_ctrl`.
- `KERNEL_SEL=4` dispatches unified observation.
- `ap_start` reaches the HLS-side contract.
- `ap_done/ap_idle/ap_ready` return to the controller.
- 32-bit direct scalar address ports are passed through.
- Output field addresses are derived from one `OUT_ADDR`.
- Current HLS error is tied to `32'd0`.
- Error paths for unsupported kernel and non-zero address high words.

The simulation uses a small control-plane mock named `unified_surfel_observation_core_ctrl_mock`. It models only `ap_ctrl_hs` and direct scalar ports. The real Vivado HLS generated IP remains a local artifact under:

```text
%TEMP%\lightning_hls_unified_obs
```

## Run Behavioral Simulation

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_wrapper_sim\run_vivado_sim.ps1
```

Default project directory:

```text
%TEMP%\lightning_slam_accel_wrapper_sim
```

Expected testbench result:

```text
[tb_slam_accel_wrapper_sim] PASS
```

## Run OOC Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_wrapper_sim\run_vivado_ooc_synth.ps1
```

Default project directory:

```text
%TEMP%\lightning_slam_accel_wrapper_ooc
```

