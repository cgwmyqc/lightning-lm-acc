param(
    [string]$XdmaModulePath = "",
    [switch]$AllowRebootFallback,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
Assert-OrinConfig
if (![string]::IsNullOrWhiteSpace($XdmaModulePath)) {
    throw "Custom XDMA module paths are disabled; the privileged helper uses modprobe xdma"
}

$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Target = Get-OrinTarget
$SshOptions = Get-OrinSshOptions
& ssh @SshOptions $Target "sudo -n /usr/local/sbin/lightning-pcie-control recover" `
    2>&1 | Tee-Object -FilePath (Join-Path $LogDir "orin_pcie_rescan.log") | ForEach-Object { $_ }
$ExitCode = $LASTEXITCODE
if ($ExitCode -ne 0 -and $AllowRebootFallback) {
    Write-Warning "PCIe hot recovery failed; explicit -AllowRebootFallback requested an Orin reboot."
    & ssh @SshOptions $Target "sudo -n /usr/local/sbin/lightning-pcie-control reboot"
    exit 2
}
exit $ExitCode
