#!/bin/bash

#shellcheck source=../src/preprocessor.bash
source "${SOURCE_DIRECTORY}/preprocessor.bash"
#shellcheck source=../src/input-processor.bash
source "${SOURCE_DIRECTORY}/input-processor.bash"

setUp() {
	setUpTools
	local toolsResult="$?"
	if [ "${toolsResult}" -gt 0 ]; then
		fail "Could not set up the tools!"
	fi
	setUpFiles
	local filesResult="$?"
	if [ "${filesResult}" -gt 0 ]; then
		fail "Could not set up the files!"
	fi
}

tearDown() {
	cleanUp
}

testSplittingInputFileWithOnlyOneEntryResultsInASingleFile() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/article/minimum.bib"
	processInputFile
	local numberOfSplitEntries
	numberOfSplitEntries=$(find "${BIB2WEB_TMP_DIR}" -name "*.bib" | wc -l | sed 's/ //g')
	assertEquals "1" "${numberOfSplitEntries}"
}

testSplittingInputFileWithOnlyMoreThanOneEntryResultsInMultipleFile() {
	BIB2WEB_BIBTEX_FILE="${SOURCE_DIRECTORY}/../../testdata/combined.bib"
	processInputFile
	local numberOfSplitEntries
	numberOfSplitEntries=$(find "${BIB2WEB_TMP_DIR}" -name "*.bib" | wc -l | sed 's/ //g')
	local expectedNumberOfEntries
	expectedNumberOfEntries=$(grep -c "^@" "${BIB2WEB_BIBTEX_FILE}")
	assertNotEquals "1" "${numberOfSplitEntries}"
	assertEquals "${expectedNumberOfEntries}" "${numberOfSplitEntries}"
}