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
#  Testing
#------------------------------------------------
function(Tests target directory binary_directory)
  #enable_testing()
    add_subdirectory(${directory} ${binary_directory})
    set(test_output ${CMAKE_SOURCE_DIR}/test_results.txt)
    add_custom_target(
        Tests
        ALL
        DEPENDS ${target}
        DEPENDS tests
        WORKING_DIRECTORY ${directory}
    )

    add_custom_command(
        TARGET Tests
        COMMENT "Running Tests in ${directory}, results in ${test_output}"
        WORKING_DIRECTORY ${directory}
        BYPRODUCTS ${binary_directory}/tests.axf
        BYPRODUCTS ${directory}/CMakeCache.txt
        BYPRODUCTS ${directory}/Makefile
        BYPRODUCTS ${directory}/cmake_install.cmake
        BYPRODUCTS ${directory}/CMakeFiles/
        BYPRODUCTS ${test_output}
        COMMAND ${binary_directory}/tests.axf 2>&1 > ${test_output}
    )
endfunction()

