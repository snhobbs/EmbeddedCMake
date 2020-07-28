if(NOT DEFINED CMAKE_CXX_CPPLINT)
set(CMAKE_CXX_CPPLINT "cpplint;--verbose=1;--linelength=100")
endif()

if(NOT DEFINED CMAKE_CXX_CLANG_TIDY)
set(CMAKE_CXX_CLANG_TIDY "clang-tidy;-checks=*;-format-style=google;-export-fixes=${CMAKE_CURRENT_BINARY_DIR}/clangtidy.results")
endif()

function(StaticAnalysis AnalyseFiles)
message(STATUS "Analyze ${AnalyseFiles}")
include(${EmbeddedCMake_DIR}/source/cpplint.cmake)
Cpplint("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" cpplint)

include(${EmbeddedCMake_DIR}/source/cppcheck.cmake)
Cppcheck("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" cppcheck)

#include(${EmbeddedCMake_DIR}/source/cccc.cmake)
#cccc("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" cccc)

include(${EmbeddedCMake_DIR}/source/flint++.cmake)
flint("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" flint++)

message("Static analysis files ${AnalyseFiles}")
include(${EmbeddedCMake_DIR}/source/flawfinder.cmake)
flawfinder("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" flawfinder)


include(${EmbeddedCMake_DIR}/source/cppclean.cmake)
cppclean("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" cppclean)

#include(${EmbeddedCMake_DIR}/source/oclint.cmake)
#oclint("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" oclint)


include(${EmbeddedCMake_DIR}/source/clangcheck.cmake)
clangcheck("${CMAKE_CURRENT_SOURCE_DIR}" "${AnalyseFiles}" clang-check-9)
endfunction()

