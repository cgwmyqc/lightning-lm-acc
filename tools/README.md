# NMA R0 Automation

These scripts implement the Stage R0 order from the NMA redesign roadmap. Run them from a PowerShell prompt on the Windows development machine.

Set only machine-specific, non-secret values in the caller environment:

```powershell
$env:ORIN_USER = "<user>"
$env:ORIN_ROOT = "<absolute-path-on-orin>"
```

SSH must use a key and BatchMode. Do not add passwords to `env.ps1`.

Typical flow:

```powershell
.\tools\windows\00_preflight.ps1
.\tools\windows\10_hls_csim.ps1
.\tools\windows\11_hls_csynth.ps1
.\tools\windows\12_hls_export_ip.ps1
.\tools\windows\20_vivado_build.ps1
.\tools\windows\21_program_jtag.ps1
.\tools\windows\30_orin_preflight.ps1
.\tools\windows\31_orin_build.ps1
.\tools\windows\33_run_golden.ps1
.\tools\windows\34_run_benchmark.ps1 `
  -InputBag "/data/input.bag" -MapPath "/data/map" `
  -CpuConfig "/data/cpu.yaml" -FpgaObsConfig "/data/fpga_obs.yaml" `
  -FpgaFullConfig "/data/fpga_full.yaml"
.\tools\windows\90_collect_reports.ps1 -CollectRemote
```

`21_program_jtag.ps1` runs PCIe recovery by default. Orin reboot fallback is never automatic; it requires an explicit `-AllowRebootFallback` on `32_orin_pcie_rescan.ps1`.

The three benchmark configs must set `profile.enable: true` and `profile.log_every_n_frames: 1`. The runner rejects runs with fewer than 100 warm-up plus 500 measured `[loc_profile]` samples, then writes `measured_frames.csv` and mean/P95/min/max values to `frame_summary.csv`.
