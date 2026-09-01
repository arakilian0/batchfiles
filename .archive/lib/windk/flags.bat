@ECHO OFF

IF NOT "%~1"=="" (
    CALL %*
    EXIT /B %ERRORLEVEL%
)

SET "LEVEL=%SCRIPT_DIR%..\"

:: Help -h
:help_action
CALL "%LEVEL%help\windk-help.bat" "%SCRIPT_NAME%" "%SCRIPT_FILE%"
EXIT /B 0

:: Edit -e
:edit_action
CALL "%LEVEL%util\editor.bat" "%SCRIPT_PATH%"
EXIT /B 0

:: Version -v
:version_action
CALL "%LEVEL%util\version.bat"
EXIT /B 0

:: List -l
:scripts_action
CALL "%LEVEL%lib\windk\list_scripts.bat"
EXIT /B 0

:: Open windk -c
:open_windk_action
CALL "%LEVEL%util\editor.bat" "%SCRIPT_DIR%.." "full"
EXIT /B 0
