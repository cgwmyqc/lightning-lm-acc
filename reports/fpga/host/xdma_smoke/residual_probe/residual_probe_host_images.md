# Stage 42 Residual Probe Host Images

- marker: `HOST_RESIDUAL_PROBE_IMAGES_PASS`
- generated_dir: `fpga/vivado/.build/host_residual_probe`

| Case | Expected counts | Purpose |
| --- | ---: | --- |
| `valid_only` | `1/0/0` | baseline valid cell |
| `reject_z_only` | `0/1/0` | residual > 0.3 through normal_z/plane_d |
| `reject_x_only` | `0/1/0` | residual > 0.3 through normal_x/plane_d |
| `miss_only` | `0/0/1` | no valid cell at target index |
| `invalid_flag_only` | `0/0/1` | cell present but flags=0 |

## Orin commands

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/valid_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_z_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_x_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/miss_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/invalid_flag_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

Each probe must print `HLS_MANIFEST_NUMERIC_PASS`.

## Orin Result 2026-06-20

- XDMA gate: PASS.
- Host image generation: PASS, marker `HOST_RESIDUAL_PROBE_IMAGES_PASS`.
- BAR shim/control register: PASS, markers `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`.
- DDR path: PASS, marker `DDR_SMOKE_PASS`.
- HLS start/done: PASS for all five probes.
- Numeric compare: PASS for `valid_only`, `miss_only`, `invalid_flag_only`; FAIL for `reject_z_only` and `reject_x_only`.

| Case | Expected | Actual | Result |
| --- | ---: | ---: | --- |
| `valid_only` | `1/0/0` | `1/0/0` | PASS |
| `reject_z_only` | `0/1/0` | `1/0/0` | FAIL |
| `reject_x_only` | `0/1/0` | `1/0/0` | FAIL |
| `miss_only` | `0/0/1` | `0/0/1` | PASS |
| `invalid_flag_only` | `0/0/1` | `0/0/1` | PASS |

Key normal-equation dumps:

```text
valid_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,1,2.25,-1.25,0,5.0625,-2.8125,0,1.5625,0,0]
valid_only ACTUAL_B=[0,0,0.04999995231628418,0.1124998927116394,-0.062499940395355225,0]
reject_z_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
reject_z_only ACTUAL_B=[0,0,0,0,0,0]
reject_x_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
reject_x_only ACTUAL_B=[0,0,0,0,0,0]
miss_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
invalid_flag_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
```

Stage 42 result: HLS residual outlier samples skip H/b accumulation, but are counted as valid instead of reject. This points to the reject branch counter/classification logic, not the DDR layout, flags offset, miss path, or normal field order.
