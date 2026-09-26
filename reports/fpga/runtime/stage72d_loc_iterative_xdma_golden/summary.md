# Stage72D Orin Summary

Result: PASS

Stage72D validates the Stage72C `slam_loc_iterative_core` board integration
through `KERNEL_SEL=6` using the real Stage72A localization iterative golden.

## Gate

```text
XDMA driver: bound
device nodes: /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 present
enable: 1
PCIe link: Gen2 x1 from kernel bandwidth line
kernel errors: no new Failed to detect XDMA config BAR / CmpltTO / AER fatal
```

## Smoke

```text
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

DDR smoke included:

```text
loc_iter_input base=0x30030000
loc_iter_output base=0x30040000
```

## Golden Replay

```text
LOC_ITER_CPU_REPLAY_PASS
LOC_ITER_XDMA_START_PASS
LOC_ITER_XDMA_DONE_PASS
LOC_ITER_XDMA_NUMERIC_PASS
LOC_ITER_XDMA_PASS
```

Three XDMA iterations:

```text
iter 1: elapsed=0.236946750s RUN_COUNT=0->1 counts=6124/837/2
iter 2: elapsed=0.236468634s RUN_COUNT=1->2 counts=6124/837/2
iter 3: elapsed=0.236429483s RUN_COUNT=2->3 counts=6124/837/2
mean:   elapsed=0.236614956s
```

Numeric comparison:

```text
status=1
flags=1
iterations=4
counts=6124/837/2
score=2.2534928608749416
max_abs=3.55271e-13
max_rel=8.21216e-15
worst_field=residual_sum
```

## Boundary

This is offline XDMA golden replay only. `run_loc_online` and
`SURFEL_FPGA_FULL_ITERATIVE` online integration remain Stage72E.
