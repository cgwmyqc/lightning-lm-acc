param(
    [ValidateSet("all", "unified_surfel_observation_core", "slam_ekf_update_core", "slam_loc_iterative_core")]
    [string]$Core = "all",
    [switch]$SkipGpp,
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
} else {
    @($Core)
}
$VivadoHls = Join-Path $env:VIVADO_HLS_2018_3 "bin\vivado_hls.bat"
$Rows = @()
foreach ($Name in $Cores) {
    $CoreDir = Join-Path $script:NmaRepoRoot "fpga\hls\$Name"
    if (!$SkipGpp) {
        $GppLog = Join-Path $LogDir "${Name}_gpp_csim.log"
        & powershell -ExecutionPolicy Bypass -File (Join-Path $CoreDir "run_gpp_csim.ps1") 2>&1 |
            Tee-Object -FilePath $GppLog
        if ($LASTEXITCODE -ne 0) { throw "$Name g++ CSim failed" }
    }
    $HlsLog = Join-Path $LogDir "${Name}_hls_csim.log"
    & powershell -ExecutionPolicy Bypass -File (Join-Path $CoreDir "run_vivado_hls_csim.ps1") `
        -VivadoHls $VivadoHls 2>&1 | Tee-Object -FilePath $HlsLog
    $ExitCode = $LASTEXITCODE
    $Rows += [pscustomobject]@{ core = $Name; stage = "csim"; exit_code = $ExitCode; log = $HlsLog }
    if ($ExitCode -ne 0) { throw "$Name Vivado HLS CSim failed" }
}
$Rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path (Join-Path $ReportRoot "hls_csim_status.csv")
Write-Output "R0_HLS_CSIM_PASS"

