@ECHO OFF
SETLOCAL EnableDelayedExpansion

CALL "%~dp0..\..\util\color.bat"

:: 1. Check if the delayed variable is empty
IF "!SUBCOMMAND_ARGS!"=="" (
    ECHO %RED%Error:%RESET% please provide the name of the script to %~n0.
    GOTO end
)

IF EXIST "%~dp0..\..\exe\!SUBCOMMAND_ARGS!.bat" (
    GOTO prompt_action
) ELSE (
    ECHO %RED%Error:%RESET% "windk\exe\!SUBCOMMAND_ARGS!.bat" does not exist.
    GOTO end
)

:prompt_action
choice /C YN /M "Are you sure you want %~n0 !SUBCOMMAND_ARGS!?"

IF %ERRORLEVEL% EQU 1 (
    move /-Y "%~dp0..\..\exe\!SUBCOMMAND_ARGS!.bat" "%~dp0..\..\.archive\!SUBCOMMAND_ARGS!.bat" >nul
    IF EXIST "%~dp0..\..\help\!SUBCOMMAND_ARGS!-help.bat" (
        move /-Y "%~dp0..\..\help\!SUBCOMMAND_ARGS!-help.bat" "%~dp0..\..\.archive\help\!SUBCOMMAND_ARGS!-help.bat" >nul
    )
    GOTO end
) ELSE IF %ERRORLEVEL% EQU 2 (
    ECHO Deletion aborted. No changes were made.
    GOTO end
)

:end
ENDLOCAL
