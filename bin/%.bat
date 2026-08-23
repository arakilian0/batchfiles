@ECHO OFF

set batch-scripts=C:\arakilian0\batch-scripts

IF [%~1]==[] ( cd %batch-scripts% ) ELSE (
  IF "%1"=="-u" ( code %batch-scripts% )
  IF "%1"=="-o" ( open %batch-scripts% )
)