@ECHO OFF
SETLOCAL EnableDelayedExpansion

CALL "%~dp0..\..\util\color.bat"

:: 1. Check if the delayed variable is empty
IF "!SUBCOMMAND_ARGS!"=="" (
    ECHO %RED%Error:%RESET% please provide the name of the script to delete.
    GOTO end
)

IF EXIST "%~dp0..\..\exe\!SUBCOMMAND_ARGS!.bat" (
    ECHO If you are unsure, run %YELLOW%!SCRIPT_NAME! archive !SUBCOMMAND_ARGS!%RESET% instead.
    GOTO prompt_action
) ELSE (
    ECHO %RED%Error:%RESET% "windk\exe\!SUBCOMMAND_ARGS!.bat" does not exist.
    GOTO end
)

:prompt_action
choice /C YN /M "Are you sure you want delete !SUBCOMMAND_ARGS!?"

IF %ERRORLEVEL% EQU 1 (
    del "%~dp0..\..\exe\!SUBCOMMAND_ARGS!.bat"
    IF EXIST "%~dp0..\..\help\!SUBCOMMAND_ARGS!-help.bat" del "%~dp0..\..\help\!SUBCOMMAND_ARGS!-help.bat"
    GOTO end
) ELSE IF %ERRORLEVEL% EQU 2 (
    ECHO Deletion aborted. No changes were made.
    GOTO end
)

:end
ENDLOCAL
