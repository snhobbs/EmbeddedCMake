#------------------------------------------------
#  CppLint
#------------------------------------------------
function(Cpplint directory files command)
    set(output ${directory}/cpplint.results)
    add_custom_target(
        cpplint
        ALL
        WORKING_DIRECTORY ${directory}
    )

    add_custom_command(
        TARGET cpplint
        PRE_BUILD
        BYPRODUCTS ${output}
        COMMENT "Running CppLint, exporting to ${output}"
        WORKING_DIRECTORY ${directory}
        COMMAND "${command}"
        ARGS
        --linelength=250
        --verbose=5
        ${files} 2>&1 | tee ${output}
    )
endfunction()

