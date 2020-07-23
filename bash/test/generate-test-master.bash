#!/bin/bash

if [ "$#" -lt 2 ]; then
	echo "Incorrect amount of arguments. Exiting…"
	exit 1
fi

testFile="$1"
shift
shunit2File="$1"
shift
echo "#!/bin/bash" > "${testFile}"
for file in "$@"; do
	cat "${file}" >> "${testFile}"
	echo "" >> "${testFile}"
done
echo "source ${shunit2File}" >> "${testFile}"