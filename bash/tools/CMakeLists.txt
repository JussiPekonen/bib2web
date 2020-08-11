# The individual tools files
set(BASH_TOOL_FILES
	generate-test-master.bash
)

# Add the target for linting the tools files, if possible
if(BIB2WEB_SHELLCHECK_EXISTS)
	add_custom_target(bash-tools-lint)
	add_custom_command(
		TARGET bash-tools-lint
		COMMAND shellcheck ARGS "-x" ${BASH_TOOL_FILES}
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

	# Add the Bash test linting target as a dependency to the Bash linting target
	add_dependencies(bash-lint bash-tools-lint)
endif()