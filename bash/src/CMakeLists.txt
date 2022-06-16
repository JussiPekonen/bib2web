# The individual source files
set(BASH_SRC_FILES
	bib2web.bash
	parameters.bash.in
	logger.bash
	error-codes.bash
	preprocessor.bash
	options-parser.bash
	input-processor.bash
	)

# Set the Bash tool version
add_custom_target(bash-version
	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash.in")
# FIXME: Set the version based on the repository tags
add_custom_command(TARGET bash-version
	COMMAND sed ARGS 's/%BIB2WEB_VERSION%/0.0/' "${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash.in" > "${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash")

# Set up test code linting
setupShellLinting(bash "${BASH_SRC_FILES}")
# Add bash-version as a dependency, otherwise the linter will fail
add_dependencies(bash-lint bash-version)
