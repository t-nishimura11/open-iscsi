#!/bin/bash
set -u

PORTAL="localhost"
TARGETNAME="test.local:target01"

. ./common-function

# setup target
setenforce 0
if ! rpm -q scsi-target-utils ; then
	touch /tmp/no-scsi-target-utils
	yum install -y scsi-target-utils
fi
dd if=/dev/zero of=/tmp/target01.img seek=1000 bs=1M count=1
cp /etc/tgt/targets.conf /etc/tgt/targets.conf.bak
cat << EOF >> /etc/tgt/targets.conf
<target test.local:target01>
	backing-store "/tmp/target01.img"
</target>
EOF
service_ctl tgtd status || touch /tmp/not_started_tgtd
service_ctl tgtd restart
# check target
tgt-admin --show


# discovery 
iscsiadm --mode=discovery --type=sendtargets --portal="${PORTAL}"

# login
iscsiadm --mode=node --login --targetname="${TARGETNAME}" --portal="${PORTAL}"

# check session
iscsiadm --mode=session
