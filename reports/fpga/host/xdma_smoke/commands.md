# XDMA Host Smoke Preparation Commands

## Windows Static Checks

```powershell
python fpga\host\xdma_smoke\validate_address_map.py --report reports\fpga\host\xdma_smoke\address_map_validation.md

python fpga\host\xdma_smoke\xdma_smoke.py --help

python fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py --out-dir fpga\vivado\.build\host_synthetic_tiny --report-dir reports\fpga\host\xdma_smoke\tiny_synthetic

python -m py_compile fpga\host\xdma_smoke\address_map.py fpga\host\xdma_smoke\validate_address_map.py fpga\host\xdma_smoke\make_tiny_synthetic_host_image.py fpga\host\xdma_smoke\xdma_smoke.py
```

## Board Skeleton Recheck

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1

powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
```

## Future Orin Smoke

These commands require a programmed board and Linux XDMA device nodes.

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --ddr-smoke

python3 fpga/host/xdma_smoke/xdma_smoke.py --write-image fpga/vivado/.build/host_synthetic_tiny/manifest.json

python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --start-zero
```
