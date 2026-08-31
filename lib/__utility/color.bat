@ECHO OFF

:: Generate %ESC% character
FOR /F "tokens=1,2 delims=#" %%a IN ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') DO SET "ESC=%%b"

:: Set Color Variables
SET "RED=%ESC%[31m"
SET "GREEN=%ESC%[32m"
SET "YELLOW=%ESC%[33m"
SET "BLUE=%ESC%[34m"
SET "MAGENTA=%ESC%[35m"
SET "CYAN=%ESC%[36m"
SET "WHITE=%ESC%[37m"
SET "GRAY=%ESC%[90m"
SET "BOLD=%ESC%[1m"
SET "DIM=%ESC%[2m"
SET "REGULAR=%ESC%[22m"
SET "RESET=%ESC%[0m"

EXIT /B 0
