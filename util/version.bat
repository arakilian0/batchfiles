@ECHO OFF
CALL "%~dp0config.bat" "package"
ECHO %NAME% version %VERSION%
EXIT /B 0
