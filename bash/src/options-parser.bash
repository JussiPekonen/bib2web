#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"
# shellcheck source=./error-codes.bash
source "${BIB2WEB_BASE_DIR}/error-codes.bash"

# Function to print out the help of the script
printHelp() {
	local scriptName
	scriptName=$(basename "$0")
	printf "%s: Tool for converting a BibTeX file to a format that can be released online\n\n" "${scriptName}"
	printf "Usage: %s [-h|--help] [-f|--format format] [-v|--verbose] file\n\n" "${scriptName}"
	printf "Options:\n"
	printf "  -h\t\t--help\t\tPrints this help text and exits.\n"
	printf "  -f format\t--format format\tSets the output format. Supported formats: %s.\n" "${BIB2WEB_SUPPORTED_OUTPUT_FORMATS}"
	printf "\t\t\t\tDefault: %s. Unsupported formats are reverted to the default.\n" "${BIB2WEB_DEFAULT_OUTPUT_FORMAT}"
	printf "  -v\t\t--verbose\tVerbose mode. Prints details of the script run to standard output.\n"
	printf "  file\t\t\t\tThe BibTeX file to be used as the input.\n"
	exit 0
}

# Function to parse the user's options
parseOptions() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
				-f|--format)
					shift
					BIB2WEB_OUTPUT_FORMAT=$(echo "$1" | "${BIB2WEB_AWK}" -f "${BIB2WEB_BASE_DIR}/awk/tolower.awk")
					shift
					;;
				-h|--help)
					printHelp
					;;
				-v|--verbose)
					BIB2WEB_VERBOSE="true"
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
			warning "Unsupported output format. Reverting to ${BIB2WEB_DEFAULT_OUTPUT_FORMAT}."
			BIB2WEB_OUTPUT_FORMAT="${BIB2WEB_DEFAULT_OUTPUT_FORMAT}"
			;;
	esac
	verbose "BibTeXFile: ${BIB2WEB_BIBTEX_FILE}"
	verbose "Output format: ${BIB2WEB_OUTPUT_FORMAT}"
	return 0
}
