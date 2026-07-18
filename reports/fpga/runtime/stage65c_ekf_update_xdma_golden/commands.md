# Stage65C EKF Update XDMA Golden Commands

Windows-side implementation completed:

```text
Added XdmaRuntime::RunMappingEkfUpdate()
Added run_mapping_ekf_update_xdma_golden
No HLS/Vivado/bitstream regeneration in Stage65C
```

Orin build:

```bash
colcon build --packages-select lightning
source install/setup.bash
```

Orin base gate:

```bash
lspci -nnk -s 0005:01:00.0
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke
```

Orin EKF update golden:

```bash
sudo ./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden \
  --golden_dir fpga/golden/mapping_update/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --output_dir reports/fpga/runtime/stage65c_ekf_update_xdma_golden
```

