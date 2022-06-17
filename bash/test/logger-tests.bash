#!/bin/bash

#shellcheck source=../src/preprocessor.bash
source "${SOURCE_DIRECTORY}/preprocessor.bash"
#shellcheck source=../src/logger.bash
source "${SOURCE_DIRECTORY}/logger.bash"

setUp() {
  # Clear the slate
  BIB2WEB_ERROR_MESSAGE=""
  BIB2WEB_WARNING_MESSAGE=""

  setUpTools
  setUpFiles
}

tearDown() {
  BIB2WEB_VERBOSE="1"
  cleanUp
  if [ -e "${BIB2WEB_LOG_FILE}" ]; then
    rm -f "${BIB2WEB_LOG_FILE}"
  fi
}

testErrorGeneration() {
  # Empty state
  assertEquals "" "${BIB2WEB_ERROR_MESSAGE}"

  local error="foo"
  generateErrorMessage "${error}"
  assertNotEquals "" "${BIB2WEB_ERROR_MESSAGE}"
  assertEquals "ERROR: ${error}" "${BIB2WEB_ERROR_MESSAGE}"
}

testError() {
  local error="foo"
  local output
  output=$(error "${error}" 2>&1)
  assertNotEquals "" "${output}"
  assertEquals "ERROR: ${error}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testErrorWithNoLogging() {
  BIB2WEB_VERBOSE="0"

  local error="foo"
  local output
  output=$(error "${error}" 2>&1)
  assertNotEquals "" "${output}"
  assertEquals "ERROR: ${error}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertNotEquals "${output}" "${lastLogEntry}"
}

testWarningGeneration() {
  # Empty state
  assertEquals "" "${BIB2WEB_WARNING_MESSAGE}"

  local warning="foo"
  generateWarningMessage "${warning}"
  assertNotEquals "" "${BIB2WEB_WARNING_MESSAGE}"
  assertEquals "WARNING: ${warning}" "${BIB2WEB_WARNING_MESSAGE}"
}

testWarning() {
  local warning="foo"
  local output
  output=$(warning "${warning}" 2>&1)
  assertNotEquals "" "${output}"
  assertEquals "WARNING: ${warning}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testWarningWithNoLogging() {
  BIB2WEB_VERBOSE="0"

  local warning="foo"
  local output
  output=$(warning "${warning}" 2>&1)
  assertNotEquals "" "${output}"
  assertEquals "WARNING: ${warning}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertNotEquals "${output}" "${lastLogEntry}"
}

testVerboseWithNoLogging() {
  BIB2WEB_VERBOSE="0"

  local message="foo"
  local output
  output=$(verbose "${message}")
  assertEquals "" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testVerboseWithDefaultVerbosity() {
  BIB2WEB_VERBOSE="1"

  local message="foo"
  local output
  output=$(verbose "${message}")
  assertEquals "" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${message}" "${lastLogEntry}"
}

testVerboseWithVerbose() {
  BIB2WEB_VERBOSE="2"

  local message="foo"
  local output
  output=$(verbose "${message}")
  assertNotEquals "" "${output}"
  assertEquals "${message}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testVeryVerboseWithVerbose() {
  BIB2WEB_VERBOSE="2"

  local message="foo"
  local output
  output=$(vverbose "${message}")
  assertEquals "" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testVeryVerboseWithVverbose() {
  BIB2WEB_VERBOSE="3"

  local message="foo"
  local output
  output=$(vverbose "${message}")
  assertEquals "* ${message}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testVeryVeryVerboseWithVverbose() {
  BIB2WEB_VERBOSE="3"

  local message="foo"
  local output
  output=$(vvverbose "${message}")
  assertEquals "" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}

testVeryVeryVerboseWithVvverbose() {
  BIB2WEB_VERBOSE="4"

  local message="foo"
  local output
  output=$(vvverbose "${message}")
  assertEquals "- ${message}" "${output}"
  assertTrue "[ -e '${BIB2WEB_LOG_FILE}' ]"
  local lastLogEntry
  lastLogEntry=$(tail -1 "${BIB2WEB_LOG_FILE}")
  assertEquals "${output}" "${lastLogEntry}"
}
