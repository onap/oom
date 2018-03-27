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

#!/bin/sh

_SRC_HOST=$1
_DST_HOST=$2
_IP=`getent hosts ${_SRC_HOST}|cut -d' ' -f1`
if [ -z ${_IP} ]; then
  echo "Cannot retreive IP for host mapping ${_SRC_HOST} -> ${_DST_HOST}"
  exit 1
fi
_REGEX=".*[[:blank:]]${_DST_HOST}$"
if grep -c -e "${_REGEX}" /etc/hosts > /dev/null 2>&1 ; then
  cp /etc/hosts /tmp/hosts
  sed -i "s/${_REGEX}/${_IP} ${_DST_HOST}/g" /tmp/hosts
  cp /tmp/hosts /etc/hosts
else
  echo "${_IP} ${_DST_HOST}" >> /etc/hosts
fi
