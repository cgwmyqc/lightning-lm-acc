# Stage56 Mapping Online FPGA_OBS Smoke Commands

## Temporary Config

```bash
python3 - <<'PY'
from pathlib import Path
import yaml
src = Path('config/default_livox.yaml')
out = Path('/tmp/lightning_stage55_mapping_fpga_obs.yaml')
data = yaml.safe_load(src.read_text())
data['fpga']['enable'] = True
data['fpga']['mapping']['enable'] = True
data['fpga']['mapping']['mode'] = 'fpga_obs'
data['fpga']['mapping']['fallback'] = 'cpu'
data['fpga']['localization']['enable'] = False
data['fasterlio']['enable_icp_part'] = False
out.write_text(yaml.safe_dump(data, sort_keys=False), encoding='utf-8')
print(out)
PY
```

## Online Smoke

```bash
source install/setup.bash
timeout --signal=SIGKILL 60s sudo -n env \
  LD_LIBRARY_PATH="$LD_LIBRARY_PATH" \
  AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" \
  PATH="$PATH" \
  ./install/lightning/lib/lightning/run_slam_offline \
    --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
    --config /tmp/lightning_stage55_mapping_fpga_obs.yaml \
  2>&1 | tee /tmp/lightning_stage55_mapping_fpga_obs.log
```

The smoke was manually interrupted after enough frames were collected because
the timeout did not terminate the sudo child cleanly.

## Log Checks

```bash
python3 - <<'PY'
from pathlib import Path
import re
text = Path('/tmp/lightning_stage55_mapping_fpga_obs.log').read_text(errors='ignore')
success = len(re.findall(r'mapping FPGA_OBS success=1', text))
fallback = len(re.findall(r'mapping FPGA_OBS failed|CPU fallback|fallback_count', text))
errors = len(re.findall(r'HLS timeout|HLS entered error|failed to open|CmpltTO|AER|Failed to detect XDMA config BAR|FATAL|Aborted|Segmentation', text))
elapsed = [float(x) for x in re.findall(r'xdma_elapsed_sec=([0-9.]+)', text)]
run_counts = re.findall(r'run_count=(\d+)->(\d+)', text)
print(f'success={success}')
print(f'fallback={fallback}')
print(f'errors={errors}')
if elapsed:
    print(f'xdma_elapsed_sec_min={min(elapsed):.6f}')
    print(f'xdma_elapsed_sec_max={max(elapsed):.6f}')
    print(f'xdma_elapsed_sec_mean={sum(elapsed)/len(elapsed):.6f}')
if run_counts:
    print(f'run_count_first={run_counts[0][0]}->{run_counts[0][1]}')
    print(f'run_count_last={run_counts[-1][0]}->{run_counts[-1][1]}')
PY
```

Observed:

```text
success=672
fallback=0
errors=0
xdma_elapsed_sec_min=0.073607
xdma_elapsed_sec_max=0.140664
xdma_elapsed_sec_mean=0.110806
run_count_first=5->6
run_count_last=676->677
```

