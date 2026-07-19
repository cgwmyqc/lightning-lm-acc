# Stage66 EKF Update Stability Commands

Purpose: run repeated `KERNEL_SEL=5` EKF update transactions on Orin after
Stage65C single-shot golden PASS.

```bash
colcon build --packages-select lightning
source install/setup.bash

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke

sudo ./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden \
  --golden_dir fpga/golden/mapping_update/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 50 \
  --output_dir reports/fpga/runtime/stage66_ekf_update_stability
```

Expected markers:

```text
MAPPING_EKF_UPDATE_REPEAT_ITER_PASS 1/50
...
MAPPING_EKF_UPDATE_REPEAT_ITER_PASS 50/50
MAPPING_EKF_UPDATE_REPEAT_PASS repeat=50
```

Kernel log check:

```bash
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link' | tail -n 160
```
