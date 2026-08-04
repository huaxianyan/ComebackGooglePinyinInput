@echo off
setlocal
set "ADB_SERVER_SOCKET=tcp:192.168.17.77:15037"
echo Remote ADB server: %ADB_SERVER_SOCKET%
echo Try: adb devices -l
echo.
cmd /k
