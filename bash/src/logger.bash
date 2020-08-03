#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"

error() {
	local message="$*"
	echo "ERROR: ${message}" >&2
}

warning() {
	local message="$*"
	echo "WARNING: ${message}" >&2
}

verbose() {
	local message="$*"
	if [ "${BIB2WEB_VERBOSE}" ]; then
		echo "${message}"
	fi
}