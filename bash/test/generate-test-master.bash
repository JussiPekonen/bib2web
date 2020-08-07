#!/bin/bash

if [ "$#" -lt 5 ]; then
	echo "Incorrect amount of arguments. Exiting…"
	exit 1
fi

sourceDir="$1"
shift
testDir="$1"
shift
outDir="$1"
shift
shunit2File="$1"
shift
testFile="$1"
shift
awkFile="${testDir}/test-gen.awk"
cat <<EOF > "${awkFile}"
/^#!.*/ {
	print \$0
	print "\nSOURCE_DIRECTORY=${sourceDir}"
	print "BIB2WEB_BASE_DIR=${sourceDir}\n"
}
/^[^#!]/ {
	print \$0
}
END {
	print "source ${shunit2File}"
}
EOF
echo "#!/bin/bash" > "${testFile}"
for file in "$@"; do
	outputfile=$(basename "${file}")
	awk -f "${awkFile}" "${testDir}/${file}" > "${outDir}/${outputfile}"
	echo "/bin/bash ${outDir}/${outputfile}" >> "${testFile}"
done
