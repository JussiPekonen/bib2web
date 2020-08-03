#!/bin/bash

if [ "$#" -lt 3 ]; then
	echo "Incorrect amount of arguments. Exiting…"
	exit 1
fi

testFile="$1"
shift
shunit2File="$1"
shift
sourceDir="$1"
shift
echo "#!/bin/bash" > "${testFile}"
printf "\nSOURCE_DIRECTORY=\"%s\"\n" "${sourceDir}" >> "${testFile}"
printf "BIB2WEB_BASE_DIR=\"%s\"\n\n" "${sourceDir}" >> "${testFile}"
for file in "$@"; do
	grep -v "#!/bin/bash" "${file}" >> "${testFile}"
	echo "" >> "${testFile}"
done
echo "source ${shunit2File}" >> "${testFile}"