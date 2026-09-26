param(
    [int]$Cycles = 10,
    [string]$Bitstream,
    [string]$ReportRoot
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $ScriptDir "env.ps1")
if ([string]::IsNullOrWhiteSpace($ReportRoot)) { $ReportRoot = $env:NMA_REPORT_ROOT }
if ($Cycles -lt 1) { throw "Cycles must be >= 1" }

$LogDir = Join-Path $ReportRoot "logs\pcie_stability"
$CsvPath = Join-Path $ReportRoot "pcie_recovery_cycles.csv"
New-Item -ItemType Directory -Force -Path $LogDir | Out-Null

$Rows = @()
for ($Cycle = 1; $Cycle -le $Cycles; $Cycle++) {
    $Started = Get-Date
    $CommandArgs = @(
        "-ExecutionPolicy", "Bypass",
        "-File", (Join-Path $ScriptDir "21_program_jtag.ps1"),
        "-ReportRoot", $ReportRoot
    )
    if (![string]::IsNullOrWhiteSpace($Bitstream)) {
        $CommandArgs += @("-Bitstream", $Bitstream)
    }

    $PreviousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    $Output = & powershell @CommandArgs 2>&1
    $ExitCode = $LASTEXITCODE
    $ErrorActionPreference = $PreviousErrorAction

    $Log = Join-Path $LogDir ("cycle_{0:d2}.log" -f $Cycle)
    $Output | Set-Content -Encoding UTF8 -Path $Log
    $Output | ForEach-Object { $_ }
    $LinkLine = $Output | Where-Object { "$_" -like "PCIE_LINK_STATUS=*" } | Select-Object -Last 1
    $Rows += [pscustomobject]@{
        cycle = $Cycle
        started_at = $Started.ToString("o")
        elapsed_ms = [math]::Round(((Get-Date) - $Started).TotalMilliseconds, 3)
        exit_code = $ExitCode
        link_status = if ($LinkLine) { "$LinkLine".Substring("PCIE_LINK_STATUS=".Length) } else { "" }
        status = if ($ExitCode -eq 0) { "PASS" } else { "FAIL" }
        log = $Log.Substring($ReportRoot.Length).TrimStart('\')
    }
    $Rows | Export-Csv -NoTypeInformation -Encoding UTF8 -Path $CsvPath

    if ($ExitCode -ne 0) {
        Write-Error "PCIe stability gate failed at cycle $Cycle of $Cycles"
        exit $ExitCode
    }
}

Write-Output "R0_PCIE_RECOVERY_STABILITY_PASS cycles=$Cycles"
