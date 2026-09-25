# Windows Build Instructions for AOOServer

## Prerequisites

Before building on Windows, you need to install:

1. **CMake** (3.16 or higher)
   - Download from: https://cmake.org/download/
   - Or install via package manager: `choco install cmake` (Chocolatey)

2. **Visual Studio with C++ tools**
   - Install Visual Studio 2022 or newer
   - Select the **Desktop development with C++** workload

## Building

### Method 1: Using PowerShell (Recommended)

```powershell
cd .\Builds\Windows
.\build.ps1
```

Or with a specific build type:
```powershell
.\build.ps1 -BuildType Debug
```

### Method 2: Using Batch File

```cmd
cd .\Builds\Windows
build.bat
```

### Method 3: Manual CMake Build

```cmd
cmake -S . -B build -G "Visual Studio 18 2026" -A x64
cmake --build build --config Release --parallel
```

Replace the generator name with the newest Visual Studio generator listed by
`cmake --help` when using a different Visual Studio release. The provided build
scripts detect this automatically.

## Output

After a successful build, the executable will be located at:
```
build/bin/Release/aooserver.exe
```

## Running

### Basic usage:
```cmd
aooserver.exe
```

### With options:
```cmd
aooserver.exe -p 10998           # Specify port
aooserver.exe -l logdir\         # Enable logging to directory
aooserver.exe -b blocklist.txt   # Specify blocklist file
aooserver.exe -h                 # Show help
```

## Troubleshooting

### "cmake not found"
- Ensure CMake is installed and added to PATH
- Restart your terminal after installing CMake

### No Visual Studio generator found
- Install Visual Studio with the Desktop development with C++ workload
- Run `cmake --help` and confirm that a Visual Studio generator is listed

### Build fails with linker errors
- Ensure all dependencies are properly installed
- Delete the repository-root `build` directory, then rebuild

## Notes

- The first build may take a while as it compiles all dependencies
- Subsequent builds will be faster due to caching
- Windows builds intentionally require MSVC and generate Visual Studio project files.
