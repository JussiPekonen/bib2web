#!/bin/bash

#shellcheck source=../src/preprocessor.bash
source "${SOURCE_DIRECTORY}/preprocessor.bash"

setUp() {
	setUpTools
}

tearDown() {
	# Call the clean up again, just in case
	cleanUp
	if [ -e "${BIB2WEB_LOG_FILE}" ]; then
		rm -f "${BIB2WEB_LOG_FILE}"
	fi
}

testToolsSetupSuccess() {
	assertNotNull "${BIB2WEB_BASENAME}"
	assertNotNull "${BIB2WEB_GREP}"
	assertNotNull "${BIB2WEB_AWK}"
	assertNotNull "${BIB2WEB_MKTEMP}"
	assertNotNull "${BIB2WEB_RM}"
	assertNotNull "${BIB2WEB_TOUCH}"
	assertNotNull "${BIB2WEB_CAT}"
	assertNotNull "${BIB2WEB_FIND}"
}

testSetUpFilesAndCleanUp() {
	BIB2WEB_LOG_FILE="foo.log"

	setUpFiles

	assertNotNull "${BIB2WEB_TMP_DIR}"
	assertTrue "[ -e '${BIB2WEB_TMP_DIR}' ]"
	assertTrue "[ -d '${BIB2WEB_TMP_DIR}' ]"
	assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"

	cleanUp
	assertFalse "[ -e '${BIB2WEB_TMP_DIR}' ]"
}