param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [string]$VivadoHls = "vivado_hls",
    [string]$HlsProjectDir,
    [string]$ReferenceRoot,
    [int]$Jobs = 18
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "azmig_syn"
}
if ([string]::IsNullOrWhiteSpace($HlsProjectDir)) {
    $HlsProjectDir = Join-Path $BuildRoot "hls_unified_obs"
}
if ([string]::IsNullOrWhiteSpace($ReferenceRoot)) {
    $ReferenceRoot = Resolve-Path (Join-Path $RepoRoot "..")
}
if ($Jobs -lt 1) {
    throw "Jobs must be >= 1"
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$HlsProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($HlsProjectDir)
$ReferenceRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReferenceRoot)
$HlsIpDir = Join-Path $HlsProjectDir "solution1\impl\ip"
$ComponentXml = Join-Path $HlsIpDir "component.xml"

if (!(Test-Path $ComponentXml)) {
    $ExportScript = Join-Path $RepoRoot "fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1"
    & powershell -ExecutionPolicy Bypass -File $ExportScript -ProjectDir $HlsProjectDir -Part $Part -VivadoHls $VivadoHls
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
    if (!(Test-Path $ComponentXml)) {
        Write-Error "HLS IP export did not produce component.xml: $ComponentXml"
        exit 1
    }
}

& powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "validate_board_profile.ps1") -ReferenceRoot $ReferenceRoot
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
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
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $HlsIpDir $ReferenceRoot $Jobs
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_project_synth_log.txt" },
    @{ Source = $Journal; Target = "vivado_project_synth_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "azmig.runs\synth_1\runme.log"); Target = "vivado_project_synth_runme_log.txt" },
    @{ Source = (Join-Path $ProjectDir "ax7z100_pcie_mig_ip_status.rpt"); Target = "ax7z100_pcie_mig_ip_status_project_synth.txt" },
    @{ Source = (Join-Path $ProjectDir "ax7z100_pcie_mig_util.rpt"); Target = "ax7z100_pcie_mig_project_synth_utilization.txt" },
    @{ Source = (Join-Path $ProjectDir "ax7z100_pcie_mig_timing.rpt"); Target = "ax7z100_pcie_mig_project_synth_timing_summary.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
