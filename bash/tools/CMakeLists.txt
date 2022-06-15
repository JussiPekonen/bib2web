# The individual tools files
set(BASH_TOOL_FILES
	generate-test-master.bash
)

# Set up test code linting
setupShellLinting(bash-tools "" "${BASH_TOOL_FILES}")
