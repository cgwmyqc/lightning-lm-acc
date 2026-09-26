# NMA R0 Automation

These scripts implement the Stage R0 order from the NMA redesign roadmap. Run them from a PowerShell prompt on the Windows development machine.

Copy `tools/windows/env.local.example.ps1` to the ignored
`tools/windows/env.local.ps1` and set only machine-specific, non-secret values there:

```powershell
$env:ORIN_HOST = "<orin-ip>"
$env:ORIN_USER = "<user>"
$env:ORIN_ROOT = "<absolute-path-on-orin>"
$env:ORIN_IDENTITY_FILE = "$HOME\.ssh\lightning_nma_ed25519"
$env:ORIN_KNOWN_HOSTS = "$HOME\.ssh\known_hosts_lightning_nma"
```

SSH uses that identity with `BatchMode`, `IdentitiesOnly`, strict host-key checking,
and the dedicated known-hosts file. Do not add passwords to either environment file.

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
.\tools\windows\35_pcie_stability.ps1 -Cycles 10
.\tools\windows\33_run_golden.ps1
.\tools\windows\34_run_benchmark.ps1 `
  -InputBag "/data/input.bag" -MapPath "/data/map" `
  -CpuConfig "/data/cpu.yaml" -FpgaObsConfig "/data/fpga_obs.yaml" `
  -FpgaFullConfig "/data/fpga_full.yaml"
.\tools\windows\90_collect_reports.ps1 -CollectRemote
```

`21_program_jtag.ps1` runs PCIe recovery by default. Orin reboot fallback is never automatic; it requires an explicit `-AllowRebootFallback` on `32_orin_pcie_rescan.ps1`.

Run `35_pcie_stability.ps1` only after a single Gen2 x4 recovery passes. It
reprograms and recovers the endpoint ten times by default, writes one log per
cycle plus `pcie_recovery_cycles.csv`, and stops at the first failure.

The benchmark runner sets `NMA_LOC_PROFILE_CSV` for each backend, rejects runs with fewer than 100 warm-up plus 500 structured frame samples, and writes `all_frames.csv`, `measured_frames.csv`, `tegrastats.log`, and mean/P50/P95/min/max/std values to `frame_summary.csv`. Golden capture uses the separate `run_lightning_golden.sh` path and never participates in sample counting.
