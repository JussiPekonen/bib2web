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
	BIB2WEB_VERBOSE="0"
}

testParseOptionsNoParametersGiven() {
	parseOptions
	assertEquals "" "${BIB2WEB_BIBTEX_FILE}"
	assertEquals "${BIB2WEB_DEFAULT_OUTPUT_FORMAT}" "${BIB2WEB_OUTPUT_FORMAT}"
	assertEquals "" "${BIB2WEB_OUTPUT_FILE}"
	assertEquals "${BIB2WEB_DEFAULT_LOG_FILE}" "${BIB2WEB_LOG_FILE}"
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

testParseOptionsOutputWithShortNotation() {
	local testFile="foo"
	parseOptions "-o" "${testFile}"
	assertEquals "${testFile}" "${BIB2WEB_OUTPUT_FILE}"
}

testParseOptionsOutputWithLongNotation() {
	local testFile="foo"
	parseOptions "--output" "${testFile}"
	assertEquals "${testFile}" "${BIB2WEB_OUTPUT_FILE}"
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

testParseOptionsVerboseWithShortNotation() {
	parseOptions "-v"
	assertEquals "1" "${BIB2WEB_VERBOSE}"
}

testParseOptionsVerboseWithLongNotation() {
	parseOptions "--verbose"
	assertEquals "1" "${BIB2WEB_VERBOSE}"
}

testParseOptionsVeryVerboseShortNotation() {
	parseOptions "-vv"
	assertEquals "2" "${BIB2WEB_VERBOSE}"
}

testParseOptionsVeryVerboseLongNotation() {
	parseOptions "--vverbose"
	assertEquals "2" "${BIB2WEB_VERBOSE}"
}

testParseOptionsVeryVeryVerboseShortNotation() {
	parseOptions "-vvv"
	assertEquals "3" "${BIB2WEB_VERBOSE}"
}

testParseOptionsVeryVeryVerboseLongNotation() {
	parseOptions "--vvverbose"
	assertEquals "3" "${BIB2WEB_VERBOSE}"
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

testOptionsSanityCheckNoOutputFileIsGiven() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	BIB2WEB_OUTPUT_FILE=""
	optionsSanityCheck
	assertEquals "$?" "0"
	assertEquals "${BIB2WEB_OUTPUT_FILE_DEFAULT_PREFIX}.${BIB2WEB_OUTPUT_FORMAT}" "${BIB2WEB_OUTPUT_FILE}"
}

testOptionsSanityCheckNoOutputFileGivenDoesNotChange() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	local testFile="foo"
	BIB2WEB_OUTPUT_FILE="${testFile}"
	optionsSanityCheck
	assertEquals "$?" "0"
	assertEquals "${testFile}" "${BIB2WEB_OUTPUT_FILE}"
}