@ECHO OFF

SET "config_parser=%~dp0\config.bat"
SET "config_file=%~dp0..\..\config\windk.cfg"

:: Parse configuration
call "!config_parser!" "!config_file!"
if !errorlevel! neq 0 (
    echo [ERROR] Parser failed with exit code: !errorlevel!
    exit /b !errorlevel!
)

ECHO %MAIN_NAME% version %MAIN_VERSION%
EXIT /B 0
