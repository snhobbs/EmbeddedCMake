function(GetGitCommit)
  # Sets GitCommit variable in parent scope
  set(GIT_EXECUTABLE "git")
  execute_process(
    COMMAND "${GIT_EXECUTABLE}" describe --tags --always HEAD
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    RESULT_VARIABLE res
    OUTPUT_VARIABLE out
    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
  #execute_process(COMMAND "git rev-parse -q HEAD" OUTPUT_VARIABLE output)
  set(GitCommit "${out}" PARENT_SCOPE)
endfunction()

GetGitCommit()
message("Git commit ${GitCommit}")

