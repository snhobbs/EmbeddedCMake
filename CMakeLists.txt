cmake_minimum_required(VERSION 3.15)

set(EMBEDDEDCMAKE_MAJOR_VERSION 1)
set(EMBEDDEDCMAKE_MINOR_VERSION 0)
set(EMBEDDEDCMAKE_PATCH_VERSION 1)
set(EMBEDDEDCMAKE_VERSION
  ${EMBEDDEDCMAKE_MAJOR_VERSION}.${EMBEDDEDCMAKE_MINOR_VERSION}.${EMBEDDEDCMAKE_PATCH_VERSION})

project(EmbeddedCMake VERSION ${EMBEDDEDCMAKE_VERSION})
set(CMAKE_C_COMPILER gcc)
set(CMAKE_CXX_COMPILER g++)
# Offer the user the choice of overriding the installation directories
set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH
  "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKE_DIR CMake)
else()
  set(DEF_INSTALL_CMAKE_DIR lib/CMake/EmbeddedCMake)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH
  "Installation directory for CMake files")

# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

# set up include-directorie
message(
  "${CMAKE_SOURCE_DIR}"
  " "
  "${PROJECT_SOURCE_DIR}"
  " "
  "${PROJECT_BINARY_DIR}")
include_directories(
  "${CMAKE_SOURCE_DIR}"
  "${PROJECT_SOURCE_DIR}"
  "${PROJECT_BINARY_DIR}")

# The interesting stuff goes here
# ===============================

# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE EmbeddedCMake)

# Create the EmbeddedCMakeConfig.cmake and EmbeddedCMakeConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
configure_file(EmbeddedCMakeConfig.cmake.in
  "${PROJECT_BINARY_DIR}/EmbeddedCMakeConfig.cmake" @ONLY)
# ... for the install tree
set(CONF_INCLUDE_DIRS "\${EMBEDDEDCMAKE_CMAKE_DIR}/${REL_INCLUDE_DIR}")
configure_file(EmbeddedCMakeConfig.cmake.in
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/EmbeddedCMakeConfig.cmake" @ONLY)
# ... for both
configure_file(EmbeddedCMakeConfigVersion.cmake.in
  "${PROJECT_BINARY_DIR}/EmbeddedCMakeConfigVersion.cmake" @ONLY)

# Install the EmbeddedCMakeConfig.cmake and EmbeddedCMakeConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/EmbeddedCMakeConfig.cmake"
  "${PROJECT_BINARY_DIR}/EmbeddedCMakeConfigVersion.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

#-----------------------------------------------------------------------------
add_subdirectory(tests)

