param([string]$ReportRoot)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
Assert-OrinConfig

& powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "30_orin_preflight.ps1") `
    -ReportRoot $ReportRoot
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$LogDir = Join-Path $ReportRoot "logs"
$BenchmarkDir = Join-Path $ReportRoot "benchmark"
New-Item -ItemType Directory -Force -Path $LogDir, $BenchmarkDir | Out-Null
$Target = Get-OrinTarget
$SshOptions = Get-OrinSshOptions
$ScpOptions = Get-OrinScpOptions
$RemoteRunner = "/tmp/lightning_nma_xdma_matrix_$PID.sh"

& scp @ScpOptions -q (Join-Path $script:NmaRepoRoot "tools\orin\xdma_benchmark.sh") "${Target}:$RemoteRunner"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$RemoteCsv = "$($env:ORIN_ROOT)/reports/nma/r0/benchmark/pcie_xdma.csv"
$RemoteCommand = "bash $(Quote-Shell $RemoteRunner) $(Quote-Shell $RemoteCsv) 2>&1"
& ssh @SshOptions $Target $RemoteCommand |
    Tee-Object -FilePath (Join-Path $LogDir "pcie_xdma_benchmark.log") | ForEach-Object { $_ }
$ExitCode = $LASTEXITCODE
& ssh @SshOptions $Target "rm -f '$RemoteRunner'" | Out-Null
if ($ExitCode -ne 0) { exit $ExitCode }

& scp @ScpOptions -q "${Target}:$RemoteCsv" (Join-Path $BenchmarkDir "pcie_xdma.csv")
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$RemoteSmoke = "$($env:ORIN_ROOT)/fpga/host/xdma_smoke/xdma_smoke.py"
$SmokeParts = @(
    "python3", $RemoteSmoke,
    "--shim-smoke", "--reg-smoke", "--ddr-smoke", "--ctrl-base", "0x1000"
)
$SmokeCommand = ($SmokeParts | ForEach-Object { Quote-Shell $_ }) -join " "
& ssh @SshOptions $Target "$SmokeCommand 2>&1" |
    Tee-Object -FilePath (Join-Path $LogDir "pcie_bar_ddr_smoke.log") | ForEach-Object { $_ }
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Output "R0_XDMA_PAYLOAD_BAR_DDR_PASS"
