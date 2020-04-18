cmake_minimum_required(VERSION 3.0.0)

#############################################################
# Begin User Defines
#############################################################
set(VERSION_MAJOR 1)
set(VERSION_MINOR 1)
set(VERSION_SUB 2)
set(TargetName "TargetName_V${VERSION_MAJOR}_${VERSION_MINOR}_${VERSION_SUB}")


set(ProjectDirectory ProjectDirectory)
set(additional_includes $ENV{IncludeDirectory})
set(toolchain_directory $ENV{Toolchain})
set(CpplintCommand cpplint)
set(CppcheckCommand cppcheck)
set(CmakeCommand /home/simon/tools/cmake-3.15.2-Linux-x86_64/bin/cmake)

include($ENV{EmbeddedCMake}/source/arm-none-eabi_Toolchain_armgcc.cmake)
include($ENV{EmbeddedCMake}/source/CMakeListsShared.cmake)
include($ENV{EmbeddedCMake}/source/LPC845.cmake)

set(LINKER_MAP output.map)
set(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/LPC845_flash.ld)
set(DEVICE_DIRECTORY ${CORTEX_LIBS}/Devices/LPC845)
set(VendorCodeBaseDirectory ${DEVICE_DIRECTORY}/VendorSdks/SDK_2.7.0_LPC845)
set(ProjectSourceDirectories ${ProjectDirectory}/source)
set(ProjectIncludeDirectories ${ProjectSourceDirectories})

set(CMAKE_BUILD_TYPE RELEASE)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(source_excludes "mtb.c" "semihost_hardfault.c")
set(static_excludes LPC804 LPC1769 uart.cpp)
set(test_directory "${ProjectDirectory}/tests")
set(test_includes ${additional_includes})

function(AddCompileFlags TargetName)
target_compile_options(
    ${TargetName}
    PUBLIC
    -g
    -Os
    -Wall
    -Wextra
    -pedantic
    -Wpedantic
    #-pedantic-errors
    #-Werror=pedantic
    -Wconversion
    -Wimplicit
    -Wunused
    -Wsuggest-final-types
    -Wmaybe-uninitialized
    -Wabi
    -Wdouble-promotion
    -Wnull-dereference
    -Winit-self

    -Wduplicated-cond
    -Wduplicated-branches
    -Wlogical-op
    -Wrestrict
    -Wold-style-cast
    -Wjump-misses-init
    -Wshadow
)
endfunction()

SET(__FIRMWARE_VERSION__ "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_SUB}")
function(AddCompileDefinitions TargetName)
target_compile_definitions(
    ${TargetName}
    PUBLIC
    -D__FIRMWARE_VERSION__="${__FIRMWARE_VERSION__}"
)
endfunction()
#############################################################
# End User Defines
#############################################################

SetupToolChain("${toolchain_directory}")
project(${TargetName})

message(STATUS "${PROJECT_NAME} ${__FIRMWARE_VERSION__}")
message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")

Tests("${CMAKE_SOURCE_DIR}" "${test_directory}" "${TargetName}" "${test_includes}" "${CmakeCommand}")

GetVendorDirectories("${VendorCodeBaseDirectory}")# Sets VendorDirectories
GetVendorSources("${VendorCodeBaseDirectory}") # Sets VendorSources

foreach (directory ${ProjectSourceDirectories})
    AUX_SOURCE_DIRECTORY(${directory} SourceFiles)
endforeach ()
list(APPEND SourceFiles ${VendorSources})

foreach (f ${source_excludes})
  list(FILTER SourceFiles EXCLUDE REGEX ${f})
endforeach ()
PrintSourceFiles("${SourceFiles}")
add_executable(
    ${TargetName}
    ${SourceFiles}
)
SetTargetOptions(${TargetName} ${LINKER_MAP} ${LINKER_SCRIPT})
set(TargetIncludes ${VendorDirectories} ${ProjectIncludeDirectories} ${DEVICE_DIRECTORY} ${additional_includes})
SetTargetInclude("${TargetName}" "${TargetIncludes}")

GetStaticAnalysisFiles("${TargetName}" "${StaticExcludes}")
Cpplint("${CMAKE_SOURCE_DIR}" "${AnalyseFiles}" "cpplint")
Cppcheck("${CMAKE_SOURCE_DIR}" "${AnalyseFiles}" "cppcheck")
MakeBinary("${CMAKE_SOURCE_DIR}" "${TargetName}" "${CMAKE_OBJCOPY}")

#--------------------------------------------------------------------------------------
# User Defined Functions
#--------------------------------------------------------------------------------------

AddCompileFlags(${TargetName})
AddCompileDefinitions(${TargetName})
