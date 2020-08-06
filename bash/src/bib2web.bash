#!/bin/bash

BIB2WEB_BASE_DIR=$(dirname "$0")

# shellcheck source=./preprocessor.bash
source "${BIB2WEB_BASE_DIR}/preprocessor.bash"
# shellcheck source=./options-parser.bash
source "${BIB2WEB_BASE_DIR}/options-parser.bash"

checkResultAndAbortIfNeeded() {
	local result="$1"
	if [ "${result}" -gt 0 ]; then
		echo "Aborting..." >&2
		exit "${result}"
	fi
}

printDetails() {
	verbose "$(printVersion)"
	verbose "${BIB2WEB_LOG_SEPARATOR}"
	verbose "BibTeXFile: ${BIB2WEB_BIBTEX_FILE}"
	verbose "Output format: ${BIB2WEB_OUTPUT_FORMAT}"
	verbose "${BIB2WEB_LOG_SEPARATOR}"
}

main() {
	# Set up tools
	setUpTools
	checkResultAndAbortIfNeeded "$?"

	# Parse user's options
	parseOptions "$@"
	optionsSanityCheck
	checkResultAndAbortIfNeeded "$?"

	# Set up temporary directory and relevant files
	setUpFiles
	checkResultAndAbortIfNeeded "$?"

	printDetails

	# Clean up the temporary directory
	cleanUp
}

main "$@"
