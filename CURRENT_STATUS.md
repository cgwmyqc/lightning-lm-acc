# Current Status

Stage: `R0 - Baseline & Automation`  
Branch: `dev-acc`  
Decision: `NO-GO`  
Overall marker: `R0_BASELINE_PASS=NO`

## Completed

- Created `dev-acc` from commit `5b2657a`.
- Tagged the pre-redesign baseline as `baseline_20260926_before_nma_redesign`.
- Added Windows and Orin automation for preflight, HLS, Vivado, JTAG, PCIe recovery, Golden replay, benchmarking, and report collection.
- Added per-launch FPGA cycle, kernel time, and polling overhead telemetry to all XDMA kernel paths.
- Reran all three g++ and Vivado HLS CSim suites successfully on Windows.
- Reran all three Vivado HLS 2018.3 C synthesis flows successfully and collected fresh absolute per-core resource/timing evidence.
- Collected the existing signed-off full-design resource/timing evidence.

## Blocking Gates

- `ORIN_USER` and `ORIN_ROOT` are unset; automated SSH/scp/build was not run.
- Latest board evidence is PCIe Gen2 x1, not Gen2 x4.
- Full design uses 78.08% LUT and 68.61% DSP, above the R0 hard gates.
- Same-bag CPU/FPGA mean and P95 measurements are missing.
- New FPGA cycle telemetry still needs board validation.
- The local WSL image lacks the glog development package, so the ROS 2 host build must be compiled in the configured Orin environment.

## Next Command

After setting key-based Orin environment variables:

```powershell
$env:ORIN_USER = "<user>"
$env:ORIN_ROOT = "<absolute-path-on-orin>"
powershell -ExecutionPolicy Bypass -File .\tools\windows\30_orin_preflight.ps1
```

Do not enter R1 or R2 until every R0 gate in `R0_FEASIBILITY_REPORT.md` passes.
