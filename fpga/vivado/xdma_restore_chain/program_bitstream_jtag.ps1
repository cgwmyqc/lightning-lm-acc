param(
    [ValidateSet("A", "A2", "B", "B2", "C", "C2")][string]$Stage = "A2",
    [string]$Bitstream,
    [string]$Xsdb = "xsdb",
    [string]$HwServer = "hw_server",
    [string]$HwHost = "localhost",
    [int]$HwPort = 3121,
    [string]$TargetFilter = "",
    [string]$LogDir
)

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..")
$StageLower = $Stage.ToLowerInvariant()
if ([string]::IsNullOrWhiteSpace($LogDir)) {
    $LogDir = Join-Path $RepoRoot "reports\fpga\vivado\xdma_restore_chain\stage_$StageLower"
}
if ([string]::IsNullOrWhiteSpace($Bitstream)) {
    $Bitstream = Join-Path $RepoRoot "fpga\vivado\.build\xdma_restore_stage_${StageLower}_impl\xdma_restore_stage_${StageLower}.runs\impl_1\xdma_restore_stage_${StageLower}_wrapper.bit"
}

$Bitstream = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($Bitstream)
if (!(Test-Path $Bitstream)) {
    throw "Bitstream not found: $Bitstream"
}

New-Item -ItemType Directory -Force -Path $LogDir | Out-Null
$Tcl = Join-Path $ScriptDir "program_bitstream_jtag.tcl"
$Log = Join-Path $LogDir "jtag_program_log.txt"

function Test-TcpPort {
    param([string]$HostName, [int]$Port)
    try {
        $Client = New-Object System.Net.Sockets.TcpClient
        $Async = $Client.BeginConnect($HostName, $Port, $null, $null)
        $Success = $Async.AsyncWaitHandle.WaitOne(500)
        if ($Success) {
            $Client.EndConnect($Async)
        }
        $Client.Close()
        return $Success
    } catch {
        return $false
    }
}

if (!(Test-TcpPort -HostName $HwHost -Port $HwPort)) {
    Start-Process -FilePath $HwServer -ArgumentList @("-s", "tcp::$HwPort") -WindowStyle Hidden | Out-Null
    $Ready = $false
    for ($i = 0; $i -lt 20; $i++) {
        Start-Sleep -Milliseconds 250
        if (Test-TcpPort -HostName $HwHost -Port $HwPort) {
            $Ready = $true
            break
        }
    }
    if (!$Ready) {
        throw "hw_server did not become ready on ${HwHost}:${HwPort}. Check Vivado cable drivers and hw_server installation."
    }
}

$Output = & $Xsdb $Tcl $Bitstream $HwHost $HwPort $TargetFilter 2>&1
$ExitCode = $LASTEXITCODE
$Output | Set-Content -Encoding UTF8 -Path $Log
$Output
exit $ExitCode
