@ECHO OFF
IF "%1"=="-rf" ( Xcopy /E /I "%2" "%3" ) ELSE (
    copy "%1" "%2"
)
