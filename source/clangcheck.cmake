#------------------------------------------------
#  CppLint
#------------------------------------------------
function(clangcheck directory files command)
    set(TargetName clangcheck)
    set(output ${directory}/${TargetName}.results)
    add_custom_target(
        ${TargetName}
        ALL
        WORKING_DIRECTORY ${directory}
    )

    add_custom_command(
        TARGET ${TargetName}
        PRE_BUILD
        BYPRODUCTS ${output}
        COMMENT "Running ${TargetName}, exporting to ${output}"
        WORKING_DIRECTORY ${directory}
        COMMAND "${command}"
        ${files} 2>&1 | tee ${output}
    )
endfunction()

