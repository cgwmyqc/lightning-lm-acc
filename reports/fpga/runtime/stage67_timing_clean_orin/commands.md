# Stage67 Timing-Clean Orin Regression Commands

Date: 2026-07-19

Assumption: Stage67 timing-clean `azmig_wrapper.bit` has been programmed by JTAG and Orin has rebooted.

```bash
mkdir -p reports/fpga/runtime/stage67_timing_clean_orin/loc_v2
mkdir -p reports/fpga/runtime/stage67_timing_clean_orin/ekf_update_repeat

lspci -nnk -s 0005:01:00.0 | tee reports/fpga/runtime/stage67_timing_clean_orin/xdma_gate.log
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta' | tee -a reports/fpga/runtime/stage67_timing_clean_orin/xdma_gate.log
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 | tee -a reports/fpga/runtime/stage67_timing_clean_orin/xdma_gate.log
cat /sys/bus/pci/devices/0005:01:00.0/enable | tee -a reports/fpga/runtime/stage67_timing_clean_orin/xdma_gate.log
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link|offline|reset|recovery|frozen' | tail -n 120 | tee reports/fpga/runtime/stage67_timing_clean_orin/journal_before.log
sudo lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta' | tee -a reports/fpga/runtime/stage67_timing_clean_orin/xdma_gate.log

colcon build --packages-select lightning
source install/setup.bash

test -x ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden
test -x ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden
test -x ./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000 2>&1 | tee reports/fpga/runtime/stage67_timing_clean_orin/shim_reg_smoke.log
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke 2>&1 | tee reports/fpga/runtime/stage67_timing_clean_orin/ddr_smoke.log

sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_loc_xdma_golden \
  --golden_dir fpga/golden/localization/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates \
  --repeat 1 \
  --output_dir reports/fpga/runtime/stage67_timing_clean_orin/loc_v2 \
  2>&1 | tee reports/fpga/runtime/stage67_timing_clean_orin/loc_v2.log

sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_surfel_mapping_xdma_golden \
  --golden_dir fpga/golden/mapping/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --abi_v2_candidates \
  2>&1 | tee reports/fpga/runtime/stage67_timing_clean_orin/mapping_v2.log

sudo -n env LD_LIBRARY_PATH="$LD_LIBRARY_PATH" AMENT_PREFIX_PATH="$AMENT_PREFIX_PATH" PATH="$PATH" \
  ./install/lightning/lib/lightning/run_mapping_ekf_update_xdma_golden \
  --golden_dir fpga/golden/mapping_update/frame_000001 \
  --ctrl_base 0x1000 \
  --timeout_sec 120 \
  --repeat 50 \
  --output_dir reports/fpga/runtime/stage67_timing_clean_orin/ekf_update_repeat \
  2>&1 | tee reports/fpga/runtime/stage67_timing_clean_orin/ekf_update_repeat.log

journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|offline|frozen' | tail -n 120 | tee reports/fpga/runtime/stage67_timing_clean_orin/journal_tail.log
```

Observed markers:

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
XDMA_CPP_GOLDEN_NUMERIC_PASS
MAPPING_XDMA_REPLAY_PASS
MAPPING_EKF_UPDATE_REPEAT_PASS repeat=50
```
