@ECHO OFF

for /f "eol=[ tokens=1,2 delims==" %%A in (%~dp0..\cfg\%~1.cfg) do (
    set "%%A=%%B"
)

EXIT /B 0
