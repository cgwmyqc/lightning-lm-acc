param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$Vivado = "vivado",
    [string]$VivadoHls = "vivado_hls",
    [string]$HlsProjectDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$BuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $ScriptDir "vivado_path.ps1")
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $BuildRoot "lmem_sim"
}
if ([string]::IsNullOrWhiteSpace($HlsProjectDir)) {
    $HlsProjectDir = Join-Path $env:TEMP "lightning_hls_unified_obs"
}

$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$HlsProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($HlsProjectDir)
$HlsIpDir = Join-Path $HlsProjectDir "solution1\impl\ip"
$ComponentXml = Join-Path $HlsIpDir "component.xml"

if (!(Test-Path $ComponentXml)) {
    $ExportScript = Join-Path $RepoRoot "fpga\hls\unified_surfel_observation_core\run_vivado_hls_export_ip.ps1"
    & powershell -ExecutionPolicy Bypass -File $ExportScript -ProjectDir $HlsProjectDir -Part $Part -VivadoHls $VivadoHls
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

$Tcl = Join-Path $ScriptDir "run_sim.tcl"
$Log = Join-Path $ProjectDir "vivado_sim.log"
$Journal = Join-Path $ProjectDir "vivado_sim.jou"

New-Item -ItemType Directory -Force -Path $ProjectDir | Out-Null
$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $BuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    $VivadoLog = Join-Path $VivadoProjectDir "vivado_sim.log"
    $VivadoJournal = Join-Path $VivadoProjectDir "vivado_sim.jou"
    & $Vivado -mode batch -source $Tcl -journal $VivadoJournal -log $VivadoLog -tclargs $VivadoProjectDir $Part $HlsIpDir
    $ExitCode = $LASTEXITCODE
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_hls_mem_harness"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
foreach ($Item in @(
    @{ Source = $Log; Target = "vivado_sim_log.txt" },
    @{ Source = $Journal; Target = "vivado_sim_jou.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem.sim\sim_1\behav\xsim\simulate.log"); Target = "xsim_simulate_log.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem.sim\sim_1\behav\xsim\xvlog.log"); Target = "xsim_xvlog_log.txt" },
    @{ Source = (Join-Path $ProjectDir "lmem.sim\sim_1\behav\xsim\xelab.log"); Target = "xsim_xelab_log.txt" }
)) {
    if (Test-Path $Item.Source) {
        Copy-Item -Force $Item.Source (Join-Path $ReportDir $Item.Target)
    }
}

$CombinedLog = ""
if (Test-Path $Log) {
    $CombinedLog += [System.IO.File]::ReadAllText($Log)
}
$XsimLog = Join-Path $ProjectDir "lmem.sim\sim_1\behav\xsim\simulate.log"
if (Test-Path $XsimLog) {
    $CombinedLog += [System.IO.File]::ReadAllText($XsimLog)
}

if ($CombinedLog -match "\[tb_lmem_bd_smoke\] FAIL") {
    exit 1
}
if ($CombinedLog -notmatch "\[tb_lmem_bd_smoke\] PASS") {
    exit 1
}

exit $ExitCode
