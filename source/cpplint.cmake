#------------------------------------------------
#  CppLint
#------------------------------------------------
function(Cpplint directory files command)
    set(cpplint_output ${directory}/cpplint.txt)
    add_custom_target(
        cpplint
        ALL
        WORKING_DIRECTORY ${directory}
    )

    add_custom_command(
        TARGET cpplint
        BYPRODUCTS ${cpplint_output}
        COMMENT "Running CppLint, exporting to ${cpplint_output}"
        WORKING_DIRECTORY ${directory}
        COMMAND ${command}
        ARGS
        --linelength=250
        --verbose=5
        ${files}
        2> ${cpplint_output}
    )
endfunction()

