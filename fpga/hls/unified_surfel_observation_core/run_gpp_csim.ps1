param(
    [string]$GoldenDir,
    [string]$Compiler = "g++"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($GoldenDir)) {
    $GoldenDir = Join-Path $RepoRoot "fpga\golden\localization\frame_000001"
}
$GoldenDir = (Resolve-Path $GoldenDir).Path

$BuildDir = Join-Path $ScriptDir "build\gpp_csim"
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
$Exe = Join-Path $BuildDir "obs_tb.exe"

& $Compiler `
    -std=c++17 `
    "-I$RepoRoot" `
    "-I$ScriptDir" `
    "-I$(Join-Path $RepoRoot 'fpga\abi')" `
    (Join-Path $ScriptDir "unified_surfel_observation_core.cpp") `
    (Join-Path $ScriptDir "obs_tb.cpp") `
    -o $Exe
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& $Exe $GoldenDir
exit $LASTEXITCODE
