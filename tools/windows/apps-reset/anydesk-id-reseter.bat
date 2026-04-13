@echo off
setlocal enabledelayedexpansion
:: =============================================================================
:: Script Name : anydesk-id-reseter.bat
:: Description : AnyDesk ID Reset Utility for Windows.
:: Usage       : Run as Administrator. No arguments required.
:: Author      : syr4ok (Andrii Syrovatko)
:: Version     : 1.2.1
:: =============================================================================


echo ========================================
echo   AnyDesk Config Reset Utility
echo ========================================

:: Check for Administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [WARNING] Please run this script as Administrator.
    pause
    exit /b
)

echo [+] [1/3] Terminating AnyDesk processes...
taskkill /F /IM "AnyDesk.exe" /T 2>nul
echo.

echo [+] [2/3] Cleaning configuration files...
if exist "%appdata%\AnyDesk\service.conf" (
    del /F /Q "%appdata%\AnyDesk\service.conf"
    echo     - %appdata%\AnyDesk\service.conf deleted.
)
if exist "%appdata%\AnyDesk\system.conf" (
    del /F /Q "%appdata%\AnyDesk\system.conf"
    echo     - %appdata%\AnyDesk\system.conf deleted.
)
if exist "%ProgramData%\AnyDesk\service.conf" (
    del /F /Q "%ProgramData%\AnyDesk\service.conf"
    echo     - %ProgramData%\AnyDesk\service.conf deleted.
)
if exist "%ProgramData%\AnyDesk\system.conf" (
    del /F /Q "%ProgramData%\AnyDesk\system.conf"
    echo     - %ProgramData%\AnyDesk\system.conf deleted.
)
echo.


echo [+] [3/3] Checking Registry entries...
set "regFound=0"

:: 32-bit system check
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AnyDesk" >nul 2>&1
if !errorLevel! equ 0 (
    echo     - Found 32-bit registry key. Deleting...
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\AnyDesk" /f >nul 2>&1
    set "regFound=1"
)

:: 64-bit system check
reg query "HKEY_LOCAL_MACHINE\SOFTWARE\AnyDesk" >nul 2>&1
if !errorLevel! equ 0 (
    echo     - Found 64-bit registry key. Deleting...
    reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\AnyDesk" /f >nul 2>&1
    set "regFound=1"
)

:: Final status based on the flag
if !regFound! equ 1 (
    echo    [OK] Registry cleanup finished.
) else (
    echo    - [INFO] No relevant registry keys found. Skipping.
)
echo.

echo Success! AnyDesk is ready for a fresh start.
echo ========================================
pause
