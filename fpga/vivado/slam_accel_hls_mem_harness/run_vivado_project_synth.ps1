param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [string]$VivadoHls = "vivado_hls",
    [string]$HlsProjectDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $ScriptDir "vivado_path.ps1")
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "lmem_syn"
}
if ([string]::IsNullOrWhiteSpace($HlsProjectDir)) {
    $HlsProjectDir = Join-Path $env:TEMP "lightning_hls_unified_obs"
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$HlsProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($HlsProjectDir)
$HlsIpDir = Join-Path $HlsProjectDir "solution1\impl\ip"
$ComponentXml = Join-Path $HlsIpDir "component.xml"

if (!(Test-Path $ComponentXml)) {
    $ExportScript = Join-Path $RepoRoot "fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1"
    & powershell -ExecutionPolicy Bypass -File $ExportScript -ProjectDir $HlsProjectDir -Part $Part -VivadoHls $VivadoHls
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

$Tcl = Join-Path $ScriptDir "run_project_synth.tcl"
$Log = Join-Path $ProjectDir "vivado_project_synth.log"
$Journal = Join-Path $ProjectDir "vivado_project_synth.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_project_synth.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_project_synth.jou"
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $HlsIpDir
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_hls_mem_harness"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_project_synth_log.txt" },
    @{ Source = $Journal; Target = "vivado_project_synth_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem_util.rpt"); Target = "slam_accel_hls_mem_harness_project_synth_utilization.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem_timing.rpt"); Target = "slam_accel_hls_mem_harness_project_synth_timing_summary.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem_ip_status.rpt"); Target = "slam_accel_hls_mem_harness_ip_status_project_synth.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem.runs\synth_1\runme.log"); Target = "vivado_project_synth_runme_log.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
