#------------------------------------------------
#  Binary
#------------------------------------------------
function(MakeBinary directory target command)
    set(axf ${target}.axf)
    set(binary ${target}.bin)
    add_custom_target(
        ${binary}
        ALL
        DEPENDS ${target}
        WORKING_DIRECTORY ${directory}
    )
    add_custom_command(
        TARGET ${binary}
        COMMENT "Exporting Binary: ${binary} from ${axf}"
        WORKING_DIRECTORY ${directory}
        BYPRODUCTS ${binary}
        COMMAND ${command}
        ARGS -O binary ${target}.axf ${binary}
    )
endfunction()


