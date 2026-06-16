# NDT vs SURFEL_CPU_SIM Short Bag Commands

## Inputs

- Bag: `/home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3`
- Map: `/home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/`
- Base config: `config/default_livox.yaml`

## Temporary Configs

The comparison used temporary configs under `/tmp`:

- `/tmp/lightning_livox_ndt_compare.yaml`
- `/tmp/lightning_livox_cpu_sim_compare.yaml`

NDT config forces:

```yaml
fpga:
  enable: false
  localization:
    enable: false
```

CPU_SIM config forces:

```yaml
fpga:
  enable: true
  mapping:
    enable: true
    mode: cpu_sim
  localization:
    enable: true
    mode: cpu_sim
```

## Run Commands

NDT baseline:

```bash
timeout --signal=SIGKILL 45s bash -lc \
  'source install/setup.bash && exec ros2 run lightning run_loc_offline \
    --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
    --config /tmp/lightning_livox_ndt_compare.yaml \
    --map_path /home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/ \
    --logtostderr=1' \
  2>&1 | rg --line-buffered -i \
  "mapping_backend|\\[LidarLoc\\] backend|PGO received LidarLoc|confidence:|surfel CPU_SIM|fallback to NDT|ERROR|FATAL|Aborted|Assertion" \
  | tee /tmp/lightning_compare_ndt.log
```

SURFEL_CPU_SIM:

```bash
timeout --signal=SIGKILL 45s bash -lc \
  'source install/setup.bash && exec ros2 run lightning run_loc_offline \
    --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
    --config /tmp/lightning_livox_cpu_sim_compare.yaml \
    --map_path /home/hit/Cheng/FPGA_ACC/lightning-lm-acc/data/new_map/ \
    --logtostderr=1' \
  2>&1 | rg --line-buffered -i \
  "mapping_backend|\\[LidarLoc\\] backend|PGO received LidarLoc|confidence:|surfel CPU_SIM|fallback to NDT|surfel CPU_SIM failed|ERROR|FATAL|Aborted|Assertion" \
  | tee /tmp/lightning_compare_cpu_sim.log
```

## Artifacts

Tracked baseline artifacts:

- `report.md`
- `summary.json`
- `commands.md`

Raw logs are intentionally not tracked by default:

- `/tmp/lightning_compare_ndt.log`
- `/tmp/lightning_compare_cpu_sim.log`

If logs must be preserved locally, copy them to a local-only `logs/` directory under this report folder.
