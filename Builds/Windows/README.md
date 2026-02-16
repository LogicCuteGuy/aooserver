# Windows Build Instructions for AOOServer

## Prerequisites

Before building on Windows, you need to install:

1. **CMake** (3.16 or higher)
   - Download from: https://cmake.org/download/
   - Or install via package manager: `choco install cmake` (Chocolatey)

2. **GCC/Clang/MinGW**
   - Option A: Install MinGW-w64
     - Download from: https://www.mingw-w64.org/
     - Or: `choco install mingw` (Chocolatey)
   - Option B: Install LLVM/Clang
     - Download from: https://releases.llvm.org/download.html
   - Option C: Use Visual Studio with C++ tools

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
cd .\Builds\Windows
mkdir build
cd build
cmake -G "Unix Makefiles" ../.. -DCMAKE_BUILD_TYPE=Release
cmake --build . --config Release
```

## Output

After a successful build, the executable will be located at:
```
Builds/Windows/build/bin/aooserver.exe
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

### "gcc not found" or compiler errors
- Ensure MinGW or other C++ compiler is installed and added to PATH
- Try: `where gcc` to verify compiler is in PATH

### Build fails with linker errors
- Ensure all dependencies are properly installed
- Try cleaning build: `rm -r build` then rebuild

## Notes

- The first build may take a while as it compiles all dependencies
- Subsequent builds will be faster due to caching
- For Visual Studio users, you can also generate Visual Studio project files:
  ```cmd
  cmake -G "Visual Studio 17 2022" ../.. -DCMAKE_BUILD_TYPE=Release
  cmake --build . --config Release
  ```
