#!/bin/bash

if [ "${SDNC_IS_PRIMARY_CLUSTER:-true}" = "true" ];then
  id=sdnc01
else
  id=sdnc02
fi

# should PROM start as passive?
state=$( bin/sdnc.cluster )
if [ "$state" == "standby" ]; then
  echo "Starting PROM in passive mode"
  passive="-p"
fi

# start PROM as foreground process
java -jar prom.jar --id $id $passive --config config
