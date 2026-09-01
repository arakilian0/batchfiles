@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET "LEVEL=..\..\..\"

CALL "%~dp0%LEVEL%util\color.bat"

IF "!SUBCOMMAND_ARGS!"=="" GOTO list_archived

IF EXIST "%~dp0%LEVEL%exe\!SUBCOMMAND_ARGS!.bat" (
    GOTO prompt_action
) ELSE (
    ECHO SKIPPING!
    ECHO %RED%Error:%RESET% "windk\exe\!SUBCOMMAND_ARGS!.bat" does not exist.
    GOTO end
)

:list_archived
ECHO List of archived scripts:

:: Check if any .bat files exist first to avoid showing a blank line
IF EXIST "%~dp0%LEVEL%.archive\*.bat" (
    FOR /F "delims=" %%A IN ('dir /B "%~dp0%LEVEL%.archive\*.bat" 2^>nul') DO (
        ECHO %CYAN%  - %%A%RESET%
    )
    IF EXIST "%~dp0%LEVEL%.archive\help\*.bat" (
        FOR /F "delims=" %%A IN ('dir /B "%~dp0%LEVEL%.archive\help\*.bat" 2^>nul') DO (
            ECHO %magenta%  - %%A%RESET%
        )
    )
) ELSE (
    ECHO %YELLOW%No archived scripts found.%RESET%
)

GOTO end

:prompt_action
choice /C YN /M "Are you sure you want %~n0 !SUBCOMMAND_ARGS!?"

IF %ERRORLEVEL% EQU 1 (
    move /-Y "%~dp0%LEVEL%exe\!SUBCOMMAND_ARGS!.bat" "%~dp0%LEVEL%.archive\!SUBCOMMAND_ARGS!.bat" >nul
    IF EXIST "%~dp0%LEVEL%help\!SUBCOMMAND_ARGS!-help.bat" (
        move /-Y "%~dp0%LEVEL%help\!SUBCOMMAND_ARGS!-help.bat" "%~dp0%LEVEL%.archive\help\!SUBCOMMAND_ARGS!-help.bat" >nul
    )
    IF EXIST "%~dp0%LEVEL%lib\!SUBCOMMAND_ARGS!" (
        move /-Y "%~dp0%LEVEL%lib\!SUBCOMMAND_ARGS!" "%~dp0%LEVEL%.archive\lib\!SUBCOMMAND_ARGS!" >nul
    )
    ECHO Successfully %~n0d !SUBCOMMAND_ARGS!.
    GOTO end
) ELSE IF %ERRORLEVEL% EQU 2 (
    ECHO Deletion aborted. No changes were made.
    GOTO end
)

:end
ENDLOCAL
