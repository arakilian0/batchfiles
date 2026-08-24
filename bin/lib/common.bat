@ECHO OFF

:: Define ESC character safely
FOR /F "tokens=1,2 delims=#" %%a IN ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') DO SET "ESC=%%b"

:: Set Color Variables (ANSI codes)
SET "RED=%ESC%[31m"
SET "GREEN=%ESC%[32m"
SET "YELLOW=%ESC%[33m"
SET "BLUE=%ESC%[34m"
SET "MAGENTA=%ESC%[35m"
SET "CYAN=%ESC%[36m"
SET "WHITE=%ESC%[37m"
SET "GRAY=%ESC%[90m"
SET "BOLD=%ESC%[1m"
SET "DIM=%ESC%[2m"
SET "REGULAR=%ESC%[22m"
SET "RESET=%ESC%[0m"

:: %1 = Argument passed to caller script
:: %2 = Full path of caller script (%~f0)

:: Handle editing this script
IF "%~1"=="." (
    code "%~2"
    EXIT /B 1
)

:: Handle help
IF /I "%~1"=="-h" GOTO show_help
IF /I "%~1"=="--help" GOTO show_help

:: Not a common flag - return 0 so caller continues
EXIT /B 0

:show_help
CALL "%~2" --internal-usage 2>nul
IF ERRORLEVEL 1 (
    ECHO Usage: %~n2 [.] [-h]
    ECHO   .           Open script in VS Code
    ECHO   -h, --help  Show help
)
EXIT /B 1