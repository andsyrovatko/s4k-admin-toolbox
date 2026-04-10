@echo off

echo [1/2] Closing AnyDesk...
taskkill /F /IM "AnyDesk.exe" /T 2>nul

echo [2/2] Removing AnyDesk cfg files (service.conf AND system.conf)...
del /F /Q "%appdata%\AnyDesk\service.conf" 2>nul
del /F /Q "%appdata%\AnyDesk\system.conf" 2>nul

echo.
echo ========================================
echo Script done it's work successfully!
echo Now you can start AnyDesk again.
echo ========================================
echo.

pause
