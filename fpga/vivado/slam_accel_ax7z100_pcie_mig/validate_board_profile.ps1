param(
    [string]$ReferenceRoot
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
if ([string]::IsNullOrWhiteSpace($ReferenceRoot)) {
    $ReferenceRoot = Resolve-Path (Join-Path $RepoRoot "..")
}
$ReferenceRoot = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($ReferenceRoot)

$DocxMatch = Get-ChildItem -LiteralPath $RepoRoot -Filter "cource_s1_ALINX_ZYNQ(AX7Z100)*.docx" | Select-Object -First 1
if ($null -eq $DocxMatch) {
    throw "Missing AX7Z100 docx in repo root: cource_s1_ALINX_ZYNQ(AX7Z100)*.docx"
}
$Docx = $DocxMatch.FullName
$MigPrj = Join-Path $ReferenceRoot "12_ddr3_pl\mig_a.prj"
$PcieXdc = Join-Path $ReferenceRoot "33_PCIe_test\Vivado\auto_create_project\src\constraints\pcie.xdc"
$PcieTcl = Join-Path $ReferenceRoot "33_PCIe_test\Vivado\auto_create_project\pl_config.tcl"

foreach ($Path in @($Docx, $MigPrj, $PcieXdc, $PcieTcl)) {
    if (!(Test-Path $Path)) {
        throw "Missing board reference file: $Path"
    }
}

$MigText = Get-Content -Raw -Encoding UTF8 $MigPrj
$PcieXdcText = Get-Content -Raw -Encoding UTF8 $PcieXdc
$PcieTclText = Get-Content -Raw -Encoding UTF8 $PcieTcl

$Checks = @(
    @{ Name = "MIG target part"; Text = $MigText; Pattern = "<TargetFPGA>xc7z100-ffg900/-2</TargetFPGA>" },
    @{ Name = "MIG DDR3 device"; Text = $MigText; Pattern = "<MemoryDevice>DDR3_SDRAM/Components/MT41K256M16XX-125</MemoryDevice>" },
    @{ Name = "MIG 200 MHz input"; Text = $MigText; Pattern = "<InputClkFreq>200</InputClkFreq>" },
    @{ Name = "MIG 1250 ps period"; Text = $MigText; Pattern = "<TimePeriod>1250</TimePeriod>" },
    @{ Name = "MIG 32-bit width"; Text = $MigText; Pattern = "<DataWidth>32</DataWidth>" },
    @{ Name = "MIG sys clk pins"; Text = $MigText; Pattern = "F9/E8(CC_P/N)" },
    @{ Name = "PCIe reset pin"; Text = $PcieXdcText; Pattern = "PACKAGE_PIN AB22" },
    @{ Name = "PCIe refclk P pin"; Text = $PcieXdcText; Pattern = "PACKAGE_PIN N8" },
    @{ Name = "PCIe refclk N pin"; Text = $PcieXdcText; Pattern = "PACKAGE_PIN N7" },
    @{ Name = "PL DDR sysclk P pin"; Text = $PcieXdcText; Pattern = "PACKAGE_PIN F9" },
    @{ Name = "PL DDR sysclk N pin"; Text = $PcieXdcText; Pattern = "PACKAGE_PIN E8" },
    @{ Name = "XDMA Gen2"; Text = $PcieTclText; Pattern = "CONFIG.pl_link_cap_max_link_speed {5.0_GT/s}" },
    @{ Name = "XDMA X4"; Text = $PcieTclText; Pattern = "CONFIG.pl_link_cap_max_link_width {X4}" },
    @{ Name = "XDMA 128-bit AXI"; Text = $PcieTclText; Pattern = "CONFIG.axi_data_width {128_bit}" },
    @{ Name = "XDMA 125 MHz AXI"; Text = $PcieTclText; Pattern = "CONFIG.axisten_freq {125}" }
)

foreach ($Check in $Checks) {
    if (!$Check.Text.Contains($Check.Pattern)) {
        throw "Board profile check failed: $($Check.Name) / $($Check.Pattern)"
    }
}

$ReportDir = Join-Path $RepoRoot "reports\fpga\vivado\slam_accel_ax7z100_pcie_mig"
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null

$Summary = @"
# AX7Z100 Board Profile Static Validation

- docx: `$Docx`
- MIG source: `$MigPrj`
- PCIe XDC source: `$PcieXdc`
- PCIe Tcl source: `$PcieTcl`

## Result

BOARD_PROFILE_PASS

## Checked facts

- `xc7z100-ffg900/-2`
- `MT41K256M16XX-125`
- PL DDR3 `InputClkFreq=200`, `TimePeriod=1250`, `DataWidth=32`
- PL DDR3 SYS_CLK pins `F9/E8`
- PCIe refclk pins `N8/N7`
- PCIe reset pin `AB22`
- XDMA Gen2 x4, 128-bit AXI, 125 MHz AXI clock target

"@

Set-Content -Encoding UTF8 -Path (Join-Path $ReportDir "board_profile_static_validation.md") -Value $Summary
Write-Host "BOARD_PROFILE_PASS"
Write-Host "Report: $(Join-Path $ReportDir "board_profile_static_validation.md")"
