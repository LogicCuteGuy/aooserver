@echo off
REM AOOServer Windows Build Script
REM Requires: CMake and GCC/Clang (MinGW or similar)

setlocal enabledelayedexpansion

echo Building aooserver for Windows...
echo.

REM Create build directory
if not exist build mkdir build
cd build

REM Run CMake
echo Running CMake configuration...
cmake -G "Unix Makefiles" ../.. -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 (
    echo CMake configuration failed!
    exit /b 1
)

REM Build the project
echo.
echo Building project...
cmake --build . --config Release
if errorlevel 1 (
    echo Build failed!
    exit /b 1
)

echo.
echo Build completed successfully!
echo Executable location: %CD%\bin\aooserver.exe
cd ..
pause
