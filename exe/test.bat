@echo off
setlocal EnableDelayedExpansion

set "config_parser=%~dp0..\lib\__utility\config.bat"
set "config_file=%~dp0..\config\windk.cfg"

:: Parse configuration
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

:: Check if the argument is a flag (starts with - or /)
if "!FIRST_CHAR!"=="-" (
    goto handle_flag
) else if "!FIRST_CHAR!"=="/" (
    goto handle_flag
) else (
    goto handle_positional
)

:handle_flag
:: Strip leading dashes/slashes to extract the key name (e.g., --help -> help, /h -> h)
set "FLAG_KEY=%~1"
set "FLAG_KEY=!FLAG_KEY:-=!"
set "FLAG_KEY=!FLAG_KEY:/=!"

:: Dynamically resolve the variable name flag_<FLAG_KEY>
set "FLAG_SCRIPT="
for /f "delims=" %%F in ("!FLAG_KEY!") do set "FLAG_SCRIPT=!flag_%%F!"

:: If this flag has a registered script and no command has been set yet, execute immediately
if defined FLAG_SCRIPT (
    if not defined TARGET_CMD (
        if exist "!FLAG_SCRIPT!" (
            call "!FLAG_SCRIPT!"
            exit /b 0
        ) else (
            echo [ERROR] Flag script not found: "!FLAG_SCRIPT!"
            exit /b 1
        )
    )
)

:: Collect general stateless flags to pass down to the subcommand
set "STATELESS_FLAGS=!STATELESS_FLAGS! %~1"
shift
goto parse_args

:handle_positional
:: Positional argument: match command or collect as subcommand arg
if not defined TARGET_CMD (
    set "CMD_KEY=%~1"

    :: Safely resolve target command path
    set "TEMP_CMD="
    for /f "delims=" %%C in ("!CMD_KEY!") do set "TEMP_CMD=!command_%%C!"

    if defined TEMP_CMD (
        set "TARGET_CMD=!TEMP_CMD!"
    ) else (
        echo [ERROR] Unknown command: %~1
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
    if defined flag_help (
        call "!flag_help!"
    )
    exit /b 1
)

if not exist "!TARGET_CMD!" (
    echo [ERROR] Script not found: "!TARGET_CMD!"
    exit /b 1
)

:: Execute resolved command script with collected flags and positional args
call "!TARGET_CMD!" !STATELESS_FLAGS! !CMD_ARGS!

endlocal
