@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET "LEVEL=..\..\..\"

CALL "%~dp0%LEVEL%util\color.bat"

IF "!SUBCOMMAND_ARGS!"=="" (
    ECHO %RED%Error:%RESET% please provide the name of the script to %~n0.
    GOTO end
)

IF EXIST "%~dp0%LEVEL%exe\!SUBCOMMAND_ARGS!.bat" (
    ECHO If you are unsure, run %YELLOW%!SCRIPT_NAME! archive !SUBCOMMAND_ARGS!%RESET% instead.
    GOTO prompt_action
) ELSE (
    ECHO %RED%Error:%RESET% "windk\exe\!SUBCOMMAND_ARGS!.bat" does not exist.
    GOTO end
)

:prompt_action
choice /C YN /M "Are you sure you want %~n0 !SUBCOMMAND_ARGS!?"

IF %ERRORLEVEL% EQU 1 (
    del "%~dp0%LEVEL%exe\!SUBCOMMAND_ARGS!.bat"
    IF EXIST "%~dp0%LEVEL%help\!SUBCOMMAND_ARGS!-help.bat" del "%~dp0%LEVEL%help\!SUBCOMMAND_ARGS!-help.bat"
    IF EXIST "%~dp0%LEVEL%lib\!SUBCOMMAND_ARGS!" rmdir /S /Q "%~dp0%LEVEL%lib\!SUBCOMMAND_ARGS!"
    GOTO end
) ELSE IF %ERRORLEVEL% EQU 2 (
    ECHO Deletion aborted. No changes were made.
    GOTO end
)

:end
ENDLOCAL
