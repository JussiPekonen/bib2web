#!/bin/bash

# Error codes for tool setup
export BIB2WEB_GREP_NOT_FOUND="1"
export BIB2WEB_AWK_NOT_FOUND="2"
export BIB2WEB_RM_NOT_FOUND="3"
export BIB2WEB_MKTEMP_NOT_FOUND="4"
export BIB2WEB_TOUCH_NOT_FOUND="6"
export BIB2WEB_CAT_NOT_FOUND="7"

# Error codes for option parsing
export BIB2WEB_MISSING_BIBTEX_FILE="7"
export BIB2WEB_NOT_BIBTEX_FILE="8"

# Error codes for directory and file setup
export BIB2WEB_CANNOT_CREATE_TMP_DIRECTORY="9"
export BIB2WEB_CANNOT_CREATE_LOG_FILE="10"

# Error codes for input processing
export BIB2WEB_CANNOT_READ_BIBTEX_FILE="11"
