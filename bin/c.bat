@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: 1. Lock script identity variables before SHIFT runs
SET "SCRIPT_PATH=%~f0"
SET "SCRIPT_NAME=%~n0"
SET "SCRIPT_FILE=%~nx0"
SET "SCRIPT_DIR=%~dp0"

SET "SHOW_HELP=0"
SET "OPEN_IN_EDITOR=0"
SET "CLOSE_TAB=0"
SET "CLOSE_ALL=0"
SET "COMMAND="

:: 2. Argument Parsing Loop
:parse_args
IF "%~1"=="" GOTO process_args

:: Match flags against arrays
FOR %%A IN (-h --help) DO IF /I "%~1"=="%%A" SET "SHOW_HELP=1" & GOTO next_arg
FOR %%A IN (-e --edit) DO IF /I "%~1"=="%%A" SET "OPEN_IN_EDITOR=1" & GOTO next_arg
FOR %%A IN (-t --tab) DO IF /I "%~1"=="%%A" SET "CLOSE_TAB=1" & GOTO next_arg
FOR %%A IN (-a --all) DO IF /I "%~1"=="%%A" SET "CLOSE_ALL=1" & GOTO next_arg

:: Capture positional arguments
IF DEFINED COMMAND ( SET "COMMAND=!COMMAND! %~1" ) ELSE ( SET "COMMAND=%~1" )

:next_arg
SHIFT & GOTO parse_args

:: 3. Action Handler
:process_args
IF "%SHOW_HELP%"=="1" GOTO help_action
IF "%OPEN_IN_EDITOR%"=="1" GOTO edit_action
IF "%CLOSE_ALL%"=="1" GOTO close_all_action
IF "%CLOSE_TAB%"=="1" GOTO close_tab_action

:: 4. Subcommands & Directory Navigation
IF DEFINED COMMAND (
    :: Directory navigation check
    IF EXIST "!COMMAND!\" (
        ENDLOCAL
        PUSHD "%COMMAND%"
        EXIT /B 0
    )

    :: Check if COMMAND is a positive integer
    SET "IS_NUM=1"
    FOR /F "delims=0123456789" %%N IN ("!COMMAND!") DO SET "IS_NUM=0"

    :: 4a. Numeric logic: Navigate up N directories
    IF "!IS_NUM!"=="1" (
        (
            ENDLOCAL
            FOR /L %%A IN (1,1,%COMMAND%) DO CD ..
        )
        EXIT /B 0
    ) ELSE (
        ECHO Error: !SCRIPT_NAME! [!COMMAND!] is not a valid command or directory.
        EXIT /B 1
    )
    EXIT /B 0
)

:: 5. Default Action (No arguments passed)
cls
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

:close_tab_action
ENDLOCAL
:: Exit the parent CMD process to close the tab/window
EXIT

:close_all_action
ENDLOCAL
:: Kill all running cmd.exe processes instantly
TASKKILL /F /IM cmd.exe >NUL 2>&1
EXIT