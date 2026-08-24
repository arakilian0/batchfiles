@ECHO OFF

IF [%~1]==[] GOTO exit_code

IF "%~1"=="." GOTO script_code
IF /I "%~1"=="-h" GOTO usage
IF /I "%~1"=="--help" GOTO usage

ECHO Error: %1 is not an acceptable argument.
GOTO usage

:script_code
code "%~f0"
EXIT /B 0

:exit_code
exit

:usage
ECHO Usage: %~n0 [.] [-h]
ECHO   (no args)        Exit terminal
ECHO   .                Open this script in VS Code
ECHO   -h, --help       Show this help
EXIT /B 0