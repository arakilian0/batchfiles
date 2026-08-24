@ECHO OFF

:: Callback handling
IF /I "%~1"=="--internal-usage" GOTO usage

:: 1. Delegate common flags to common_flags.bat
CALL "%~dp0lib\common.bat" "%~1" "%~f0"
IF ERRORLEVEL 1 EXIT /B %ERRORLEVEL%

:: 2. Handle script-specific flags / defaults
IF [%~1]==[] GOTO default_action
IF /I "%~1"=="-p" GOTO custom_flag

:: 3. Catch invalid arguments HERE (only after checking all valid options)
ECHO %RED%Error:%RESET% %DIM%"%~1"%RESET% is not an acceptable argument.
GOTO usage

:default_action
ECHO Running default task...
EXIT /B 0

:custom_flag
ECHO Running custom flag -p...
EXIT /B 0

:usage
ECHO.
ECHO Usage: %CYAN%%~n0%RESET%%DIM% [.] [-p] [-h]%RESET%
ECHO.
ECHO   %DIM%(no args)%RESET%           Run default action
ECHO   %DIM%.%RESET%                   Open %~nx0 in VS Code
ECHO   %DIM%-p%RESET%                  Run custom task
ECHO   %DIM%-h, --help%RESET%          Show help
EXIT /B 1