# Pre-check that shunit2 is available
execute_process(COMMAND which ARGS shunit2
	OUTPUT_VARIABLE BIB2WEB_SHUNIT2
	ERROR_QUIET)
string(REGEX REPLACE "\n" "" BIB2WEB_SHUNIT2 "${BIB2WEB_SHUNIT2}")
if(NOT EXISTS "${BIB2WEB_SHUNIT2}")
	message("shunit2 does not exist. No Bash tests will be added to the build.")
	set(BIB2WEB_SHUNIT2_EXISTS FALSE)
else()
	set(BIB2WEB_SHUNIT2_EXISTS TRUE)
endif()

# Pre-check that shellchecks is available
execute_process(COMMAND which ARGS shellcheck
	OUTPUT_VARIABLE BIB2WEB_SHELLCHECK
	ERROR_QUIET)
string(REGEX REPLACE "\n" "" BIB2WEB_SHELLCHECK "${BIB2WEB_SHELLCHECK}")
if(NOT EXISTS "${BIB2WEB_SHELLCHECK}")
	message("shellcheck does not exist. No Bash linting will be added to the build.")
	set(BIB2WEB_SHELLCHECK_EXISTS FALSE)
else()
	set(BIB2WEB_SHELLCHECK_EXISTS TRUE)
endif()