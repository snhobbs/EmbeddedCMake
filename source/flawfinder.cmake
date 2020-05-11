#------------------------------------------------
#  CppLint
#------------------------------------------------
function(flawfinder directory files command)
    set(target_name flawfinder)
    set(output ${directory}/${target_name}.results)
    add_custom_target(
        ${target_name} 
        ALL
        WORKING_DIRECTORY ${directory}
    )

    add_custom_command(
        TARGET ${target_name} 
        BYPRODUCTS ${output}
        COMMENT "Running ${target_name}, exporting to ${output}"
        WORKING_DIRECTORY ${directory}
        COMMAND ${command}
        ARGS
        ${files} 2>&1 | tee ${output}
    )
endfunction()

