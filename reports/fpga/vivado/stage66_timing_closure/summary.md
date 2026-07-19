# Stage66B Vivado Timing Closure Summary

Status: bitstream generated, but post-route setup timing is still not closed.

Results:

- Board profile static validation: PASS.
- BD validate: PASS.
- Project synthesis: PASS, `PROJECT_SYNTH_PASS`.
- Implementation / bitstream: PASS, `IMPLEMENTATION_BITSTREAM_PASS`.
- Bitstream: `fpga/vivado/.build/azmig_impl/azmig.runs/impl_1/azmig_wrapper.bit`.

Post-route timing:

```text
WNS = -0.575 ns
TNS = -32.114 ns
Failing setup endpoints = 289
WHS = 0.021 ns
THS = 0.000 ns
Timing constraints are not met.
```

Worst failing path:

```text
Clock: userclk2, period 8.000 ns
Source: azmig_i/unified_obs_0/.../unified_surfel_obfYi_U806/din0_buf1_reg[16]
Destination: azmig_i/unified_obs_0/.../unified_surfel_obfYi_U807/.../ap_dmul_3_max_dsp_64
Data path delay: 8.432 ns
Logic: double multiply DSP chain
```

Utilization:

```text
Slice LUTs: 146962 / 277400 (52.98%)
Slice Registers: 164410 / 554800 (29.63%)
Block RAM Tile: 127.5 / 755 (16.89%)
DSPs: 792 / 2020 (39.21%)
Bonded IOB: 74 / 362 (20.44%)
BUFGCTRL: 10 / 32 (31.25%)
```

DRC:

- Vivado implementation log ended with `1 Critical Warnings and 0 Errors`.
- `report_drc` contains warnings/advisories, including the existing MIG clock
  dedicated-route override:
  `CLOCK_DEDICATED_ROUTE constraint is set to FALSE`.

Conclusion:

- Stage66B improved the timing risk substantially compared with Stage65B
  (`TNS=-2451.445 ns` previously), but it does not satisfy the timing-closed
  acceptance gate.
- The generated bitstream may be used only for short functional bring-up /
  Stage66A repeat smoke, not as a reliable online `FPGA_FULL` baseline.

Next timing closure direction:

- Do not change EKF math first; the worst path is currently observation
  double multiplication.
- Prioritize observation HLS timing closure: tune double operator latency or
  lower the observation clock / split clock domains before enabling online
  `FPGA_FULL`.
