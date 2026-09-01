@echo off
:: ============================================================================
:: Module: config.bat
:: Description: Parses INI/CFG files into caller variables with path expansion
::              and cross-section alias pointer (@:) resolution.
:: ============================================================================

set "INI_FILE=%~1"
if not exist "%INI_FILE%" exit /b 1

:: Extract the directory of the INI file to resolve relative paths cleanly
for %%I in ("%INI_FILE%") do set "CONFIG_DIR=%%~dpI"
set "_CURRENT_SECTION="

:: ----------------------------------------------------------------------------
:: STEP 1: Parse INI/CFG line-by-line and load key=value pairs into memory
:: ----------------------------------------------------------------------------
for /f "usebackq tokens=1* delims==" %%A in ("%INI_FILE%") do (
    set "_LINE=%%A"

    if defined _LINE (
        set "_FIRST_CHAR=!_LINE:~0,1!"

        :: Skip comment lines starting with ';' or '#'
        if not "!_FIRST_CHAR!"==";" if not "!_FIRST_CHAR!"=="#" (

            :: Detect section headers: [section_name]
            if "!_FIRST_CHAR!"=="[" (
                for /f "delims=[]" %%S in ("%%A") do set "_CURRENT_SECTION=%%S"
            ) else (
                :: Process key=value assignments within active section
                if defined _CURRENT_SECTION (
                    set "VAL=%%B"

                    :: Expand relative paths (. or ..) relative to INI folder location
                    if "!VAL:~0,1!"=="." (
                        for %%F in ("!CONFIG_DIR!!VAL!") do set "VAL=%%~fF"
                    )

                    :: Assign variable in caller environment (e.g. flag_help=..., command_create=...)
                    set "!_CURRENT_SECTION!_%%A=!VAL!"
                )
            )
        )
    )
)

:: ----------------------------------------------------------------------------
:: STEP 2: Resolve alias pointers (@:) across [flag] and [command] sections
:: Depth-limited (max 3 passes) to handle multi-hop aliases while preventing infinite loops.
:: ----------------------------------------------------------------------------
for /L %%D in (1,1,3) do (
    :: Resolve @: pointers in [flag_] variables
    for /f "tokens=1,* delims==" %%X in ('set flag_ 2^>nul') do (
        set "RAW_VAL=%%Y"
        if "!RAW_VAL:~0,2!"=="@:" (
            set "TARGET_KEY=!RAW_VAL:~2!"
            for /f "delims=" %%T in ("!TARGET_KEY!") do (
                if defined flag_%%T set "%%X=!flag_%%T!"
                if defined command_%%T set "%%X=!command_%%T!"
            )
        )
    )

    :: Resolve @: pointers in [command_] variables
    for /f "tokens=1,* delims==" %%X in ('set command_ 2^>nul') do (
        set "RAW_VAL=%%Y"
        if "!RAW_VAL:~0,2!"=="@:" (
            set "TARGET_KEY=!RAW_VAL:~2!"
            for /f "delims=" %%T in ("!TARGET_KEY!") do (
                if defined command_%%T set "%%X=!command_%%T!"
                if defined flag_%%T set "%%X=!flag_%%T!"
            )
        )
    )
)

:: ----------------------------------------------------------------------------
:: STEP 3: Cleanup internal parser variables to keep caller scope clean
:: ----------------------------------------------------------------------------
set "INI_FILE="
set "CONFIG_DIR="
set "_CURRENT_SECTION="
set "_LINE="
set "_FIRST_CHAR="
set "VAL="
set "RAW_VAL="
set "TARGET_KEY="

exit /b 0
