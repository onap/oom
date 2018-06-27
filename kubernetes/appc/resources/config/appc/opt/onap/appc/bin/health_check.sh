#!/bin/bash -x

startODL_status=$(ps -e | grep startODL | wc -l)
waiting_bundles=$(/opt/opendaylight/current/bin/client bundle:list | grep Waiting | wc -l)
run_level=$(/opt/opendaylight/current/bin/client system:start-level)

  if [ "$run_level" == "Level 100" ] && [ "$startODL_status" -lt "1" ] && [ "$waiting_bundles" -lt "1" ]
  then
    echo APPC is healthy.
  else
    echo APPC is not healthy.
    exit 1
  fi

exit 0
