@echo off
setlocal EnableDelayedExpansion

REM === jellyfin-mpv-shim config installer ===
REM Copies conf.json and auto_sub.lua from dotfiles to Roaming,
REM preserving or generating client_uuid automatically.

set "SOURCE=%~dp0jellyfin-mpv-shim"
set "DEST=%APPDATA%\jellyfin-mpv-shim"

echo [install] jellyfin-mpv-shim config
echo.

REM --- Step 1: Determine client_uuid ---
set "CLIENT_UUID="

REM 1a. Try to read existing UUID from destination conf.json
if exist "%DEST%\conf.json" (
    for /f "tokens=2 delims=:" %%A in ('findstr /i "client_uuid" "%DEST%\conf.json"') do (
        set "RAW=%%A"
        REM Strip quotes, commas, whitespace
        for /f "tokens=*" %%B in ("!RAW!") do (
            set "STRIPPED=%%B"
            set "STRIPPED=!STRIPPED:"=!"
            set "STRIPPED=!STRIPPED:,=!"
            set "STRIPPED=!STRIPPED: =!"
            if not "!STRIPPED!"=="" if not "!STRIPPED!"=="""" (
                set "CLIENT_UUID=!STRIPPED!"
            )
        )
    )
)

REM 1b. If no existing UUID, try source conf.json
if "!CLIENT_UUID!"=="" (
    if exist "%SOURCE%\conf.json" (
        for /f "tokens=2 delims=:" %%A in ('findstr /i "client_uuid" "%SOURCE%\conf.json"') do (
            set "RAW=%%A"
            for /f "tokens=*" %%B in ("!RAW!") do (
                set "STRIPPED=%%B"
                set "STRIPPED=!STRIPPED:"=!"
                set "STRIPPED=!STRIPPED:,=!"
                set "STRIPPED=!STRIPPED: =!"
                if not "!STRIPPED!"=="" if not "!STRIPPED!"=="""" (
                    set "CLIENT_UUID=!STRIPPED!"
                )
            )
        )
    )
)

REM 1c. If still empty, generate new UUID via PowerShell
if "!CLIENT_UUID!"=="" (
    for /f "usebackq tokens=*" %%U in (`powershell -NoProfile -Command "[guid]::NewGuid().ToString()"`) do (
        set "CLIENT_UUID=%%U"
    )
    echo [uuid] Generated new: !CLIENT_UUID!
) else (
    echo [uuid] Reusing existing: !CLIENT_UUID!
)

REM --- Step 2: Ensure destination directories exist ---
if not exist "%DEST%" mkdir "%DEST%"
if not exist "%DEST%\scripts" mkdir "%DEST%\scripts"

REM --- Step 3: Copy conf.json with UUID injected ---
echo [copy] conf.json -^> %DEST%\conf.json
powershell -NoProfile -Command ^
    "$json = Get-Content -Raw -Path '%SOURCE%\conf.json' -Encoding UTF8; ^
     $json = $json -replace '\"client_uuid\"\s*:\s*\"[^\"]*\"', ('\"client_uuid\":\"' + '%CLIENT_UUID%' + '\"'); ^
     [System.IO.File]::WriteAllText('%DEST%\conf.json', $json, [System.Text.Encoding]::UTF8)"

REM --- Step 4: Copy auto_sub.lua ---
echo [copy] auto_sub.lua -^> %DEST%\scripts\auto_sub.lua
copy /Y "%SOURCE%\script\auto_sub.lua" "%DEST%\scripts\auto_sub.lua" >nul

echo.
echo [done] Config installed to %DEST%
echo.
pause
