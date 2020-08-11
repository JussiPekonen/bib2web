#!/bin/bash

# shellcheck source=./parameters.bash
source "${BIB2WEB_BASE_DIR}/parameters.bash"
# shellcheck source=./logger.bash
source "${BIB2WEB_BASE_DIR}/logger.bash"

generateEntrySplitterFile() {
	local splitterFile="$1"
	"${BIB2WEB_CAT}" <<EOF > "${splitterFile}"
BEGIN {
	data = ""
	file = ""
}
/^@/ {
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
	output=$("${BIB2WEB_AWK}" -f "${splitterFile}" "${BIB2WEB_BIBTEX_FILE}" 2>&1)
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
	local splitterFile="${BIB2WEB_TMP_DIR}/splitter.awk"
	generateEntrySplitterFile "${splitterFile}"
	splitEntries "${splitterFile}"
	local splitResult="$?"
	if [ "${splitResult}" -gt "0" ]; then
		error "Could not process the contents of ${BIB2WEB_BIBTEX_FILE}!"
		return "${BIB2WEB_CANNOT_PROCESS_BIBTEX_FILE}"
	fi
}

parseField() {
	local field="$1"
	local entry="$2"
	local parserFile="${BIB2WEB_TMP_DIR}/${field}-input.awk"
	if [ ! -e "${parserFile}" ]; then
		cat <<EOF > "${parserFile}"
BEGIN {
	FS = " = "
}
tolower(\$1) ~ /${field}$/ {
	data = \$2
	# Strip the trailing comma, if exists
	sub(/,$/, "", data)
	# Quoted data
	sub(/^"/, "", data)
	sub(/"$/, "", data)
	# Data in curly braces
	sub(/^{/, "", data)
	sub(/}$/, "", data)
	# Internal curly braces
	gsub(/{/, "", data)
	gsub(/}/, "", data)
	# Replace tildes with a space
	gsub(/~/, " ", data)
	# Remove the special characters' leading slash
	gsub(/\\\\/, "", data)
	print data
}
EOF
	fi
	local fieldContent
	fieldContent=$("${BIB2WEB_AWK}" -f "${parserFile}" "${entry}" 2>&1)
	local fieldParsingResult
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		error "Cannot parse field ${field}!"
		error "Reason: ${fieldContent}"
		return "${BIB2WEB_CANNOT_PARSE_ENTRY}"
	fi
	vvverbose "${field}: ${fieldContent}"
	echo "${field}: ${fieldContent}" > "${entry}.${field}"
	return "0"
}

parseEntry() {
	local entry="$1"
	local entryName
	entryName=$("${BIB2WEB_BASENAME}" "${entry}" | "${BIB2WEB_AWK}" "{sub(/.bib/, \"\", \$0); print \$0}")
	vverbose "Parsing entry ${entryName}..."
	local fieldParsingResult
	# Parse the entry type
	local type
	type=$("${BIB2WEB_AWK}" "BEGIN { FS = \"{\"} \$1 ~ /^@/ { print tolower(\$1)}" "${entry}")
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		error "Cannot parse entry type!"
		error "Reason: ${type}"
		return "${fieldParsingResult}"
	fi
	vverbose "type: ${type}"
	echo "type: ${type}" > "${entry}.type"
	# Parse the default fields
	parseField "address" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "annote" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "author" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "booktitle" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "chapter" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "crossref" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "doi" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "edition" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "editor" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "email" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "howpublished" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "institution" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "journal" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "key" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "month" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "note" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "number" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "organization" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "pages" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "publisher" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "school" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "series" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "title" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "type" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "volume" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	parseField "year" "${entry}"
	fieldParsingResult="$?"
	if [ "${fieldParsingResult}" -gt "0" ]; then
		return "${fieldParsingResult}"
	fi
	return "0"
}

getEntries() {
	"${BIB2WEB_FIND}" "${BIB2WEB_TMP_DIR}" -name "*.bib"
}

parseEntries() {
	for entry in $(getEntries); do
		parseEntry "${entry}"
		local entryParsingResult="$?"
		if [ "${entryParsingResult}" -gt "0" ]; then
			error "Error when parsing an entry!"
			return "${entryParsingResult}"
			break
		fi
	done
	return "0"
}

processEntries() {
	verbose "Processing the entries..."
	# Do a sanity check that the entries can be read
	local entries
	entries=$(getEntries)
	local entryFindResult="$?"
	if [ "${entryFindResult}" -gt "0" ]; then
		error "Could not fetch the entries!"
		return "${BIB2WEB_CANNOT_FIND_ENTRIES}"
	fi
	local entryCount
	entryCount=$(echo "${entries}" | grep -c ".bib")
	vverbose "Number of entries: ${entryCount}"
	parseEntries
	verbose "Input processing completed!"
	verbose "${BIB2WEB_LOG_SEPARATOR}"
	return "0"
}