@echo off
call dm colonialmarinesindefinity.dme
if %ERRORLEVEL% == 0 goto :run_server
goto :end

:run_server
call DreamDaemon colonialmarinesindefinity.dmb 1399 -trusted -params "local_test=1"

:end
exit
