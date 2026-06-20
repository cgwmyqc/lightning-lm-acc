param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [int]$Jobs = 18
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "xdma_diag_syn"
}
if ($Jobs -lt 1) {
    throw "Jobs must be >= 1"
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "run_project_synth.tcl"
$Log = Join-Path $ProjectDir "vivado_project_synth.log"
$Journal = Join-Path $ProjectDir "vivado_project_synth.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_project_synth.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_project_synth.jou"
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $Jobs
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\xdma_config_bar_diag"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_project_synth_log.txt" },
    @{ Source = $Journal; Target = "vivado_project_synth_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_diag.runs\synth_1\runme.log"); Target = "vivado_project_synth_runme_log.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_config_bar_diag_ip_status.rpt"); Target = "xdma_config_bar_diag_ip_status_project_synth.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_config_bar_diag_xdma_bd_properties.rpt"); Target = "xdma_config_bar_diag_xdma_bd_properties_project_synth.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_config_bar_diag_xdma_ip_properties.rpt"); Target = "xdma_config_bar_diag_xdma_ip_properties_project_synth.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_config_bar_diag_synth_util.rpt"); Target = "xdma_config_bar_diag_synth_utilization.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_config_bar_diag_synth_timing.rpt"); Target = "xdma_config_bar_diag_synth_timing_summary.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
