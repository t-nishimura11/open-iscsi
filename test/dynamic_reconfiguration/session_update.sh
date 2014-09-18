#!/bin/bash

usage_exit() {
	echo "Usage: $0 -n PARAM_NAME -v PARAM_VALUE" 1>&2
	exit 1
}

while getopts n:v: OPT ; do
	case ${OPT} in
		"n" ) PARAM_NAME="${OPTARG}" ;;
		"v" ) PARAM_VALUE="${OPTARG}" ;;
		\? ) usage_exit ;;
	esac
done

TEMP=$(mktemp)

# get before params
iscsiadm --mode=session -d 8 2>${TEMP}.before

# change param value
iscsiadm --mode=session --op=update --name="${PARAM_NAME}"\
	 --value="${PARAM_VALUE}"

# get after params
iscsiadm --mode=session -d 8 2>${TEMP}.after

diff -up ${TEMP}.before ${TEMP}.after > ${TEMP}.diff.${PARAM_NAME}
if [ "$(cat ${TEMP}.diff.${PARAM_NAME} | wc -l)" -eq 0 ] ; then
	echo "FAIL: ${PARAM_NAME} not updated."
fi
rm -rf ${TEMP}*
