@ECHO OFF

WHERE code >nul 2>nul
IF %ERRORLEVEL% NEQ 0 GOTO fallback

code "%SCRIPT_PATH%"
EXIT /B 0

:fallback
notepad "%SCRIPT_PATH%"
EXIT /B 0