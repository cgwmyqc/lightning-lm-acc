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
