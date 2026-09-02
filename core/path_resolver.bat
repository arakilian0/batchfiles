@echo off

setlocal DisableDelayedExpansion

set "ACTION=%~1"

if /i "%ACTION%"=="resolve" goto :resolve_action

if "%ACTION%"=="" (
    echo [ERROR] Missing action for path_resolver
    echo Usage: path_resolver.bat ^<resolve^> ^<path^> ^<result_var^> [base_dir]
    echo    or: path_resolver.bat "path\to\resolve" [base_dir]    ^(CLI mode^)
    exit /b 1
)

call :do_resolve "%~1" __PR_CLI_RESULT__ "%~2"
if errorlevel 1 (
    >&2 echo path_resolver: could not resolve "%~1"
    exit /b 1
)
echo(%__PR_CLI_RESULT__%
exit /b 0

:resolve_action

call :do_resolve "%~2" __PR_ACTION_RESULT__ "%~4"
set "_pr_action_rc=%errorlevel%"
if not "%_pr_action_rc%"=="0" (
    endlocal
    exit /b %_pr_action_rc%
)
endlocal & set "%~3=%__PR_ACTION_RESULT__%"
exit /b 0

:do_resolve
setlocal DisableDelayedExpansion
set "_pr_in=%~1"
set "_pr_base=%~3"

if "%_pr_in%"=="" (
    endlocal
    exit /b 1
)

set "_pr_isabs="
if "%_pr_in:~1,1%"==":" set "_pr_isabs=1"
if "%_pr_in:~0,2%"=="\\" set "_pr_isabs=1"

if not defined _pr_isabs if defined _pr_base (
    set "_pr_in=%_pr_base%\%_pr_in%"
)

set "_pr_out="
for %%A in ("%_pr_in%") do set "_pr_out=%%~fA"

if "%_pr_out%"=="" (
    endlocal
    exit /b 1
)

endlocal & set "%~2=%_pr_out%"
exit /b 0
