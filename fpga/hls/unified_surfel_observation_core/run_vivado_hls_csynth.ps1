param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$VivadoHls = "vivado_hls"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $env:TEMP "lightning_hls_unified_obs"
}

$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$GoldenDir = Join-Path $RepoRoot "fpga\golden\localization\frame_000001"
$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "create_vivado_hls_project.tcl"

& $VivadoHls -f $Tcl -tclargs $GoldenDir $ProjectDir $Part "csynth"
exit $LASTEXITCODE
