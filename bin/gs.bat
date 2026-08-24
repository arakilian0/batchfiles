@ECHO OFF

where git >nul 2>&1
IF ERRORLEVEL 1 (
    ECHO Error: git not found in PATH.
    EXIT /B 1
)

git rev-parse --is-inside-work-tree >nul 2>&1
IF ERRORLEVEL 1 (
    ECHO Error: not inside a git repository.
    EXIT /B 1
)

git status