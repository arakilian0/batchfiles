@ECHO OFF
SETLOCAL EnableDelayedExpansion

CALL "%~dp0..\..\util\color.bat"

:: 1. Check if the delayed variable is empty
IF "!SUBCOMMAND_ARGS!"=="" (
    ECHO %RED%Error:%RESET% please provide the name of the script to %~n0.
    GOTO end
)

:: 2. Search ONLY the system PATH using delayed expansion
WHERE "$PATH:!SUBCOMMAND_ARGS!" >nul 2>nul

:: 3. Check errorlevel directly (avoids delayed expansion evaluation bugs)
IF ERRORLEVEL 1 ( GOTO notfound ) ELSE ( GOTO found )

:found
ECHO Error: Command '!SUBCOMMAND_ARGS!' already exists on system PATH. Please choose another name for your command.
GOTO end

:notfound
copy "%~dp0..\..\temp\script.bat" "%~dp0..\..\exe\!SUBCOMMAND_ARGS!.bat" >nul
copy "%~dp0..\..\temp\help.bat" "%~dp0..\..\help\!SUBCOMMAND_ARGS!-help.bat" >nul
GOTO end

:end
ENDLOCAL
