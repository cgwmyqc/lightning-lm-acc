param(
    [ValidateSet("A", "A2", "B", "C")][string]$Stage = "A2",
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [int]$Jobs = 18,
    [string]$ReferenceRoot
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")

if ($Jobs -lt 1) {
    throw "Jobs must be >= 1"
}
$StageLower = $Stage.ToLowerInvariant()
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "xdma_restore_stage_${StageLower}_impl"
}
if ([string]::IsNullOrWhiteSpace($ReferenceRoot)) {
    $ReferenceRoot = Resolve-Path (Join-Path $RepoRoot "..")
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$ReferenceRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReferenceRoot)
$Tcl = Join-Path $ScriptDir "run_project_impl_bitstream.tcl"
$Log = Join-Path $ProjectDir "vivado_impl_bitstream.log"
$Journal = Join-Path $ProjectDir "vivado_impl_bitstream.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_impl_bitstream.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_impl_bitstream.jou"
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $Stage $Jobs $ReferenceRoot
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\xdma_restore_chain\stage_$StageLower"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
$ActualBitstream = Get-ChildItem -Path (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}.runs\impl_1") -Filter "*.bit" -ErrorAction SilentlyContinue | Select-Object -First 1
$ActualBitstreamReport = Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_bitstream_path_actual.txt"
if ($ActualBitstream) {
    @(
        "BITSTREAM_PATH=$($ActualBitstream.FullName)"
        "BITSTREAM_SIZE_BYTES=$($ActualBitstream.Length)"
    ) | Set-Content -Encoding ASCII -Path $ActualBitstreamReport
} elseif (Test-Path (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_bitstream_path.txt")) {
    Copy-Item -Force (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_bitstream_path.txt") $ActualBitstreamReport
}

foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_impl_bitstream_log.txt" },
    @{ Source = $Journal; Target = "vivado_impl_bitstream_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}.runs\synth_1\runme.log"); Target = "vivado_impl_synth_runme_log.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}.runs\impl_1\runme.log"); Target = "vivado_impl_runme_log.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_ip_status.rpt"); Target = "ip_status_impl.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_xdma_bd_properties.rpt"); Target = "xdma_bd_properties_impl.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_xdma_ip_properties.rpt"); Target = "xdma_ip_properties_impl.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_impl_util.rpt"); Target = "impl_utilization.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_impl_timing.rpt"); Target = "impl_timing_summary.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_impl_drc.rpt"); Target = "impl_drc.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_impl_route_status.rpt"); Target = "impl_route_status.txt" },
    @{ Source = $ActualBitstreamReport; Target = "bitstream_path.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
