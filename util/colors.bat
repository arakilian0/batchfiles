@ECHO OFF

:: Import Colors from cfg/windk.cfg
CALL "%~dp0config.bat" "windk"

:: Generate %ESC% character
FOR /F "tokens=1,2 delims=#" %%a IN ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') DO SET "ESC=%%b"

:: Set Color Variables
SET "RED=%ESC%%_red%"
SET "GREEN=%ESC%%_green%"
SET "YELLOW=%ESC%%_yellow%"
SET "BLUE=%ESC%%_blue%"
SET "MAGENTA=%ESC%%_magenta%"
SET "CYAN=%ESC%%_cyan%"
SET "WHITE=%ESC%%_white%"
SET "GRAY=%ESC%%_gray%"
SET "BOLD=%ESC%%_bold%"
SET "DIM=%ESC%%_dim%"
SET "REGULAR=%ESC%%_regular%"
SET "RESET=%ESC%%_reset%"

EXIT /B 0