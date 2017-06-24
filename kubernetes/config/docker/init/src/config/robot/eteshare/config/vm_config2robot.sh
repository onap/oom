#!/bin/bash

#
# Make vm1_robot config available to robot
#
CONFIG=/opt/config
PROPERTIES=/opt/eteshare/config/vm_properties.py
GLOBAL_VM_PROPERTIES="# File generated from /opt/config\n#\n"
for f in `ls $CONFIG/*.txt`;
do
    VALUE=`cat $f`
    NAME=${f%.*}
    NAME=${NAME##*/}
    GLOBAL_VM_PROPERTIES=$"$GLOBAL_VM_PROPERTIES \"$NAME\" : \"$VALUE\",\n"
done
GLOBAL_VM_PROPERTIES=${GLOBAL_VM_PROPERTIES/%,\\n/\}}
echo -e $GLOBAL_VM_PROPERTIES > $PROPERTIES
REGION=`cat $CONFIG/region.txt`
echo -e "\nGLOBAL_OPENSTACK_SERVICE_REGION = \"$REGION\"" >> /opt/eteshare/config/integration_robot_properties.py
