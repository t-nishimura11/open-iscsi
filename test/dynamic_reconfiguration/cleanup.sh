#!/bin/bash
set -u

PORTAL="localhost"
TARGETNAME="test.local:target01"

. ./common-function

# logout
iscsiadm --mode=node --logout --targetname="${TARGETNAME}" --portal="${PORTAL}"

# check sesstion
iscsiadm --mode=session

# delete
iscsiadm --mode=node --op=delete --targetname="${TARGETNAME}" \
	--portal="${PORTAL}"

# check node
iscsiadm --mode=node

# cleanup target
if [ -f /etc/tgt/targets.conf.bak ] ; then
	mv -f /etc/tgt/targets.conf.bak /etc/tgt/targets.conf
fi
if [ -f /tmp/not_started_tgtd ] ; then
	rm -f /tmp/not_started_tgtd
	service_ctl tgtd stop
else
	service_ctl tgtd restart
fi
rm -f /tmp/target01.img
if [ -f /tmp/no-scsi-target-utils ] ; then
	yum remove -y scsi-target-utils
	rm -f /tmp/no-scsi-target-utils
fi
if [ -f /tmp/Enforcing ] ; then
	setenforce 1 
	rm -f /tmp/Enforcing
fi
