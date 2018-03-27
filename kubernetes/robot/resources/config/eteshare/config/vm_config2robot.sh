# Copyright © 2017 Amdocs, Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
