# AX7Z100 PCIe/MIG Board Skeleton Commands

## Static Board Profile

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\validate_board_profile.ps1
```

Result: `BOARD_PROFILE_PASS`

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
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_project_synth.ps1
```

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
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\run_vivado_impl_bitstream.ps1
```

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

## Windows JTAG Programming Preparation

This command is prepared but was not run in this report stage.

```powershell
powershell -ExecutionPolicy Bypass -File .\fpga\vivado\slam_accel_ax7z100_pcie_mig\program_bitstream_jtag.ps1 -Bitstream .\fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit
```
