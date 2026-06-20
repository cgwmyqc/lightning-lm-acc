# PCIe Reset And Constraint Review

Date: 2026-06-17

## Conclusion

- No evidence was found that the current AX7Z100 design ties PCIe reset to a
  physical push button.
- Current XDC pins match the ALINX AX7Z100 PCIe reference used for this stage:
  - `pcie_rst_n = AB22`
  - `pcie_ref_clk_p/n = N8/N7`
  - `sys_clk_p/n = F9/E8`
- The BD-level reset topology did differ from the ALINX reference pattern:
  PCIe PERST# was also driving MIG `sys_rst`.
- This has been fixed. PCIe PERST# now drives only XDMA `sys_rst_n`; MIG
  `sys_rst` is held inactive high through `mig_rst_hi`.

## Current Reset Topology

```text
pcie_rst_n / PERST# / AB22 -> xdma_0/sys_rst_n
mig_rst_hi/dout            -> mig_7series_0/sys_rst
mig_7series_0/ui_clk_sync_rst -> rst_mig_ui/ext_reset_in
rst_mig_ui/peripheral_aresetn -> mig_7series_0/aresetn and MIG-side AXI reset
```

MIG `sys_rst` is active low in the current MIG configuration, so constant `1`
is the inactive state.

## Validation

Commands rerun after the fix:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Results:

```text
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
DONE PIN=1
```

Timing status:

```text
WNS=-0.234 ns
TNS=-3.143 ns
Setup failing endpoints=193
Timing constraints are not met.
```

The bitstream can be used for PCIe enumeration experiments, but timing closure
is still required before reliable accelerator validation.

## Orin-Side Checks If Enumeration Still Fails

Run while AX7Z100 stays powered and configured:

```bash
sudo reboot
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

If `10ee:7024` is still absent, prioritize:

- Confirm Orin PCIe root port is enabled in kernel/device tree.
- Confirm Orin/root-complex 100 MHz PCIe reference clock reaches AX7Z100
  `N8/N7`.
- Confirm PERST# reaches AX7Z100 `AB22` and is released high during
  enumeration.
- Confirm lane wiring/orientation and that the first-pass design is Gen2 x4.
- Confirm the board was not power-cycled after JTAG programming.

If `10ee:7024` appears but `/dev/xdma0_*` is missing, switch focus to XDMA
Linux driver loading and device node creation.
