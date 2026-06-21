@echo off
setlocal EnableDelayedExpansion

:: ============================================
:: PowerShell Profile Installer
:: ============================================

echo ============================================
echo   PowerShell Profile Installer
echo ============================================
echo.

set "SOURCE_DIR=%~dp0powershell"
set "PROFILE_DIR=%USERPROFILE%\Documents\PowerShell"
set "PROFILE_FILE=%PROFILE_DIR%\Microsoft.PowerShell_profile.ps1"

:: Check if source files exist
if not exist "%SOURCE_DIR%\user_profile.ps1" (
    echo [ERROR] user_profile.ps1 not found in %SOURCE_DIR%
    exit /b 1
)
if not exist "%SOURCE_DIR%\noorkhafidzin.omp.json" (
    echo [ERROR] noorkhafidzin.omp.json not found in %SOURCE_DIR%
    exit /b 1
)

:: Create PowerShell profile directory if not exists
if not exist "%PROFILE_DIR%" (
    echo [INFO] Creating profile directory: %PROFILE_DIR%
    mkdir "%PROFILE_DIR%"
)

:: Backup existing profile
if exist "%PROFILE_FILE%" (
    set "BACKUP=%PROFILE_FILE%.bak.%date:~-4%%date:~3,2%%date:~0,2%.%time:~0,2%%time:~3,2%%time:~6,2%"
    set "BACKUP=!BACKUP: =0!"
    echo [INFO] Backing up existing profile to: !BACKUP!
    copy /Y "%PROFILE_FILE%" "!BACKUP!" >nul
)

:: Copy profile files
echo [INFO] Copying user_profile.ps1...
copy /Y "%SOURCE_DIR%\user_profile.ps1" "%PROFILE_FILE%" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy user_profile.ps1
    exit /b 1
)

echo [INFO] Copying noorkhafidzin.omp.json...
copy /Y "%SOURCE_DIR%\noorkhafidzin.omp.json" "%PROFILE_DIR%\noorkhafidzin.omp.json" >nul
if errorlevel 1 (
    echo [ERROR] Failed to copy noorkhafidzin.omp.json
    exit /b 1
)

echo.
echo ============================================
echo   Installation Complete!
echo ============================================
echo.
echo Profile installed to: %PROFILE_FILE%
echo OMP config installed to: %PROFILE_DIR%\noorkhafidzin.omp.json
echo.
echo Restart PowerShell or run: . $PROFILE
echo.

endlocal
