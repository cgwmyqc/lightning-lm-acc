# synthetic_tiny status

Date: 2026-06-17

## Status

- Synthetic image generation: PASS (`SYNTHETIC_IMAGE_PASS`)
- Synthetic RTL numeric simulation: PASS (`[tb_lmem_golden] PASS`)
- BD validate regression: PASS (`BD_VALIDATE_PASS`)
- BRAM smoke simulation regression: PASS (`[tb_lmem_bd_smoke] PASS`)
- Project-managed synthesis regression: PASS (`PROJECT_SYNTH_PASS`, `SYNTH_1_STATUS=synth_design Complete!`)
- Ignore hygiene: PASS (`fpga/vivado/.build/`, `fpga/golden/`, and Python `__pycache__/` are ignored/generated-only)

## Command

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_hls_mem_harness\run_vivado_synthetic_sim.ps1
```

## Fixture

- scan points: 1
- active blocks: 1
- obs cells: 256
- valid cells: 1
- pose: identity
- expected counts: 1 / 0 / 0
- generated image directory: `fpga/vivado/.build/synthetic_tiny`

## Numeric Result

- counts: 1 / 0 / 0
- max_abs: `2.980232227667301e-09`
- max_rel: `2.980232227667301e-09`
- tolerance: `abs <= 1e-4` or `rel <= 1e-3`
- XSim finish time: `29995 ns`

## Logs

- `synthetic_image_summary.md`
- `vivado_synthetic_sim_log.txt`
- `xsim_synthetic_simulate_log.txt`
- `xsim_synthetic_xvlog_log.txt`

## Notes

This fixture validates the real generated HLS RTL, `slam_accel_ctrl`
direct-control path, direct scalar address ports, output field address wiring,
and behavioral AXI memory model numeric path. It does not replace full golden
replay; full/bounded golden RTL numeric simulation remains runtime-blocked in
Vivado 2018.3 XSim and is not used as the per-change gate.

Python `__pycache__/` is ignored because the synthetic generator imports shared
helpers from `make_golden_mem_images.py`.
