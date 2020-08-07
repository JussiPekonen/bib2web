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