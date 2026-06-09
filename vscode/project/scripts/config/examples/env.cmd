rem Set Oracle home and tns_admin dir manually in this script, could differ on VDDI oracle client installs
rem Make sure in config file below
rem   TNS_ADMIN   is set correctly, e.g. C:\PROGRA~2\MIFA7F~1\data\oracle\admin (for Oracle Wallet)
rem   ORACLE_HOME is set correctly, e.g. C:\oracle\ora11g
rem   PATH        is set correctly, e.g. %ORACLE_HOME%\bin;%PATH%
rem
rem Put this file in the 'scripts\config' folder

echo Set TNS_ADMIN
echo Set ORACLE_HOME
echo Set PATH
set TNS_ADMIN=C:\PROGRA~2\MIFA7F~1\data\oracle\admin
set ORACLE_HOME=C:\oracle\ora11g
set PATH=%ORACLE_HOME%\bin;%PATH%
