@ECHO OFF
SETLOCAL EnableDelayedExpansion

SET "LEVELS=..\..\..\"

CALL "%~dp0%LEVELS%util\color.bat"

IF "!SUBCOMMAND_ARGS!"=="" (
    ECHO %RED%Error:%RESET% please provide the name of the script to %~n0.
    GOTO end
)

WHERE "$PATH:!SUBCOMMAND_ARGS!" >nul 2>nul

IF ERRORLEVEL 1 ( GOTO notfound ) ELSE ( GOTO found )

:found
ECHO Error: Command '!SUBCOMMAND_ARGS!' already exists on system PATH. Please choose another name for your command.
GOTO end

:notfound
set "LIB_DIR=%~dp0%LEVELS%lib\!SUBCOMMAND_ARGS!"

IF NOT EXIST "!LIB_DIR!" (
    mkdir "!LIB_DIR!"
)

copy "%~dp0%LEVELS%temp\script.bat" "%~dp0%LEVELS%exe\!SUBCOMMAND_ARGS!.bat" >nul
copy "%~dp0%LEVELS%temp\help.bat" "%~dp0%LEVELS%help\!SUBCOMMAND_ARGS!-help.bat" >nul
copy "%~dp0%LEVELS%temp\flags.bat" "%~dp0%LEVELS%lib\!SUBCOMMAND_ARGS!\flags.bat" >nul
GOTO end

:end
ENDLOCAL
