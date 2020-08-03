#!/bin/bash

# Shell tools used by the script
export BIB2WEB_GREP
BIB2WEB_GREP=$(which grep)
export BIB2WEB_AWK
BIB2WEB_AWK=$(which awk)

# Constant variables used by option parsing
export BIB2WEB_OUTPUT_FORMAT_HTML="html"
export BIB2WEB_OUTPUT_FORMAT_JSON="json"
export BIB2WEB_SUPPORTED_OUTPUT_FORMATS="${BIB2WEB_OUTPUT_FORMAT_HTML}, ${BIB2WEB_OUTPUT_FORMAT_JSON}"
export BIB2WEB_DEFAULT_OUTPUT_FORMAT="${BIB2WEB_OUTPUT_FORMAT_HTML}"

# Parameters set by the option parsing
export BIB2WEB_BIBTEX_FILE=""
export BIB2WEB_OUTPUT_FORMAT="${BIB2WEB_DEFAULT_OUTPUT_FORMAT}"
export BIB2WEB_VERBOSE=""
