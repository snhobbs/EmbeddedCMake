# BinaryGenerator.cmake
# Adds target which uses the passed command to generate a plain binary from armelf
# Arguments:
#   directory -> directory containing the axf
#   target    -> The name of the target producing the axf
#   command   -> objdump command
function(MakeBinary directory target command)
  #add_custom_target(
  #     ${target}.bin
  #     ALL
  #     DEPENDS ${target}
  #     WORKING_DIRECTORY ${directory}
  # )
    add_custom_command(
      #     TARGET "${target}.bin"
        DEPENDS ${target.axf}
        COMMENT "Exporting Binary: ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin from ${target}.axf"
        WORKING_DIRECTORY ${directory}
        #BYPRODUCTS ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
        OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
        COMMAND ${command}
        ARGS -O binary ${target}.axf ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin
    )
endfunction()


