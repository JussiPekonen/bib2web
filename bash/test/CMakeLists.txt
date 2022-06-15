# The individual test files
set(BASH_TEST_FILES
	preprocessor-tests.bash
	options-parser-tests.bash
	input-processor-tests.bash
)

# Set up test run
setupShellTests(bash "${CMAKE_CURRENT_SOURCE_DIR}/../tools/generate-test-master.bash" "${BASH_TEST_FILES}")

# Set up test code linting
setupShellLinting(bash-test bash-version "${BASH_TEST_FILES}")
