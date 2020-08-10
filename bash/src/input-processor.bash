#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"

parseInputFile() {
	"${BIB2WEB_CAT}" "${BIB2WEB_BIBTEX_FILE}"
}

generateEntrySplitterFile() {
	local splitterFile="$1"
	"${BIB2WEB_CAT}" <<EOF > "${BIB2WEB_TMP_DIR}/${splitterFile}"
BEGIN {
	data = ""
	file = ""
}
/^@.*/ {
	if (length(data) > 0) {
		print data > file
		data = ""
	}
	key = \$0
	sub(/.*{/, "", key)
	sub(/,$/, "", key)
	file = "${BIB2WEB_TMP_DIR}/" key ".bib"
}
{
	data = data \$0 "\n"
}
END {
	print data > file
}
EOF
	vvverbose "Splitter file created!"
}

splitEntries() {
	local splitterFile="$1"
	local output=
	output=$("${BIB2WEB_AWK}" -f "${BIB2WEB_TMP_DIR}/${splitterFile}" "${BIB2WEB_BIBTEX_FILE}" 2>&1)
	local result="$?"
	vvverbose "Splitter result: ${result}"
	if [ "${result}" -gt "0" ]; then
		vvverbose "Splitter error:"
		vvverbose "${output}"
	fi
	return "${result}"
}

processInputFile() {
	verbose "Processing the input file..."
	vverbose "Splitting the input BibTeX file into individual entries..."
	local splitterFile="splitter.awk"
	generateEntrySplitterFile "${splitterFile}"
	splitEntries "${splitterFile}"
	local splitResult="$?"
	if [ "${splitResult}" -gt "0" ]; then
		error "Could not process the contents of ${BIB2WEB_BIBTEX_FILE}!"
		return "${BIB2WEB_CANNOT_PROCESS_BIBTEX_FILE}"
	fi
	vverbose "Input processing completed!"
	verbose "${BIB2WEB_LOG_SEPARATOR}"
}