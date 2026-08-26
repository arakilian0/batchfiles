@ECHO OFF
CALL "%~dp0..\lib\colors.bat"

ECHO Usage:%CYAN% %~1 %RESET%%GRAY%[-t ^| --tab] [-a ^| --all] [-e ^| --edit] [-h ^| --help]%RESET%
ECHO.
ECHO   %GRAY%(no args)%RESET%           Clear screen
ECHO   %GRAY%-t, --tab%RESET%           Close current terminal tab
ECHO   %GRAY%-a, --all%RESET%           Close all running terminal sessions
ECHO   %GRAY%-e, --edit%RESET%          Open %~2 in VS Code or Notepad
ECHO   %GRAY%-h, --help%RESET%          Show help
EXIT /B 1