@ECHO OFF

IF NOT DEFINED SUBCOMMAND_ARGS (
    ECHO Arguments are null or empty.
) ELSE (
    ECHO Arguments exist: !SUBCOMMAND_ARGS!
)

ENDLOCAL
EXIT /B 0
