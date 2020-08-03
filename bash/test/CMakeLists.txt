# The individual test files
set(BASH_TEST_FILES
	${CMAKE_CURRENT_SOURCE_DIR}/option-parsing.bash
)

if(BIB2WEB_SHUNIT2_EXISTS)
	# Generate the master test file to be run
	set(BASH_TEST_MASTER_FILE "${CMAKE_CURRENT_BINARY_DIR}/.bash-test.sh")
	add_custom_command(
		OUTPUT "${BASH_TEST_MASTER_FILE}"
		COMMAND /bin/bash ARGS "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" "${BASH_TEST_MASTER_FILE}" "${BIB2WEB_SHUNIT2}" "${CMAKE_CURRENT_SOURCE_DIR}/../src" "${BASH_TEST_FILES}"
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" "${BASH_TEST_FILES}")

	# Add the target for running the tests
	add_custom_target(bash-test
		DEPENDS "${BASH_TEST_MASTER_FILE}")
	add_custom_command(
		TARGET bash-test
		COMMAND /bin/bash ARGS "${BASH_TEST_MASTER_FILE}")

	add_dependencies(test bash-test)

endif()

if(BIB2WEB_SHELLCHECK_EXISTS)
	# Add the target for linting the test files
	add_custom_target(bash-test-lint)
	add_custom_command(
		TARGET bash-test-lint
		COMMAND shellcheck ARGS "-x" ${BASH_TEST_FILES} "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash"
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

	add_dependencies(bash-lint bash-test-lint)
endif()