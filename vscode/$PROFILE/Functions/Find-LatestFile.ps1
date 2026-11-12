function Find-LatestFile {
    param(
        [string]$Path = $PWD,

        [Parameter(Mandatory)]
        [string]$FileName
    )

    # Zorg dat we altijd met een volledig pad werken
    $Path = (Resolve-Path $Path).Path

    # Bepaal de versies-directory
    if ((Split-Path $Path -Leaf) -ieq "versies") {
        $versiesPath = $Path
    }
    else {
        $versiesPath = Join-Path $Path "versies"
    }

    if (-not (Test-Path $versiesPath -PathType Container)) {
        Write-Host "Versies-map niet gevonden: $versiesPath"
        return
    }

    # Bepaal of wildcard-zoeken wordt gebruikt
    $wildcardSearch = $FileName.EndsWith('*')

    # Bouw het zoekpatroon op
    if ($wildcardSearch) {
        $searchName = [regex]::Escape($FileName.TrimEnd('*'))
        $pattern = "^.*_$searchName[^.]*\.(?<extension>[^.]+)$"
    }
    else {
        $searchName = [regex]::Escape($FileName)
        $pattern = "^.*_$searchName\.(?<extension>[^.]+)$"
    }

    # Zoek alle mogelijke bestanden
    $fileMatches = Get-ChildItem $versiesPath -File -Recurse |
        Where-Object {
            $_.Name -match $pattern
        } |
        ForEach-Object {

            $relative = $_.FullName.Substring($versiesPath.Length).TrimStart('\')
            $parts = $relative -split '\\'

            # Verwacht:
            # v1.4.7\db\<schema>\<bestand>
            if ($parts.Count -ne 4) {
                return
            }

            $versionName = $parts[0]

            # Alleen geldige releaseversies
            if ($versionName -notmatch '^v\d+\.\d+\.\d+(\.\d+)?$') {
                return
            }

            [PSCustomObject]@{
                File      = $_
                Version   = [version]$versionName.Substring(1)
                Directory = $_.Directory.FullName
                FileName  = $_.Name
            }
        }

    if (-not $fileMatches) {
        Write-Host "Bestand voor '$FileName' niet gevonden."
        return
    }

    # Wildcard: alle resultaten retourneren
    if ($wildcardSearch) {
        return $fileMatches | Sort-Object Version -Descending
    }

    # Exact zoeken: hoogste releaseversie bepalen
    return $fileMatches |
        Sort-Object Version -Descending |
        Select-Object -First 1
}


function flf {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$FileName
    )

    Find-LatestFile -FileName $FileName
}
