param(
    [ValidatePattern("^[A-Za-z0-9._-]+$")]
    [string]$ChangeId = (Get-Date -Format "yyyyMMdd_HHmmss"),
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
Assert-OrinConfig

$LogDir = Join-Path $ReportRoot "logs\pcie_diagnostics"
$CsvPath = Join-Path $ReportRoot "pcie_diagnostic_attempts.csv"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Target = Get-OrinTarget
$SshOptions = Get-OrinSshOptions
$ScpOptions = Get-OrinScpOptions
$RemoteScript = "/tmp/lightning_pcie_diagnostics_$PID.sh"
$LocalScript = Join-Path $script:NmaRepoRoot "tools\orin\pcie_link_diagnostics.sh"

& scp @ScpOptions -q $LocalScript "${Target}:$RemoteScript"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$PreviousErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$Output = & ssh @SshOptions $Target "bash '$RemoteScript' 2>&1"
$ExitCode = $LASTEXITCODE
$ErrorActionPreference = $PreviousErrorAction
& ssh @SshOptions $Target "rm -f '$RemoteScript'" | Out-Null

$LogPath = Join-Path $LogDir "${ChangeId}.log"
$Output | Set-Content -Encoding UTF8 -Path $LogPath
$Output | ForEach-Object { $_ }

$Values = @{}
foreach ($Line in $Output) {
    $Text = "$Line"
    if ($Text -match '^([A-Z0-9_]+)=(.*)$') {
        $Values[$Matches[1]] = $Matches[2]
    }
}

$GitCommit = (& git -C $script:NmaRepoRoot rev-parse HEAD).Trim()
$GitDirty = ![string]::IsNullOrWhiteSpace((& git -C $script:NmaRepoRoot status --porcelain | Out-String))
$Row = [pscustomobject]@{
    change_id = $ChangeId
    timestamp_utc = $Values["TIMESTAMP_UTC"]
    git_commit = $GitCommit
    working_tree_dirty = $GitDirty
    hostname = $Values["HOSTNAME"]
    endpoint_bdf = $Values["ENDPOINT_BDF"]
    root_bdf = $Values["ROOT_BDF"]
    endpoint_speed = $Values["ENDPOINT_CURRENT_SPEED"]
    endpoint_width = $Values["ENDPOINT_CURRENT_WIDTH"]
    endpoint_max_speed = $Values["ENDPOINT_MAX_SPEED"]
    endpoint_max_width = $Values["ENDPOINT_MAX_WIDTH"]
    root_speed = $Values["ROOT_CURRENT_SPEED"]
    root_width = $Values["ROOT_CURRENT_WIDTH"]
    root_max_speed = $Values["ROOT_MAX_SPEED"]
    root_max_width = $Values["ROOT_MAX_WIDTH"]
    dt_status = $Values["DT_STATUS"]
    dt_num_lanes = $Values["DT_NUM_LANES"]
    dt_domain = $Values["DT_DOMAIN"]
    dt_phy_names = $Values["DT_PHY_NAMES"]
    endpoint_driver = $Values["ENDPOINT_DRIVER"]
    xdma_nodes_ok = $Values["XDMA_NODES_OK"]
    xdma_user_mode = $Values["XDMA0_USER_MODE"]
    xdma_h2c_mode = $Values["XDMA0_H2C_0_MODE"]
    xdma_c2h_mode = $Values["XDMA0_C2H_0_MODE"]
    xdma_event_mode = $Values["XDMA0_EVENTS_0_MODE"]
    status = $Values["DIAG_STATUS"]
    reason = $Values["DIAG_REASON"]
    exit_code = $ExitCode
    log = $LogPath.Substring($ReportRoot.Length).TrimStart('\')
}

$Rows = @()
if (Test-Path -LiteralPath $CsvPath) {
    $Rows = @(Import-Csv -LiteralPath $CsvPath | Where-Object { $_.change_id -ne $ChangeId })
}
$Rows += $Row
$Rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $CsvPath

if ($ExitCode -ne 0) {
    Write-Output "R0_PCIE_DIAGNOSTIC_FAIL change_id=$ChangeId reason=$($Values['DIAG_REASON'])"
    exit $ExitCode
}
Write-Output "R0_PCIE_DIAGNOSTIC_PASS change_id=$ChangeId"
