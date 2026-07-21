<#
.SYNOPSIS
Retrieves version information from GitVersion.

.DESCRIPTION
Runs the GitVersion CLI and returns the version information as a PowerShell
object.

The function invokes:

    dotnet-gitversion /output json

and converts the JSON output into a PowerShell object.

GitVersion must be installed and available on the system PATH.

.OUTPUTS
A PowerShell object containing the version information returned by GitVersion.

At a minimum, the following properties are expected:

    MajorMinorPatch
    InformationalVersion
    FullSemVer

Additional properties returned by GitVersion are preserved.

.EXAMPLE
$gitVersion = Get-GitVersion

Returns the current version information for the repository.

.EXAMPLE
$gitVersion = Get-GitVersion

Write-Host $gitVersion.MajorMinorPatch
Write-Host $gitVersion.InformationalVersion

Displays the current semantic version and informational version.

.NOTES
Throws an exception if GitVersion does not return any data.


# -----------------------------------------------------------------------------
# Revision History
# -----------------------------------------------------------------------------
#
# Date         Author           Description
# ----------   ---------------  -----------------------------------------------
# 2026-07-18   Giliam Breems    Initial implementation.
#
# -----------------------------------------------------------------------------

#>

function Install-GitVersion {
    [CmdletBinding()]
    param()

    if (Get-Command dotnet-gitversion -ErrorAction SilentlyContinue) {
        return
    }

    Write-Host "GitVersion not found. Installing .NET global tool..."

    & dotnet tool install --global GitVersion.Tool --version 6.8.0

    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install GitVersion."
    }

    # Refresh the PATH for the current PowerShell session.
    $dotnetTools = Join-Path $HOME '.dotnet\tools'

    if ((Test-Path $dotnetTools) -and ($env:PATH -notlike "*$dotnetTools*")) {
        $env:PATH = "$dotnetTools$([IO.Path]::PathSeparator)$env:PATH"
    }

    if (-not (Get-Command dotnet-gitversion -ErrorAction SilentlyContinue)) {
        throw "GitVersion was installed, but 'dotnet-gitversion' could not be found. Restart your PowerShell session and try again."
    }
}

function Get-GitVersion {
    [CmdletBinding()]
    param()

    $gitVersion = dotnet-gitversion /output json | ConvertFrom-Json

    if (-not $gitVersion) {
        throw "GitVersion did not return any data."
    }

    # [PSCustomObject]@{
    #     MajorMinorPatch      = $gitVersion.MajorMinorPatch
    #     InformationalVersion = $gitVersion.InformationalVersion
    #     FullSemVer           = $gitVersion.FullSemVer
    # }

    return $gitVersion
}