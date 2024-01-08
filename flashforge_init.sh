#!/bin/sh
set -x

WORK_DIR=`dirname $0`
RUN_DIR="/opt/PROGRAM"

MACHINE=Adventurer5MPro
PID=0024

CHECH_ARCH=`uname -m`
if [ "${CHECH_ARCH}" != "armv7l" ];then
    echo "Machine architecture error."
    echo ${CHECH_ARCH}
    exit 1
fi

## Root password "123456"
SSID_NAME="Adventurer5M Pro"
SSID_PASS=12345678
cp $WORK_DIR/shadow /etc/shadow
cp $WORK_DIR/inittab /etc/inittab
sync

if [ ! -d ${RUN_DIR} ];then
	mkdir -p ${RUN_DIR}
fi
sync

cat $WORK_DIR/start.img > /dev/fb0

## Copy new binarys and files
cp -R $WORK_DIR/bin/* /bin
mkdir -p /etc/ssh
cp $WORK_DIR/files/sshd_config /etc/ssh/sshd_config
cp $WORK_DIR/files/etc_group /etc/group
cp $WORK_DIR/files/etc_passwd /etc/passwd
sync

## Enable SSH
cp $WORK_DIR/files/S50sshd /etc/init.d/
chmod a+x /etc/init.d/S50sshd

## Last fixes
rm -rf /var/empty
mkdir /var/empty
sync

cat $WORK_DIR/end.img > /dev/fb0
exit 0
