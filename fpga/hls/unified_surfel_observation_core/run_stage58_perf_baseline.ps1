param(
    [string]$GoldenDir,
    [string]$ReportDir,
    [string]$Compiler = "g++"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($GoldenDir)) {
    $GoldenDir = Join-Path $RepoRoot "fpga\golden\localization\frame_000001"
}
if ([string]::IsNullOrWhiteSpace($ReportDir)) {
    $ReportDir = Join-Path $RepoRoot "reports\fpga\hls\unified_surfel_observation_core\stage58_perf_baseline"
}

$GoldenDir = (Resolve-Path $GoldenDir).Path
$ReportDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReportDir)
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null

$Stdout = Join-Path $ReportDir "gpp_csim_synthetic_sweep_stdout.txt"
$Commands = Join-Path $ReportDir "commands.md"

$CommandText = @(
    "# Stage 58 HLS Performance Baseline Commands",
    "",
    "````powershell",
    "powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_stage58_perf_baseline.ps1",
    "````",
    "",
    "This script runs:",
    "",
    "````powershell",
    "powershell -ExecutionPolicy Bypass -File .\fpga\hls\unified_surfel_observation_core\run_gpp_csim.ps1 -GoldenDir $GoldenDir -Compiler $Compiler -SyntheticSweep",
    "````"
) -join [Environment]::NewLine
$CommandText | Set-Content -Encoding UTF8 $Commands

& powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "run_gpp_csim.ps1") `
    -GoldenDir $GoldenDir `
    -Compiler $Compiler `
    -SyntheticSweep *>&1 | Tee-Object -FilePath $Stdout
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

Write-Host "STAGE58_PERF_BASELINE_PASS"
Write-Host "REPORT_DIR=$ReportDir"
