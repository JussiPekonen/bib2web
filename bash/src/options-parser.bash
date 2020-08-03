#!/bin/bash

BIB2WEB_BIBTEX_FILE=""

# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"
# shellcheck source=./error-codes.bash
source "${BIB2WEB_BASE_DIR}/error-codes.bash"

# Function to parse the user's options
parseOptions() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
				*) BIB2WEB_BIBTEX_FILE="$1"; shift
		esac
	done
}

# Function to do some final sanity checking for the options the user gives
optionsSanityCheck() {
	if [ "${BIB2WEB_BIBTEX_FILE}" == "" ]; then
		error "You must specify the BibTeX file as an argument!"
		return "${BIB2WEB_MISSING_BIBTEX_FILE}"
	fi
	local fileType
	fileType=$(file "${BIB2WEB_BIBTEX_FILE}" | grep "BibTeX")
	if [ "${fileType}" == "" ]; then
		error "The given file is not a BibTeX file!"
		return "${BIB2WEB_NOT_BIBTEX_FILE}"
	fi
	return 0
}
