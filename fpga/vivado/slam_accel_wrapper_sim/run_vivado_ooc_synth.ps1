param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $env:TEMP "lightning_slam_accel_wrapper_ooc"
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "run_ooc_synth.tcl"
$Log = Join-Path $ProjectDir "vivado.log"
$Journal = Join-Path $ProjectDir "vivado.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
& $Vivado -mode batch -source $Tcl -journal $Journal -log $Log -tclargs $ProjectDir $Part
exit $LASTEXITCODE
