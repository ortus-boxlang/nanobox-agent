@echo off
REM ──────────────────────────────────────────────────────────────
REM NanoBox — AI Agent Platform
REM Windows Batch entry point
REM ──────────────────────────────────────────────────────────────

SETLOCAL ENABLEDELAYEDEXPANSION

REM Locate this script's directory
SET "SCRIPT_DIR=%~dp0"
REM Remove trailing backslash
IF "%SCRIPT_DIR:~-1%"=="\" SET "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

REM Locate boxlang.bat in PATH
WHERE boxlang.bat >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    REM Check common locations
    IF EXIST "%LOCALAPPDATA%\boxlang\bin\boxlang.bat" (
        SET "BOXLANG=%LOCALAPPDATA%\boxlang\bin\boxlang.bat"
    ) ELSE (
        ECHO Error: boxlang.bat not found in PATH.
        ECHO Install BoxLang: https://boxlang.ortusbooks.com/getting-started/installation
        EXIT /B 4
    )
) ELSE (
    FOR /F "tokens=*" %%G IN ('WHERE boxlang.bat') DO (
        SET "BOXLANG=%%G"
        GOTO :FOUND
    )
)
:FOUND

REM Setup NANOBOX_HOME if not set
IF "%NANOBOX_HOME%"=="" SET "NANOBOX_HOME=%USERPROFILE%\.nanobox"

REM Locate CLI script
SET "CLI_SCRIPT=%NANOBOX_HOME%\current\nanobox.bx"
IF NOT EXIST "%CLI_SCRIPT%" (
    SET "CLI_SCRIPT=%SCRIPT_DIR%\nanobox.bx"
)
IF NOT EXIST "%CLI_SCRIPT%" (
    ECHO Error: nanobox.bx not found in %NANOBOX_HOME%\current or beside this wrapper.
    EXIT /B 1
)

REM Pass all arguments to boxlang
"%BOXLANG%" "%CLI_SCRIPT%" %*
EXIT /B %ERRORLEVEL%