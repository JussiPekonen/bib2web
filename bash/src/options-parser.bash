#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"
# shellcheck source=./error-codes.bash
source "${BIB2WEB_BASE_DIR}/error-codes.bash"

# Function to parse the user's options
parseOptions() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
				-f|--format)
					shift
					BIB2WEB_OUTPUT_FORMAT=$(echo "$1" | "${BIB2WEB_AWK}" -f "${BIB2WEB_BASE_DIR}/awk/tolower.awk")
					shift
					;;
				*)
					if [ "${BIB2WEB_BIBTEX_FILE}" == "" ]; then
						BIB2WEB_BIBTEX_FILE="$1"
					fi
					shift
					;;
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
	fileType=$(file "${BIB2WEB_BIBTEX_FILE}" | "${BIB2WEB_GREP}" "BibTeX")
	if [ "${fileType}" == "" ]; then
		error "The given file is not a BibTeX file!"
		return "${BIB2WEB_NOT_BIBTEX_FILE}"
	fi
	case "${BIB2WEB_OUTPUT_FORMAT}" in
		"${BIB2WEB_OUTPUT_FORMAT_HTML}"|"${BIB2WEB_OUTPUT_FORMAT_JSON}")
			;;
		*)
			warning "Unsupported output format. Reverting to html."
			BIB2WEB_OUTPUT_FORMAT="${BIB2WEB_OUTPUT_FORMAT_HTML}"
			;;
	esac
	return 0
}
