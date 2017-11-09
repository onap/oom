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
