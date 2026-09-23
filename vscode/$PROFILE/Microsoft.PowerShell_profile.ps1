# Use next command to create or modify $PROFILE and add function)s) below
#
#    if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }; notepad $PROFILE
#

# Dit zorgt ervoor dat PowerShell mijn eigen VS Code start in plaats van de systeemversie
function code {
  & "$env:USERPROFILE\Applications\VSCode-win32-x64\bin\code.cmd" $args
}

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

    # Alles vóór FileName negeren.
    #
    # Voor FileName = nvwa_util:
    #
    #   R__04A_nvwa_util.pkb
    #   R__123_nvwa_util_test.pkb
    #   FOO_nvwa_util.post
    #
    # zijn allemaal geldig.
    #
    # FileName moet wel eindigen vóór postfix/extensie.
    $pattern = "^.*_$([regex]::Escape($FileName))(?<postfix>[^.]*)\.(?<extension>[^.]+)$"

    # Zoek alle mogelijke bestanden
    $matches = Get-ChildItem $versiesPath -File -Recurse |
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

            # Alleen geldige releaseversies:
            # v1.2.3
            # v1.2.3.1
            if ($versionName -notmatch '^v\d+\.\d+\.\d+(\.\d+)?$') {
                return
            }

            [PSCustomObject]@{
                File    = $_
                Version = [version]$versionName.Substring(1)
            }
        }

    if (-not $matches) {
        Write-Host "Bestand voor '$FileName' niet gevonden."
        return
    }

    # Hoogste releaseversie bepalen
    $result = $matches |
        Sort-Object Version -Descending |
        Select-Object -First 1

    $directory = $result.File.Directory.FullName

    Write-Host "Gevonden in versie $($result.Version): $directory"

    # Volledig directorypad teruggeven
    return $directory
}

function flf {
    param(
        [Parameter(Mandatory, Position = 0)]
        [string]$FileName
    )

    Find-LatestFile -FileName $FileName
}
