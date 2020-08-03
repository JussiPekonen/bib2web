set(BASH_SRC_FILES
	"${CMAKE_CURRENT_SOURCE_DIR}/bib2web.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/logger.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/error-codes.bash"
	"${CMAKE_CURRENT_SOURCE_DIR}/options-parser.bash"
	)

if(BIB2WEB_SHELLCHECK_EXISTS)
	# Add target for Bash linting
	add_custom_target(bash-lint
		DEPENDS "${BASH_SRC_FILES}"
		)
	add_custom_command(TARGET bash-lint
		COMMAND shellcheck ARGS "-x" ${BASH_SRC_FILES}
		WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
	add_dependencies(lint bash-lint)
endif()