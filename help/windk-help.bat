@ECHO OFF
CALL "%~dp0..\util\color.bat"

ECHO.
ECHO Usage:%CYAN% %~1 %RESET%%GRAY%^<target^>%RESET% %GRAY%[options]%RESET%
ECHO.
ECHO   %BOLD%^<TARGET^>%RESET%
ECHO   %CYAN%^<directory^>%RESET%         Navigate to a folder by name or full path (%~1 src ^| %~1 C:\Projects)
ECHO   %CYAN%^<number^>%RESET%            Navigate up N parent directories (%~1 2 ^= cd ../..)
ECHO.
ECHO   %BOLD%[OPTIONS]%RESET%
ECHO   %GRAY%(no args)%RESET%           Clear screen
ECHO   %GRAY%-t, --tab%RESET%           Close current terminal tab
ECHO   %GRAY%-a, --all%RESET%           Close all running terminal sessions
ECHO   %GRAY%-e, --edit%RESET%          Open %~2 in VS Code or Notepad
ECHO   %GRAY%-h, --help%RESET%          Show help
EXIT /B 1
