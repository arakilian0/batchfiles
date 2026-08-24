@ECHO OFF

IF [%~1]==[] (
  SET error = no filename detected
  SET "%error"
  EXIT /B
) ELSE (
  type nul > %1
)
