#------------------------------------------------
#  Clangtidy
#------------------------------------------------
function(clangtidy directory files command)
    set(target_name clangtidy)
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
        ARGS "-checks=*"
        ARGS "-format-style=google"
        ARGS "-export-fixes="
        ARGS "-checks=*"
        ARGS "-checks=*"
        ${files} 2>&1 | tee ${output}
    )
endfunction()

