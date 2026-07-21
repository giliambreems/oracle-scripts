<#
.SYNOPSIS
Builds an Oracle SQLcl/SQL*Plus connection string.

.DESCRIPTION
Builds a connection string for Oracle SQLcl/SQL*Plus.

The connection descriptor can either be supplied as a complete string or be
constructed from its individual components. These two approaches are mutually
exclusive.

If a proxy schema is specified, it is appended using Oracle's proxy syntax:

    "USERNAME"[PROXY_SCHEMA]

Otherwise the username is quoted as:

    "USERNAME"

When no connection descriptor is supplied, a descriptor is constructed using
the supplied connection parameters. The default values are suitable for a
local Oracle Free Database installation.

.PARAMETER Username
Oracle database username.

Username is always treated as a quoted Oracle identifier. The supplied casing is preserved.

.PARAMETER ProxySchema
Optional proxy schema (for example RELEASE).

.PARAMETER Password
Optional password for the Oracle user.

.PARAMETER ConnectDescriptor
Optional complete connection descriptor.

Example:
    jdbc:oracle:thin:@//localhost:1521/FREEPDB1

If specified, the individual connection component parameters cannot be used.

.PARAMETER Protocol
Connection protocol (for example jdbc).

.PARAMETER Vendor
Database vendor (for example oracle).

.PARAMETER DriverType
Driver type (for example thin).

Protocol, Vendor and DriverType must either all be specified or all omitted.

.PARAMETER Host
Database host name.

Default:
    localhost

.PARAMETER Port
Database listener port.

Default:
    1521

.PARAMETER ServiceName
Oracle service name.

Default:
    FREEPDB1

.EXAMPLE
New-OracleConnectionString `
    -Username 'USER.NAME' `
    -ProxySchema 'RELEASE' `
    -Password 'secret' `
    -ConnectDescriptor 'jdbc:oracle:thin:@//localhost:1521/FREEPDB1'

Returns:

"USER.NAME"[RELEASE]/secret@jdbc:oracle:thin:@//localhost:1521/FREEPDB1

.EXAMPLE
New-OracleConnectionString `
    -Username 'USER.NAME' `
    -Password 'secret' `
    -Protocol 'jdbc' `
    -Vendor 'oracle' `
    -DriverType 'thin' `
    -Host 'localhost' `
    -Port 1521 `
    -ServiceName 'FREEPDB1'

Returns:

"USER.NAME"/secret@jdbc:oracle:thin:@//localhost:1521/FREEPDB1

.EXAMPLE
New-OracleConnectionString `
    -Username 'USER.NAME' `
    -Password 'secret'

Returns:

"USER.NAME"/secret@//localhost:1521/FREEPDB1


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

function New-OracleConnectionString {
    [CmdletBinding(DefaultParameterSetName = 'Components')]
    param(
        [Parameter(Mandatory)]
        [string]$Username,

        [string]$ProxySchema,

        [string]$Password,

        # Complete connection descriptor.
        [Parameter(Mandatory, ParameterSetName = 'Descriptor')]
        [string]$ConnectDescriptor,

        # Optional driver components.
        # If one is specified, all three must be specified.
        [Parameter(ParameterSetName = 'Components')]
        [string]$Protocol,

        [Parameter(ParameterSetName = 'Components')]
        [string]$Vendor,

        [Parameter(ParameterSetName = 'Components')]
        [string]$DriverType,

        # Optional //{host}:{port}/{service} components.
        # Defaults to //localhost:1521/FREEPDB1 for local Oracle Free Database installations.
        [Parameter(ParameterSetName = 'Components')]
        [string]$HostName = "localhost",

        [Parameter(ParameterSetName = 'Components')]
        [int]$Port = 1521,

        [Parameter(ParameterSetName = 'Components')]
        [string]$ServiceName = "FREEPDB1"
    )

    $OracleHostPrefix = '//'

    $quotedUser = "`"$Username`""

    # Build the user part of the connection string, including optional proxy schema.
    $userPart = if ([string]::IsNullOrWhiteSpace($ProxySchema)) {
        $quotedUser
    }
    else {
        "$quotedUser[$ProxySchema]"
    }

    # Build the password part of the connection string, including optional password.
    $passwordPart = if ([string]::IsNullOrWhiteSpace($Password)) {
        ""
    }
    else {
        "/$Password"
    }

    if ($PSCmdlet.ParameterSetName -eq 'Components') {

        # Validate driver component usage.
        $driverParts = @($Protocol, $Vendor, $DriverType) |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }

        if ($driverParts.Count -gt 0 -and $driverParts.Count -ne 3) {
            throw "Protocol, Vendor and DriverType must either all be specified or all be omitted."
        }

        # Oracle JDBC requires a leading '//' before the host.
        $HostName = if ($HostName.StartsWith($OracleHostPrefix)) {
            $HostName
        }
        else {
            "$OracleHostPrefix$HostName"
        }

        # Build the optional connection prefix.
        $ConnectDescriptor = if ($driverParts.Count -eq 3) {
            "$Protocol`:$Vendor`:$DriverType`:@$HostName`:$Port/$ServiceName"
        }
        else {
            "$HostName`:$Port/$ServiceName"
        }
    }

    return "$userPart$passwordPart@$ConnectDescriptor"
}