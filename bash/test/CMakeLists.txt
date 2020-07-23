# Pre-check that shunit2 is available
execute_process(COMMAND which ARGS shunit2
	OUTPUT_VARIABLE BIB2WEB_SHUNIT2
	ERROR_QUIET)
string(REGEX REPLACE "\n" "" BIB2WEB_SHUNIT2 "${BIB2WEB_SHUNIT2}")

# The shunit2 does not exist, no Bash tests will be added the build
if(NOT EXISTS "${BIB2WEB_SHUNIT2}")
	message(WARNING "shunit2 does not exist. No Bash tests will be added to the build.")
else()

	# The individual test files
	set(BASH_TEST_FILES
	)

	# Generate the master test file to be run
	set(BASH_TEST_MASTER_FILE "${CMAKE_CURRENT_BINARY_DIR}/.bash-test.sh")
	add_custom_command(
		OUTPUT "${BASH_TEST_MASTER_FILE}"
		COMMAND /bin/bash ARGS "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" "${BASH_TEST_MASTER_FILE}" "${BIB2WEB_SHUNIT2}" "${BASH_TEST_FILES}"
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" "${BASH_TEST_FILES}")

	# Add the target for running the tests
	add_custom_target(bash-test
		DEPENDS "${BASH_TEST_MASTER_FILE}")
	add_custom_command(
		TARGET bash-test
		COMMAND /bin/bash ARGS "${BASH_TEST_MASTER_FILE}")

	add_dependencies(test bash-test)

endif()