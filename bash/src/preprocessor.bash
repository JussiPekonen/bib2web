#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"
# shellcheck source=./error-codes.bash
source "${BIB2WEB_BASE_DIR}/error-codes.bash"

# Set up tools
setUpTools() {
	# grep
	BIB2WEB_GREP=$(which grep)
	local grepResult="$?"
	if [ "${grepResult}" -gt 0 ]; then
		printError "grep not found!"
		return "${BIB2WEB_GREP_NOT_FOUND}"
	fi
	# awk
	BIB2WEB_AWK=$(which awk)
	local awkResult="$?"
	if [ "${awkResult}" -gt 0 ]; then
		printError "awk not found!"
		return "${BIB2WEB_AWK_NOT_FOUND}"
	fi
	# mktemp
	BIB2WEB_MKTEMP=$(which mktemp)
	local mktempResult="$?"
	if [ "${mktempResult}" -gt 0 ]; then
		printError "mktemp not found!"
		return "${BIB2WEB_MKTEMP_NOT_FOUND}"
	fi
	# rm
	BIB2WEB_RM=$(which rm)
	local rmResult="$?"
	if [ "${rmResult}" -gt 0 ]; then
		printError "rm not found!"
		return "${BIB2WEB_RM_NOT_FOUND}"
	fi
	# touch
	BIB2WEB_TOUCH=$(which touch)
	local touchResult="$?"
	if [ "${touchResult}" -gt 0 ]; then
		printError "touch not found!"
		return "${BIB2WEB_TOUCH_NOT_FOUND}"
	fi
	return 0
}

# Set up temporary files
setUpFiles() {
	BIB2WEB_TMP_DIR=$("${BIB2WEB_MKTEMP}" -d -t bib2web-XXXXXX)
	local mktempResult="$?"
	if [ "${mktempResult}" -gt 0 ]; then
		printError "Could not create the temporary directory!"
		return "${BIB2WEB_CANNOT_CREATE_TMP_DIRECTORY}"
	fi
	if [ -e "${BIB2WEB_LOG_FILE}" ]; then
		"${BIB2WEB_RM}" "${BIB2WEB_LOG_FILE}"
	fi
	"${BIB2WEB_TOUCH}" "${BIB2WEB_LOG_FILE}" 2> /dev/null
	local touchResult="$?"
	if [ "${touchResult}" -gt 0 ]; then
		printError "Could not create the log file!"
		return "${BIB2WEB_CANNOT_CREATE_LOG_FILE}"
	fi
	return 0
}

# Clean-up
cleanUp() {
	"${BIB2WEB_RM}" -rf "${BIB2WEB_TMP_DIR}"
}
