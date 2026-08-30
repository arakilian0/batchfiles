@ECHO OFF
SETLOCAL EnableDelayedExpansion

CALL "%~dp0..\util\config.bat" "package"
CALL "%~dp0..\util\color.bat"

:: 1. Lock script identity variables (resolves alias if RUN_AS is set)
SET "SCRIPT_PATH=%~f0"
IF DEFINED RUN_AS (
    SET "SCRIPT_NAME=!RUN_AS!"
    SET "RUN_AS="
) ELSE (
    SET "SCRIPT_NAME=%~n0"
)
SET "SCRIPT_FILE=%~nx0"
SET "SCRIPT_DIR=%~dp0"

SET "SHOW_HELP=0"
SET "SHOW_VERSION=0"
SET "SHOW_SCRIPTS=0"
SET "OPEN_IN_EDITOR=0"
SET "OPEN_WINDK_IN_EDITOR=0"
SET "COMMAND="
SET "SUBCOMMAND_ARGS="

SET "ERROR_1=Run %YELLOW%!SCRIPT_NAME! --help%RESET% for available commands."

:: 2. Argument Parsing Loop
:parse_args
IF "%~1"=="" GOTO process_args

:: Match flags against arrays
FOR %%A IN (-h --help) DO IF /I "%~1"=="%%A" SET "SHOW_HELP=1" & GOTO next_arg
FOR %%A IN (-e --edit) DO IF /I "%~1"=="%%A" SET "OPEN_IN_EDITOR=1" & GOTO next_arg
FOR %%A IN (-v --version) DO IF /I "%~1"=="%%A" SET "SHOW_VERSION=1" & GOTO next_arg
FOR %%A IN (-l --list) DO IF /I "%~1"=="%%A" SET "SHOW_SCRIPTS=1" & GOTO next_arg
FOR %%A IN (-c --code) DO IF /I "%~1"=="%%A" SET "OPEN_WINDK_IN_EDITOR=1" & GOTO next_arg

:: Capture positional arguments (First is COMMAND, remaining go to SUBCOMMAND_ARGS)
IF NOT DEFINED COMMAND (
    SET "COMMAND=%~1"
) ELSE (
    IF DEFINED SUBCOMMAND_ARGS (
        SET "SUBCOMMAND_ARGS=!SUBCOMMAND_ARGS! %~1"
    ) ELSE (
        SET "SUBCOMMAND_ARGS=%~1"
    )
)

:next_arg
SHIFT & GOTO parse_args

:: 3. Action Handler
:process_args
IF "%SHOW_HELP%"=="1" CALL "%SCRIPT_DIR%..\lib\windk\flags.bat" :help_action & EXIT /B 0
IF "%OPEN_IN_EDITOR%"=="1" CALL "%SCRIPT_DIR%..\lib\windk\flags.bat" :edit_action & EXIT /B 0
IF "%SHOW_VERSION%"=="1" CALL "%SCRIPT_DIR%..\lib\windk\flags.bat" :version_action & EXIT /B 0
IF "%SHOW_SCRIPTS%"=="1" CALL "%SCRIPT_DIR%..\lib\windk\flags.bat" :scripts_action & EXIT /B 0
IF "%OPEN_WINDK_IN_EDITOR%"=="1" CALL "%SCRIPT_DIR%..\lib\windk\flags.bat" :open_windk_action & EXIT /B 0

:: 4. Subcommands & Directory Navigation
IF DEFINED COMMAND (
    IF "!COMMAND!"=="install" CALL "%SCRIPT_DIR%..\lib\windk\install.bat" & EXIT /B 0

    :: If neither condition matched:
    ECHO %ERROR_1%
    ENDLOCAL
    EXIT /B 1
)

:: 5. Default Action (No arguments passed)
ECHO %ERROR_1%
ENDLOCAL
EXIT /B 0
