@ECHO OFF

IF [%~1]==[] (
  dir
) ELSE (
  dir /a
)
