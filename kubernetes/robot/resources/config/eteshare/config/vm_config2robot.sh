#!/bin/bash

#
# Make vm1_robot config available to robot
#
CONFIG=/opt/config
PROPERTIES=/opt/eteshare/config/vm_properties.py
GLOBAL_VM_PROPERTIES="# File generated from /opt/config\n#\n"
HASH="GLOBAL_INJECTED_PROPERTIES={"
COMMA=""
for f in `ls $CONFIG/*.txt`;
do
    VALUE=`cat $f`
    NAME=${f%.*}
    NAME=${NAME##*/}
    NAME=${NAME^^}
    GLOBAL_VM_PROPERTIES=$"${GLOBAL_VM_PROPERTIES}GLOBAL_INJECTED_$NAME = \"$VALUE\"\n"
	HASH=$"${HASH}${COMMA}\n\"GLOBAL_INJECTED_$NAME\" : \"$VALUE\""
	COMMA=","
done
HASH="${HASH}}\n"
GLOBAL_VM_PROPERTIES="${GLOBAL_VM_PROPERTIES}\n${HASH}"
GLOBAL_VM_PROPERTIES=${GLOBAL_VM_PROPERTIES}
echo -e $GLOBAL_VM_PROPERTIES > $PROPERTIES
