#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"

# Function to print out the version of the script
printVersion() {
	local scriptName
	scriptName=$(basename "$0")
	printf "%s, version %s\n" "${scriptName}" "${BIB2WEB_VERSION}"
}

BIB2WEB_ERROR_MESSAGE=""
BIB2WEB_WARNING_MESSAGE=""

generateErrorMessage() {
	local message="$*"
	BIB2WEB_ERROR_MESSAGE="ERROR: ${message}"
}

printError() {
	generateErrorMessage "$@"
	echo "${BIB2WEB_ERROR_MESSAGE}" >&2
}

error() {
	printError "$@"
	echo "${BIB2WEB_ERROR_MESSAGE}" >> "${BIB2WEB_LOG_FILE}"
}

generateWarningMessage() {
	local message="$*"
	BIB2WEB_WARNING_MESSAGE="WARNING: ${message}"
}

printWarning() {
	generateWarningMessage "$@"
	echo "${BIB2WEB_WARNING_MESSAGE}" >&2
}

warning() {
	printWarning "$@"
	echo "${BIB2WEB_WARNING_MESSAGE}" >> "${BIB2WEB_LOG_FILE}"
}

verbose() {
	local message="$*"
	if [ "${BIB2WEB_VERBOSE}" ]; then
		echo "${message}" >&1
	fi
	echo "${message}" >> "${BIB2WEB_LOG_FILE}"
}