@ECHO OFF
SETLOCAL EnableDelayedExpansion

CALL "%~dp0..\util\config.bat" "windk"
CALL "%~dp0..\util\colors.bat"

ECHO %RED%%VERSION%%RESET%
ECHO hello world!
EXIT /B 0