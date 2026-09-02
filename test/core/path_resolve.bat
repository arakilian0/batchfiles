@echo off
setlocal EnableDelayedExpansion

:: Canonicalize paths relative to the current script directory (%~dp0)
call "%~dp0..\..\core\path_resolver.bat" resolve "%~dp0..\..\core\config_manager.bat" CONFIG_MGR
call "%~dp0..\..\core\path_resolver.bat" resolve "%~dp0..\..\tools\windk\.cfg" CONFIG_FILE

if not exist "!CONFIG_MGR!" (
    echo [ERROR] Config manager missing at: "!CONFIG_MGR!"
    endlocal & exit /b 1
)

if not exist "!CONFIG_FILE!" (
    echo [ERROR] Configuration file missing at: "!CONFIG_FILE!"
    endlocal & exit /b 1
)

ECHO [CONFIG MANAGER]: "!CONFIG_MGR!"
ECHO [CONFIG FILE]: "!CONFIG_FILE!"

endlocal & exit /b 1
