# Stage65B Orin Commands

Date: 2026-07-18

Assumption: Stage65B `azmig_wrapper.bit` has been programmed by JTAG and Orin has rebooted.

```bash
mkdir -p reports/fpga/runtime/stage65b_ekf_update_bd_orin

lspci -nnk -s 0005:01:00.0 | tee reports/fpga/runtime/stage65b_ekf_update_bd_orin/xdma_gate.log
lspci -vv -s 0005:01:00.0 | grep -Ei 'LnkCap|LnkSta' | tee -a reports/fpga/runtime/stage65b_ekf_update_bd_orin/xdma_gate.log
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 | tee -a reports/fpga/runtime/stage65b_ekf_update_bd_orin/xdma_gate.log
cat /sys/bus/pci/devices/0005:01:00.0/enable | tee -a reports/fpga/runtime/stage65b_ekf_update_bd_orin/xdma_gate.log
journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|link|offline|reset|recovery|frozen' | tail -n 120 | tee reports/fpga/runtime/stage65b_ekf_update_bd_orin/journal_before.log

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --shim-smoke --reg-smoke --ctrl-base 0x1000 2>&1 | tee reports/fpga/runtime/stage65b_ekf_update_bd_orin/shim_reg_smoke.log

sudo python3 fpga/host/xdma_smoke/xdma_smoke.py --ddr-smoke 2>&1 | tee reports/fpga/runtime/stage65b_ekf_update_bd_orin/ddr_smoke.log

journalctl -k --no-pager | grep -Ei 'xdma|10ee|7024|0005:01:00|CmpltTO|BAR|probe|AER|offline|frozen' | tail -n 120 | tee reports/fpga/runtime/stage65b_ekf_update_bd_orin/journal_tail.log
```

Observed markers:

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```
