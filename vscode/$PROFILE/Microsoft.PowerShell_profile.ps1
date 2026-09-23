# Use next command to create or modify $PROFILE and add function)s) below
#
#    if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }; notepad $PROFILE
#

# Dit zorgt ervoor dat PowerShell mijn eigen VS Code start in plaats van de systeemversie
function code {
  & "$env:USERPROFILE\Applications\VSCode-win32-x64\bin\code.cmd" $args
}
