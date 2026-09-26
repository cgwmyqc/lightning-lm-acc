param(
    [Parameter(Mandatory = $true)][string]$InputBag,
    [Parameter(Mandatory = $true)][string]$MapPath,
    [Parameter(Mandatory = $true)][string]$CpuConfig,
    [Parameter(Mandatory = $true)][string]$FpgaObsConfig,
    [Parameter(Mandatory = $true)][string]$FpgaFullConfig,
    [int]$WarmupFrames = 100,
    [int]$MeasureFrames = 500,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
if ([string]::IsNullOrWhiteSpace($env:ORIN_USER)) { throw "ORIN_USER is unset" }
if ([string]::IsNullOrWhiteSpace($env:ORIN_ROOT)) { throw "ORIN_ROOT is unset" }
if ($WarmupFrames -lt 0 -or $MeasureFrames -lt 1) { throw "Invalid warmup/measure frame counts" }

$LogDir = Join-Path $ReportRoot "logs"
$BenchmarkDir = Join-Path $ReportRoot "benchmark"
New-Item -ItemType Directory -Force -Path $LogDir, $BenchmarkDir | Out-Null
$Target = "$($env:ORIN_USER)@$($env:ORIN_HOST)"
$Runner = "/tmp/lightning_nma_runner_$PID.sh"
$XdmaBench = "/tmp/lightning_nma_xdma_benchmark_$PID.sh"
& scp -q (Join-Path $script:NmaRepoRoot "tools\orin\run_lightning_benchmark.sh") "${Target}:$Runner"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
& scp -q (Join-Path $script:NmaRepoRoot "tools\orin\xdma_benchmark.sh") "${Target}:$XdmaBench"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

& ssh -o BatchMode=yes $Target "bash '$XdmaBench' '$($env:ORIN_ROOT)/reports/nma/r0/benchmark/pcie_xdma.csv'" 2>&1 |
    Tee-Object -FilePath (Join-Path $LogDir "pcie_xdma_benchmark.log") | ForEach-Object { $_ }
if ($LASTEXITCODE -ne 0) { throw "XDMA bandwidth benchmark failed" }

function Quote-Shell([string]$Value) {
    $Escape = "'" + '"' + "'" + '"' + "'"
    return "'" + $Value.Replace("'", $Escape) + "'"
}
$Runs = @(
    @{ Name = "CPU"; Config = $CpuConfig },
    @{ Name = "FPGA_OBS"; Config = $FpgaObsConfig },
    @{ Name = "FPGA_FULL_ITERATIVE"; Config = $FpgaFullConfig }
)
foreach ($Run in $Runs) {
    $RemoteOutput = "$($env:ORIN_ROOT)/reports/nma/r0/benchmark/$($Run.Name)"
    $Parts = @("bash", $Runner, $env:ORIN_ROOT, $RemoteOutput, "$WarmupFrames", "$MeasureFrames",
               "run_loc_offline", "--input_bag=$InputBag", "--map_path=$MapPath", "--config=$($Run.Config)")
    $RemoteCommand = ($Parts | ForEach-Object { Quote-Shell $_ }) -join " "
    & ssh -o BatchMode=yes $Target $RemoteCommand 2>&1 |
        Tee-Object -FilePath (Join-Path $LogDir "benchmark_$($Run.Name).log") | ForEach-Object { $_ }
    if ($LASTEXITCODE -ne 0) { throw "$($Run.Name) benchmark failed" }
}

& scp -q -r "${Target}:$($env:ORIN_ROOT)/reports/nma/r0/benchmark/." $BenchmarkDir
if ($LASTEXITCODE -ne 0) { throw "Failed to collect benchmark results" }
& ssh -o BatchMode=yes $Target "rm -f '$Runner' '$XdmaBench'" | Out-Null
Write-Output "R0_BENCHMARK_COLLECTION_PASS"
