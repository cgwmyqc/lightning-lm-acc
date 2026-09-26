param(
    [switch]$LocalOnly,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")

if ([string]::IsNullOrWhiteSpace($ReportRoot)) {
    $ReportRoot = $env:NMA_REPORT_ROOT
}
$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Checks = New-Object System.Collections.Generic.List[object]
function Add-Check {
    param([string]$Name, [bool]$Pass, [string]$Detail, [bool]$Required = $true)
    $Checks.Add([pscustomobject]@{
        name = $Name
        pass = $Pass
        required = $Required
        detail = $Detail
    })
}

foreach ($Name in @("git", "cmake", "python", "ssh", "scp", "vivado", "vivado_hls", "xsdb", "hw_server")) {
    $Command = Get-Command $Name -ErrorAction SilentlyContinue
    Add-Check "tool_$Name" ($null -ne $Command) $(if ($Command) { $Command.Source } else { "not found" })
}

$Branch = (& git -C $script:NmaRepoRoot branch --show-current 2>&1 | Out-String).Trim()
Add-Check "git_branch" ($Branch -eq "dev-acc") "current=$Branch expected=dev-acc"

foreach ($RelativePath in @(
    "fpga\golden\localization\frame_000001",
    "fpga\golden\localization_iterative\frame_000001",
    "fpga\golden\mapping\frame_000001",
    "fpga\golden\mapping_update\frame_000001",
    "fpga\vivado\slam_accel_ax7z100_pcie_mig\create_bd.tcl"
)) {
    $FullPath = Join-Path $script:NmaRepoRoot $RelativePath
    Add-Check "path_$($RelativePath -replace '[\\.]','_')" (Test-Path $FullPath) $FullPath
}

if (!$LocalOnly) {
    $HasUser = ![string]::IsNullOrWhiteSpace($env:ORIN_USER)
    $HasRoot = ![string]::IsNullOrWhiteSpace($env:ORIN_ROOT)
    Add-Check "orin_user_configured" $HasUser $(if ($HasUser) { "set" } else { "ORIN_USER is unset" })
    Add-Check "orin_root_configured" $HasRoot $(if ($HasRoot) { "set" } else { "ORIN_ROOT is unset" })

    $Reachable = $false
    $TcpDetail = "not tested"
    $Client = New-Object System.Net.Sockets.TcpClient
    try {
        $Async = $Client.BeginConnect($env:ORIN_HOST, 22, $null, $null)
        if ($Async.AsyncWaitHandle.WaitOne(2000)) {
            $Client.EndConnect($Async)
            $Reachable = $true
            $TcpDetail = "$($env:ORIN_HOST):22 reachable"
        } else {
            $TcpDetail = "$($env:ORIN_HOST):22 timed out"
        }
    } catch {
        $TcpDetail = $_.Exception.Message
    } finally {
        $Client.Close()
    }
    Add-Check "orin_ssh_port" $Reachable $TcpDetail
}

$CsvPath = Join-Path $ReportRoot "preflight.csv"
$Checks | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $CsvPath
$RequiredFailures = @($Checks | Where-Object { $_.required -and !$_.pass })
$Status = if ($RequiredFailures.Count -eq 0) { "PASS" } else { "FAIL" }
$Summary = @(
    "R0_PREFLIGHT=$Status"
    "timestamp=$([DateTime]::UtcNow.ToString('o'))"
    "repo=$script:NmaRepoRoot"
    "branch=$Branch"
    "checks=$($Checks.Count)"
    "required_failures=$($RequiredFailures.Count)"
)
$Summary | Set-Content -Encoding ASCII -Path (Join-Path $LogDir "preflight.log")
$Checks | Format-Table -AutoSize
$Summary
if ($Status -ne "PASS") {
    exit 1
}

