#------------------------------------------------------------------------------------------
# Set Project Defaults
#------------------------------------------------------------------------------------------

if(NOT DEFINED CpplintCommand)
  set(CpplintCommand cpplint)
endif()

if(NOT DEFINED CppcheckCommand)
  set(CppcheckCommand cppcheck)
endif()

if(NOT DEFINED ClangtidyCommand)
  set(ClangtidyCommand clang-tidy)
endif()


