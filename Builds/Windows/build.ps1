# AOOServer Windows Build Script
# Requires: CMake and Visual Studio with the Desktop development with C++ workload

param(
    [ValidateSet("Debug", "Release", "RelWithDebInfo", "MinSizeRel")]
    [string]$BuildType = "Release"
)

$ErrorActionPreference = "Stop"
$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$buildDir = Join-Path $repoRoot "build"

if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: CMake not found. Please install CMake." -ForegroundColor Red
    exit 1
}

$generator = cmake --help |
    Select-String '^\s*\*?\s*Visual Studio [0-9]+ [0-9]{4}' |
    ForEach-Object { [regex]::Match($_.Line, 'Visual Studio [0-9]+ [0-9]{4}').Value } |
    Select-Object -First 1

if (-not $generator) {
    Write-Host "ERROR: No Visual Studio C++ generator was found." -ForegroundColor Red
    exit 1
}

Write-Host "Configuring aooserver with $generator (x64)..." -ForegroundColor Cyan
& cmake -S $repoRoot -B $buildDir -G $generator -A x64
if ($LASTEXITCODE -ne 0) {
    Write-Host "CMake configuration failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}

Write-Host "Building $BuildType..." -ForegroundColor Cyan
& cmake --build $buildDir --config $BuildType --parallel
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed!" -ForegroundColor Red
    exit $LASTEXITCODE
}

$executable = Join-Path $buildDir "bin\$BuildType\aooserver.exe"
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "Executable location: $executable" -ForegroundColor Green
