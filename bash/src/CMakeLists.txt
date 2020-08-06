# The individual source files
set(BASH_SRC_FILES
	"${CMAKE_CURRENT_SOURCE_DIR}/bib2web.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash.in"
	"${CMAKE_CURRENT_SOURCE_DIR}/logger.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/error-codes.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/preprocessor.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/options-parser.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/input-processor.bash"
	)

# Set the Bash tool version
add_custom_target(bash-version
	DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash.in")
# FIXME: Set the version based on the repository tags
add_custom_command(TARGET bash-version
	COMMAND sed ARGS 's/%BIB2WEB_VERSION%/0.0/' "${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash.in" > "${CMAKE_CURRENT_SOURCE_DIR}/parameters.bash")

# Add target for Bash linting, if possible
if(BIB2WEB_SHELLCHECK_EXISTS)
	add_custom_target(bash-lint
		DEPENDS "${BASH_SRC_FILES}"
		)
	add_custom_command(TARGET bash-lint
		COMMAND shellcheck ARGS "-x" ${BASH_SRC_FILES}
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")

	# Set the version, just in case
	add_dependencies(bash-lint bash-version)

	# Add the Bash linting target as a dependency to the general linting target
	add_dependencies(lint bash-lint)
endif()