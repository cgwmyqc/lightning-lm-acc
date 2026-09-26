# PCIe Gen2 x4 Field Checklist

Date: 2026-09-26
Target: Jetson AGX Orin Developer Kit + AX7Z100 carrier/core board
Current result: endpoint present at Gen2 x1; target is Gen2 x4

Keep MID360 disconnected until this checklist, the ten-cycle recovery gate, and
the four Golden suites pass. The lidar is not involved in PCIe link training.

## Confirmed Software Facts

- Orin root port: `141a0000.pcie`, PCI domain `0005`, status `okay`.
- Live Device Tree: `num-lanes=8`; the root port is not configured as x1.
- Root-port capability: Gen4 x8; current link: Gen2 x1.
- FPGA endpoint capability: Gen2 x4; current link: Gen2 x1.
- A controlled X2 image advertised Gen2 x2 but also trained only x1. Logical
  lane 1 is the first unavailable expansion lane.
- FPGA endpoint `0005:01:00.0` binds to `xdma`; user/H2C/C2H/event nodes exist.
- XDMA must retain `enable_lane_reversal=true`. The `false` diagnostic image
  did not enumerate after either hot recovery or a cold boot.

## Confirmed Lane Mapping

The board intentionally reverses the four lanes while preserving P/N polarity.
The XDMA lane-reversal setting compensates for this routing.

| PCIe slot signal | Slot pins | Carrier net | J30 pins | FPGA Bank112 lane | FPGA package P/N |
|---|---|---|---|---|---|
| RC TX lane 0 | B14/B15 PETp0/n0 | `PCIE_RX0_P/N` | 52/50 P/N | RX3 | P6/P5 |
| RC TX lane 1 | B19/B20 PETp1/n1 | `PCIE_RX1_P/N` | 46/44 P/N | RX2 | T6/T5 |
| RC TX lane 2 | B23/B24 PETp2/n2 | `PCIE_RX2_P/N` | 40/38 P/N | RX1 | U4/U3 |
| RC TX lane 3 | B27/B28 PETp3/n3 | `PCIE_RX3_P/N` | 34/32 P/N | RX0 | V6/V5 |
| FPGA TX lane 0 | A16/A17 PERp0/n0 | `PCIE_TX0_P/N` | 51/49 P/N | TX3 | N4/N3 |
| FPGA TX lane 1 | A21/A22 PERp1/n1 | `PCIE_TX1_P/N` | 45/43 P/N | TX2 | P2/P1 |
| FPGA TX lane 2 | A25/A26 PERp2/n2 | `PCIE_TX2_P/N` | 39/37 P/N | TX1 | R4/R3 |
| FPGA TX lane 3 | A29/A30 PERp3/n3 | `PCIE_TX3_P/N` | 33/31 P/N | TX0 | T2/T1 |
| REFCLK | A13/A14 P/N | `PCIE_CLK_P/N` | 57/55 P/N | CLK0 | N8/N7 |
| PERST# | A11 | `PCIE_PERST` | carrier routing | `pcie_rst_n` | AB22 |

Sources:

- `hardware/01_SCH/AX7Z035B_AX7Z100B_SCH.pdf`, sheets 2 and 13.
- `hardware/01_SCH/AC7Z100B_SCH.pdf`, sheets 8 and 15.
- `fpga/vivado/xdma_restore_chain/restore_pcie.xdc`.

## Power-Off Inspection

1. Shut down Orin, remove Orin input power, and remove any separate FPGA-board
   power. Wait until all board LEDs are off.
2. Keep MID360 and other optional peripherals disconnected.
3. Reseat the PCIe card/adapter and both ends of every PCIe cable. Inspect for
   incomplete insertion, bent contacts, damaged cable pairs, or loose board
   standoffs.
4. Compare lanes 1-3 with the known-training lane 0. Check each P and N route
   from the slot through the carrier connector to the Bank112 package pins in
   the table above.
5. Do not expect DC continuity through the complete FPGA-TX path: carrier sheet
   13 contains AC-coupling capacitors C278-C285. Check each side of those
   capacitors separately and compare component population across all lanes.
6. Verify that P stays P and N stays N. Lane order must remain reversed as
   documented; do not rewire it to straight-through while XDMA lane reversal is
   enabled.

Record exactly one physical change per attempt:

| Change ID | Single change | Visual/continuity result | Cold-boot link | Decision |
|---|---|---|---|---|
| `baseline_before_reseat` | none | pending | Gen2 x1 | FAIL |
| `reseat_01` | power-off reseat only | continuity not measured | Gen2 x1 | FAIL |
| `vendor_x2_01` | X2 diagnostic image | endpoint MaxWidth x2 | Gen2 x1 | FAIL; inspect logical lane 1 |
| `vendor_x4_restore_01` | restore default X4 image | endpoint MaxWidth x4 | Gen2 x1 | FAIL; baseline restored |
| `cable_swap_01` | known-good cable/adapter | pending | pending | pending |

## Powered Measurements

Only probe the powered board with suitable differential/high-impedance
equipment and a known ground reference.

1. Confirm 100 MHz differential REFCLK at FPGA N8/N7.
2. Confirm PERST# at AB22 is asserted during reset and released before link
   training.
3. Compare receive activity on Bank112 RX2 (`T6/T5`, logical lane 1) with the
   known-working RX3 (`P6/P5`, logical lane 0). Then compare TX2 (`P2/P1`) with
   TX3 (`N4/N3`).
4. Capture the measurement setup and the exact Change ID; do not change the
   cable, Device Tree, and FPGA image in the same attempt.

## Test After Each Change

1. Program the default Stage A2 image with lane reversal enabled and skip hot
   recovery:

   ```powershell
   .\tools\windows\21_program_jtag.ps1 `
     -Bitstream .\fpga\vivado\.build\xdma_restore_stage_a2_impl\xdma_restore_stage_a2.runs\impl_1\xdma_restore_stage_a2_wrapper.bit `
     -SkipPcieRecovery
   ```

2. Completely power-cycle the Orin and FPGA path.
3. Record the attempt:

   ```powershell
   .\tools\windows\29_pcie_link_diagnostics.ps1 -ChangeId reseat_01
   ```

4. Stop if the result is not Gen2 x4. Do not run XDMA payload, Golden, or
   benchmark tests on a failed attempt.
5. After Stage A2 reaches Gen2 x4, restore the full NMA bitstream, confirm one
   full-NMA Gen2 x4 recovery, and run the ten-cycle stability gate.

## XDMA Access Setup

The current device nodes are `root:root 0600`, so the non-root Golden and
benchmark runners cannot use them yet. Install the dedicated group rule once on
Orin from an interactive terminal:

```bash
cd /home/hit/Cheng/FPGA_ACC/lightning-lm-acc
sudo bash tools/orin/install_xdma_access.sh hit
```

Reconnect SSH and require `xdma` in `id -nG`; the XDMA nodes must then be
`root:xdma 0660`. This grants device access without restoring unrestricted
passwordless sudo.

After the Stage A2 cold-boot diagnostic reports Gen2 x4, finish the automated
R0 sequence with:

```powershell
.\tools\windows\37_complete_r0_after_x4.ps1 -ChangeId reseat_01
```

The script is fail-fast and will not run payload or Golden tests if the link or
device permissions are incorrect.

## Acceptance Order

1. Stage A2 cold boot: Gen2 x4.
2. Full NMA cold boot and hot recovery: Gen2 x4.
3. Ten consecutive JTAG/recovery cycles: PASS.
4. XDMA payload matrix and BAR/register smoke: PASS.
5. Four Golden suites, three runs each: PASS.
6. Only then attach MID360 or run the 100+500-frame rosbag benchmark.
