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
	printf "%s, version %s: A tool for converting a BibTeX file to a format that can be released online\n\n" "${scriptName}" "${BIB2WEB_VERSION}"
	printf "Usage: %s [OPTIONS] file\n\n" "${scriptName}"
	printf "Arguments:\n"
	printf "  file\t\t\t\tThe BibTeX file to be used as the input.\n\n"
	printf "Options:\n"
	printf "  -h\t\t--help\t\tPrints this help text and exits.\n"
	printf "  --version\t\t\tPrints the version of the tool and exits.\n"
	printf "  -f format\t--format format\tSets the output format. Supported formats: %s.\n" "${BIB2WEB_SUPPORTED_OUTPUT_FORMATS}"
	printf "\t\t\t\tDefault: %s. Unsupported formats are reverted to the default.\n" "${BIB2WEB_DEFAULT_OUTPUT_FORMAT}"
	printf "  -l logfile\t--log logfile\tSets the log file. Default: %s.\n" "${BIB2WEB_DEFAULT_LOG_FILE}"
	printf "  -v\t\t--verbose\tVerbose mode. Prints details of the tool run to standard output.\n"
	printf "  -vv\t\t--vverbose\tHigher verbose mode. Script internal variable values are printed out.\n"
	printf "  -vvv\t\t--vvverbose\tHigheest verbose mode. Results from the various subprocessed are printed out.\n"
}

# Function to parse the user's options
parseOptions() {
	while [ "$#" -gt 0 ]; do
		case "$1" in
				-f|--format)
					shift
					BIB2WEB_OUTPUT_FORMAT=$(echo "$1" | "${BIB2WEB_AWK}" "{ print tolower(\$0) }")
					shift
					;;
				-h|--help)
					printHelp
					exit 0
					;;
				-l|--log)
					shift
					BIB2WEB_LOG_FILE="$1"
					shift
					;;
				-v|--verbose)
					BIB2WEB_VERBOSE="1"
					shift
					;;
				-vv|--vverbose)
					BIB2WEB_VERBOSE="2"
					shift
					;;
				-vvv|--vvverbose)
					BIB2WEB_VERBOSE="3"
					shift
					;;
				--version)
					printVersion
					exit 0
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
		printError "You must specify the BibTeX file as an argument!"
		return "${BIB2WEB_MISSING_BIBTEX_FILE}"
	fi
	local fileType
	fileType=$(file "${BIB2WEB_BIBTEX_FILE}" | "${BIB2WEB_GREP}" "BibTeX")
	if [ "${fileType}" == "" ]; then
		printError "The given file (${BIB2WEB_BIBTEX_FILE}) is not a BibTeX file!"
		return "${BIB2WEB_NOT_BIBTEX_FILE}"
	fi
	case "${BIB2WEB_OUTPUT_FORMAT}" in
		"${BIB2WEB_OUTPUT_FORMAT_HTML}"|"${BIB2WEB_OUTPUT_FORMAT_JSON}")
			;;
		*)
			printWarning "Unsupported output format. Reverting to ${BIB2WEB_DEFAULT_OUTPUT_FORMAT}."
			BIB2WEB_OUTPUT_FORMAT="${BIB2WEB_DEFAULT_OUTPUT_FORMAT}"
			;;
	esac
	return 0
}
