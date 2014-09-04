#!/bin/bash
set -ue

PORTAL="localhost"
TARGETNAME=""


setenforce 0

# discovery 
iscsiadm --mode=discovery --type=sendtargets --portal="${PORTAL}"

# login
if [ -n "${TARGETNAME}" -a -n "${PORTAL}" ]; then
	iscsiadm --mode=node --login --targetname="${TARGETNAME}"\
		--portal="${PORTAL}"
elif [ -n "${TARGETNAME}" ]; then
	iscsiadm --mode=node --login --targetname="${TARGETNAME}"
elif [ -n "${TARGETNAME}" ]; then
	iscsiadm --mode=node --login --portal="${PORTAL}"
else
	iscsiadm --mode=node --login
fi

# check session
iscsiadm --mode=session
