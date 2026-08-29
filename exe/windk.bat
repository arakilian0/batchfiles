@ECHO OFF
SETLOCAL EnableDelayedExpansion

CALL "%~dp0..\util\config.bat" "windk"
CALL "%~dp0..\util\colors.bat"

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
IF "%SHOW_HELP%"=="1" GOTO help_action
IF "%OPEN_IN_EDITOR%"=="1" GOTO edit_action
IF "%SHOW_VERSION%"=="1" GOTO version_action
IF "%SHOW_SCRIPTS%"=="1" GOTO scripts_action
IF "%OPEN_WINDK_IN_EDITOR%"=="1" GOTO open_windk_action

:: 4. Subcommands & Directory Navigation
IF DEFINED COMMAND (
    IF EXIST "%~dp0src\!COMMAND!.bat" (
        ECHO !COMMAND! already exists.
        ENDLOCAL
        EXIT /B !ERRORLEVEL!
    ) 
    
    IF "!COMMAND!"=="update" (
        ECHO Running built-in command: update
        ENDLOCAL
        EXIT /B 0
    )
    
    :: If neither condition matched:
    ECHO Create "%~dp0src\!COMMAND!.bat" and "%~dp0lib\help\!COMMAND!.bat"
    ENDLOCAL
    EXIT /B 1
)

:: 5. Default Action (No arguments passed)
ECHO Run %YELLOW%!SCRIPT_NAME! --help%RESET% for available commands.
ENDLOCAL
EXIT /B 0

:: 6. Helper Actions
:help_action
CALL "%SCRIPT_DIR%..\lib\help\windk-help.bat" "%SCRIPT_NAME%" "%SCRIPT_FILE%"
ENDLOCAL
EXIT /B 0

:edit_action
CALL "%SCRIPT_DIR%..\lib\editor.bat" "%SCRIPT_PATH%"
ENDLOCAL
EXIT /B 0

:version_action
ECHO %NAME% version %VERSION%
ENDLOCAL
EXIT /B 0

:scripts_action
IF EXIST "%SCRIPT_DIR%" (
    FOR /F "tokens=*" %%F IN ('DIR /B /A-D "%SCRIPT_DIR%\*.bat" 2^>NUL') DO (
        ECHO %GREEN%  %%~nxF%RESET%
    )
) ELSE (
    ECHO %RED%Error: Source directory not found at "%SCRIPT_DIR%"%RESET%
)
ENDLOCAL
EXIT /B 0

:open_windk_action
CALL "%SCRIPT_DIR%..\lib\editor.bat" "%SCRIPT_DIR%.." "full"
ENDLOCAL
EXIT /B 0