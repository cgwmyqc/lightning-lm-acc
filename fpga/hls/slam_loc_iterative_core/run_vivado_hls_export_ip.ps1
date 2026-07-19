param(
    [string]$ProjectDir,
    [string]$Part = "xc7z100ffg900-2",
    [string]$ClockNs = "8",
    [string]$VivadoHls = "vivado_hls",
    [string]$Vivado = "vivado"
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$DefaultBuildRoot = Join-Path $RepoRoot "fpga\vivado\.build"
. (Join-Path $RepoRoot "fpga\vivado\slam_accel_hls_mem_harness\vivado_path.ps1")
if ([string]::IsNullOrWhiteSpace($ProjectDir)) {
    $ProjectDir = Join-Path $DefaultBuildRoot "hls_slam_loc_iterative_export"
}

$GoldenDir = Join-Path $RepoRoot "fpga\golden\localization_iterative\frame_000001"
$ProjectDir = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ProjectDir)
$Tcl = Join-Path $ScriptDir "create_vivado_hls_project.tcl"

$ShortPathInfo = New-LightningVivadoShortPath -ActualPath $ProjectDir -BuildRoot $DefaultBuildRoot
try {
    $VivadoProjectDir = $ShortPathInfo.ShortPath
    & $VivadoHls -f $Tcl -tclargs $GoldenDir $VivadoProjectDir $Part "export_ip" $ClockNs
    $hlsExit = $LASTEXITCODE
    $IpDir = Join-Path $ProjectDir "solution1\impl\ip"
    $VivadoIpDir = Join-Path $VivadoProjectDir "solution1\impl\ip"
    $PackTcl = Join-Path $IpDir "run_ippack.tcl"
    $VivadoPackTcl = Join-Path $VivadoIpDir "run_ippack.tcl"
    $ComponentXml = Join-Path $IpDir "component.xml"
    if (!(Test-Path $ComponentXml) -and (Test-Path $PackTcl)) {
        $content = Get-Content $PackTcl -Raw
        if ($content -match 'set Revision\s+"?(\d+)"?') {
            $Revision = [UInt64]$Matches[1]
            if ($Revision -gt [UInt64][Int32]::MaxValue) {
                Write-Warning "Vivado HLS generated overflowing core_revision=$Revision. Rewriting local run_ippack.tcl revision to 1 and rerunning packager."
                $content = $content -replace 'set Revision\s+"?\d+"?', 'set Revision    "1"'
                Set-Content -Path $PackTcl -Value $content -Encoding ASCII
                Push-Location $VivadoIpDir
                try {
                    & $Vivado -mode batch -source $VivadoPackTcl -notrace
                    $hlsExit = $LASTEXITCODE
                } finally {
                    Pop-Location
                }
            }
        }
    }
    if (Test-Path $ComponentXml) {
        Write-Host "LOC_ITER_EXPORT_IP_PASS"
        Write-Host "LOC_ITER_HLS_IP_DIR=$IpDir"
        exit 0
    }
    if ($hlsExit -eq 0) {
        Write-Error "Localization iterative HLS IP export did not produce component.xml: $ComponentXml"
        exit 1
    }
    exit $hlsExit
} finally {
    Remove-LightningVivadoShortPath -ShortPathInfo $ShortPathInfo
}
