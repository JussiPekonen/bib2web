macro(checkTool tool)
  execute_process(COMMAND which ARGS "${tool}"
    OUTPUT_VARIABLE "BIB2WEB_${tool}"
    ERROR_QUIET)
  string(REGEX REPLACE "\n" "" "BIB2WEB_${tool}" "${BIB2WEB_${tool}}")
  if(NOT EXISTS "${BIB2WEB_${tool}}")
    message("${tool} does not exist. Targets that depend on it will not be generated!")
    set("BIB2WEB_${tool}_EXISTS" FALSE)
  else()
    set("BIB2WEB_${tool}_EXISTS" TRUE)
  endif()
endmacro()