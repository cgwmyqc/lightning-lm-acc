# Stage A2 X2 Diagnostic Summary

Date: 2026-09-26
Result: `ENUMERATED_GEN2_X1`

- Part: `xc7z100ffg900-2`
- XDMA: Gen2 X2, lane reversal enabled, 64-bit AXI at 250 MHz
- PCI ID: `10ee:7022`
- Post-route timing: WNS `+0.203 ns`, WHS `+0.045 ns`
- Route status: zero unrouted nets
- Bitstream size: `3313403` bytes
- SHA-256: `a8218246c43683e24c948a9f0c650730d9cc9654839c589b0fb9ed38bbe7a302`
- Orin endpoint capability: Gen2 X2
- Negotiated link: Gen2 X1
- XDMA driver and user/H2C/C2H/event nodes: present

This proves the generated image is X2 while the physical link cannot train its
second lane. The fault investigation should start with logical lane 1. The
default X4 Stage A2 image was restored after this test.
