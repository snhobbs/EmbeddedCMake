CMAKE_MINIMUM_REQUIRED (VERSION 2.6)
#include(CMakeForceCompiler)

# CMake Options
SET(CMAKE_VERBOSE_MAKEFILE ON)

# CROSS COMPILER SETTING
set(CMAKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

# ENABLE ASM
ENABLE_LANGUAGE(ASM)

# Clear flags to set in sane state
SET(CMAKE_STATIC_LIBRARY_PREFIX)
SET(CMAKE_STATIC_LIBRARY_SUFFIX)

SET(CMAKE_EXECUTABLE_LIBRARY_PREFIX)
SET(CMAKE_EXECUTABLE_LIBRARY_SUFFIX)

set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)#THIS IS SUPER CRITICAL, KEEPS CMAKE FROM ADDING SYSTEM LIBRARIES
SET(CMAKE_STATIC_LIBRARY_LINK_CXX_FLAGS)#here on spec
SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS)#Keeps CMake from adding rdynamic as a flag
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--no-export-dynamic")#Also keeps CMake from adding rdynamic as a flag

set(CMAKE_EXECUTABLE_SUFFIX .axf)
set(TOOL_PREFIX arm-none-eabi)
set(TOOLCHAIN_EXT "")#no extension

# Compilers like arm-none-eabi-gcc that target bare metal systems don't pass
# CMake's compiler check, use the forcing functions and set explicitly
function(SetupToolChain toolchain_directory)
    SET(CMAKE_C_COMPILER ${toolchain_directory}/${TOOL_PREFIX}-gcc${TOOLCHAIN_EXT} PARENT_SCOPE)
    SET(CMAKE_CXX_COMPILER ${toolchain_directory}/${TOOL_PREFIX}-g++${TOOLCHAIN_EXT} PARENT_SCOPE)
    SET(CMAKE_ASM_COMPILER ${toolchain_directory}/${TOOL_PREFIX}-gcc${TOOLCHAIN_EXT} PARENT_SCOPE)
    SET(CMAKE_OBJCOPY ${toolchain_directory}/${TOOL_PREFIX}-objcopy CACHE INTERNAL "objcopy tool")
    SET(CMAKE_OBJDUMP ${toolchain_directory}/${TOOL_PREFIX}-objdump CACHE INTERNAL "objdump tool")
    set(CMAKE_C_COMPILER_WORKS TRUE PARENT_SCOPE)
    set(CMAKE_CXX_COMPILER_WORKS TRUE PARENT_SCOPE)

    add_definitions(
        -D__NEWLIB__ 
        -D__MCUXPRESSO
        -D__USE_CMSIS 
    )
    
    set(CompilerFlags 
        -mapcs#FIXME WHAT IS THIS
        -fstrict-volatile-bitfields
        -mfloat-abi=soft
        PARENT_SCOPE
    )

    set(LinkerFlags
        -Wl,-print-memory-usage 
        PARENT_SCOPE
    )
endfunction()

function(SetArmStartupFile VendorCodeBaseDirectory)
    SetArmCppStartupFile(${VendorCodeBaseDirectory})
    set(ArmStartupFile ${ArmCppStartupFile} PARENT_SCOPE)
endfunction()
