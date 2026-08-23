@ECHO OFF
call dotfiles-config
IF [%~1]==[] ( cd %dir_dotfiles% ) ELSE (
  IF "%1"=="-u" ( code %dir_dotfiles% )
  IF "%1"=="-o" ( open %dir_dotfiles% )
)