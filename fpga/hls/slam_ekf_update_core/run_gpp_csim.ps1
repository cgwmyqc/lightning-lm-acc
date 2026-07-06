param(
    [string]$GoldenDir,
    [string]$Compiler = "g++"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($GoldenDir)) {
    $GoldenDir = Join-Path $RepoRoot "fpga\golden\mapping_update\frame_000001"
}
$GoldenDir = (Resolve-Path $GoldenDir).Path

$BuildDir = Join-Path $ScriptDir "build\gpp_csim"
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
$Exe = Join-Path $BuildDir "ekf_tb.exe"

& $Compiler `
    -std=c++11 `
    "-I$ScriptDir" `
    (Join-Path $ScriptDir "slam_ekf_update_core.cpp") `
    (Join-Path $ScriptDir "ekf_update_tb.cpp") `
    -o $Exe
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& $Exe $GoldenDir
exit $LASTEXITCODE
