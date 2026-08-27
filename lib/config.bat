@ECHO OFF

for /f "eol=[ tokens=1,2 delims==" %%A in (%~dp0..\cfg\windk.cfg) do (
    set "%%A=%%B"
)