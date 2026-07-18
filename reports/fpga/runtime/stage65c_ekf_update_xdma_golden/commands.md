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
test -x ./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden
```

Orin base gate:

```bash
mkdir -p reports/fpga/runtime/stage65c_ekf_update_xdma_golden

lspci -nnk -s 0005:01:00.0 | tee reports/fpga/runtime/stage65c_ekf_update_xdma_golden/xdma_gate.log
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta' | tee -a reports/fpga/runtime/stage65c_ekf_update_xdma_golden/xdma_gate.log
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 | tee -a reports/fpga/runtime/stage65c_ekf_update_xdma_golden/xdma_gate.log
cat /sys/bus/pci/devices/0005:01:00.0/enable | tee -a reports/fpga/runtime/stage65c_ekf_update_xdma_golden/xdma_gate.log
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link|offline|reset|recovery|frozen' | tail -n 120 | tee reports/fpga/runtime/stage65c_ekf_update_xdma_golden/journal_before.log

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000 2>&1 | tee reports/fpga/runtime/stage65c_ekf_update_xdma_golden/shim_reg_smoke.log
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke 2>&1 | tee reports/fpga/runtime/stage65c_ekf_update_xdma_golden/ddr_smoke.log
```

Orin EKF update golden:

```bash
sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden \
  --golden_dir fpga/golden/mapping_update/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --verify_readback \
  --output_dir reports/fpga/runtime/stage65c_ekf_update_xdma_golden \
  2>&1 | tee reports/fpga/runtime/stage65c_ekf_update_xdma_golden/ekf_update_xdma.log

journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|offline|frozen' | tail -n 120 | tee reports/fpga/runtime/stage65c_ekf_update_xdma_golden/journal_tail.log
```

Observed markers:

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
MAPPING_EKF_UPDATE_XDMA_START_PASS
MAPPING_EKF_UPDATE_XDMA_DONE_PASS
MAPPING_EKF_UPDATE_XDMA_NUMERIC_PASS
MAPPING_EKF_UPDATE_XDMA_PASS
```
