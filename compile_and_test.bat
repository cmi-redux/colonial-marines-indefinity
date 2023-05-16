@echo off
call dm ColonialMarinesRU.dme
if %ERRORLEVEL% == 0 goto :run_server
goto :end

:run_server
call DreamDaemon ColonialMarinesRU.dmb 1399 -trusted -params "local_test=1"

:end
exit
