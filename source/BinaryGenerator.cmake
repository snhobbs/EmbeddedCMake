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
  set(source ${CMAKE_CURRENT_BINARY_DIR}/${target}.axf)
  set(dest ${CMAKE_CURRENT_BINARY_DIR}/${target}.bin)
  message("Exporting Binary: ${dest} from ${source}")

  add_custom_target(
    ${target}.bin
    ALL
    DEPENDS ${source}
    WORKING_DIRECTORY ${directory}
    COMMENT "Exporting Binary: ${dest} from ${source}"
    BYPRODUCTS ${dest}
    COMMAND ${command} -O binary ${source} ${dest}
  )
  add_dependencies(${target}.bin ${target})
#add_custom_command(
#    TARGET ${dest}
#    WORKING_DIRECTORY ${directory}
#    #OUTPUT ${dest}
#  )
endfunction()


