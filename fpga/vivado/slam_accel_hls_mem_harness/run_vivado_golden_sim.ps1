param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [string]$VivadoHls = "vivado_hls",
    [string]$HlsProjectDir,
    [string]$GoldenDir,
    [string]$ImageDir,
    [int]$MaxPoints = 64,
    [switch]$FullFrame,
    [switch]$RunNumeric
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $ScriptDir "vivado_path.ps1")

if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "lmem_golden_sim"
}
if ([string]::IsNullOrWhiteSpace($HlsProjectDir)) {
    $HlsProjectDir = Join-Path $env:TEMP "lightning_hls_unified_obs"
}
if ([string]::IsNullOrWhiteSpace($GoldenDir)) {
    $GoldenDir = Join-Path $RepoRoot "fpga\golden\localization\frame_000001"
}
if ([string]::IsNullOrWhiteSpace($ImageDir)) {
    if ($FullFrame) {
        $ImageDir = Join-Path $BuildRoot "golden_frame_000001_full"
    } else {
        $ImageDir = Join-Path $BuildRoot ("golden_frame_000001_n{0}" -f $MaxPoints)
    }
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$HlsProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($HlsProjectDir)
$GoldenDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($GoldenDir)
$ImageDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ImageDir)
$HlsImplDir = Join-Path $HlsProjectDir "solution1\impl"
$ComponentXml = Join-Path $HlsImplDir "ip\component.xml"

if (!(Test-Path $ComponentXml)) {
    $ExportScript = Join-Path $RepoRoot "fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1"
    & powershell -ExecutionPolicy Bypass -File $ExportScript -ProjectDir $HlsProjectDir -Part $Part -VivadoHls $VivadoHls
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

if ($FullFrame) {
    $ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_hls_mem_harness\golden_frame_000001_full"
} else {
    $ReportDir = Join-Path $RepoRoot ("reports\fpga\vivado\slam_accel_hls_mem_harness\golden_frame_000001_n{0}" -f $MaxPoints)
}
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null

$ImageScript = Join-Path $ScriptDir "make_golden_mem_images.py"
if ($FullFrame) {
    & python $ImageScript --golden-dir $GoldenDir --out-dir $ImageDir --report-dir $ReportDir
} else {
    & python $ImageScript --golden-dir $GoldenDir --out-dir $ImageDir --report-dir $ReportDir --max-points $MaxPoints
}
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

$Tcl = Join-Path $ScriptDir "run_golden_sim.tcl"
$Log = Join-Path $ProjectDir "vivado_golden_sim.log"
$Journal = Join-Path $ProjectDir "vivado_golden_sim.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_golden_sim.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_golden_sim.jou"
    $RunNumericArg = if ($RunNumeric) { "1" } else { "0" }
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $HlsImplDir $ImageDir $RunNumericArg
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_golden_sim_log.txt" },
    @{ Source = $Journal; Target = "vivado_golden_sim_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem_golden.sim\sim_1\behav\xsim\simulate.log"); Target = "xsim_golden_simulate_log.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem_golden.sim\sim_1\behav\xsim\xvlog.log"); Target = "xsim_golden_xvlog_log.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem_golden.sim\sim_1\behav\xsim\xelab.log"); Target = "xsim_golden_xelab_log.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

$CombinedLog = ""
if (Test-Path $Log) {
    $CombinedLog += [System.IO.File]::ReadAllText($Log)
}
$XsimLog = Join-Path $ProjectDir "lmem_golden.sim\sim_1\behav\xsim\simulate.log"
if (Test-Path $XsimLog) {
    $CombinedLog += [System.IO.File]::ReadAllText($XsimLog)
}

if ($RunNumeric) {
    if ($CombinedLog -match "\[tb_lmem_golden\] FAIL") {
        exit 1
    }
    if ($CombinedLog -notmatch "\[tb_lmem_golden\] PASS") {
        exit 1
    }
} else {
    if ($CombinedLog -notmatch "GOLDEN_SIM_ELABORATE_PRELOAD_ONLY") {
        exit 1
    }
    if ($CombinedLog -notmatch "\[axi_memory_model\] loaded") {
        exit 1
    }
}

exit $ExitCode
