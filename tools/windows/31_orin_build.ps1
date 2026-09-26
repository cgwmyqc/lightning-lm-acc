param(
    [ValidateSet("Debug", "Release", "RelWithDebInfo")][string]$BuildType = "RelWithDebInfo",
    [switch]$Sync,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
Assert-OrinConfig

$LogDir = Join-Path $ReportRoot "logs"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Target = Get-OrinTarget
$SshOptions = Get-OrinSshOptions
$ScpOptions = Get-OrinScpOptions
$RemoteScript = "/tmp/lightning_nma_build_$PID.sh"
& scp @ScpOptions -q (Join-Path $script:NmaRepoRoot "tools\orin\build_lightning.sh") "${Target}:$RemoteScript"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
$RemoteRoot = Quote-Shell $env:ORIN_ROOT
$SyncCommand = if ($Sync) {
    "cd $RemoteRoot && test -z `"`$(git status --porcelain)`" && git fetch origin dev-acc && git checkout dev-acc && git merge --ff-only origin/dev-acc && "
} else { "" }
$PreviousErrorAction = $ErrorActionPreference
$ErrorActionPreference = "Continue"
$RemoteCommand = "{ $SyncCommand bash '$RemoteScript' $RemoteRoot '$BuildType'; rc=`$?; rm -f '$RemoteScript'; exit `$rc; } 2>&1"
& ssh @SshOptions $Target $RemoteCommand |
    Tee-Object -FilePath (Join-Path $LogDir "orin_build.log") | ForEach-Object { $_ }
$SshExitCode = $LASTEXITCODE
$ErrorActionPreference = $PreviousErrorAction
if ($SshExitCode -ne 0) { exit $SshExitCode }
