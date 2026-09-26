# Vendor PCIe Reference Review

Date: 2026-09-26
Source: vendor high-speed transceiver tutorial V1.0 and its chapter 5/6 examples

## Decision

The vendor examples are useful configuration references, but neither example is
an AX7Z100 Gen2 x4 reference image. Do not program their generated bitstreams on
the current XC7Z100 board.

The chapter 6 XDMA project targets `xc7z015clg485-2` and explicitly configures
Gen2 x1. The chapter 5 RIFFA project name contains `Gen1x4If64`, but its RTL sets
`C_NUM_LANES=1` and its constraints contain only lane 0. Both examples therefore
establish a known vendor x1 topology, not a working x4 topology for this board.

## Reusable Findings

| Item | Vendor reference | Current Stage A2 | Assessment |
|---|---|---|---|
| FPGA part | `xc7z015clg485-2` | `xc7z100ffg900-2` | Bitstreams and pin constraints are incompatible |
| PCIe generation | Gen2, 5.0 GT/s | Gen2, 5.0 GT/s | Matches |
| Link width | x1 | x4 target | Vendor example cannot validate x4 |
| Reference clock | 100 MHz | 100 MHz | Matches |
| Clock buffer | `util_ds_buf`, `IBUFDSGTE` | `util_ds_buf`, `IBUFDSGTE` | Matches |
| AXI width/frequency | 64-bit, 62.5 MHz for x1 | 64-bit, 250 MHz for x4 | Both follow the vendor throughput table |
| Lane reversal | disabled on the x1 board | enabled on AX7Z100 path | Board-specific; current hardware requires it |

The tutorial's throughput table states that Gen2 x4 with a 64-bit AXI path uses
250 MHz, while a 128-bit path can use 125 MHz. Stage A2 uses 64-bit/250 MHz and
the full NMA design uses 128-bit/125 MHz, so the current width failure is not
explained by an undersized AXI clock.

The tutorial also notes that a host can miss an endpoint when host enumeration
starts before FPGA initialization. That supports the existing cold-reboot test
procedure and the separate JTAG hot-recovery requirement, but it does not
explain a stable, enumerated Gen2 x1 link.

## Implemented Diagnostic

Stage A2 is now parameterized for `X1`, `X2`, or `X4`. The width is encoded in
the endpoint device ID for unambiguous hardware identification:

| Build width | Device ID |
|---|---|
| X1 | `10ee:7021` |
| X2 | `10ee:7022` |
| X4 | `10ee:7024` |

The X2 image used lane reversal, 64-bit AXI at 250 MHz, and the same XDC/refclk
path as the X4 baseline. Vivado implementation passed with WNS `+0.203 ns`, WHS
`+0.045 ns`, and zero unrouted nets.

```text
bitstream_size=3313403
sha256=a8218246c43683e24c948a9f0c650730d9cc9654839c589b0fb9ed38bbe7a302
```

After JTAG programming and an Orin reboot, the endpoint enumerated as
`10ee:7022` and correctly advertised `MaxWidth x2`, but both partners negotiated
Gen2 x1. Restoring the X4 image returned `MaxWidth x4` and again negotiated x1.

## Fault Isolation

The X2 result rules out all explanations that require lanes 2 or 3 before the
link can reach x2. The first expansion lane, logical lane 1, is not training.
The next inspection should compare logical lane 1 with the known-working lane 0
in both directions:

1. Orin PET lane 1 through the adapter/carrier to FPGA Bank112 RX2 (`T6/T5`).
2. FPGA Bank112 TX2 (`P2/P1`) through the AC-coupling network to Orin PER lane 1.
3. Connector contact, cable pair, capacitor population, solder joints, and
   powered receive activity on those two differential pairs.
4. A known-good cable/adapter A/B test before any further XDMA parameter change.

Keep the default X4 image with `enable_lane_reversal=true` loaded. Do not start
payload, Golden, R1, or R2 testing until the X4 gate passes.
