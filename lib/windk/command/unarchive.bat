@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET "LEVEL=..\..\..\"

CALL "%~dp0%LEVEL%util\color.bat"

:: 1. Check if the delayed variable is empty
IF "!SUBCOMMAND_ARGS!"=="" (
    ECHO %RED%Error:%RESET% please provide the name of the script to %~n0.
    GOTO end
)

IF EXIST "%~dp0%LEVEL%.archive\!SUBCOMMAND_ARGS!.bat" (
    GOTO prompt_action
) ELSE (
    ECHO %RED%Error:%RESET% "windk\.archive\!SUBCOMMAND_ARGS!.bat" does not exist.
    GOTO end
)

:prompt_action
choice /C YN /M "Are you sure you want %~n0 !SUBCOMMAND_ARGS!?"

IF %ERRORLEVEL% EQU 1 (
    move /-Y "%~dp0%LEVEL%.archive\!SUBCOMMAND_ARGS!.bat" "%~dp0%LEVEL%exe\!SUBCOMMAND_ARGS!.bat" >nul
    IF EXIST "%~dp0%LEVEL%.archive\help\!SUBCOMMAND_ARGS!-help.bat" (
        move /-Y "%~dp0%LEVEL%.archive\help\!SUBCOMMAND_ARGS!-help.bat" "%~dp0%LEVEL%help\!SUBCOMMAND_ARGS!-help.bat" >nul
    )
    IF EXIST "%~dp0%LEVEL%.archive\lib\!SUBCOMMAND_ARGS!" (
        move /-Y "%~dp0%LEVEL%.archive\lib\!SUBCOMMAND_ARGS!" "%~dp0%LEVEL%lib\!SUBCOMMAND_ARGS!" >nul
    )
    ECHO Successfully %~n0d !SUBCOMMAND_ARGS!.
    GOTO end
) ELSE IF %ERRORLEVEL% EQU 2 (
    ECHO Deletion aborted. No changes were made.
    GOTO end
)

:end
ENDLOCAL
