@ECHO OFF
call dotfiles-config
IF [%~1]==[] ( cd %dir_back% ) ELSE (
  for /l %%a in (1,1,%1) do (
    cd %dir_back%
  )
)