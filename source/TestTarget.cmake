#------------------------------------------------
#  Testing
#------------------------------------------------
function(Tests target directory binary_directory)
  #enable_testing()
    add_subdirectory(${directory} ${binary_directory})
    set(test_output ${CMAKE_CURRENT_BINARY_DIR}/test_results.results)
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
        OUTPUT_FILE ${output}
        COMMAND ${binary_directory}/tests.axf 
    )
endfunction()

