function(PrintSourceFiles files)
    foreach (fname ${files})
        get_filename_component(barename ${fname} NAME)
        get_filename_component(path ${fname} PATH)
        list(APPEND source_directories ${path})
    endforeach ()
    list(REMOVE_DUPLICATES source_directories)

    message("\n\t\tSource Directories and Files\n\t\t----------------------------\n")
    foreach (directory ${source_directories})
        message("Source Directory: ${directory}")
        foreach (fname ${files})
            get_filename_component(barename ${fname} NAME)
            get_filename_component(path ${fname} PATH)
            if (${path} STREQUAL ${directory})
                message("\t${barename}") 
            endif ()
        endforeach ()
    endforeach ()
endfunction()


function(SetTargetInclude target includes)
    message("\n\t\tInclude Directories and Files\n\t\t----------------------------\n")
    foreach (directory ${includes})
        target_include_directories(${target} PUBLIC ${directory})
        message("Include Directory: ${directory}")
    endforeach ()
endfunction()

function(GetStaticAnalysisFiles target exclude_patterns)
    get_target_property(analysis_directories ${target} INCLUDE_DIRECTORIES)
    foreach (pattern ${exclude_patterns})
        list(FILTER analysis_directories EXCLUDE REGEX ${pattern})
    endforeach ()

    message(STATUS "\n\nAnalysing Include Directories")
    foreach (directory ${analysis_directories})
        message(STATUS "Include Directory: ${directory}")
        file(GLOB depth_header_files ${directory}/*/*.h)
        file(GLOB header_files ${directory}/*.h)
        file(GLOB cpp_files ${directory}/*.cpp)
        foreach (file ${depth_header_files} ${header_files} ${cpp_files})
            list(APPEND analysis_files ${file})
        endforeach ()
    endforeach ()

    foreach (pattern ${exclude_patterns})
        list(FILTER analysis_files EXCLUDE REGEX ${pattern})
    endforeach ()
    set(AnalyseFiles "${analysis_files}" PARENT_SCOPE)
endfunction()


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
#------------------------------------------------
#  CppCheck
#------------------------------------------------
function(Cppcheck directory files command)
    set(cppcheck_output ${directory}/cppcheck.txt)
    add_custom_target(
        cppcheck
        ALL
        WORKING_DIRECTORY ${directory}
    )
add_custom_command(
        TARGET cppcheck
        COMMENT "Running CppCheck, exporting to ${cppcheck_output}"
        WORKING_DIRECTORY ${directory}
        BYPRODUCTS ${cppcheck_output}
        COMMAND ${command}
        ARGS
        #--enable=warning,performance,portability,information,missingInclude
        --enable=all
        #--check-config
        --output-file=${cppcheck_output}
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

#------------------------------------------------
#  Testing
#------------------------------------------------
function(Tests directory test_directory target cortex_libs command)
    set(test_output ${directory}/test_results.txt)
    add_custom_target(
        tests
        ALL
        DEPENDS ${target}
        WORKING_DIRECTORY ${test_directory}
    )

    add_custom_command(
        TARGET tests
        COMMENT "Running Tests in ${test_directory}, results in ${test_output}"
        WORKING_DIRECTORY ${test_directory}
        BYPRODUCTS ${test_directory}/Tests
        BYPRODUCTS ${test_directory}/CMakeCache.txt
        BYPRODUCTS ${test_directory}/Makefile
        BYPRODUCTS ${test_directory}/cmake_install.cmake
        BYPRODUCTS ${test_directory}/CMakeFiles/
        BYPRODUCTS ${test_output}
        COMMAND CORTEXLIBS=${cortex_libs} ${command}
        #COMMAND ${cmake_command}
        ARGS ./
        COMMAND make
        ARGS all
        COMMAND ./Tests 2>&1 > ${test_output}
    )
endfunction()

