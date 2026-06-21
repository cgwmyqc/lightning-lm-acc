# Stage 46 Lookup Mismatch Analysis

## Context

Stage 45 narrowed the remaining board mismatch to real active-map lookup:

- `real_valid_point` index `0`: expected and actual `1/0/0`, PASS.
- `real_reject_point` index `1`: expected and actual `0/1/0`, PASS.
- `real_miss_point` index `19`: expected `0/0/1`, actual `1/0/0`, FAIL.

The failing point has CPU/Python trace center `(0,1,3)/23` and expected
reason `lookup_miss`. Host image readback and register readback passed, so this
stage focuses on identifying which cell the HLS board image actually used.

## Orin command

```bash
sudo python3 fpga/host/xdma_smoke/xdma_smoke.py \
  --hls-manifest fpga/vivado/.build/host_golden_trace_n64/real_miss_point/manifest.json \
  --ctrl-base 0x1000 \
  --verify-image-readback \
  --read-regs-after-config \
  --dump-output-raw-words \
  --dump-normal-equation \
  --save-output-json reports/fpga/host/xdma_smoke/golden_trace_n64/real_miss_point_output.json
```

Expected diagnostic markers before analysis:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=1
HLS_OUTPUT_JSON=reports/fpga/host/xdma_smoke/golden_trace_n64/real_miss_point_output.json
```

The HLS numeric comparison is still expected to fail until the lookup issue is
fixed.

## Windows / host-only analyzer

```powershell
python fpga\host\xdma_smoke\analyze_lookup_mismatch.py --golden-dir fpga\golden\localization\frame_000001 --point-index 19 --actual-json reports\fpga\host\xdma_smoke\golden_trace_n64\real_miss_point_output.json --report-dir reports\fpga\host\xdma_smoke\lookup_mismatch_stage46
python -m py_compile fpga\host\xdma_smoke\analyze_lookup_mismatch.py fpga\host\xdma_smoke\xdma_smoke.py
```

Analyzer outputs:

- `lookup_mismatch_analysis.md`
- `lookup_mismatch_analysis.json`

## Decision rule

- If the best inferred HLS candidate is outside the CPU legal neighbor set,
  fix HLS lookup/address/packed AXI reads.
- If the best inferred HLS candidate is inside the CPU legal neighbor set,
  recheck CPU/Python expected and `SurfelLocBackend` trace.
- If the candidate cannot be uniquely inferred, generate a Stage 46 debug
  bitstream that writes selected block/cell/offset/debug residual into reserved
  output words `32..39`.

## Orin Result 2026-06-21 10:48

XDMA/base gates passed:

```text
Kernel driver in use: xdma
/dev/xdma0_user
/dev/xdma0_h2c_0
/dev/xdma0_c2h_0
/sys/bus/pci/devices/0005:01:00.0/enable = 1
SHIM_SMOKE_PASS
REG_SMOKE_PASS
DDR_SMOKE_PASS
```

`real_miss_point` diagnostic output was saved before the expected numeric failure:

```text
HOST_IMAGE_READBACK_PASS
SCAN_COUNT_READBACK=1
HLS_MANIFEST_START_PASS
HLS_MANIFEST_DONE_PASS
STATUS=0x00000204
ERROR=0x00000000
HLS_OUTPUT_JSON=reports/fpga/host/xdma_smoke/golden_trace_n64/real_miss_point_output.json
EXPECTED_COUNTS=0/0/1
ACTUAL_COUNTS=1/0/0
OUTPUT_WORD[27]=0x0000000000000001
OUTPUT_WORD[28]=0x0000000000000000
```

Analyzer result:

```text
LOOKUP_MISMATCH_ANALYSIS_PASS
report=reports/fpga/host/xdma_smoke/lookup_mismatch_stage46/lookup_mismatch_analysis.md
json=reports/fpga/host/xdma_smoke/lookup_mismatch_stage46/lookup_mismatch_analysis.json
cpu_lookup_result=miss
best_candidate=offset=459031 block=(-1,1,3)/23 legal_cpu_neighbor=False score=0
```

Best inferred HLS candidate:

```text
offset=459031
block=(-1,1,3)
cell_idx=23
legal_cpu_neighbor=False
residual=-0.028110894923855767
normal=[0.14008283615112305, 0.8049452900886536, 0.5765760540962219]
```

Conclusion: the best inferred HLS cell is outside the CPU legal 26-neighbor set. The next fix should target HLS lookup/address/packed AXI reading or synthesized neighbor selection.
