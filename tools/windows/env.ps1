$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path (Join-Path $ScriptDir "..\..")).Path

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

