param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern("^[A-Za-z0-9._-]+$")]
    [string]$ChangeId,
    [int]$Cycles = 10,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
if ($Cycles -ne 10) { throw "The R0 recovery gate requires exactly 10 cycles" }

function Invoke-R0Step {
    param([string]$Name, [string]$Script, [string[]]$Arguments = @())
    Write-Output "R0_STEP_BEGIN name=$Name"
    & powershell -ExecutionPolicy Bypass -File (Join-Path $ScriptDir $Script) `
        -ReportRoot $ReportRoot @Arguments
    if ($LASTEXITCODE -ne 0) {
        Write-Output "R0_STEP_FAIL name=$Name exit_code=$LASTEXITCODE"
        exit $LASTEXITCODE
    }
    Write-Output "R0_STEP_PASS name=$Name"
}

Invoke-R0Step "stage_a2_x4_diagnostic" "29_pcie_link_diagnostics.ps1" -Arguments @("-ChangeId", $ChangeId)
Invoke-R0Step "stage_a2_preflight" "30_orin_preflight.ps1"
Invoke-R0Step "program_full_nma" "21_program_jtag.ps1"
Invoke-R0Step "full_nma_preflight" "30_orin_preflight.ps1"
Invoke-R0Step "ten_cycle_recovery" "35_pcie_stability.ps1" -Arguments @("-Cycles", "$Cycles")
Invoke-R0Step "xdma_payload_bar_ddr" "36_run_xdma_matrix.ps1"
Invoke-R0Step "four_suite_golden" "33_run_golden.ps1" -Arguments @("-Suite", "all", "-Repeat", "3", "-VerifyReadback")
Invoke-R0Step "collect_reports" "90_collect_reports.ps1"

Write-Output "R0_POST_X4_ACCEPTANCE_PASS change_id=$ChangeId cycles=$Cycles"
