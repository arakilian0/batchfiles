@ECHO OFF

IF EXIST "%SCRIPT_DIR%" (
    FOR /F "tokens=*" %%F IN ('DIR /B /A-D "%SCRIPT_DIR%\*.bat" 2^>NUL') DO (
        ECHO %GREEN%  %%~nxF%RESET%
    )
) ELSE (
    ECHO %RED%Error: Source directory not found at "%SCRIPT_DIR%"%RESET%
)

EXIT /B 0
