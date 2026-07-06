# Stage62 Orin Result: Localization Solve6x6 Golden

Status: PASS

## Hardware Gate

- BDF: `0005:01:00.0`
- Device: `10ee:7024`
- Kernel driver: `xdma`
- Nodes: `/dev/xdma0_user`, `/dev/xdma0_h2c_0`, `/dev/xdma0_c2h_0`
- Enable: `1`
- PCIe link: `5GT/s x1`, endpoint capability `x4`
- Kernel log: no new `Failed to detect XDMA config BAR`, `CmpltTO`, or AER fatal during Stage62 tests.

## Smoke

```text
XDMA_CPP_SHIM_SMOKE_PASS
XDMA_CPP_REG_SMOKE_PASS
XDMA_CPP_DDR_SMOKE_PASS
```

## Localization V2 Regression

```text
abi_v2_candidates=1
fpga_solve6x6=0
scan_count=6963
expected_counts=6050/911/2
COUNTS=6050/911/2
XDMA_CPP_GOLDEN_NUMERIC_PASS
HLS_WAIT_SEC=0.12032
```

## Localization V2 + FPGA Solve6x6

```text
abi_v2_candidates=1
fpga_solve6x6=1
COUNTS=6050/911/2
LOC_XDMA_SOLVE6X6_PASS
FPGA_SOLVE6X6_STATUS=1
XDMA_CPP_GOLDEN_REPEAT_PASS ITERATIONS=3 ABI_V2_CANDIDATES=1
```

Elapsed:

```text
iter_01=0.120416260 s
iter_02=0.120113495 s
iter_03=0.120796971 s
mean=0.120442242 s
speedup_vs_stage57_1536ms=12.753x
speedup_vs_stage61_120290ms=0.999x
```

Solve result:

```text
status=[1, 1, 1]
dx_norm=0.068321888
dx=[-0.048509941555978785,
    -0.041637405753014667,
     0.023276896564930594,
     0.0017501070996257212,
     0.0058700982657821452,
    -0.0012874587746111517]
solve max_abs=6.93889e-18
solve max_rel=6.93889e-18
```

## Mapping V2 Regression

```text
MAPPING_XDMA_REPLAY_PASS
STATUS=0x204
ERROR=0x0
RUN_COUNT=4->5
SCAN_COUNT_READBACK=782
abi_v2_candidates=1
candidate_count=782
candidate_valid=653
candidate_miss=129
hls_wait_sec=0.0149056
counts actual=611/0/171 expected=611/0/171
values_ok=1
max_abs=0.268571
max_rel=1.99295e-05
worst_field=H(3,3)
```

## Conclusion

Stage62 Orin golden gate passes. The new FPGA solve6x6 output matches the C++ reference within the required tolerance, while localization and mapping Candidate ABI V2 observation regressions remain PASS. Stage63 may start: online `SURFEL_FPGA_OBS_SOLVE` runtime integration for localization only.

