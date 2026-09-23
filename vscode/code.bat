@echo off
:: Dit script zorgt ervoor dat CMD mijn eigen VS Code start in plaats van de systeemversie
:: Locatie: %USERPROFILE%\code.bat

@"%USERPROFILE%\Applications\VSCode-win32-x64\bin\code.cmd" %*
