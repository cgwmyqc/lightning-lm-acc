param(
    [string]$GoldenDir,
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$ClockNs = "8",
    [string]$VivadoHls = "vivado_hls"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($GoldenDir)) {
    $GoldenDir = Join-Path $RepoRoot "fpga\golden\mapping_update\frame_000001"
}
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $ScriptDir "build\vivado_hls_slam_ekf_update_csim"
}

$GoldenDir = (Resolve-Path $GoldenDir).Path
$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "create_vivado_hls_project.tcl"

& $VivadoHls -f $Tcl -tclargs $GoldenDir $ProjectDir $Part "csim" $ClockNs
exit $LASTEXITCODE
