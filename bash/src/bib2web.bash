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

main() {
	# Set up tools
	setupTools
	checkResultAndAbortIfNeeded "$?"

	# Parse user's options
	parseOptions "$@"
	optionsSanityCheck
	checkResultAndAbortIfNeeded "$?"
}

main "$@"
