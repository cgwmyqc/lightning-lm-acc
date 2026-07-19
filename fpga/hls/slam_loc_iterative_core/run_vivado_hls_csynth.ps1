param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$ClockNs = "8",
    [string]$VivadoHls = "vivado_hls"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$DefaultBuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $DefaultBuildRoot "hls_slam_loc_iterative_csynth"
}

$GoldenDir = Join-Path $RepoRoot "fpga\golden\localization_iterative\frame_000001"
$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "create_vivado_hls_project.tcl"

$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $DefaultBuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    & $VivadoHls -f $Tcl -tclargs $GoldenDir $VivadoProjectDir $Part "csynth" $ClockNs
    if ($LASTEXITCODE -eq 0) {
        Write-Host "LOC_ITER_CSYNTH_PASS"
    }
    exit $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

