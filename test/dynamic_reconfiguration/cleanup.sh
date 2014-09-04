#!/bin/bash
set -ue

PORTAL="localhost"
TARGETNAME=""

# logout
if [ -n "${TARGETNAME}" -a -n "${PORTAL}" ]; then 
	iscsiadm --mode=node --logout --targetname="${TARGETNAME}"\
		--portal="${PORTAL}"
elif [ -n "${TARGETNAME}" ]; then
	iscsiadm --mode=node --logout --targetname="${TARGETNAME}"
elif [ -n "${PORTAL}" ]; then
	iscsiadm --mode=node --logout --portal="${PORTAL}"
else
	iscsiadm --mode=node --logout
fi

# delete
if [ -n "${TARGETNAME}" ]; then
	iscsiadm --mode=node --op=delete --targetname="${TARGETNAME}"
elif [ -n "${PORTAL}" ]; then
	iscsiadm --mode=node --op=delete --portal="${PORTAL}"
else
	iscsiadm --mode=node --op=delete
fi

# check node
iscsiadm --mode=node

setenforce 1
