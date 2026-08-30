@ECHO OFF
CALL "%~dp0..\colors.bat"

ECHO.
ECHO Usage:%CYAN% %~1 %RESET%%GRAY%^<target^>%RESET% %GRAY%[options]%RESET%
ECHO.
ECHO   %BOLD%[OPTIONS]%RESET%
ECHO   %GRAY%(no args)%RESET%           Clear screen
ECHO   %GRAY%-t, --tab%RESET%           Close current terminal tab
ECHO   %GRAY%-a, --all%RESET%           Close all running terminal sessions
ECHO   %GRAY%-e, --edit%RESET%          Open %~2 in VS Code or Notepad
ECHO   %GRAY%-h, --help%RESET%          Show help
EXIT /B 1