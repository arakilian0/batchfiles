@echo off
:: config.bat - Parses INI/CFG into caller's environment
set "INI_FILE=%~1"
if not exist "%INI_FILE%" exit /b 1

for %%I in ("%INI_FILE%") do set "CONFIG_DIR=%%~dpI"
set "_CURRENT_SECTION="

for /f "usebackq tokens=1* delims==" %%A in ("%INI_FILE%") do (
    set "_LINE=%%A"

    if defined _LINE (
        set "_FIRST_CHAR=!_LINE:~0,1!"

        :: Skip comments starting with ; or #
        if not "!_FIRST_CHAR!"==";" if not "!_FIRST_CHAR!"=="#" (

            :: Check for section headers [section]
            if "!_FIRST_CHAR!"=="[" (
                for /f "delims=[]" %%S in ("%%A") do set "_CURRENT_SECTION=%%S"
            ) else (
                :: Process key=value pairs
                if defined _CURRENT_SECTION (
                    set "VAL=%%B"

                    :: Expand relative paths (. or ..) relative to config directory
                    if "!VAL:~0,1!"=="." (
                        for %%F in ("!CONFIG_DIR!!VAL!") do set "VAL=%%~fF"
                    )

                    :: 1. Set full variable directly in caller environment (e.g. flag_help=...)
                    set "!_CURRENT_SECTION!_%%A=!VAL!"

                    :: 2. Auto-generate 1-letter alias for [flag] section
                    if /i "!_CURRENT_SECTION!"=="flag" (
                        set "FULL_KEY=%%A"
                        set "SHORT_ALIAS=!FULL_KEY:~0,1!"

                        :: Only set short alias if not already assigned
                        if not defined flag_!SHORT_ALIAS! (
                            set "flag_!SHORT_ALIAS!=!VAL!"
                        )
                    )
                )
            )
        )
    )
)

:: Clean up parser internal variables so they don't clog the environment
set "INI_FILE="
set "CONFIG_DIR="
set "_CURRENT_SECTION="
set "_LINE="
set "_FIRST_CHAR="
set "VAL="
set "FULL_KEY="
set "SHORT_ALIAS="

exit /b 0
