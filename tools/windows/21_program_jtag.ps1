param(
    [string]$Bitstream,
    [switch]$SkipPcieRecovery,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

if ([string]::IsNullOrWhiteSpace($Bitstream)) {
    $Candidates = @(
        (Join-Path $script:NmaRepoRoot "fpga\vivado\.build\r0_impl\azmig.runs\impl_1\azmig_wrapper.bit"),
        (Join-Path $script:NmaRepoRoot "fpga\vivado\.build\azmig_impl\azmig.runs\impl_1\azmig_wrapper.bit")
    )
    $Bitstream = $Candidates | Where-Object { Test-Path $_ } | Select-Object -First 1
}
if ([string]::IsNullOrWhiteSpace($Bitstream) -or !(Test-Path $Bitstream)) {
    throw "No bitstream found. Pass -Bitstream explicitly or run 20_vivado_build.ps1."
}

$FlowDir = Join-Path $script:NmaRepoRoot "fpga\vivado\slam_accel_ax7z100_pcie_mig"
$Xsdb = Join-Path $env:VIVADO_2018_3 "bin\xsdb.bat"
$HwServer = Join-Path $env:VIVADO_2018_3 "bin\hw_server.bat"
& powershell -ExecutionPolicy Bypass -File (Join-Path $FlowDir "program_bitstream_jtag.ps1") `
    -Bitstream $Bitstream -Xsdb $Xsdb -HwServer $HwServer -LogDir $LogDir
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Output "R0_JTAG_PROGRAM_PASS bitstream=$Bitstream"
if (!$SkipPcieRecovery) {
    & powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "32_orin_pcie_rescan.ps1") `
        -ReportRoot $ReportRoot
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

