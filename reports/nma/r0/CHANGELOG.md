# R0 Changelog

## 2026-09-26

- Added key-only Orin SSH configuration with a dedicated known-hosts file.
- Replaced unrestricted passwordless sudo with a root-owned PCIe helper that
  permits only status, recovery, and reboot operations.
- Fixed recovery when no initial FPGA BDF is present and restricted module
  loading to `modprobe xdma`.
- Separated Golden replay from benchmark collection and made zero-sample runs
  fail explicitly.
- Added structured per-frame CPU/PCIe/kernel/ESKF/fallback telemetry.
- Initialized rosdep and verified a complete plus incremental Orin build.
- Fixed HLS export destinations so Vivado consumes the freshly exported IP.
- Re-ran three-core CSim, C synthesis, IP export, full Vivado implementation,
  timing signoff, bitstream generation, and JTAG programming.
- Compared the complete NMA image with the Stage A2 XDMA-only diagnostic image.
- Parameterized the Stage A2 flow for lane reversal, implemented a fresh
  `false` variant, and proved it cannot enumerate on either hot recovery or
  cold boot; the existing `true` setting is required.
- Changed Orin preflight to read PCIe speed/width from sysfs and emit an
  explicit `link_not_gen2_x4` failure without privileged `lspci -vv` access.
- Added the fail-fast 10-cycle JTAG/PCIe recovery stability runner with
  per-cycle logs and CSV output.
- Recorded the Gen2 x1 link failure and stopped before Golden, R1, and R2.
- Audited the live Orin `141a0000.pcie` Device Tree node and confirmed
  `status=okay`, `num-lanes=8`, and domain `0005`.
- Verified the full reversed-lane routing from the x8 slot through J30 to FPGA
  Bank112 using the carrier and core-board schematics.
- Added per-change PCIe diagnostics, a field checklist, hard x4 guards on
  stability/Golden/benchmark runners, and an independent payload/BAR/DDR gate.
- Added a minimal dedicated-group udev installer for non-root XDMA access;
  interactive privileged installation remains pending.
- Extended preflight to require the XDMA event node and non-root read/write
  access, and added a fail-fast post-x4 R0 acceptance orchestrator.
- Reprogrammed the lane-reversal-enabled Stage A2 image after a complete
  power-off reseat, rebooted Orin, and recorded `reseat_01`: enumeration and
  XDMA device creation pass, but both link partners remain at Gen2 x1.
- Reviewed the vendor chapter 5/6 PCIe tutorial and examples. Confirmed both
  target XC7Z015 and implement x1; retained their refclk, AXI-frequency, and
  boot-order guidance without treating their bitstreams as AX7Z100 images.
- Parameterized Stage A2 for X1/X2/X4 diagnostic widths and distinct PCI device
  IDs, then generated an X2 bitstream with positive post-route timing.
- Programmed the X2 image and rebooted Orin. The endpoint advertised Gen2 x2 as
  `10ee:7022` but negotiated x1, isolating the first failed expansion lane to
  logical lane 1. Restored and reverified the default X4 Stage A2 image.
