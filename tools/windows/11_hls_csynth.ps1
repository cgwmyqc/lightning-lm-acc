param(
    [ValidateSet("all", "unified_surfel_observation_core", "slam_ekf_update_core", "slam_loc_iterative_core")]
    [string]$Core = "all",
    [string]$ClockNs = "8",
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Cores = if ($Core -eq "all") {
    @("unified_surfel_observation_core", "slam_ekf_update_core", "slam_loc_iterative_core")
} else { @($Core) }
$VivadoHls = Join-Path $env:VIVADO_HLS_2018_3 "bin\vivado_hls.bat"
$Rows = @()
foreach ($Name in $Cores) {
    $CoreDir = Join-Path $script:NmaRepoRoot "fpga\hls\$Name"
    $ProjectDir = Join-Path $script:NmaRepoRoot "fpga\vivado\.build\r0_${Name}_csynth"
    $Log = Join-Path $LogDir "${Name}_hls_csynth.log"
    & powershell -ExecutionPolicy Bypass -File (Join-Path $CoreDir "run_vivado_hls_csynth.ps1") `
        -ProjectDir $ProjectDir -ClockNs $ClockNs -VivadoHls $VivadoHls 2>&1 | Tee-Object -FilePath $Log
    $ExitCode = $LASTEXITCODE
    $Report = Join-Path $ProjectDir "solution1\syn\report\${Name}_csynth.rpt"
    $Rows += [pscustomobject]@{ core = $Name; stage = "csynth"; exit_code = $ExitCode; report = $Report; log = $Log }
    if ($ExitCode -ne 0) { throw "$Name Vivado HLS synthesis failed" }
}
$Rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path (Join-Path $ReportRoot "hls_csynth_status.csv")
Write-Output "R0_HLS_CSYNTH_PASS"

