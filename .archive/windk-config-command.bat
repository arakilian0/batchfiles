@echo off
setlocal EnableDelayedExpansion

set "SUB_CMD=%~1"
set "CONFIG_MGR=%~dp0..\..\__utility\config_manager.bat"
set "CONFIG_FILE=%~dp0..\..\..\config\windk.cfg"

:: Route internal subcommands
if /i "%SUB_CMD%"=="get" goto :cmd_get
if /i "%SUB_CMD%"=="set" goto :cmd_set
if /i "%SUB_CMD%"=="list" goto :cmd_list

:: If no subcommand matches, show help
echo [ERROR] Unknown subcommand '%SUB_CMD%' for config.
echo Usage: windk config ^<get^|set^|list^> [args]
exit /b 1


:cmd_get
:: Example: windk config get section key
set "SEC=%~2"
set "KEY=%~3"

if "%SEC%"=="" or "%KEY%"=="" (
    echo Usage: windk config get ^<section^> ^<key^>
    exit /b 1
)

call "%CONFIG_MGR%" GET "%CONFIG_FILE%" "%SEC%" "%KEY%" "RESULT"
if defined RESULT (
    echo %RESULT%
) else (
    echo [ERROR] Key not found.
    exit /b 1
)
exit /b 0


:cmd_set
:: Example: windk config set section key value
set "SEC=%~2"
set "KEY=%~3"
set "VAL=%~4"

if "%SEC%"=="" or "%KEY%"=="" or "%VAL%"=="" (
    echo Usage: windk config set ^<section^> ^<key^> ^<value^>
    exit /b 1
)

call "%CONFIG_MGR%" SET "%CONFIG_FILE%" "%SEC%" "%KEY%" "%VAL%"
echo Updated [%SEC%] %KEY%=%VAL%
exit /b 0


:cmd_list
:: Example: windk config list
type "%CONFIG_FILE%"
exit /b 0
