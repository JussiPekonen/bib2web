#!/bin/bash

#shellcheck source=../src/options-parser.bash
source "${SOURCE_DIRECTORY}/options-parser.bash"

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