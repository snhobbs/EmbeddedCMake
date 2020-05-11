#------------------------------------------------
#  CppCheck
#------------------------------------------------
function(Cppcheck directory files command)
    set(output ${directory}/cppcheck.results)
    add_custom_target(
        cppcheck
        ALL
        WORKING_DIRECTORY ${directory}
    )
add_custom_command(
        TARGET cppcheck
        COMMENT "Running CppCheck, exporting to ${output}"
        WORKING_DIRECTORY ${directory}
        BYPRODUCTS ${output}
        COMMAND "${command}"
        ARGS
        #--enable=warning,performance,portability,information,missingInclude
        --enable=all
        #--check-config
        --output-file=${output}
        --force
        --language=c++
        --std=c++14
        #--library=qt.cfg
        #--template="[{severity}][{id}] {message} {callstack} \(On {file}:{line}\)"
        --template="[{severity}][{id}] {message} {callstack} \(On {file}:{line}\)"
        --verbose
        --quiet
        ${files}
    )
endfunction()

