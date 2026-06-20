param(
    [ValidateSet("A", "A2", "B", "C")][string]$Stage = "A2",
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [string]$ReferenceRoot
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")

$StageLower = $Stage.ToLowerInvariant()
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "xdma_restore_stage_${StageLower}_bd"
}
if ([string]::IsNullOrWhiteSpace($ReferenceRoot)) {
    $ReferenceRoot = Resolve-Path (Join-Path $RepoRoot "..")
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$ReferenceRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReferenceRoot)
$Tcl = Join-Path $ScriptDir "create_stage_bd.tcl"
$Log = Join-Path $ProjectDir "vivado_bd_validate.log"
$Journal = Join-Path $ProjectDir "vivado_bd_validate.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_bd_validate.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_bd_validate.jou"
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $Stage $ReferenceRoot
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\xdma_restore_chain\stage_$StageLower"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_bd_validate_log.txt" },
    @{ Source = $Journal; Target = "vivado_bd_validate_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_ip_status.rpt"); Target = "ip_status.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_xdma_bd_properties.rpt"); Target = "xdma_bd_properties.txt" },
    @{ Source = (Join-Path $ProjectDir "xdma_restore_stage_${StageLower}_xdma_ip_properties.rpt"); Target = "xdma_ip_properties.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

exit $ExitCode
