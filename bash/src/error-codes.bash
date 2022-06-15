#!/bin/bash

# Error codes for tool setup
export BIB2WEB_BASENAME_NOT_FOUND="1"
export BIB2WEB_GREP_NOT_FOUND="2"
export BIB2WEB_AWK_NOT_FOUND="3"
export BIB2WEB_RM_NOT_FOUND="4"
export BIB2WEB_MKTEMP_NOT_FOUND="5"
export BIB2WEB_TOUCH_NOT_FOUND="6"
export BIB2WEB_CAT_NOT_FOUND="7"
export BIB2WEB_FIND_NOT_FOUND="8"

# Error codes for option parsing
export BIB2WEB_MISSING_BIBTEX_FILE="10"
export BIB2WEB_NOT_BIBTEX_FILE="11"

# Error codes for directory and file setup
export BIB2WEB_CANNOT_CREATE_TMP_DIRECTORY="20"
export BIB2WEB_CANNOT_CREATE_LOG_FILE="21"

# Error codes for input processing
export BIB2WEB_CANNOT_PROCESS_BIBTEX_FILE="30"
export BIB2WEB_CANNOT_FIND_ENTRIES="31"
export BIB2WEB_CANNOT_PARSE_ENTRY="32"
