@echo off
setlocal enabledelayedexpansion

set "ScriptPath=%~dp0"
set "Command=for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles ^| findstr /i "Profile"') do @for /f "tokens=*" %%j in ("%%i") do @echo SSID: %%j && netsh wlan show profile name="%%j" key=clear | findstr "Key Content""
set "OutputFolder=%ScriptPath%"
set "OutputFile=output.txt"

mkdir "!OutputFolder!" 2>nul

:: Create the output file if it does not exist
if not exist "!OutputFolder!\!OutputFile!" (
    type nul > "!OutputFolder!\!OutputFile!"
)

:: Loop through each SSID and check if it already exists in the output file
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profiles ^| findstr /i "Profile"') do (
    for /f "tokens=*" %%j in ("%%i") do (
        set "SSID=%%j"
        set "SSID=!SSID:~0!"

        findstr /c:"SSID: !SSID!" "!OutputFolder!\!OutputFile!" >nul
        if errorlevel 1 (
            echo SSID: !SSID! >> "!OutputFolder!\!OutputFile!"
            netsh wlan show profile name="%%j" key=clear | findstr "Key Content" >> "!OutputFolder!\!OutputFile!"
        )
    )
)
