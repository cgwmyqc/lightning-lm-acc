# Stage56 Mapping Online FPGA_OBS Smoke Summary

## Result

Stage56 mapping-only online smoke passed on the short bag window.

Temporary config:

```text
/tmp/lightning_stage55_mapping_fpga_obs.yaml
```

Changed keys:

```yaml
fpga:
  enable: true
  mapping:
    enable: true
    mode: fpga_obs
    fallback: cpu
  localization:
    enable: false
fasterlio:
  enable_icp_part: false
```

Observed backend:

```text
[LaserMapping] mapping_backend=FPGA_OBS
```

Smoke statistics from `/tmp/lightning_stage55_mapping_fpga_obs.log`:

```text
mapping FPGA_OBS success frames: 672
mapping FPGA_OBS fallback frames: 0
error markers: 0
xdma_elapsed_sec_min=0.073607
xdma_elapsed_sec_mean=0.110806
xdma_elapsed_sec_max=0.140664
run_count_first=5->6
run_count_last=676->677
```

Representative first and last frames:

```text
success_count=1   scan_points=812 active_blocks=66  active_cells=16896 valid/reject/miss=533/0/279 xdma_elapsed_sec=0.13859 status=0x204 error=0x0 run_count=5->6
success_count=672 scan_points=734 active_blocks=120 active_cells=30720 valid/reject/miss=656/0/78  xdma_elapsed_sec=0.112899 status=0x204 error=0x0 run_count=676->677
```

The process was manually interrupted after sufficient smoke coverage to avoid
running the full bag.

## Interpretation

Stage56 clears the gate for Stage57 joint mapping + localization FPGA_OBS
testing. The next stage should enable both subsystems together and use the XDMA
runtime lock added in Stage55 to serialize shared hardware transactions.

