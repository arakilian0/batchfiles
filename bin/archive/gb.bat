@ECHO OFF

SETLOCAL EnableExtensions EnableDelayedExpansion

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

IF "%~1"=="" (
    git branch
    EXIT /B 0
)

SET "ACTION=switch"
SET "TARGETS="

:parse_args
IF "%~1"=="" GOTO do_action

IF /I "%~1"=="-d" (
    SET "ACTION=delete"
    SHIFT & GOTO parse_args
)
IF /I "%~1"=="-D" (
    SET "ACTION=force-delete"
    SHIFT & GOTO parse_args
)
IF /I "%~1"=="-l" (
    git branch
    EXIT /B 0
)
IF /I "%~1"=="-h" GOTO usage
IF /I "%~1"=="--help" GOTO usage

REM anything else is treated as a branch name
IF DEFINED TARGETS (
    SET "TARGETS=!TARGETS! %~1"
) ELSE (
    SET "TARGETS=%~1"
)
SHIFT
GOTO parse_args

:do_action
IF NOT DEFINED TARGETS (
    git branch
    EXIT /B 0
)

IF /I "%ACTION%"=="delete" (
    FOR %%B IN (%TARGETS%) DO (
        IF NOT "%%~B"=="" (
            git branch -d "%%~B"
            IF ERRORLEVEL 1 (
                ECHO Error: failed to delete branch "%%~B".
                EXIT /B 1
            )
        )
    )
    EXIT /B 0
)
IF /I "%ACTION%"=="force-delete" (
    FOR %%B IN (%TARGETS%) DO (
        IF NOT "%%~B"=="" (
            git branch -D "%%~B"
            IF ERRORLEVEL 1 (
                ECHO Error: failed to force-delete branch "%%~B".
                EXIT /B 1
            )
        )
    )
    EXIT /B 0
)

REM default: switch into each branch, creating it first if it doesn't exist
FOR %%B IN (%TARGETS%) DO (
    CALL :switch_or_create "%%~B"
    IF ERRORLEVEL 1 (
        ECHO Error: failed to switch to branch "%%~B".
        EXIT /B 1
    )
)
EXIT /B 0

:switch_or_create
IF "%~1"=="" EXIT /B 0
git show-ref --verify --quiet "refs/heads/%~1"
IF ERRORLEVEL 1 (
    git checkout -b "%~1"
) ELSE (
    git checkout "%~1"
)
EXIT /B %ERRORLEVEL%

:usage
ECHO Usage: %~n0 [branch...] [-d or -D] [-l] [-h]
ECHO   (no args)         List branches
ECHO   branch            Create+switch, or switch if it exists
ECHO   branch1 branch2   Same, for multiple branches in sequence
ECHO   branch -d         Delete branch (safe, only if merged)
ECHO   branch -D         Force-delete branch
ECHO   -l                List branches
ECHO   -h, --help        Show this help
EXIT /B 0