@echo off
REM AOOServer Windows Build Script
REM Requires: PowerShell, CMake, and Visual Studio C++ tools

set "BUILD_TYPE=%~1"
if "%BUILD_TYPE%"=="" set "BUILD_TYPE=Release"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build.ps1" -BuildType "%BUILD_TYPE%"
exit /b %ERRORLEVEL%
