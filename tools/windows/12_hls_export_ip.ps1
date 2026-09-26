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
    $ProjectDir = Join-Path $script:NmaRepoRoot "fpga\vivado\.build\r0_${Name}_export"
    $Log = Join-Path $LogDir "${Name}_hls_export.log"
    & powershell -ExecutionPolicy Bypass -File (Join-Path $CoreDir "run_vivado_hls_export_ip.ps1") `
        -ProjectDir $ProjectDir -ClockNs $ClockNs -VivadoHls $VivadoHls 2>&1 | Tee-Object -FilePath $Log
    $ExitCode = $LASTEXITCODE
    $Component = Join-Path $ProjectDir "solution1\impl\ip\component.xml"
    $Pass = ($ExitCode -eq 0) -and (Test-Path $Component)
    $Rows += [pscustomobject]@{ core = $Name; stage = "export_ip"; pass = $Pass; component = $Component; log = $Log }
    if (!$Pass) { throw "$Name Vivado HLS IP export failed" }
}
$Rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path (Join-Path $ReportRoot "hls_export_status.csv")
Write-Output "R0_HLS_EXPORT_IP_PASS"

