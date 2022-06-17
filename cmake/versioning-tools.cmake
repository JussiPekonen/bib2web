# Version getter
macro(getVersionFromTag tag_prefix version_variable)
  execute_process(
    COMMAND git describe --tags --match "${tag_prefix}/*" --abbrev=0
    ERROR_QUIET
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
    OUTPUT_VARIABLE version
  )
  if ("${version}" STREQUAL "")
    message(STATUS "${tag_prefix} version: No tag prefixed with \"${tag_prefix}/\" was found, setting the version to 0.0.")
    set(version "0.0")
  endif()
  set(${version_variable} "${version}")
endmacro()