param(
    [Parameter(Mandatory = $true)][string]$Bitstream,
    [string]$Vivado = "vivado",
    [string]$HwTarget = "",
    [string]$LogDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($LogDir)) {
    $LogDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig"
}

$Bitstream = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Bitstream)
if (!(Test-Path $Bitstream)) {
    throw "Bitstream not found: $Bitstream"
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Tcl = Join-Path $ScriptDir "program_bitstream_jtag.tcl"
$Log = Join-Path $LogDir "vivado_jtag_program_log.txt"
$Journal = Join-Path $LogDir "vivado_jtag_program_jou.txt"

$Args = @("-mode", "batch", "-source", $Tcl, "-journal", $Journal, "-log", $Log, "-tclargs", $Bitstream)
if (![string]::IsNullOrWhiteSpace($HwTarget)) {
    $Args += $HwTarget
}

& $Vivado @Args
exit $LASTEXITCODE
