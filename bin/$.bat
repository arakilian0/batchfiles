@ECHO OFF

IF [%~1]==[] GOTO start_terminal
IF /I "%~1"=="-p" GOTO system_props
IF /I "%~1"=="-h" GOTO usage
IF /I "%~1"=="--help" GOTO usage

ECHO Error: %1 is not an acceptable argument.
GOTO usage

:start_terminal
start cmd.exe
GOTO :EOF

:system_props
start SystemPropertiesAdvanced.exe
GOTO :EOF

:usage
ECHO Usage: %~n0 [-p] [-h]
ECHO   (no args)        Command prompt
ECHO   -p               System properties
ECHO   -h, --help       Show this help
EXIT /B 0