#!/bin/bash

BIB2WEB_BASE_DIR=$(dirname "$0")

# shellcheck source=./preprocessor.bash
source "${BIB2WEB_BASE_DIR}/preprocessor.bash"
# shellcheck source=./options-parser.bash
source "${BIB2WEB_BASE_DIR}/options-parser.bash"
# shellcheck source=./input-processor.bash
source "${BIB2WEB_BASE_DIR}/input-processor.bash"

checkResultAndAbortIfNeeded() {
	local result="$1"
	if [ "${result}" -gt 0 ]; then
		echo "Aborting..." >&2
		if [ "${BIB2WEB_TMP_DIR}" ] && [ -e "${BIB2WEB_TMP_DIR}" ]; then
			cleanUp
		fi
		exit "${result}"
	fi
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

	# Process the input file
	processInputFile
	checkResultAndAbortIfNeeded "$?"

	# Clean up the temporary directory
	cleanUp
}

main "$@"
