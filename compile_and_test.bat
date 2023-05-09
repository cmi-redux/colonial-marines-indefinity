@echo off
call dm ColonialMarinesRU.dme
if %ERRORLEVEL% == 0 goto :run_server
goto :end

:run_server
call DreamDaemon colonialmarines.dmb 58140 -trusted -params "local_test=1"

:end
exit
