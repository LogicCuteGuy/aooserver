# AOOServer Windows Build Script
# Requires: CMake and GCC/Clang (MinGW or similar)

param(
    [string]$BuildType = "Release"
)

Write-Host "Building aooserver for Windows..."
Write-Host ""

# Check if cmake is available
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: CMake not found. Please install CMake." -ForegroundColor Red
    exit 1
}

# Create build directory
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Name "build" | Out-Null
}

# Navigate to build directory
Push-Location build

try {
    # Run CMake
    Write-Host "Running CMake configuration..." -ForegroundColor Cyan
    cmake -G "Unix Makefiles" ../.. -DCMAKE_BUILD_TYPE=$BuildType
    if ($LASTEXITCODE -ne 0) {
        Write-Host "CMake configuration failed!" -ForegroundColor Red
        exit 1
    }

    # Build the project
    Write-Host ""
    Write-Host "Building project..." -ForegroundColor Cyan
    cmake --build . --config $BuildType
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Build failed!" -ForegroundColor Red
        exit 1
    }

    Write-Host ""
    Write-Host "Build completed successfully!" -ForegroundColor Green
    Write-Host "Executable location: $(Get-Location)\bin\aooserver.exe" -ForegroundColor Green
}
finally {
    Pop-Location
}
