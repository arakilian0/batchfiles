@echo off
:: lib\__utility\colors.bat - Fast ANSI Color Initialization with Fallback Support

:: 1. Check if NO_COLOR environment variable is set
if defined NO_COLOR goto disable_colors

:: 2. Verify Windows Version (Windows 10 Build 10586+ supports VT codes natively)
for /f "tokens=4-5 delims=[.] " %%A in ('ver') do (
    set "WIN_MAJOR=%%A"
    set "WIN_BUILD=%%B"
)

:: Older than Windows 10 -> Disable colors
if %WIN_MAJOR% LSS 10 goto disable_colors

:: 3. Generate ESC character (ASCII 27) via lightweight prompt call
for /f %%A in ('echo prompt $E ^| cmd') do set "ESC=%%A"

:: Standard Foreground Colors
set "RED=%ESC%[31m"
set "GREEN=%ESC%[32m"
set "YELLOW=%ESC%[33m"
set "BLUE=%ESC%[34m"
set "MAGENTA=%ESC%[35m"
set "CYAN=%ESC%[36m"
set "WHITE=%ESC%[37m"
set "GRAY=%ESC%[90m"

:: Bright Foreground Colors
set "BRIGHT_RED=%ESC%[91m"
set "BRIGHT_GREEN=%ESC%[92m"
set "BRIGHT_YELLOW=%ESC%[93m"
set "BRIGHT_BLUE=%ESC%[94m"

:: Text Styles
set "BOLD=%ESC%[1m"
set "DIM=%ESC%[2m"
set "UNDERLINE=%ESC%[4m"
set "RESET=%ESC%[0m"

goto cleanup

:disable_colors
:: Fallback: Set variables as empty strings to avoid breaking echo statements
set "RED="
set "GREEN="
set "YELLOW="
set "BLUE="
set "MAGENTA="
set "CYAN="
set "WHITE="
set "GRAY="

set "BRIGHT_RED="
set "BRIGHT_GREEN="
set "BRIGHT_YELLOW="
set "BRIGHT_BLUE="

set "BOLD="
set "DIM="
set "UNDERLINE="
set "RESET="

:cleanup
set "ESC="
set "WIN_MAJOR="
set "WIN_BUILD="
exit /b 0
