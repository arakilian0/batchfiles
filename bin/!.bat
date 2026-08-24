@ECHO OFF

IF /I "%~1"=="--internal-usage" GOTO usage

CALL "%~dp0lib\common.bat" "%~1" "%~f0"
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

IF [%~1]==[] GOTO default_action
IF /I "%~1"=="-f" GOTO exit_window
IF /I "%~1"=="--force" GOTO exit_window

ECHO %RED%Error:%RESET% %DIM%"%~1"%RESET% is not an acceptable argument.
GOTO usage

:default_action
EXIT

:exit_window
taskkill /F /IM wt.exe /IM OpenConsole.exe /IM WindowsTerminal.exe 2>nul
EXIT

:usage
ECHO.
ECHO Usage:%CYAN% %~n0 %RESET%%DIM%[.] [-f] [-h]%RESET%
ECHO.
ECHO   %DIM%(no args)%RESET%           Quit current session
ECHO   %DIM%.%RESET%                   Open %~nx0 in VS Code
ECHO   %DIM%-f, --force%RESET%         Quit all terminal processes
ECHO   %DIM%-h, --help%RESET%          Show help
EXIT /B 1