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

## Stage 44 Orin result 2026-06-21

The Stage 44 `output_words` bitstream passed all five residual probes:

| Case | Expected counts | Actual counts | Result |
| --- | ---: | ---: | --- |
| `valid_only` | `1/0/0` | `1/0/0` | PASS |
| `reject_z_only` | `0/1/0` | `0/1/0` | PASS |
| `reject_x_only` | `0/1/0` | `0/1/0` | PASS |
| `miss_only` | `0/0/1` | `0/0/1` | PASS |
| `invalid_flag_only` | `0/0/1` | `0/0/1` | PASS |

All runs reached:

```text
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
HLS_MANIFEST_NUMERIC_PASS
STATUS=0x00000204
ERROR=0x00000000
```

This confirms the single `uint64_t* output_words` path correctly writes `valid_count`, `reject_count`, and `miss_count` for the single-point fixtures.
