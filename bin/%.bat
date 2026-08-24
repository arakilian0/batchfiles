@ECHO OFF

SET "batch_scripts=C:\arakilian0\batchfiles"

IF [%~1]==[] GOTO scripts_dir

IF "%~1"=="." GOTO script_code
IF /I "%~1"=="-c" GOTO scripts_code
IF /I "%~1"=="-e" GOTO scripts_explore
IF /I "%~1"=="-h" GOTO usage
IF /I "%~1"=="--help" GOTO usage

ECHO Error: %1 is not an acceptable argument.
GOTO usage

:script_code
code "%~f0"
EXIT /B 0

:scripts_dir
cd /d "%batch_scripts%"
GOTO :EOF

:scripts_code
code "%batch_scripts%"
GOTO :EOF

:scripts_explore
explorer "%batch_scripts%"
GOTO :EOF

:usage
ECHO Usage: %~n0 [.] [-c] [-e] [-h]
ECHO   (no args)        cd batchfiles
ECHO   .                Open this script in VS Code
ECHO   -c               Open batchfiles folder in VS Code
ECHO   -e               Explore batchfiles in File Explorer
ECHO   -h, --help       Show this help
EXIT /B 0