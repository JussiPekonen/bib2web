#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"

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