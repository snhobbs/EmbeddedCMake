cmake_minimum_required(VERSION 3.10.0)

set(dirs
)
foreach(dir ${dirs})
  set(path ${PROJECT_SOURCE_DIR}/${dir}/tests)
  if(EXISTS ${path})
    message(STATUS "${dir} has tests")
    list(APPEND source_directories ${path})
    list(APPEND source_directories ${path}/source)
  else()
    message(WARNING "${dir} has no tests")
  endif()
endforeach()

#-----------------------------------------------------------------------------

#SET(CMAKE_CXX_COMPILER clang++-8)
SET(CMAKE_CXX_COMPILER /usr/bin/g++-8)
find_package(UnitTest++ QUIET)
add_executable(tests)
target_compile_options(
tests
PRIVATE
    -fsanitize=address
    -fno-omit-frame-pointer
    -fsanitize=undefined)
target_compile_options(
tests
PRIVATE
    -g
    -Os
    -Wall
    -Wextra
    -pedantic
    -Wpedantic
    #-pedantic-errors
    #-Werror=pedantic

    -Wconversion
    $<$<COMPILE_LANGUAGE:C>:-Wimplicit>
    $<$<COMPILE_LANGUAGE:C>:-Wunused>

    #$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
    $<$<COMPILE_LANGUAGE:CXX>:-Wabi>
    $<$<CXX_COMPILER_ID:GNU>:-Wsuggest-final-types>
    $<$<CXX_COMPILER_ID:GNU>:-Wmaybe-uninitialized>
    $<$<CXX_COMPILER_ID:GNU>:-Wdouble-promotion>
    $<$<CXX_COMPILER_ID:GNU>:-Wnull-dereference>
    -Winit-self

    $<$<CXX_COMPILER_ID:GNU>:-Wduplicated-cond>
    $<$<CXX_COMPILER_ID:GNU>:-Wduplicated-branches>
    $<$<CXX_COMPILER_ID:GNU>:-Wlogical-op>
    $<$<CXX_COMPILER_ID:GNU>:-Wrestrict>
    $<$<C_COMPILER_ID:GNU>:$<$<COMPILE_LANGUAGE:C>:-Wjump-misses-init>>
    $<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>
    -Wshadow
)

target_compile_features(tests PUBLIC cxx_std_17)
target_compile_definitions(tests PRIVATE TESTING)
target_compile_definitions(tests PRIVATE UNITTESTING)
target_compile_definitions(tests PRIVATE LINUX)
set_property(TARGET tests PROPERTY CXX_STANDARD 17)
SET(CMAKE_VERBOSE_MAKEFILE ON)

#fixme this should have all the sources
foreach(dir ${source_directories})
  aux_source_directory(${dir} DIR_SRCS)
endforeach()

target_sources(tests PUBLIC main.cpp)
target_sources(tests PUBLIC ${DIR_SRCS})
#target_link_directories(tests PUBLIC /usr/lib/clang/8/lib/linux/)
#target_link_libraries( tests clang_rt.ubsan_standalone-x86_64.a)
#target_link_libraries(tests ${UNITTEST++_PATH})
target_link_libraries( tests asan)
#target_link_libraries( tests tsan)
target_link_libraries( tests ubsan)
#target_link_libraries( tests msan)

target_link_libraries( tests UnitTest++)

target_include_directories(tests PUBLIC ${TESTSRC} )
target_include_directories(tests PUBLIC ${CMAKE_SOURCE_DIR} )

message(STATUS "Sources: ${DIR_SRCS}")

add_test(NAME ${CMAKE_SOURCE_DIR} COMMAND tests)
