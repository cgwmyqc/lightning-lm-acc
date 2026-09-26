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
.\tools\windows\29_pcie_link_diagnostics.ps1 -ChangeId baseline
.\tools\windows\30_orin_preflight.ps1
.\tools\windows\31_orin_build.ps1
.\tools\windows\35_pcie_stability.ps1 -Cycles 10
.\tools\windows\36_run_xdma_matrix.ps1
.\tools\windows\33_run_golden.ps1
.\tools\windows\34_run_benchmark.ps1 `
  -InputBag "/data/input.bag" -MapPath "/data/map" `
  -CpuConfig "/data/cpu.yaml" -FpgaObsConfig "/data/fpga_obs.yaml" `
  -FpgaFullConfig "/data/fpga_full.yaml"
.\tools\windows\90_collect_reports.ps1 -CollectRemote
```

`21_program_jtag.ps1` runs PCIe recovery by default. Orin reboot fallback is never automatic; it requires an explicit `-AllowRebootFallback` on `32_orin_pcie_rescan.ps1`.

Use `29_pcie_link_diagnostics.ps1` after each single physical or platform
change. Give every attempt a unique `-ChangeId`; it records endpoint/root-port
speed and width, the live Device Tree lane count, XDMA node state, and a raw log
without modifying the device. Follow
`reports/nma/r0/PCIE_FIELD_CHECKLIST.md` for the verified slot/J30/Bank112 lane
mapping. Keep MID360 disconnected during this work.

Run `35_pcie_stability.ps1` only after a single Gen2 x4 recovery passes. It
reprograms and recovers the endpoint ten times by default, writes one log per
cycle plus `pcie_recovery_cycles.csv`, and stops at the first failure. The
script now enforces the initial Gen2 x4 preflight before the first JTAG cycle.

After the ten-cycle gate, `36_run_xdma_matrix.ps1` verifies 4 KiB through
32 MiB H2C/C2H payloads, BAR identity/register access, and representative PL
DDR regions. The Golden and benchmark runners also enforce Gen2 x4 before
touching XDMA.

The Orin XDMA driver currently creates root-only nodes. Install the dedicated
group rule once from an interactive Orin terminal, then reconnect SSH:

```bash
sudo bash tools/orin/install_xdma_access.sh hit
```

After Stage A2 reaches Gen2 x4 on a cold boot and the XDMA group rule is
installed, the remaining R0 gates can be executed in their fixed fail-fast
order with:

```powershell
.\tools\windows\37_complete_r0_after_x4.ps1 -ChangeId reseat_01
```

This restores the full NMA image, requires ten recovery cycles, runs the XDMA
payload/BAR/DDR checks, runs all four Golden suites three times, and refreshes
the report manifest. It deliberately does not start the rosbag benchmark.

The benchmark runner sets `NMA_LOC_PROFILE_CSV` for each backend, rejects runs with fewer than 100 warm-up plus 500 structured frame samples, and writes `all_frames.csv`, `measured_frames.csv`, `tegrastats.log`, and mean/P50/P95/min/max/std values to `frame_summary.csv`. Golden capture uses the separate `run_lightning_golden.sh` path and never participates in sample counting.
