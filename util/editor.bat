@ECHO OFF

CALL "%~dp0config.bat" "editor"

:: Check if code exists in PATH
WHERE %editor1% >nul 2>nul
:: If not go to fallback
IF %ERRORLEVEL% NEQ 0 GOTO fallback

:: Open argument 1 in vscode
%editor1% "%~1"
EXIT /B 0

:fallback
IF "%~2" == "full" (
    ECHO Error: Default editor VS Code not found on System PATH.
    ECHO Configure your editor in windk/lib/editor.bat
    EXIT /B 0
)

%editor2% "%~1"
EXIT /B 0

