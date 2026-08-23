@ECHO OFF

IF NOT [%~1]==[-rf] (DEL %~1) ELSE (RMDIR /s /q %~2)
