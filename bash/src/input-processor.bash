#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"

logOptions() {
	verbose "$(printVersion)"
	verbose "${BIB2WEB_LOG_SEPARATOR}"
	verbose "BibTeXFile: ${BIB2WEB_BIBTEX_FILE}"
	verbose "Output format: ${BIB2WEB_OUTPUT_FORMAT}"
	verbose "${BIB2WEB_LOG_SEPARATOR}"
}

parseInputFile() {
	"${BIB2WEB_CAT}" "${BIB2WEB_BIBTEX_FILE}"
}

generateEntrySplitterFile() {
	"${BIB2WEB_CAT}" <<EOF > "${BIB2WEB_TMP_DIR}/splitter.awk"
BEGIN {
	data = ""
	file = ""
}
/^@.*/ {
	if (length(data) > 0) {
		print data > file
		data = ""
	}
	split(\$0, entry, "{")
	split(entry[2], key, ",")
	file = "${BIB2WEB_TMP_DIR}/" key[1] ".bib"
}
{
	data = data \$0 "\n"
}
END {
	print data > file
}
EOF
}

splitEntries() {
	"${BIB2WEB_AWK}" -f "${BIB2WEB_TMP_DIR}/splitter.awk" "${BIB2WEB_BIBTEX_FILE}" 2> "${BIB2WEB_LOG_FILE}"
	return "$?"
}

processInputFile() {
	logOptions
	verbose "Splitting the input BibTeX file into individual entries..."
	generateEntrySplitterFile
	splitEntries
	local splitResult="$?"
	if [ "${splitResult}" -gt "0" ]; then
		error "Could not process the contents of ${BIB2WEB_BIBTEX_FILE}!"
		return "${BIB2WEB_CANNOT_PROCESS_BIBTEX_FILE}"
	fi
	verbose "Input processing completed!"
}