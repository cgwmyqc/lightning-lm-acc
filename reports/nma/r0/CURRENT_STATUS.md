# R0 Current Status

Date: 2026-09-26
Branch: `dev-acc`
Overall status: `R0_BLOCKED_AT_PCIE_GEN2_X4_GATE`

R1 and R2 have not started. The first implementation batch remains stopped at
R0 because the endpoint negotiates Gen2 x1 instead of the required Gen2 x4.

## Completed

- Dedicated key-only Orin access and a pinned host key are in use.
- `/usr/local/sbin/lightning-pcie-control` is root-owned and exposes only
  `status`, `recover`, and `reboot`; the former unrestricted sudo rule was
  removed.
- `rosdep` is initialized and the Orin `dev-acc` tree builds successfully with
  `colcon` in `RelWithDebInfo` mode.
- The four Golden suites have a dedicated runner and can no longer be confused
  with benchmark sample collection.
- Per-frame host telemetry now covers candidate build, map export, packing,
  H2C, register access, FPGA cycles/kernel time, host wait, polling overhead,
  C2H, ESKF, total time, CPU use, and fallback reason.
- All three cores passed native CSim, Vivado HLS CSim, C synthesis, and fresh IP
  export. Export paths now match the IP repositories consumed by Vivado.
- Fresh full Vivado synthesis, implementation, timing signoff, and bitstream
  generation passed.
- Full NMA and the XDMA-only Stage A2 diagnostic image both program through
  JTAG with clean FPGA configuration status.
- The Stage A2 flow now accepts an explicit lane-reversal setting. A fresh
  `LaneReversal=false` image passed implementation and was tested on hardware.
- Recovery with no initial BDF performs a rescan instead of assuming a prior
  endpoint exists. A cold Orin reboot with the diagnostic image enumerates and
  binds the XDMA driver.
- The live Orin Device Tree has been audited. Root port `141a0000.pcie` is
  `okay`, reports `num-lanes=8`, and maps to PCI domain `0005`; it is not
  configured as an x1 port.
- Carrier and core-board schematics confirm an intentional full x4 lane-order
  reversal with P/N polarity preserved. The verified slot/J30/Bank112 mapping
  is captured in `PCIE_FIELD_CHECKLIST.md`.
- Read-only per-change PCIe diagnostics, an initial x4 stability gate, and a
  gated XDMA payload/BAR/DDR runner are now available.
- A post-x4 orchestrator fixes the remaining R0 order as full-NMA restore,
  ten recovery cycles, payload/BAR/DDR, four Golden suites repeated three
  times, and report collection.
- All stability, payload, Golden, benchmark, and post-x4 orchestration entry
  points were exercised against the current x1 link and stopped at the x4 gate
  with exit code 14 before touching their data paths.

## Fresh FPGA Baseline

| Metric | Result | Gate | Status |
|---|---:|---:|---|
| Slice LUT | 216,599 / 277,400 = 78.08% | <=72% | FAIL |
| Slice FF | 246,370 / 554,800 = 44.41% | <=65% | PASS |
| DSP | 1,386 / 2,020 = 68.61% | <=65% | FAIL |
| BRAM tile | 146 / 755 = 19.34% | <=75% | PASS |
| WNS | +0.086 ns | >0 ns | PASS |
| WHS | +0.016 ns | >0 ns | PASS |
| Vectorless on-chip power | 9.728 W, low confidence | evidence only | WARN |

`NMA_PRODUCT_RESOURCE_GATE=FAIL` is expected for the current three-core
architecture and must be resolved by the R3-R8 shared architecture. It is
independent of the R0 PCIe failure.

Fresh bitstream:

```text
fpga/vivado/.build/r0_impl/azmig.runs/impl_1/azmig_wrapper.bit
size=12920775
sha256=556a55ca97f02b8332fc9f059651ff16fd947b77be2f25b3585f35edfb10e62f
```

## PCIe Gate

| Image and recovery path | Enumeration | XDMA nodes | Link | Result |
|---|---|---|---|---|
| Full NMA, no initial BDF, hot rescan | missing | no | unavailable | FAIL |
| Stage A2 XDMA-only, no initial BDF, hot rescan | missing | no | unavailable | FAIL |
| Stage A2 XDMA-only, Orin cold reboot | PASS | PASS | Gen2 x1 | FAIL |
| Full NMA, existing BDF, remove/rescan | PASS | PASS | Gen2 x1 | FAIL |
| Stage A2, lane reversal disabled, remove/rescan | missing | no | unavailable | FAIL |
| Stage A2, lane reversal disabled, Orin cold reboot | missing | no | unavailable | FAIL |

The endpoint reports a maximum width of x4 and the Orin root port reports a
maximum width of x8. Both report a current width of x1 at 5.0 GT/s. This rules
out the HLS cores, MIG, BAR shim, and XDMA driver as the primary cause of the
width failure and points to training of lanes 1-3.

Disabling lane reversal prevents enumeration in both hot-recovery and cold-boot
tests. The existing `enable_lane_reversal=true` setting is therefore necessary
for this board path and should remain enabled. The remaining fault domain is
the physical path or platform assignment for lanes 1-3, not the reversal
property itself.

The live Device Tree and root-port capability now rule out an Orin
`num-lanes=1` configuration. The highest-priority checks are connector seating,
cable/adapter continuity, AC-coupling component population, and signal
integrity on the three non-training lane pairs.

The current XDMA character devices are `root:root 0600`. A dedicated `xdma`
group udev installer has been added, but it requires one interactive sudo run
on Orin before non-root payload and Golden tests can execute.

## Intentionally Not Run

- XDMA payload matrix
- Four FPGA Golden suites, three repetitions each
- Kernel-cycle validation
- 100-frame warm-up and 500-frame measured rosbag runs
- R1 persistent runtime and IRQ changes
- R2 lookup benchmark core

These remain gated by ten consecutive Gen2 x4 JTAG/recovery cycles. The real
rosbag, map, and benchmark configuration are also still required before the
100+500-frame capture.

## Next Hardware Actions

1. Verify carrier, adapter, and connector continuity/polarity for lanes 1-3 and
   compare the physical lane order with the XDC and schematic.
2. Probe PCIe refclk and PERST# at the FPGA and confirm timing relative to Orin
   boot and JTAG reconfiguration.
3. Review the Orin device-tree/root-port lane assignment and confirm the
   selected connector exposes all four lanes. The active node is already
   enabled for eight lanes; confirm the physical connector/adapter uses them.
4. After x4 is restored, execute ten JTAG/recovery loops before XDMA payload,
   Golden, cycle, and rosbag validation.
5. Install the dedicated XDMA udev rule interactively and reconnect SSH before
   running the non-root payload and Golden gates.
