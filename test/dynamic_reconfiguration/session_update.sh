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

TEMP_BEFORE=`mktemp /tmp/iscsi_params_before.XXXX`
TEMP_AFTER=`mktemp /tmp/iscsi_params_after.XXXX`

# get before params
iscsiadm --mode=session -d 8 2>${TEMP_BEFORE}

# change param value
iscsiadm --mode=session --op=update --name="${PARAM_NAME}"\
	 --value="${PARAM_VALUE}"

# get after params
iscsiadm --mode=session -d 8 2>${TEMP_AFTER}

diff -up ${TEMP_BEFORE} ${TEMP_AFTER}
rm -rf ${TEMP_BEFORE} ${TEMP_AFTER}
