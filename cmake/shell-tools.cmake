include("${PROJECT_SOURCE_DIR}/cmake/check-tools.cmake")

# Pre-check that shunit2 is available
checkTool(shunit2)

# Function to set up shell tests using shunit2
function(setupShellTests shell generator test_files)
	# Add target for running the tests, if possible
	if(BIB2WEB_shunit2_EXISTS)
		# Generate the master test file to be run
		set("${shell}_TEST_MASTER_FILE" "${CMAKE_CURRENT_BINARY_DIR}/.${shell}-test.sh")
		add_custom_command(
			OUTPUT "${${shell}_TEST_MASTER_FILE}"
			COMMAND "/bin/${shell}" ARGS "${generator}" "${CMAKE_CURRENT_SOURCE_DIR}/../src" "${CMAKE_CURRENT_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}" "${BIB2WEB_shunit2}" "${${shell}_TEST_MASTER_FILE}" ${test_files}
			DEPENDS "${generator}" "${test_files}")
		# Custom target for running the test
		add_custom_target("${shell}-test"
			DEPENDS "${${shell}_TEST_MASTER_FILE}")
		add_custom_command(
			TARGET "${shell}-test"
			COMMAND "/bin/${shell}" ARGS "${${shell}_TEST_MASTER_FILE}")
		# Add the testing target as a dependency to the general testing target
		add_dependencies(test "${shell}-test")
	else()
		message("Skipping ${shell} shell tests...")
	endif()
endfunction()

# Pre-check that shellcheck is available
checkTool(shellcheck)

# Function to running shell linter using shellcheck
function(setupShellLinting target_name dependency files)
	# Add target for running shellcheck, if possible
	if (BIB2WEB_shellcheck_EXISTS)
		add_custom_target("${target_name}-lint"
			DEPENDS "${files}"
			)
		add_custom_command(TARGET "${target_name}-lint"
			COMMAND "${BIB2WEB_shellcheck}" ARGS "-x" ${files}
			WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
		# Add the shell linting target as a dependency to the general linting target
		add_dependencies(lint "${target_name}-lint")
		# Add the dependency to this newly created target
		if (NOT "${dependency}" STREQUAL "")
			add_dependencies("${target_name}-lint" "${dependency}")
		endif()
	endif()
endfunction()