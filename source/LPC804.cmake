set(Triple thumbv6m-nxp-none-eabi)
set(CMAKE_C_COMPILER_TARGET ${Triple})
set(CMAKE_CXX_COMPILER_TARGET ${Triple})
set(CMAKE_ASM_COMPILER_TARGET ${Triple})

function(SetArmCppStartupFile VendorCodeBaseDirectory)
    set(ArmCppStartupFile ${VendorCodeBaseDirectory}/devices/LPC804/mcuxpresso/startup_lpc804.cpp PARENT_SCOPE)
endfunction()

function(SetArmAssemblyStartupFile VendorCodeBaseDirectory)
    set(ArmAssemblyStartupFile ${VendorCodeBaseDirectory}/devices/LPC804/gcc/startup_LPC804.S PARENT_SCOPE)
endfunction()

function(GetVendorDirectories device_directory)
    set(sub_directories devices/LPC804 devices/LPC804/drivers CMSIS CMSIS/Include) 
    #list(APPEND devices/LPC845/gcc ${sub_directories})
    #list(APPEND devices/LPC845/mcuxpresso ${VendorCodeDirectories})
    set(vendor_directories)
    foreach (directory ${sub_directories})
        list(APPEND vendor_directories ${device_directory}/${directory})
    endforeach ()
    set(VendorDirectories ${vendor_directories} PARENT_SCOPE)
endfunction()

function(GetVendorSources device_directory)
   SetArmStartupFile(${device_directory}) 
   list(APPEND sources ${ArmStartupFile})#defined in toolchain
    GetVendorDirectories(${device_directory})
    foreach(directory ${VendorDirectories})
        AUX_SOURCE_DIRECTORY(${directory} sources)
    endforeach()
    message("Vendor Sources " ${sources})
    set(VendorSources ${sources} PARENT_SCOPE)
endfunction()


function(SetTargetOptions target linker_map linker_script)

set(MCPU cortex-m0plus)
target_compile_options(
    ${target}
    PUBLIC
    $<$<COMPILE_LANGUAGE:ASM>:-ffreestanding>
    $<$<COMPILE_LANGUAGE:ASM>:-D__STARTUP_CLEAR_BSS>#FIXME WHAT IS THIS
    $<$<COMPILE_LANGUAGE:C>:-ffreestanding>
    #$<$<COMPILE_LANGUAGE:C>:-fno-builtin> # we want builtin for C++ constexprs
    $<$<COMPILE_LANGUAGE:C>:-std=c${CMAKE_C_STANDARD}>
    $<$<COMPILE_LANGUAGE:CXX>:-std=c++${CMAKE_CXX_STANDARD}>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    $<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
    -fmessage-length=0 
    -mcpu=${MCPU}
    -fno-common 
    -nostartfiles
    -nodefaultlibs
    -nostdlib 
    -ffunction-sections 
    -fdata-sections 
    -v
    -c
    -mfloat-abi=soft
    -mthumb
    -fshort-enums # needed for clang compatibility
    #-MMD
    #-MP
)

    foreach(flag ${CompilerFlags})
        target_compile_options(
            ${target}
            PUBLIC
            ${flag}
        )
    endforeach()

target_compile_definitions(
    ${target}
    PUBLIC
    -DFSL_RTOS_BM 
    -DSDK_OS_BAREMETAL 
    -DSDK_DEBUGCONSOLE=0 
    -DCPU_LPC804M101JHI33
    -DCPU_LPC804

    #-D__MCUXPRESSO 
    #-D__USE_CMSIS 
    #-adhlns="$@.lst" 
)

#-----------------------------------------------------------------------
# Linking
#-----------------------------------------------------------------------
#set(CMAKE_C_LINK_FLAGS "")
#set(CMAKE_CXX_LINK_FLAGS "")
target_link_options(
    ${target}
    PUBLIC
    -Wl,-Map=${linker_map}
    -Wl,--gc-sections 
    -Wl,--sort-section=alignment
    -Wl,-z
    -Wl,muldefs
    #-specs=nano.specs
    #-specs=nosys.specs
    #-s# strip all symbols
    #-flto 
    #-O3 
    #-ffat-lto-objects
    #-nodefaultlibs 
    #-nostdlib 
    -mcpu=${MCPU} 
    -mthumb
    -T${linker_script} -static
    #-Wl,--start-group
    #-lm -lc -lgcc -lnosys
    #-Wl,--end-group
)
    foreach(flag ${LinkerFlags})
        target_link_options(
            ${target}
            PUBLIC
            ${flag}
        )
    endforeach()


if("${CMAKE_C_COMPILER_ID}" STREQUAL "GNU")
    TARGET_LINK_LIBRARIES(${target} -Wl,--start-group)
    target_link_libraries(${target} debug m)

    target_link_libraries(${target} debug c)

    target_link_libraries(${target} debug gcc)

    target_link_libraries(${target} debug nosys)

    target_link_libraries(${target} optimized m)

    target_link_libraries(${target} optimized c)

    target_link_libraries(${target} optimized gcc)

    target_link_libraries(${target} optimized nosys)

    TARGET_LINK_LIBRARIES(${target} -Wl,--end-group)

    target_link_libraries(${target} -specs=nano.specs)

    target_link_libraries(${target} -specs=nosys.specs)# disable semihosting
endif()

endfunction()
