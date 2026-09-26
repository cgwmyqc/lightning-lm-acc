param(
    [ValidateSet("all", "localization", "localization_iterative", "mapping", "mapping_update")]
    [string]$Suite = "all",
    [int]$Repeat = 3,
    [switch]$VerifyReadback,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
Assert-OrinConfig
if ($Repeat -lt 1) { throw "Repeat must be >= 1" }

& powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir "30_orin_preflight.ps1") `
    -ReportRoot $ReportRoot
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$LogDir = Join-Path $ReportRoot "logs"
$ResultDir = Join-Path $ReportRoot "golden"
New-Item -ItemType Directory -Force -Path $LogDir, $ResultDir | Out-Null
$Target = Get-OrinTarget
$SshOptions = Get-OrinSshOptions
$ScpOptions = Get-OrinScpOptions
$RemoteRunner = "/tmp/lightning_nma_runner_$PID.sh"
& scp @ScpOptions -q (Join-Path $script:NmaRepoRoot "tools\orin\run_lightning_golden.sh") "${Target}:$RemoteRunner"
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$Suites = if ($Suite -eq "all") {
    @("localization", "localization_iterative", "mapping", "mapping_update")
} else { @($Suite) }
$Definitions = @{
    localization = @("run_surfel_loc_xdma_golden", "fpga/golden/localization/frame_000001")
    localization_iterative = @("run_surfel_loc_iterative_xdma_golden", "fpga/golden/localization_iterative/frame_000001")
    mapping = @("run_surfel_mapping_xdma_golden", "fpga/golden/mapping/frame_000001")
    mapping_update = @("run_mapping_ekf_update_xdma_golden", "fpga/golden/mapping_update/frame_000001")
}
$Verify = if ($VerifyReadback) { "true" } else { "false" }
foreach ($Name in $Suites) {
    $Executable = $Definitions[$Name][0]
    $Golden = $Definitions[$Name][1]
    $RemoteOutput = "$($env:ORIN_ROOT)/reports/nma/r0/golden/$Name"
    if ($Name -eq "mapping") {
        for ($Iteration = 1; $Iteration -le $Repeat; $Iteration++) {
            $RunName = "run_{0:d2}" -f $Iteration
            $RunOutput = "$RemoteOutput/$RunName"
            $CommandParts = @(
                "bash", $RemoteRunner, $env:ORIN_ROOT, $RunOutput, $Executable,
                "--golden_dir=$Golden"
            )
            $RemoteCommand = ($CommandParts | ForEach-Object { Quote-Shell $_ }) -join " "
            & ssh @SshOptions $Target "$RemoteCommand 2>&1" |
                Tee-Object -FilePath (Join-Path $LogDir "golden_${Name}_${RunName}.log") | ForEach-Object { $_ }
            if ($LASTEXITCODE -ne 0) { throw "$Name $RunName golden failed" }
        }
        & scp @ScpOptions -q -r "${Target}:$RemoteOutput" $ResultDir
        if ($LASTEXITCODE -ne 0) { throw "Failed to collect $Name golden output" }
        continue
    }
    $Arguments = @("--golden_dir=$Golden", "--verify_readback=$Verify")
    $Arguments += "--repeat=$Repeat"
    $Arguments += "--output_dir=$RemoteOutput"
    $CommandParts = @("bash", $RemoteRunner, $env:ORIN_ROOT, $RemoteOutput, $Executable) + $Arguments
    $RemoteCommand = ($CommandParts | ForEach-Object { Quote-Shell $_ }) -join " "
    & ssh @SshOptions $Target "$RemoteCommand 2>&1" |
        Tee-Object -FilePath (Join-Path $LogDir "golden_${Name}.log") | ForEach-Object { $_ }
    if ($LASTEXITCODE -ne 0) { throw "$Name golden failed" }
    & scp @ScpOptions -q -r "${Target}:$RemoteOutput" $ResultDir
    if ($LASTEXITCODE -ne 0) { throw "Failed to collect $Name golden output" }
}
& ssh @SshOptions $Target "rm -f '$RemoteRunner'" | Out-Null
Write-Output "R0_GOLDEN_PASS"
