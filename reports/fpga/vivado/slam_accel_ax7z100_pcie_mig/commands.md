# AX7Z100 PCIe/MIG Board Skeleton Commands

## Static Board Profile

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1
```

Result: `BOARD_PROFILE_PASS`

Pin/reset conclusion:

```text
pcie_rst_n = AB22
pcie_ref_clk_p/n = N8/N7
sys_clk_p/n = F9/E8
No physical-button reset constraint was found in the current XDC.
```

## BD Validate

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
```

Result: `BD_VALIDATE_PASS`

Default generated project directory:

```text
fpga/vivado/.build/azmig_bd
```

## Project-Managed Synthesis

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
```

Default jobs: `18`. Use `-Jobs N` only when machine resources require a lower
value.

Result:

```text
SYNTH_1_STATUS=synth_design Complete!
PROJECT_SYNTH_PASS
Synthesis finished with 0 errors, 0 critical warnings and 14 warnings.
```

Default generated project directory:

```text
fpga/vivado/.build/azmig_syn
```

## Implementation And Bitstream

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Default jobs: `18`. The Tcl flow launches both `synth_1` and `impl_1` with the
same jobs value.

Result:

```text
SYNTH_1_STATUS=synth_design Complete!
IMPL_1_STATUS=write_bitstream Complete!
IMPLEMENTATION_BITSTREAM_PASS
```

Default generated project directory:

```text
fpga/vivado/.build/azmig_impl
```

Generated bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
```

## HLS IP Export Path

The board-level scripts now default the HLS IP export project to:

```text
fpga/vivado/.build/hls_unified_obs
```

The PowerShell wrapper uses the existing temporary short-drive mapping when
invoking Vivado HLS, so the generated files remain under `fpga/vivado/.build/`
while Vivado 2018.3 sees a short path such as `V:/hls_unified_obs`.

## Windows JTAG Programming Preparation

Use `hw_server` + `xsdb` over JTAG for temporary programming. This is not Flash
programming and it is not persistent after power-off.

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Expected result:

```text
JTAG_PROGRAM_PASS
```

Observed result on 2026-06-17:

```text
FPGA_STATE=FPGA is configured
DONE PIN: 1
JTAG_PROGRAM_PASS
```

## Reset Topology Fix Run

Change:

```text
pcie_rst_n -> xdma_0/sys_rst_n only
mig_rst_hi/dout -> mig_7series_0/sys_rst
```

MIG `sys_rst` is no longer driven by PCIe PERST#. The fixed flow was rerun with:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Observed result on 2026-06-17 after the reset fix:

```text
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
DONE PIN: 1
```

Timing note:

```text
WNS=-0.234 ns
TNS=-3.143 ns
Setup failing endpoints=193
Timing constraints are not met.
```

This bitstream is suitable for PCIe reset/enumeration experiments, but not yet
for reliable accelerator functional validation.

## Orin Enumeration Retest

Run after JTAG programming while AX7Z100 remains powered and configured:

```bash
sudo reboot
lspci -nn | grep -Ei '10ee|7024|xilinx|memory|serial'
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee'
```

If no `10ee:7024` appears, the next checks are PCIe 100 MHz refclk, PERST#
release on `AB22`, lane wiring/orientation, and Orin root-port enablement.

## Lane Reversal Bring-Up Run

Hardware review on 2026-06-19 indicates the PCIe x4 lane order is likely
reversed between the slot and FPGA Bank112. XDMA is now configured with:

```text
CONFIG.enable_lane_reversal {true}
```

Rerun:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Required generated-IP check:

```text
PARAM_VALUE.enable_lane_reversal = true
```

Observed result on 2026-06-19:

```text
BD_VALIDATE_PASS
PROJECT_SYNTH_PASS
IMPLEMENTATION_BITSTREAM_PASS
JTAG_PROGRAM_PASS
Generated XDMA XCI: PARAM_VALUE.enable_lane_reversal=true
FPGA_STATE=FPGA is configured
DONE PIN: 1
```

Generated bitstream:

```text
fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit
BITSTREAM_SIZE_BYTES=7638099
```

Timing note remains:

```text
WNS=-0.234 ns
TNS=-3.143 ns
Setup failing endpoints=193
Timing constraints are not met.
```

Use this bitstream only for PCIe enumeration bring-up. It is not yet a reliable
accelerator functional-validation image.

## Orin XDMA Driver Bring-Up

Observed after the lane-reversal bitstream:

```text
0005:01:00.0 Serial controller: Xilinx Corporation Device 7024
```

This means PCIe enumeration is now working. Missing `/dev/xdma*` nodes normally
means the Orin Linux XDMA driver is not loaded, not bound, or did not create
device nodes.

Check on Orin:

```bash
lspci -nn -s 0005:01:00.0 -vvv
dmesg | grep -Ei 'pcie|pci|aer|link|xdma|xilinx|10ee|7024'
lsmod | grep -i xdma
modinfo xdma 2>/dev/null || true
ls -l /dev/xdma*
dmesg | grep -Ei 'xdma|10ee|7024'
```

Expected before host smoke:

```text
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
```

Then run:

```bash
python3 fpga/host/xdma_smoke/xdma_smoke.py --reg-smoke --ddr-smoke
```

## XDMA BAR Convergence Run

After the X4 XDMA-only diagnostic bitstream produced `/dev/xdma0_*` on Orin,
the full `azmig` design was regenerated with only the manual MSI-X BAR
indicator overrides removed from the source Tcl:

```text
Removed CONFIG.pf0_msix_cap_pba_bir {BAR_1}
Removed CONFIG.pf0_msix_cap_table_bir {BAR_1}
```

Rerun:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```

Observed result on 2026-06-20:

```text
BD_VALIDATE_PASS
VIVADO_RUN_JOBS=18
PROJECT_SYNTH_PASS
SYNTH_1_STATUS=synth_design Complete!
IMPL_1_STATUS=write_bitstream Complete!
IMPLEMENTATION_BITSTREAM_PASS
BITSTREAM_SIZE_BYTES=7638099
JTAG_PROGRAM_PASS
FPGA_STATE=FPGA is configured
DONE PIN: 1
```

Timing remains unchanged:

```text
WNS=-0.234 ns
TNS=-3.143 ns
Setup failing endpoints=193
WHS=0.038 ns
THS=0.000 ns
Hold failing endpoints=0
```

This image is the next full-design Orin bring-up candidate. Orin must now
reboot while AX7Z100 stays powered/configured, then check whether
`/dev/xdma0_*` is also created by the full MIG/HLS design.

## Stage 44 Output Words Fix 2026-06-21

Formal board image regenerated with the Stage 44 HLS IP. The BD now connects `ctrl_0/unified_obs_output_addr` to `unified_obs_0/output_words`; old per-field output direct ports are not connected.

Commands:

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_bd_validate.ps1
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1 -Jobs 18
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1 -Jobs 18
```

Results:

- BD validate: PASS.
- Project synthesis: PASS.
- Implementation/bitstream: PASS.
- Bitstream: `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`.
- Timing: WNS `-0.132 ns`, WHS `0.045 ns`; use as function-validation bitstream only.
- Route status: 0 routing errors.
- DRC: 0 errors; warnings/advisories remain.

Next Orin gate: JTAG program the new bitstream, reboot Orin, run shim/reg, DDR, Stage 42 residual probes, then Stage 41 multi-cell and Stage 40 n64 golden if probes pass.
