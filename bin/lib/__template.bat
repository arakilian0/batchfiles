@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: 1. Lock script identity variables before SHIFT runs
SET "SCRIPT_PATH=%~f0"
SET "SCRIPT_NAME=%~n0"
SET "SCRIPT_FILE=%~nx0"
SET "SCRIPT_DIR=%~dp0"

SET "SHOW_HELP=0"
SET "OPEN_IN_EDITOR=0"
SET "COMMAND="

:: 2. Argument Parsing Loop
:parse_args
IF "%~1"=="" GOTO process_args

:: Match flags against arrays
FOR %%A IN (-h --help) DO IF /I "%~1"=="%%A" SET "SHOW_HELP=1" & GOTO next_arg
FOR %%A IN (-e --edit) DO IF /I "%~1"=="%%A" SET "OPEN_IN_EDITOR=1" & GOTO next_arg

:: Capture positional arguments
IF DEFINED COMMAND ( SET "COMMAND=!COMMAND! %~1" ) ELSE ( SET "COMMAND=%~1" )

:next_arg
SHIFT & GOTO parse_args

:: 3. Action Handler
:process_args
IF "%SHOW_HELP%"=="1" GOTO help_action
IF "%OPEN_IN_EDITOR%"=="1" GOTO edit_action

:: 4. Subcommands
IF DEFINED COMMAND (
    ECHO Error: !SCRIPT_NAME! [!COMMAND!] is not a command. See '!SCRIPT_NAME! --help'.
    EXIT /B 0
)

:: 5. Default Action (No arguments passed)
ECHO running default action...
EXIT /B 0

:: 6. Helper Actions
:help_action
CALL "%SCRIPT_DIR%help\%SCRIPT_NAME%-help.bat" "%SCRIPT_NAME%" "%SCRIPT_FILE%"
ENDLOCAL
EXIT /B 0

:edit_action
CALL "%SCRIPT_DIR%lib\editor.bat" "%SCRIPT_PATH%"
ENDLOCAL
EXIT /B 0