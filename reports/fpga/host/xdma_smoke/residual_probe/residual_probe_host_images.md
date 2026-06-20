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

## Stage 43 Orin Reboot Retest 2026-06-20 23:34

- Rebooted Orin before retest; XDMA bound cleanly with `enable=1`.
- Base setup passed: `SHIM_SMOKE_PASS`, `REG_SMOKE_PASS`, `DDR_SMOKE_PASS`.
- No new `CmpltTO` or AER recovery failure was observed in the retest log window.

| Case | Expected | Actual | Result |
| --- | ---: | ---: | --- |
| `valid_only` | `1/0/0` | `0/0/0` | FAIL |
| `reject_z_only` | `0/1/0` | `1/0/0` | FAIL |
| `reject_x_only` | `0/1/0` | `1/0/0` | FAIL |
| `miss_only` | `0/0/1` | `0/0/1` | PASS |
| `invalid_flag_only` | `0/0/1` | `0/0/1` | PASS |

Key dump:

```text
valid_only ACTUAL_H_UPPER=[0,0,0,0,0,0,0,0,0,0,0,1,2.25,-1.25,0,5.0625,-2.8125,0,1.5625,0,0]
valid_only ACTUAL_B=[0,0,0.04999995231628418,0.1124998927116394,-0.062499940395355225,0]
```

Stage 43 reboot retest result: residual probes still fail on output count fields, so Stage 41 and Stage 40 were not rerun.
