function New-LightningVivadoShortPath {
    param(
        [Parameter(Mandatory = $true)][string]$ActualPath,
        [Parameter(Mandatory = $true)][string]$BuildRoot
    )

    New-Item -ItemType Directory -Force -Path $BuildRoot | Out-Null
    New-Item -ItemType Directory -Force -Path $ActualPath | Out-Null

    $ActualRoot = [System.IO.Path]::GetFullPath($BuildRoot).TrimEnd('\')
    $ActualFull = [System.IO.Path]::GetFullPath($ActualPath).TrimEnd('\')

    if (!$ActualFull.StartsWith($ActualRoot, [System.StringComparison]::OrdinalIgnoreCase)) {
        return [pscustomobject]@{
            ActualPath = $ActualFull
            ShortPath = $ActualFull
            Drive = $null
            Mounted = $false
        }
    }

    foreach ($Letter in @("V", "W", "X", "Y", "Z", "U", "T")) {
        $Drive = "$Letter`:"
        if (Test-Path "$Drive\") {
            continue
        }

        & subst $Drive $ActualRoot | Out-Null
        if ($LASTEXITCODE -eq 0) {
            $Suffix = $ActualFull.Substring($ActualRoot.Length).TrimStart('\')
            $ShortPath = if ([string]::IsNullOrWhiteSpace($Suffix)) { "$Drive\" } else { Join-Path "$Drive\" $Suffix }
            return [pscustomobject]@{
                ActualPath = $ActualFull
                ShortPath = $ShortPath
                Drive = $Drive
                Mounted = $true
            }
        }
    }

    return [pscustomobject]@{
        ActualPath = $ActualFull
        ShortPath = $ActualFull
        Drive = $null
        Mounted = $false
    }
}

function Remove-LightningVivadoShortPath {
    param(
        [Parameter(Mandatory = $true)]$ShortPathInfo
    )

    if ($ShortPathInfo.Mounted -and ![string]::IsNullOrWhiteSpace($ShortPathInfo.Drive)) {
        & subst $ShortPathInfo.Drive /D | Out-Null
    }
}
