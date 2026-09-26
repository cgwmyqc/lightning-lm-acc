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
bdf=$(lspci -Dn -d 10ee: | awk 'NR == 1 { print $1 }')
if [ -z "$bdf" ]; then
    echo "ORIN_PREFLIGHT_FAIL reason=xilinx_endpoint_missing"
    exit 12
fi
echo "PCIE_BDF=$bdf"
lspci -nn -s "$bdf"
pcie_path="/sys/bus/pci/devices/$bdf"
current_speed=$(cat "$pcie_path/current_link_speed")
current_width=$(cat "$pcie_path/current_link_width")
max_speed=$(cat "$pcie_path/max_link_speed")
max_width=$(cat "$pcie_path/max_link_width")
echo "PCIE_CURRENT_SPEED=$current_speed"
echo "PCIE_CURRENT_WIDTH=$current_width"
echo "PCIE_MAX_SPEED=$max_speed"
echo "PCIE_MAX_WIDTH=$max_width"
if [[ "$current_speed" != 5.0\ GT/s* || "$current_width" != "4" ]]; then
    echo "ORIN_PREFLIGHT_FAIL reason=link_not_gen2_x4"
    exit 14
fi
for node in /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 /dev/xdma0_events_0; do
    if [ ! -c "$node" ]; then
        echo "ORIN_PREFLIGHT_FAIL reason=xdma_node_missing node=$node"
        exit 15
    fi
    if [ ! -r "$node" ] || [ ! -w "$node" ]; then
        echo "ORIN_PREFLIGHT_FAIL reason=xdma_access_denied node=$node"
        exit 16
    fi
done
ls -l /dev/xdma0_user /dev/xdma0_h2c_0 /dev/xdma0_c2h_0 /dev/xdma0_events_0
echo ORIN_PREFLIGHT_PASS
'@
$RemoteRoot = Quote-Shell $env:ORIN_ROOT
$Remote | & ssh @SshOptions $Target "bash -s -- $RemoteRoot 2>&1" |
    Tee-Object -FilePath (Join-Path $LogDir "orin_preflight.log") | ForEach-Object { $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
