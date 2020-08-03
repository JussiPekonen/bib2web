#!/bin/bash

error() {
	local message="$*"
	echo "ERROR: ${message}" >&2
}

warning() {
	local message="$*"
	echo "WARNING: ${message}" >&2
}