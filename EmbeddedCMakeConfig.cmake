# - Config file for the CortexLibs package
# It defines the following variables
#  EMBEDDEDCMAKE_INCLUDE_DIRS - include directories for CortexLibs
#  EMBEDDEDCMAKE_LIBRARIES    - libraries to link against
#  EMBEDDEDCMAKE_EXECUTABLE   - the bar executable

# Compute paths
get_filename_component(EMBEDDEDCMAKE_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
set(EMBEDDEDCMAKE_INCLUDE_DIRS "/home/simon/Argus/ArgusMsds/cmake/EmbeddedCMake;/home/simon/Argus/ArgusMsds/cmake/EmbeddedCMake")
