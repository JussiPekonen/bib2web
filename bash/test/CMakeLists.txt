# The individual test files
set(BASH_TEST_FILES
	"${CMAKE_CURRENT_SOURCE_DIR}/options-parser-tests.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/preprocessor-tests.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/input-processor-tests.bash"
)

# Add target for running the tests, if possible
if(BIB2WEB_SHUNIT2_EXISTS)
	# Generate the master test file to be run
	set(BASH_TEST_MASTER_FILE "${CMAKE_CURRENT_BINARY_DIR}/.bash-test.sh")
	add_custom_command(
		OUTPUT "${BASH_TEST_MASTER_FILE}"
		COMMAND /bin/bash ARGS "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" "${BASH_TEST_MASTER_FILE}" "${BIB2WEB_SHUNIT2}" "${CMAKE_CURRENT_SOURCE_DIR}/../src" ${BASH_TEST_FILES}
		DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" "${BASH_TEST_FILES}")

	add_custom_target(bash-test
		DEPENDS "${BASH_TEST_MASTER_FILE}")
	add_custom_command(
		TARGET bash-test
		COMMAND /bin/bash ARGS "${BASH_TEST_MASTER_FILE}")

	# Set the version, just in case
	add_dependencies(bash-test bash-version)

	# Add the Bash testing target as a dependency to the general testing target
	add_dependencies(test bash-test)
endif()

# Add the target for linting the test files, if possible
if(BIB2WEB_SHELLCHECK_EXISTS)
	add_custom_target(bash-test-lint)
	add_custom_command(
		TARGET bash-test-lint
		COMMAND shellcheck ARGS "-x" "${CMAKE_CURRENT_SOURCE_DIR}/generate-test-master.bash" ${BASH_TEST_FILES}
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

	# Set the version, just in case
	add_dependencies(bash-test-lint bash-version)

	# Add the Bash test linting target as a dependency to the Bash linting target
	add_dependencies(bash-lint bash-test-lint)
endif()