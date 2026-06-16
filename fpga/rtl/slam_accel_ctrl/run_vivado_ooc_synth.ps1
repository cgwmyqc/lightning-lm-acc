param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $env:TEMP "lightning_slam_accel_ctrl_ooc"
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "synth_ooc.tcl"

& $Vivado -mode batch -source $Tcl -tclargs $ProjectDir $Part
exit $LASTEXITCODE
