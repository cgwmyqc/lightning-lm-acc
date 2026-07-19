# Stage71 HLS Summary

Status: PASS.

HLS IP:

```text
slam_loc_iterative_core
```

Result:

```text
g++ CSim: PASS
Vivado HLS CSim: PASS
Vivado HLS C Synthesis: PASS
Vivado HLS IP export: PASS
```

Resource and timing estimate:

```text
target clock: 8.00 ns
estimated clock: 7.519 ns
BRAM_18K: 156
DSP48E: 574
FF: 85804
LUT: 94725
```

The first validation fixture is synthetic because no real localization iterative golden is currently available on Windows.
