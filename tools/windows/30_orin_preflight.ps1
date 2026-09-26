param([string]$ReportRoot)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
Assert-OrinConfig

$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Target = Get-OrinTarget
$SshOptions = Get-OrinSshOptions
$Remote = @'
set -eu
echo "HOSTNAME=$(hostname)"
uname -a
test -d "$1"
echo "ORIN_ROOT_OK=$1"
lspci -nn | grep -i '10ee:'
lspci -d 10ee: -vv | grep -m1 'LnkSta:'
test -c /dev/xdma0_user
test -c /dev/xdma0_h2c_0
test -c /dev/xdma0_c2h_0
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0
echo ORIN_PREFLIGHT_PASS
'@
$RemoteRoot = Quote-Shell $env:ORIN_ROOT
$Remote | & ssh @SshOptions $Target "bash -s -- $RemoteRoot" 2>&1 |
    Tee-Object -FilePath (Join-Path $LogDir "orin_preflight.log") | ForEach-Object { $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
