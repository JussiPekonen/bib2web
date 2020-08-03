#!/bin/bash

BIB2WEB_BASE_DIR=$(dirname "$0")

# shellcheck source=./options-parser.bash
source "${BIB2WEB_BASE_DIR}/options-parser.bash"

main() {
	parseOptions "$@"
	optionsSanityCheck
	local optionsSanityCheckResult="$?"
	if [ "${optionsSanityCheckResult}" -gt 0 ]; then
		echo "Aborting..." >&2
		exit "${optionsSanityCheckResult}"
	fi
}

main "$@"
