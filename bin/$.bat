@ECHO OFF

IF /I "%~1"=="--internal-usage" GOTO usage

CALL "%~dp0lib\common.bat" "%~1" "%~f0"
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

IF [%~1]==[] GOTO default_action
IF /I "%~1"=="-p" GOTO system_props
IF /I "%~1"=="--props" GOTO system_props
IF /I "%~1"=="-n" GOTO new_terminal
IF /I "%~1"=="--new" GOTO new_terminal

ECHO %RED%Error:%RESET% %DIM%"%~1"%RESET% is not an acceptable argument.
GOTO usage

:default_action
SET "TERM_PROGRAM="
wt.exe -w 0 nt cmd.exe 2>nul
IF ERRORLEVEL 1 GOTO new_terminal
EXIT /B 0

:new_terminal
SET "TERM_PROGRAM="
START cmd.exe
EXIT /B 0

:system_props
START SystemPropertiesAdvanced.exe
EXIT /B 0

:usage
ECHO.
ECHO Usage: %CYAN%%~n0%RESET%%DIM% [.] [-p] [-n] [-h]%RESET%
ECHO.
ECHO   %DIM%(no args)%RESET%          Open new terminal tab
ECHO   %DIM%.%RESET%                  Open %~nx0 in VS Code
ECHO   %DIM%-p, --props%RESET%        Open Advanced System Properties
ECHO   %DIM%-n, --new%RESET%          Open new CMD window
ECHO   %DIM%-h, --help%RESET%         Show help
EXIT /B 1