param(
    [string]$XdmaModulePath = "",
    [switch]$AllowRebootFallback,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
if ([string]::IsNullOrWhiteSpace($env:ORIN_USER)) { throw "ORIN_USER is unset" }

$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Target = "$($env:ORIN_USER)@$($env:ORIN_HOST)"
$RemoteScript = "/tmp/lightning_nma_pcie_rescan_$PID.sh"
& scp -q (Join-Path $script:NmaRepoRoot "tools\orin\pcie_rescan.sh") "${Target}:$RemoteScript"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
function Quote-Shell([string]$Value) {
    $Escape = "'" + '"' + "'" + '"' + "'"
    return "'" + $Value.Replace("'", $Escape) + "'"
}
$ModuleArg = Quote-Shell $XdmaModulePath
& ssh -o BatchMode=yes $Target "sudo -n bash '$RemoteScript' $ModuleArg; rc=`$?; rm -f '$RemoteScript'; exit `$rc" `
    2>&1 | Tee-Object -FilePath (Join-Path $LogDir "orin_pcie_rescan.log") | ForEach-Object { $_ }
$ExitCode = $LASTEXITCODE
if ($ExitCode -ne 0 -and $AllowRebootFallback) {
    Write-Warning "PCIe hot recovery failed; explicit -AllowRebootFallback requested an Orin reboot."
    & ssh -o BatchMode=yes $Target "sudo -n reboot"
    exit 2
}
exit $ExitCode
