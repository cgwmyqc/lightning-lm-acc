# Stage 42 Residual Reject Probe

## Windows static validation

```powershell
python fpga\host\xdma_smoke\make_residual_probe_host_images.py --out-dir fpga\vivado\.build\host_residual_probe --report-dir reports\fpga\host\xdma_smoke\residual_probe
python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\make_residual_probe_host_images.py fpga\host\xdma_smoke\xdma_smoke.py
python fpga\host\xdma_smoke\xdma_smoke.py --help
```

Expected marker:

```text
HOST_RESIDUAL_PROBE_IMAGES_PASS
```

## Orin gate

```bash
python3 fpga/host/xdma_smoke/make_residual_probe_host_images.py --out-dir fpga/vivado/.build/host_residual_probe --report-dir reports/fpga/host/xdma_smoke/residual_probe
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/valid_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_z_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/reject_x_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/miss_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --hls-manifest fpga/vivado/.build/host_residual_probe/invalid_flag_only/manifest.json --ctrl-base 0x1000 --dump-normal-equation
```

Expected counts:

| Case | Expected |
| --- | ---: |
| `valid_only` | `1/0/0` |
| `reject_z_only` | `0/1/0` |
| `reject_x_only` | `0/1/0` |
| `miss_only` | `0/0/1` |
| `invalid_flag_only` | `0/0/1` |

Each probe must print `HLS_MANIFEST_NUMERIC_PASS`.

## Interpretation

- Reject probes that become valid point to residual threshold or `normal/plane_d` field interpretation.
- `invalid_flag_only` becoming valid points to `ObsCellFloat64.flags` packing or offset.
- x/z reject differences point to `normal_x/y/z` field order or packing.
- All probes passing means Stage 41 fixture or expected recompute should be rechecked.
