@ECHO OFF

IF NOT "%~1"=="" (
    CALL %*
    EXIT /B %ERRORLEVEL%
)

FOR %%I IN ("%SCRIPT_DIR%..\lib\windk\command\archive.bat") DO SET "ARCHIVE_BAT=%%~fI"

:archive_action
CALL "%SCRIPT_DIR%..\lib\windk\command\archive.bat" %*
EXIT /B 0

:unarchive_action
CALL "%SCRIPT_DIR%..\lib\windk\command\unarchive.bat" %*
EXIT /B 0

:create_action
CALL "%SCRIPT_DIR%..\lib\windk\command\create.bat" %*
EXIT /B 0

:delete_action
CALL :action_handler "delete" & EXIT /B 0


:action_handler
CALL "%SCRIPT_DIR%..\lib\windk\command\%1.bat" %*
EXIT /B 0
