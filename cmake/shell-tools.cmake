include("${PROJECT_SOURCE_DIR}/cmake/check-tools.cmake")

# Pre-check that shunit2 is available
checkTool(shunit2)

# Function to set up shell tests using shunit2
function(setupShellTests shell generator test_files)
	# Add target for running the tests, if possible
	if(BIB2WEB_shunit2_EXISTS)
		# Process the test files to be runnable
		set(processed_test_files "")
		foreach(file ${test_files})
			set(output_file "${CMAKE_CURRENT_BINARY_DIR}/runnable-${file}")
			add_custom_command(
				OUTPUT "${output_file}"
				COMMAND echo ARGS "\\#!/bin/${shell}" > "${output_file}"
				COMMAND echo ARGS "SOURCE_DIRECTORY=${CMAKE_CURRENT_SOURCE_DIR}/../src" >> "${output_file}"
				COMMAND echo ARGS "BIB2WEB_BASE_DIR=${CMAKE_CURRENT_SOURCE_DIR}/../src" >> "${output_file}"
				COMMAND echo ARGS "oneTimeSetUp\\(\\) {" >> "${output_file}"
				COMMAND echo ARGS "  echo \\\"\\\"" >> "${output_file}"
				COMMAND echo ARGS "  echo \\\"Running tests from ${file}...\\\"" >> "${output_file}"
				COMMAND echo ARGS "  echo \\\"\\\"" >> "${output_file}"
				COMMAND echo ARGS "}" >> "${output_file}"
				COMMAND grep ARGS "-v" "/bin/${shell}" "${CMAKE_CURRENT_SOURCE_DIR}/${file}" >> "${output_file}"
				COMMAND echo ARGS "source ${BIB2WEB_shunit2}" >> "${output_file}"
				DEPENDS "${file}"
			)
			list(APPEND processed_test_files "${output_file}")
		endforeach()
		# Generate the master test file to be run
		set(main_test_file "${CMAKE_CURRENT_BINARY_DIR}/test.${shell}")
		add_custom_command(
			OUTPUT "${main_test_file}"
			COMMAND ls ARGS "${CMAKE_CURRENT_BINARY_DIR}/runnable-*" > "${CMAKE_CURRENT_BINARY_DIR}/tests.tmp"
			COMMAND sed ARGS "'s#^#/bin/${shell} #g'" "${CMAKE_CURRENT_BINARY_DIR}/tests.tmp" > "${main_test_file}"
			DEPENDS "${test_files}" "${processed_test_files}"
			)
		# Add target for running the tests
		add_custom_target("${shell}-test" DEPENDS "${main_test_file}")
		add_custom_command(
			TARGET "${shell}-test"
			COMMAND "/bin/${shell}" ARGS "${main_test_file}"
			COMMAND rm ARGS "${CMAKE_CURRENT_BINARY_DIR}/runnable-*"
			)
		# Add the testing target as a dependency to the general testing target
		add_dependencies(test "${shell}-test")
	else()
		message("Skipping ${shell} shell tests...")
	endif()
endfunction()

# Pre-check that shellcheck is available
checkTool(shellcheck)

# Function to running shell linter using shellcheck
function(setupShellLinting target_name files)
	set(master_target "${ARGN}")
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
		if (NOT "${master_target}" STREQUAL "")
			add_dependencies("${master_target}-lint" "${target_name}-lint")
		endif()
	endif()
endfunction()
