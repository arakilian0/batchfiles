@ECHO OFF

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