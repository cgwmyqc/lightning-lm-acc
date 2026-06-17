param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [string]$VivadoHls = "vivado_hls",
    [string]$HlsProjectDir,
    [string]$ReferenceRoot
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "azmig_bd"
}
if ([string]::IsNullOrWhiteSpace($HlsProjectDir)) {
    $HlsProjectDir = Join-Path $env:TEMP "lightning_hls_unified_obs"
}
if ([string]::IsNullOrWhiteSpace($ReferenceRoot)) {
    $ReferenceRoot = Resolve-Path (Join-Path $RepoRoot "..")
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
}

& powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "validate_board_profile.ps1") -ReferenceRoot $ReferenceRoot
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$Tcl = Join-Path $ScriptDir "create_bd.tcl"
$Log = Join-Path $ProjectDir "vivado_bd_validate.log"
$Journal = Join-Path $ProjectDir "vivado_bd_validate.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_bd_validate.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_bd_validate.jou"
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $HlsIpDir $ReferenceRoot
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_bd_validate_log.txt" },
    @{ Source = $Journal; Target = "vivado_bd_validate_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "ax7z100_pcie_mig_ip_status.rpt"); Target = "ax7z100_pcie_mig_ip_status.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
