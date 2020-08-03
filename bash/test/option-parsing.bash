#!/bin/bash

#shellcheck source=../src/options-parser.bash
source "${SOURCE_DIRECTORY}/options-parser.bash"

testParseOptionsNoParametersGivenEmptyBibTeXFile() {
	parseOptions
	assertEquals "" "${BIB2WEB_BIBTEX_FILE}"
}

testParseOptionsBibTeXFileGiven() {
	local bibTeXFile="foo.bib"
	parseOptions "${bibTeXFile}"
	assertEquals "${bibTeXFile}" "${BIB2WEB_BIBTEX_FILE}"
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

testOptionsSanityCheckBibTeXFileSet() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	optionsSanityCheck
	assertEquals "$?" "0"
}