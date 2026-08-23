@ECHO OFF

IF [%~1]==[] ( cd ../ ) ELSE (
  for /l %%a in (1,1,%1) do (
    cd ../
  )
)