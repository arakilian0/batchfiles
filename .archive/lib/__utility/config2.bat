@echo off
:: ============================================================================
:: Module: config_manager.bat
:: Usage GET: call config_manager.bat GET "windk.cfg" "section" "key" "RET_VAR"
:: Usage SET: call config_manager.bat SET "windk.cfg" "section" "key" "value"
:: ============================================================================

set "ACTION=%~1"
set "CFG_FILE=%~2"
set "TARGET_SEC=%~3"
set "TARGET_KEY=%~4"

if /i "%ACTION%"=="GET" goto :action_get
if /i "%ACTION%"=="SET" goto :action_set
exit /b 1

:: ============================================================================
:: GET OPERATION (On-demand key lookup & pointer resolution)
:: ============================================================================
:action_get
set "RET_VAR=%~5"
if not exist "%CFG_FILE%" exit /b 1
for %%I in ("%CFG_FILE%") do set "CFG_DIR=%%~dpI"

setlocal EnableDelayedExpansion
set "RAW_VAL="
set "CURR_SEC="

:: Read line-by-line until target key is found
for /f "usebackq eol=; tokens=1* delims==" %%A in ("%CFG_FILE%") do (
    set "LINE=%%A"
    set "VAL=%%B"
    set "FIRST=!LINE:~0,1!"

    if "!FIRST!"=="[" (
        for /f "delims=[]" %%S in ("!LINE!") do set "CURR_SEC=%%S"
    ) else if /i "!CURR_SEC!"=="%TARGET_SEC%" (
        if /i "!LINE!"=="%TARGET_KEY%" (
            set "RAW_VAL=!VAL!"
            goto :found
        )
    )
)
endlocal & exit /b 1

:found
:: Resolve @: Pointer Chains
set "HOPS=0"
:resolve_loop
if "!RAW_VAL:~0,2!"=="@:" (
    set /a HOPS+=1
    if !HOPS! gtr 3 goto :finalize

    set "LOOKUP_KEY=!RAW_VAL:~2!"
    set "RAW_VAL="
    set "CURR_SEC="

    for /f "usebackq eol=; tokens=1* delims==" %%A in ("%CFG_FILE%") do (
        set "LINE=%%A"
        set "VAL=%%B"
        set "FIRST=!LINE:~0,1!"

        if "!FIRST!"=="[" (
            for /f "delims=[]" %%S in ("!LINE!") do set "CURR_SEC=%%S"
        ) else if /i "!CURR_SEC!"=="%TARGET_SEC%" (
            if /i "!LINE!"=="!LOOKUP_KEY!" set "RAW_VAL=!VAL!"
        )
    )
    if defined RAW_VAL goto :resolve_loop
)

:finalize
:: Expand relative paths
if "!RAW_VAL:~0,1!"=="." (
    for %%F in ("%CFG_DIR%!RAW_VAL!") do set "RAW_VAL=%%~fF"
)

endlocal & set "%RET_VAR%=%RAW_VAL%"
exit /b 0

:: ============================================================================
:: SET OPERATION (Update existing keys or create new sections/keys)
:: ============================================================================
:action_set
set "NEW_VAL=%~5"
set "TMP_FILE=%CFG_FILE%.tmp"

setlocal EnableDelayedExpansion
set "CURR_SEC="
set "KEY_UPDATED=0"
set "SEC_FOUND=0"

:: Create/clear temporary output file
type nul > "%TMP_FILE%"

if exist "%CFG_FILE%" (
    for /f "tokens=1* delims=] eol=" %%A in ('findstr /n "^" "%CFG_FILE%"') do (
        set "LINE=%%B"

        if defined LINE (
            set "FIRST=!LINE:~0,1!"

            :: Track section headers
            if "!FIRST!"=="[" (
                :: If we're leaving the target section and key was missing, append key before new section
                if /i "!CURR_SEC!"=="%TARGET_SEC%" if !KEY_UPDATED! equ 0 (
                    echo %TARGET_KEY%=%NEW_VAL%>> "%TMP_FILE%"
                    set "KEY_UPDATED=1"
                )
                for /f "delims=[]" %%S in ("!LINE!") do set "CURR_SEC=%%S"
                if /i "!CURR_SEC!"=="%TARGET_SEC%" set "SEC_FOUND=1"
                echo !LINE!>> "%TMP_FILE%"
            ) else (
                :: Check if this line is the key we want to update inside the target section
                if /i "!CURR_SEC!"=="%TARGET_SEC%" (
                    for /f "tokens=1* delims==" %%K in ("!LINE!") do (
                        if /i "%%K"=="%TARGET_KEY%" (
                            echo %TARGET_KEY%=%NEW_VAL%>> "%TMP_FILE%"
                            set "KEY_UPDATED=1"
                        ) else (
                            echo !LINE!>> "%TMP_FILE%"
                        )
                    )
                ) else (
                    echo !LINE!>> "%TMP_FILE%"
                )
            )
        ) else (
            :: Preserve blank lines
            echo.>> "%TMP_FILE%"
        )
    )
)

:: Handle edge cases: Target key or section did not exist
if !KEY_UPDATED! equ 0 (
    if !SEC_FOUND! equ 0 (
        echo.>> "%TMP_FILE%"
        echo [%TARGET_SEC%]>> "%TMP_FILE%"
    )
    echo %TARGET_KEY%=%NEW_VAL%>> "%TMP_FILE%"
)

endlocal

:: Atomic swap
move /y "%TMP_FILE%" "%CFG_FILE%" >nul
exit /b 0
