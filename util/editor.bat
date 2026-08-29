@ECHO OFF

:: Check if code exists in PATH
WHERE code >nul 2>nul
:: If not go to fallback
IF %ERRORLEVEL% NEQ 0 GOTO fallback

:: Open argument 1 in vscode
code "%~1"
EXIT /B 0

:fallback
IF "%~2" == "full" (
    ECHO Error: Default editor VS Code not found on System PATH.
    ECHO Configure your editor in windk/lib/editor.bat
    EXIT /B 0
)

notepad "%~1"
EXIT /B 0

