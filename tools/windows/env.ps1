$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path
$LocalEnv = Join-Path $ScriptDir "env.local.ps1"
if (Test-Path -LiteralPath $LocalEnv) {
    . $LocalEnv
}

if ([string]::IsNullOrWhiteSpace($env:ORIN_HOST)) {
    $env:ORIN_HOST = "192.168.31.119"
}

# ORIN_USER and ORIN_ROOT are intentionally not given machine-specific defaults.
# Set them in the caller environment or in an ignored local wrapper. Passwords
# must never be stored here; all remote scripts use BatchMode SSH.

function Find-XilinxRoot {
    param([string]$CommandName)
    $Command = Get-Command $CommandName -ErrorAction SilentlyContinue
    if ($null -eq $Command) {
        return $null
    }
    return Split-Path -Parent (Split-Path -Parent $Command.Source)
}

if ([string]::IsNullOrWhiteSpace($env:VIVADO_2018_3)) {
    $VivadoRoot = Find-XilinxRoot "vivado"
    if ($VivadoRoot) {
        $env:VIVADO_2018_3 = $VivadoRoot
    }
}
if ([string]::IsNullOrWhiteSpace($env:VIVADO_HLS_2018_3)) {
    $HlsRoot = Find-XilinxRoot "vivado_hls"
    if ($HlsRoot) {
        $env:VIVADO_HLS_2018_3 = $HlsRoot
    }
}
if ([string]::IsNullOrWhiteSpace($env:NMA_KERNEL_CLOCK_HZ)) {
    $env:NMA_KERNEL_CLOCK_HZ = "125000000"
}
if ([string]::IsNullOrWhiteSpace($env:NMA_REPORT_ROOT)) {
    $env:NMA_REPORT_ROOT = Join-Path $RepoRoot "reports\nma\r0"
}

$script:NmaRepoRoot = $RepoRoot

function Assert-OrinConfig {
    if ([string]::IsNullOrWhiteSpace($env:ORIN_USER)) { throw "ORIN_USER is unset" }
    if ([string]::IsNullOrWhiteSpace($env:ORIN_ROOT)) { throw "ORIN_ROOT is unset" }
    if ([string]::IsNullOrWhiteSpace($env:ORIN_IDENTITY_FILE)) { throw "ORIN_IDENTITY_FILE is unset" }
    if (!(Test-Path -LiteralPath $env:ORIN_IDENTITY_FILE)) {
        throw "ORIN_IDENTITY_FILE does not exist: $($env:ORIN_IDENTITY_FILE)"
    }
    if ([string]::IsNullOrWhiteSpace($env:ORIN_KNOWN_HOSTS)) { throw "ORIN_KNOWN_HOSTS is unset" }
    if (!(Test-Path -LiteralPath $env:ORIN_KNOWN_HOSTS)) {
        throw "ORIN_KNOWN_HOSTS does not exist: $($env:ORIN_KNOWN_HOSTS)"
    }
}

function Get-OrinTarget {
    return "$($env:ORIN_USER)@$($env:ORIN_HOST)"
}

function Get-OrinSshOptions {
    return @(
        "-o", "BatchMode=yes",
        "-o", "IdentitiesOnly=yes",
        "-o", "StrictHostKeyChecking=yes",
        "-o", "UserKnownHostsFile=$($env:ORIN_KNOWN_HOSTS)",
        "-o", "ConnectTimeout=5",
        "-i", $env:ORIN_IDENTITY_FILE
    )
}

function Get-OrinScpOptions {
    return @(
        "-o", "BatchMode=yes",
        "-o", "IdentitiesOnly=yes",
        "-o", "StrictHostKeyChecking=yes",
        "-o", "UserKnownHostsFile=$($env:ORIN_KNOWN_HOSTS)",
        "-o", "ConnectTimeout=5",
        "-i", $env:ORIN_IDENTITY_FILE
    )
}

function Quote-Shell([string]$Value) {
    $Escape = "'" + '"' + "'" + '"' + "'"
    return "'" + $Value.Replace("'", $Escape) + "'"
}
