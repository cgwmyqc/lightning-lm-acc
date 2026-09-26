param(
    [ValidateSet("Debug", "Release", "RelWithDebInfo")][string]$BuildType = "RelWithDebInfo",
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
if ([string]::IsNullOrWhiteSpace($env:ORIN_USER)) { throw "ORIN_USER is unset" }
if ([string]::IsNullOrWhiteSpace($env:ORIN_ROOT)) { throw "ORIN_ROOT is unset" }

$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Target = "$($env:ORIN_USER)@$($env:ORIN_HOST)"
$RemoteScript = "/tmp/lightning_nma_build_$PID.sh"
& scp -q (Join-Path $script:NmaRepoRoot "tools\orin\build_lightning.sh") "${Target}:$RemoteScript"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
function Quote-Shell([string]$Value) {
    $Escape = "'" + '"' + "'" + '"' + "'"
    return "'" + $Value.Replace("'", $Escape) + "'"
}
$RemoteRoot = Quote-Shell $env:ORIN_ROOT
& ssh -o BatchMode=yes $Target "bash '$RemoteScript' $RemoteRoot '$BuildType'; rc=`$?; rm -f '$RemoteScript'; exit `$rc" `
    2>&1 | Tee-Object -FilePath (Join-Path $LogDir "orin_build.log") | ForEach-Object { $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
