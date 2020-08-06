#!/bin/bash

#shellcheck source=../src/preprocessor.bash
source "${SOURCE_DIRECTORY}/preprocessor.bash"
#shellcheck source=../src/options-parser.bash
source "${SOURCE_DIRECTORY}/options-parser.bash"

setUp() {
	setUpTools
	local result="$?"
	if [ "${result}" -gt 0 ]; then
		fail "Could not set up the tools!"
	fi
}

testParseOptionsNoParametersGiven() {
	parseOptions
	assertEquals "" "${BIB2WEB_BIBTEX_FILE}"
	assertEquals "html" "${BIB2WEB_OUTPUT_FORMAT}"
}

testParseOptionsBibTeXFileGiven() {
	local bibTeXFile="foo.bib"
	parseOptions "${bibTeXFile}"
	assertEquals "${bibTeXFile}" "${BIB2WEB_BIBTEX_FILE}"
}

testParseOptionsOnlyFirstFileIsChosen() {
	local bibTeXFile="foo.bib"
	parseOptions "${bibTeXFile}" "--bar" "bork"
	assertEquals "${bibTeXFile}" "${BIB2WEB_BIBTEX_FILE}"
}

testParseOptionsFormatWithShortNotation() {
	local testFormat="foo"
	parseOptions "-f" "${testFormat}"
	assertEquals "${testFormat}" "${BIB2WEB_OUTPUT_FORMAT}"
}

testParseOptionsFormatWithLongNotation() {
	local testFormat="foo"
	parseOptions "--format" "${testFormat}"
	assertEquals "${testFormat}" "${BIB2WEB_OUTPUT_FORMAT}"
}

testParseOptionsLogFileWithShortNotation() {
	local testFile="foo"
	parseOptions "-l" "${testFile}"
	assertEquals "${testFile}" "${BIB2WEB_LOG_FILE}"
}

testParseOptionsLogFileWithLongNotation() {
	local testFile="foo"
	parseOptions "--log" "${testFile}"
	assertEquals "${testFile}" "${BIB2WEB_LOG_FILE}"
}

testOptionsSanityCheckBibTeXFileNotSet() {
	BIB2WEB_BIBTEX_FILE=""
	optionsSanityCheck 2> /dev/null
	assertEquals "$?" "${BIB2WEB_MISSING_BIBTEX_FILE}"
}

testOptionsSanityCheckBibTeXFileNotBibTeXFile() {
	BIB2WEB_BIBTEX_FILE="$0"
	optionsSanityCheck 2> /dev/null
	assertEquals "$?" "${BIB2WEB_NOT_BIBTEX_FILE}"
}

testOptionsSanityCheckBibTeXFileSetFormatHtml() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	BIB2WEB_OUTPUT_FORMAT="${BIB2WEB_OUTPUT_FORMAT_HTML}"
	optionsSanityCheck
	assertEquals "$?" "0"
	assertEquals "${BIB2WEB_OUTPUT_FORMAT_HTML}" "${BIB2WEB_OUTPUT_FORMAT}"
}

testOptionsSanityCheckBibTeXFileSetFormatJson() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	BIB2WEB_OUTPUT_FORMAT="${BIB2WEB_OUTPUT_FORMAT_JSON}"
	optionsSanityCheck
	assertEquals "$?" "0"
	assertEquals "${BIB2WEB_OUTPUT_FORMAT_JSON}" "${BIB2WEB_OUTPUT_FORMAT}"
}

testOptionsSanityCheckBibTeXFileSetUnsupportedFormatRevertsToHtml() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	BIB2WEB_OUTPUT_FORMAT="foo"
	optionsSanityCheck 2> /dev/null
	assertEquals "$?" "0"
	assertEquals "${BIB2WEB_OUTPUT_FORMAT_HTML}" "${BIB2WEB_OUTPUT_FORMAT}"
}