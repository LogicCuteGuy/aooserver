cmake_minimum_required(VERSION 3.16)
project(aooserver)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Determine platform-specific flags
if(WIN32)
    add_definitions(-D_WIN32_WINNT=0x0601)
    add_definitions(-DNOMINMAX)
    add_definitions(-DWin32)
elseif(APPLE)
    add_definitions(-DMACOSX)
elseif(UNIX AND NOT APPLE)
    add_definitions(-DLINUX)
endif()

# JUCE Library Code sources
if(WIN32)
    set(JUCE_SOURCES
        JuceLibraryCode/include_juce_core.cpp
        JuceLibraryCode/include_juce_audio_basics.cpp
        JuceLibraryCode/include_juce_audio_formats.cpp
        JuceLibraryCode/include_juce_cryptography.cpp
        JuceLibraryCode/include_juce_data_structures.cpp
        JuceLibraryCode/include_juce_events.cpp
    )
elseif(APPLE)
    set(JUCE_SOURCES
        JuceLibraryCode/include_juce_core.mm
        JuceLibraryCode/include_juce_audio_basics.mm
        JuceLibraryCode/include_juce_audio_formats.mm
        JuceLibraryCode/include_juce_cryptography.mm
        JuceLibraryCode/include_juce_data_structures.mm
        JuceLibraryCode/include_juce_events.mm
    )
else()
    set(JUCE_SOURCES
        JuceLibraryCode/include_juce_core.cpp
        JuceLibraryCode/include_juce_audio_basics.cpp
        JuceLibraryCode/include_juce_audio_formats.cpp
        JuceLibraryCode/include_juce_cryptography.cpp
        JuceLibraryCode/include_juce_data_structures.cpp
        JuceLibraryCode/include_juce_events.cpp
    )
endif()

# AOO library sources
set(AOO_SOURCES
    deps/aoo/lib/src/client.cpp
    deps/aoo/lib/src/codec_pcm.cpp
    deps/aoo/lib/src/common.cpp
    deps/aoo/lib/src/net_utils.cpp
    deps/aoo/lib/src/server.cpp
    deps/aoo/lib/src/sink.cpp
    deps/aoo/lib/src/source.cpp
    deps/aoo/lib/src/sync.cpp
    deps/aoo/lib/src/time.cpp
)

# MD5 library
set(MD5_SOURCES
    deps/aoo/deps/md5/md5.c
)

# OSCpack library
set(OSCPACK_SOURCES
    deps/aoo/deps/oscpack/osc/OscOutboundPacketStream.cpp
    deps/aoo/deps/oscpack/osc/OscPrintReceivedElements.cpp
    deps/aoo/deps/oscpack/osc/OscReceivedElements.cpp
    deps/aoo/deps/oscpack/osc/OscTypes.cpp
)

# Main application
set(APP_SOURCES
    Source/Main.cpp
)

# Create executable
add_executable(aooserver
    ${JUCE_SOURCES}
    ${AOO_SOURCES}
    ${MD5_SOURCES}
    ${OSCPACK_SOURCES}
    ${APP_SOURCES}
)

# Include directories
target_include_directories(aooserver PRIVATE
    JuceLibraryCode
    JuceLibraryCode/modules
    deps/aoo/lib
    deps/aoo/deps
    deps/aoo/lib/aoo
    deps/aoo/deps/md5
    deps/aoo/deps/oscpack
)

# Compiler options
if(MSVC)
    target_compile_options(aooserver PRIVATE /W3)
else()
    target_compile_options(aooserver PRIVATE -Wall -Wextra -fvisibility=hidden)
endif()

# Add defines
target_compile_definitions(aooserver PRIVATE
    AOO_STATIC
    USE_CODEC_OPUS=0
    JUCE_APP_VERSION=1.0.0
    JUCE_APP_VERSION_HEX=0x10000
    JucePlugin_Build_VST=0
    JucePlugin_Build_VST3=0
    JucePlugin_Build_AU=0
    JucePlugin_Build_AUv3=0
    JucePlugin_Build_AAX=0
    JucePlugin_Build_Standalone=0
    JucePlugin_Build_Unity=0
    JucePlugin_Build_LV2=0
)

if(WIN32)
    target_compile_definitions(aooserver PRIVATE WINDOWS=1)
elseif(UNIX AND NOT APPLE)
    target_compile_definitions(aooserver PRIVATE LINUX=1)
elseif(APPLE)
    target_compile_definitions(aooserver PRIVATE MACOSX=1)
endif()

# Platform-specific libraries
if(WIN32)
    target_link_libraries(aooserver PRIVATE
        ws2_32
        winmm
        kernel32
        user32
        gdi32
        winspool
        comdlg32
        advapi32
        shell32
        ole32
        oleaut32
        uuid
        odbc32
        odbccp32
        wininet
        version
        shlwapi
        pathcch
    )
elseif(APPLE)
    target_link_libraries(aooserver PRIVATE
        "-framework Foundation"
        "-framework CoreFoundation"
        "-framework CoreAudio"
        "-framework CoreMIDI"
        "-framework AudioToolbox"
        "-framework Accelerate"
        "-framework Cocoa"
        "-framework IOKit"
        "-framework Security"
    )
else()
    target_link_libraries(aooserver PRIVATE pthread)
endif()

# Output directory
set_target_properties(aooserver PROPERTIES
    RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
