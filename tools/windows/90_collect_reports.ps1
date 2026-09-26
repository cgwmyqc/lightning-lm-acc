param(
    [switch]$CollectRemote,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
$CollectedDir = Join-Path $ReportRoot "reports"
New-Item -ItemType Directory -Force -Path $CollectedDir | Out-Null

$Sources = @(
    (Join-Path $script:NmaRepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig\ax7z100_pcie_mig_impl_utilization.txt"),
    (Join-Path $script:NmaRepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig\ax7z100_pcie_mig_impl_timing_summary.txt"),
    (Join-Path $script:NmaRepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig\summary.md")
)
foreach ($Source in $Sources) {
    if (Test-Path $Source) { Copy-Item -Force $Source $CollectedDir }
}

$TopReports = @(
    "unified_surfel_observation_core_csynth.rpt",
    "slam_ekf_update_core_csynth.rpt",
    "slam_loc_iterative_core_csynth.rpt"
)
foreach ($ReportName in $TopReports) {
    $Report = Get-ChildItem (Join-Path $script:NmaRepoRoot "fpga\vivado\.build") -Filter $ReportName `
        -File -Recurse -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($Report) {
        Copy-Item -Force $Report.FullName (Join-Path $CollectedDir $Report.Name)
    }
}

if ($CollectRemote) {
    Assert-OrinConfig
    $Target = Get-OrinTarget
    $ScpOptions = Get-OrinScpOptions
    & scp @ScpOptions -q -r "${Target}:$($env:ORIN_ROOT)/reports/nma/r0/." $ReportRoot
    if ($LASTEXITCODE -ne 0) { throw "Remote report collection failed" }
}

$ManifestPath = Join-Path $ReportRoot "artifact_manifest.csv"
$Manifest = Get-ChildItem $ReportRoot -File -Recurse | Where-Object { $_.FullName -ne $ManifestPath } | ForEach-Object {
    [pscustomobject]@{
        path = $_.FullName.Substring($ReportRoot.Length).TrimStart('\')
        bytes = $_.Length
        sha256 = (Get-FileHash -Algorithm SHA256 $_.FullName).Hash.ToLowerInvariant()
    }
}
$Manifest | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $ManifestPath
Write-Output "R0_REPORT_COLLECTION_PASS files=$($Manifest.Count)"
