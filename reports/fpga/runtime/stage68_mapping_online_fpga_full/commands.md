# Stage68 Mapping FPGA_FULL Online Smoke Commands

## Build

```bash
colcon build --packages-select lightning
source install/setup.bash
```

## XDMA Gate And Smoke

```bash
lspci -nnk -s 0005:01:00.0
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta'
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
cat /sys/bus/pci/devices/0005:01:00.0/enable
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

## Golden Regression

```bash
./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates

./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden \
  --golden_dir fpga/golden/mapping_update/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 50 \
  --output_dir reports/fpga/runtime/stage68_mapping_online_fpga_full/ekf_update_repeat
```

## Online-Path Smoke With Temporary Config

The smoke used `/tmp/stage68_fpga_full_livox.yaml`, copied from
`config/default_livox.yaml` and changed only for this test:

```yaml
fpga:
  enable: true
  runtime:
    candidate_abi_v2: true
  mapping:
    enable: true
    mode: fpga_full
    fallback: cpu
  localization:
    enable: false

fasterlio:
  max_iteration: 1
  enable_icp_part: false
  use_aa: false

system:
  with_loop_closing: false
  with_ui: false
```

Command:

```bash
timeout 75s ./install/lightning/lib/lightning/run_slam_offline \
  --input_bag /home/hit/Cheng/FPGA_ACC/mid360_20260313_outdoor_30deg_up_quan_03_0.db3 \
  --config /tmp/stage68_fpga_full_livox.yaml \
  2>&1 | tee reports/fpga/runtime/stage68_mapping_online_fpga_full/online_slam_fpga_full_smoke.log
```

The timeout exit status was `124`, which means the controlled smoke stopped by
time limit after collecting enough frames.

