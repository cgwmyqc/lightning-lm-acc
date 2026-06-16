param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$VivadoHls = "vivado_hls"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $env:TEMP "lightning_hls_unified_obs"
}

$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$GoldenDir = Join-Path $RepoRoot "fpga\golden\localization\frame_000001"
$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "create_vivado_hls_project.tcl"

& $VivadoHls -f $Tcl -tclargs $GoldenDir $ProjectDir $Part "export_ip"
$HlsExitCode = $LASTEXITCODE

$IpDir = Join-Path $ProjectDir "solution1\impl\ip"
$ComponentXml = Join-Path $IpDir "component.xml"
$ZipPattern = Join-Path $IpDir "*.zip"
if ((Test-Path $ComponentXml) -or ((Get-ChildItem $ZipPattern -ErrorAction SilentlyContinue | Select-Object -First 1) -ne $null)) {
    exit 0
}

$IpPackTcl = Join-Path $IpDir "run_ippack.tcl"
if (!(Test-Path $IpPackTcl)) {
    if ($HlsExitCode -eq 0) {
        exit 1
    }
    exit $HlsExitCode
}

$IpPackText = Get-Content $IpPackTcl -Raw
if ($IpPackText -notmatch 'set Revision\s+"(\d+)"') {
    if ($HlsExitCode -eq 0) {
        exit 1
    }
    exit $HlsExitCode
}

$Revision = [UInt64]$Matches[1]
if ($Revision -le [UInt64][Int32]::MaxValue) {
    if ($HlsExitCode -eq 0) {
        exit 1
    }
    exit $HlsExitCode
}

Write-Warning "Vivado HLS generated core_revision=$Revision, which overflows Vivado 2018.3 IP packager. Rewriting local run_ippack.tcl revision to 1 and rerunning packager."
$IpPackText = $IpPackText -replace 'set Revision\s+"\d+"', 'set Revision    "1"'
Set-Content -Path $IpPackTcl -Value $IpPackText -Encoding ASCII

Push-Location $IpDir
try {
    & vivado -mode batch -source $IpPackTcl -notrace
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
