@ECHO OFF
SETLOCAL

@REM REM Check if ORACLE_HOME has been set
@REM if (C:\oracle\ora11g) == () goto :nohome

REM Get the command line arguments
set args=
:loop
  if !%1==! goto :done
  set args=%args% %1
  shift
  goto :loop
:done

rem set classpath for orapki - align this to your local SQLcl installation
set tools=%cd%\..\generic
set sqlcl=%tools%\sqlcl\lib
set java=%tools%\graalvm
set classpath=%sqlcl%\oraclepki.jar
set classpath=%classpath%;%sqlcl%\osdt_core.jar
set classpath=%classpath%;%sqlcl%\osdt_cert.jar

rem simulate orapki command
%java%\bin\java -classpath %classpath% oracle.security.pki.textui.OraclePKITextUI %args%

@REM goto :exit

@REM :nohome
@REM echo ORACLE_HOME environment variable is not set

@REM :exit
endlocal
