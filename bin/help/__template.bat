@ECHO OFF
CALL "%~dp0..\lib\colors.bat"

ECHO Usage:%CYAN% %~1 %RESET%%GRAY%[-e] [-h]%RESET%
ECHO   %GRAY%(no args)%RESET%           No argument handler
ECHO   %GRAY%-e, --edit%RESET%          Open %~2 in VS Code or Notepad.
ECHO   %GRAY%-h, --help%RESET%          Show help
EXIT /B 1