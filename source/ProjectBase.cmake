#------------------------------------------------------------------------------------------
# Set Project Defaults
#------------------------------------------------------------------------------------------

if(NOT DEFINED EmbeddedCMake_DIR)
  set(EmbeddedCMake_DIR $ENV{HOME}/EmbeddedCMake)
endif()

if(NOT DEFINED toolchain_base)
  set(toolchain_base $ENV{HOME}/ToolChains)
endif()

if(NOT DEFINED CpplintCommand)
  set(CpplintCommand cpplint)
endif()

if(NOT DEFINED CppcheckCommand)
  set(CppcheckCommand cppcheck)
endif()

if(NOT DEFINED ClangtidyCommand)
  set(ClangtidyCommand clang-tidy)
endif()


#------------------------------------------------------------
# Add Project Sources
#------------------------------------------------------------
include(${EmbeddedCMake_DIR}/source/Utilities.cmake)
foreach (directory ${ProjectSourceDirectories})
    AUX_SOURCE_DIRECTORY(${directory} SourceFiles)
endforeach ()

foreach (file ${source_excludes})
  message("Remove ${file}")
  list(FILTER SourceFiles EXCLUDE REGEX ${file})
endforeach()

target_sources(${TargetName} PUBLIC ${SourceFiles})
get_target_property(SOURCES ${TargetName} TargetSources)
PrintSourceFiles("${TargetSources}")


#------------------------------------------------------------
# Setup Toolchain
#------------------------------------------------------------
include(${EmbeddedCMake_DIR}/source/arm-none-eabi_Toolchain.cmake)
if(NOT DEFINED BUILD_TYPE)
  set(BUILD_TYPE "GCC_ARM")
  message(WARNING "BUILD_TYPE not set, using ${BUILD_TYPE}")
endif()
string(TOUPPER "${BUILD_TYPE}" BUILD_TYPE)

if("${BUILD_TYPE}" STREQUAL CLANG)
  set(LinkerScriptType "GCC_ARM")
elseif("${BUILD_TYPE}" STREQUAL MCUXPRESSO)
  set(LinkerScriptType "MCUXpresso")
else()
  set(LinkerScriptType "GCC_ARM")
endif()
message(STATUS "Using BUILD_TYPE ${BUILD_TYPE}")

if(NOT DEFINED LINKER_SCRIPT)
  set(LINKER_SCRIPT ${CMAKE_BINARY_DIR}/${ChipName}_${LinkerScriptType}.ld)
  message(WARNING "Linker script not set, using ${LINKER_SCRIPT}")
endif()

if(NOT EXISTS ${LINKER_SCRIPT})
  message(SEND_ERROR "Linker script ${LINKER_SCRIPT} not found")
endif()

if(NOT DEFINED LINKER_MAP)
  set(LINKER_MAP "${CMAKE_BINARY_DIR}/${TargetName}_${BUILD_TYPE}.map")
  # message(WARNING "Linker map not set, using ${LINKER_MAP}")
  message(STATUS "Linker Map: ${LINKER_MAP}")
endif()

SetupToolchain(${BUILD_TYPE} ${VendorCodeBaseDirectory} ${toolchain_base})
#  Sets the ArmStartupFile Option
target_sources(${TargetName} PUBLIC ${ArmStartupFile})

message(STATUS "C compiler: ${CMAKE_C_COMPILER}")
message(STATUS "C++ compiler: ${CMAKE_CXX_COMPILER}")
message(STATUS "Linker: ${CMAKE_CXX_LINKER}")

SetTargetOptions(${TargetName} ${LINKER_MAP} ${LINKER_SCRIPT} ${BUILD_TYPE})
set(TargetIncludes ${VendorDirectories} ${ProjectIncludeDirectories} ${DeviceLibrarySource})
SetTargetInclude("${TargetName}" "${TargetIncludes}")

#------------------------------------------------------------
# Static Analysis
#------------------------------------------------------------
option(RUN_ANALYSIS "Run CppCheck, CppLint, and Clang-tidy" ON)
if(${RUN_ANALYSIS})
set(CMAKE_CXX_CPPLINT "${CpplintCommand};--verbose=5;--linelength=100")
set(CMAKE_CXX_CLANG_TIDY "${ClangtidyCommand};-checks=*")

list(APPEND static_analysis_excludes ${VendorDirectories})
list(APPEND static_analysis_excludes ${CortexLibs_DIR})
GetStaticAnalysisFiles("${TargetName}" "${static_analysis_excludes}")

include(${EmbeddedCMake_DIR}/source/cppcheck.cmake)
Cppcheck("${CMAKE_SOURCE_DIR}" "${AnalyseFiles}" ${CppcheckCommand})
endif()

#------------------------------------------------------------
# Make AXF into plain binary
#------------------------------------------------------------
option(EXPORT_BINARY "Run CppCheck, CppLint, and Clang-tidy" ON)
if(${EXPORT_BINARY})
  include(${EmbeddedCMake_DIR}/source/BinaryGenerator.cmake)
MakeBinary("${CMAKE_SOURCE_DIR}" "${TargetName}" "${CMAKE_OBJCOPY}")
endif()

#------------------------------------------------------------
# Run Tests
#------------------------------------------------------------
option(RUN_TESTS "Run tests" ON)
if(${RUN_TESTS})
  include(${EmbeddedCMake_DIR}/source/TestTarget.cmake)
  if(NOT DEFINED TestDirectory)
    set(TestDirectory "${ProjectDirectory}/tests")
  endif()
  Tests(${TargetName} ${TestDirectory} ${TestDirectory})
endif()

#--------------------------------------------------------------------------------------

