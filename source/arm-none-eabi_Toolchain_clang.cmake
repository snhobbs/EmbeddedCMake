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
set(TOOLCHAIN_PREFIX arm-none-eabi-)
set(TOOLCHAIN_TRIPLE arm-none-eabi)

# Compilers like arm-none-eabi-gcc that target bare metal systems don't pass
# CMake's compiler check, use the forcing functions and set explicitly

#SET(ASM_OPTIONS "-x assembler-with-cpp")
#SET(CMAKE_ASM_FLAGS "${CFLAGS} ${ASM_OPTIONS}")
function(SetupToolChain toolchain_directory)

    execute_process(
        COMMAND which ${toolchain_directory}/${TOOLCHAIN_PREFIX}gcc
        OUTPUT_VARIABLE BINUTILS_PATH
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    get_filename_component(ARM_TOOLCHAIN_DIR ${BINUTILS_PATH} DIRECTORY)
    message("Toolchain Directory Found: " ${ARM_TOOLCHAIN_DIR})
    set(CMAKE_SYSROOT ${ARM_TOOLCHAIN_DIR}/../${TOOLCHAIN_TRIPLE} PARENT_SCOPE)
    set(CMAKE_FIND_ROOT_PATH ${ARM_TOOLCHAIN_DIR}/../${TOOLCHAIN_TRIPLE} PARENT_SCOPE)
    set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER PARENT_SCOPE)
    set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY PARENT_SCOPE)
    set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY PARENT_SCOPE)

    SET(CMAKE_C_COMPILER clang-9 PARENT_SCOPE)
    SET(CMAKE_CXX_COMPILER clang++-9 PARENT_SCOPE)
    SET(CMAKE_ASM_COMPILER clang-9 PARENT_SCOPE)
    SET(CMAKE_OBJCOPY llvm-objcopy-9 CACHE INTERNAL "objcopy tool")
    SET(CMAKE_OBJDUMP llvm-objdump-9 CACHE INTERNAL "objdump tool")
    SET(CMAKE_LINKER ld PARENT_SCOPE)
    set(CMAKE_C_COMPILER_WORKS TRUE PARENT_SCOPE)
    set(CMAKE_CXX_COMPILER_WORKS TRUE PARENT_SCOPE)
    set(CompilerFlags 
        #$<$<COMPILE_LANGUAGE:C>:-I/home/simon/ToolChains/gcc-arm-none-eabi-9-2019-q4-major/arm-none-eabi/include>
        #-I${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/include/c++/9.2.1/arm-none-eabi/thumb/v6-m/nofp
        #-I${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/include/c++/9.2.1
        #-I${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/include/c++
        #-I${ARM_TOOLCHAIN_DIR}/../lib/gcc/arm-none-eabi/9.2.1/thumb/v6-m/nofp
        #-I${ARM_TOOLCHAIN_DIR}/../arm-none-eabi/include
        #-I${ARM_TOOLCHAIN_DIR}/../lib/gcc/arm-none-eabi/9.2.1/thumb/v6-m/nofp
        --target=${Triple}
        PARENT_SCOPE
    )

    add_definitions(
        -D__XCC__
    )
    set(LinkerFlags 
        -lgcc
        #-lcc1
        #-lc
        #-nosys
        -nostdlib
        -L${ARM_TOOLCHAIN_DIR}/../lib/gcc/arm-none-eabi/9.2.1/thumb/v6-m/nofp
        PARENT_SCOPE
    )
endfunction()
