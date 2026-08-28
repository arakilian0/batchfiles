@ECHO OFF

WHERE code >nul 2>nul
IF %ERRORLEVEL% NEQ 0 GOTO fallback

code "%~1"
EXIT /B 0

:fallback
notepad "%~1"
EXIT /B 0