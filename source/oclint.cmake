#------------------------------------------------
#  CppLint
#------------------------------------------------
function(oclint directory files command)
    set(TargetName oclint)
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
        ARGS
        --linelength=250
        --verbose=5
        ${files} 2>&1 | tee ${output}
    )
endfunction()

