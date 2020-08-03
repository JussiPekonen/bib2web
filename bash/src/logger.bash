#!/bin/bash

error() {
	local message="$*"
	echo "ERROR: ${message}" >&2
}