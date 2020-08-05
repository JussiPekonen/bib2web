#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./error-codes.bash
source "${BIB2WEB_BASE_DIR}/error-codes.bash"

setupTools() {
	# grep
	BIB2WEB_GREP=$(which grep)
	local grepResult="$?"
	if [ "${grepResult}" -gt 0 ]; then
		echo "grep not found!" >&2
		return "${BIB2WEB_GREP_NOT_FOUND}"
	fi
	# awk
	BIB2WEB_AWK=$(which awk)
	local awkResult="$?"
	if [ "${awkResult}" -gt 0 ]; then
		echo "awk not found!" >&2
		return "${BIB2WEB_AWK_NOT_FOUND}"
	fi
}