param(
    [string]$GoldenDir,
    [string]$Compiler = "g++"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($GoldenDir)) {
    $GoldenDir = Join-Path $RepoRoot "fpga\golden\localization_iterative\frame_000001"
}

$BuildDir = Join-Path $ScriptDir "build\gpp_csim"
New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
$Exe = Join-Path $BuildDir "loc_iterative_tb.exe"

& $Compiler `
    -std=c++11 `
    "-I$RepoRoot" `
    (Join-Path $ScriptDir "slam_loc_iterative_core.cpp") `
    (Join-Path $ScriptDir "loc_iterative_tb.cpp") `
    -o $Exe
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& $Exe $GoldenDir
exit $LASTEXITCODE

