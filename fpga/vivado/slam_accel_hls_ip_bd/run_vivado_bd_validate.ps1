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
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $env:TEMP "lightning_slam_accel_hls_ip_bd"
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

$Tcl = Join-Path $ScriptDir "create_bd.tcl"
$Log = Join-Path $ProjectDir "vivado_bd_validate.log"
$Journal = Join-Path $ProjectDir "vivado_bd_validate.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
& $Vivado -mode batch -source $Tcl -journal $Journal -log $Log -tclargs $ProjectDir $Part $HlsIpDir
$ExitCode = $LASTEXITCODE

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_hls_ip_bd"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_bd_validate_log.txt" },
    @{ Source = $Journal; Target = "vivado_bd_validate_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "slam_accel_hls_ip_bd_ip_status.rpt"); Target = "slam_accel_hls_ip_bd_ip_status.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
