param(
    [switch]$SynthesisOnly,
    [int]$Jobs = 18,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Vivado = Join-Path $env:VIVADO_2018_3 "bin\vivado.bat"
$VivadoHls = Join-Path $env:VIVADO_HLS_2018_3 "bin\vivado_hls.bat"
$FlowDir = Join-Path $script:NmaRepoRoot "fpga\vivado\slam_accel_ax7z100_pcie_mig"
if ($SynthesisOnly) {
    $Runner = Join-Path $FlowDir "run_vivado_project_synth.ps1"
    $ProjectDir = Join-Path $script:NmaRepoRoot "fpga\vivado\.build\r0_project_synth"
    $Log = Join-Path $LogDir "vivado_project_synth.log"
} else {
    $Runner = Join-Path $FlowDir "run_vivado_impl_bitstream.ps1"
    $ProjectDir = Join-Path $script:NmaRepoRoot "fpga\vivado\.build\r0_impl"
    $Log = Join-Path $LogDir "vivado_impl_bitstream.log"
}

& powershell -ExecutionPolicy Bypass -File $Runner -ProjectDir $ProjectDir -Vivado $Vivado `
    -VivadoHls $VivadoHls -Jobs $Jobs 2>&1 | Tee-Object -FilePath $Log
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Output $(if ($SynthesisOnly) { "R0_VIVADO_SYNTH_PASS" } else { "R0_VIVADO_IMPL_PASS" })

