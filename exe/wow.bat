@echo off
setlocal EnableDelayedExpansion

set "config_parser=%~dp0..\lib\__utility\config.bat"
set "config_file=%~dp0..\config\windk.cfg"

:: 1. Parse configuration and load dynamic variables (flag_* and command_*)
call "!config_parser!" "!config_file!"
if !errorlevel! neq 0 (
    echo [ERROR] Parser failed with exit code: !errorlevel!
    exit /b !errorlevel!
)

set "TARGET_CMD="
set "STATELESS_FLAGS="
set "CMD_ARGS="

:parse_args
if "%~1"=="" goto run_command

set "ARG=%~1"
set "FIRST_CHAR=!ARG:~0,1!"

:: Check if argument is a flag (starts with - or /)
if "!FIRST_CHAR!"=="-" (
    goto handle_flag
) else if "!FIRST_CHAR!"=="/" (
    goto handle_flag
) else (
    goto handle_positional
)

:handle_flag
:: Strip leading dashes and slashes (e.g. "--help" -> "help", "/h" -> "h")
set "FLAG_KEY=%~1"
set "FLAG_KEY=!FLAG_KEY:-=!"
set "FLAG_KEY=!FLAG_KEY:/=!"

:: Dynamically resolve flag_<FLAG_KEY> variable
set "FLAG_SCRIPT="
for /f "delims=" %%F in ("!FLAG_KEY!") do set "FLAG_SCRIPT=!flag_%%F!"

:: Immediate execution if flag script is registered AND no subcommand is set yet
if defined FLAG_SCRIPT (
    if not defined TARGET_CMD (
        if exist "!FLAG_SCRIPT!" (
            call "!FLAG_SCRIPT!"
            exit /b %ERRORLEVEL%
        ) else (
            echo [ERROR] Flag script not found: "!FLAG_SCRIPT!"
            exit /b 1
        )
    )
)

:: Collect general/stateless flags to pass down to target subcommand
set "STATELESS_FLAGS=!STATELESS_FLAGS! %~1"

:: FIXED: SHIFT must occur here to advance to the next argument
shift
goto parse_args

:handle_positional
:: Match subcommand or collect as subcommand positional arguments
if not defined TARGET_CMD (
    set "CMD_KEY=%~1"

    :: Safely resolve target command path (command_<CMD_KEY>)
    set "TEMP_CMD="
    for /f "delims=" %%C in ("!CMD_KEY!") do set "TEMP_CMD=!command_%%C!"

    if defined TEMP_CMD (
        set "TARGET_CMD=!TEMP_CMD!"
    ) else (
        echo [ERROR] Unknown command: %~1
        if defined flag_help call "!flag_help!"
        exit /b 1
    )
) else (
    set "CMD_ARGS=!CMD_ARGS! %~1"
)

shift
goto parse_args

:run_command
if not defined TARGET_CMD (
    echo [ERROR] No command specified.

    :: Dynamically find and execute any loaded flag script (prioritizing help or running the first available flag)
    set "FALLBACK_SCRIPT="

    :: Search environment for any variable starting with 'flag_'
    for /f "tokens=1,* delims==" %%A in ('set flag_ 2^>nul') do (
        if not defined FALLBACK_SCRIPT (
            set "FALLBACK_SCRIPT=%%B"
        )
        :: If a specific help flag is present in cfg, select it specifically
        echo %%A | findstr /i "help" >nul && set "FALLBACK_SCRIPT=%%B"
    )

    if defined FALLBACK_SCRIPT (
        if exist "!FALLBACK_SCRIPT!" call "!FALLBACK_SCRIPT!"
    )
    exit /b 1
)

if not exist "!TARGET_CMD!" (
    echo [ERROR] Script not found: "!TARGET_CMD!"
    exit /b 1
)

:: 3. Execute resolved command script with forwarded flags and arguments
call "!TARGET_CMD!" !STATELESS_FLAGS! !CMD_ARGS!

endlocal
exit /b %ERRORLEVEL%
