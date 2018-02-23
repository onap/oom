#!/bin/bash
#############################################################################
#
# Copyright © 2018 Amdocs, Bell.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################################################################
# v20180318
# https://wiki.onap.org/display/DW/ONAP+on+Kubernetes
# source from https://jira.onap.org/browse/OOM-715, 716, 711
# Michael O'Brien
#

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
example 
./cd.sh -b amsterdam -e onap (will rerun onap in the onap namespace, no new repo, no deletion of existing repo, no sdnc workaround, no onap removal at the end
./cd.sh -b master -e onap -c true -d true -w true -r true (run as cd server, new oom, delete prev oom, run workarounds, clean onap at the end of the script
./cd.sh -b master -e onap -c true -d false -w true -r false (standard new server/dev environment - use this as the default)

-u                  : Display usage
-b [branch]         : branch = master or amsterdam (required)
-e [environment]    : use the default (onap)
-c [true|false]     : FLAG clone new oom repo (default: true)
-d [true|false]     : FLAG delete prev oom - (cd build) (default: false)
-w [true|false]     : FLAG apply workarounds  IE: sdnc (default: true)
-r [true|false]     : FLAG remove oom at end of script - for use by CD only (default: false)
EOF
}

deploy_onap() {
  
  echo "$(date)"
  echo "running with: -b $BRANCH -e $ENVIRON -c $CLONE_NEW_OOM -d $DELETE_PREV_OOM -w $APPLY_WORKAROUNDS -r $REMOVE_OOM_AT_END"
  echo "provide onap-parameters.yaml(amsterdam) or values.yaml(master) and aai-cloud-region-put.json"
  #exit 0
  # fix virtual memory for onap-log:elasticsearch under Rancher 1.6.11 - OOM-431
  sudo sysctl -w vm.max_map_count=262144
  if [[ "$DELETE_PREV_OOM" != false ]]; then
    echo "remove existing oom"
    # master/beijing only - not amsterdam
    if [ "$BRANCH" == "master" ]; then
      kubectl delete namespace $ENVIRON
      kubectl delete namespace dcae
      kubectl delete namespace dev
      sudo helm delete --purge dev
      sudo helm delete --purge $ENVIRON
      sudo helm delete --purge dcae
    else
      oom/kubernetes/oneclick/deleteAll.bash -n $ENVIRON
    fi

    sleep 1
    # verify
    DELETED=$(kubectl get pods --all-namespaces -a | grep 0/ | wc -l)
    echo "verify deletion is finished."
    while [  $(kubectl get pods --all-namespaces | grep 0/ | wc -l) -gt 0 ]; do
      sleep 15
      echo "waiting for deletions to complete"
    done
    # wait for 0/1 before deleting
    echo "sleeping 30 sec"
    # delete potential hanging clustered pods
    kubectl delete pod $ENVIRON-aaf-sms-vault-0 -n $ENVIRON --grace-period=0 --force
    kubectl delete pod $ENVIRON-aai-cassandra-0 -n $ENVIRON --grace-period=0 --force
    kubectl delete pod $ENVIRON-aai-cassandra-1 -n $ENVIRON --grace-period=0 --force
    kubectl delete pod $ENVIRON-aai-cassandra-2 -n $ENVIRON --grace-period=0 --force
    # specific to when there is no helm release
    kubectl delete pv --all
    kubectl delete clusterrolebinding --all
    # replace with watch
    # keep jenkins 120 sec timeout happy with echos
    sleep 30
    echo "List of ONAP Modules - look for terminating pods"
    LIST_ALL=$(kubectl get pods --all-namespaces --show-all -o wide )
    echo "${LIST_ALL}"

    # for use by continuous deployment only
    echo " deleting /dockerdata-nfs"
    sudo chmod -R 777 /dockerdata-nfs/onap
    sudo chmod -R 777 /dockerdata-nfs/dev
    rm -rf /dockerdata-nfs/onap
    rm -rf /dockerdata-nfs/dev
  fi
  # for use by continuous deployment only
  if [[ "$CLONE_NEW_OOM" != false ]]; then
    rm -rf oom
    echo "pull new oom"
    git clone -b $BRANCH http://gerrit.onap.org/r/oom
  fi

  if [ "$BRANCH" == "master" ]; then
    echo "moving values.yaml to oom/kubernetes/"
    #sudo cp values.yaml oom/kubernetes/onap
  else
    echo "start config pod"
    # still need to source docker variables
    source oom/kubernetes/oneclick/setenv.bash
    #echo "source setenv override"
    echo "moving onap-parameters.yaml to oom/kubernetes/config"
    cp onap-parameters.yaml oom/kubernetes/config
    cd oom/kubernetes/config
    ./createConfig.sh -n $ENVIRON
    cd ../../../
    echo "verify onap-config is 0/1 not 1/1 - as in completed - an error pod - means you are missing onap-parameters.yaml or values are not set in it."
    while [  $(kubectl get pods -n onap -a | grep config | grep 0/1 | grep Completed | wc -l) -eq 0 ]; do
      sleep 15
      echo "waiting for config pod to complete"
    done
  fi

  # usually the prepull takes up to 25-300 min - however hourly builds will finish the docker pulls before the config pod is finished
  #echo "pre pull docker images - 35+ min"
  #wget https://jira.onap.org/secure/attachment/11261/prepull_docker.sh
  #chmod 777 prepull_docker.sh
  #./prepull_docker.sh
  echo "start onap pods"
  if [ "$BRANCH" == "master" ]; then
    cd oom/kubernetes/
    sudo make clean
    sudo make all
    sudo make onap
    sudo helm install local/onap -n onap --namespace $ENVIRON
    cd ../../
  else
    cd oom/kubernetes/oneclick
    ./createAll.bash -n $ENVIRON
    cd ../../../
  fi

  echo "wait for all pods up for 15-80 min"
  FAILED_PODS_LIMIT=0
  MAX_WAIT_PERIODS=480 # 120 MIN
  COUNTER=0
  PENDING_PODS=0
  while [  $(kubectl get pods --all-namespaces | grep 0/ | wc -l) -gt $FAILED_PODS_LIMIT ]; do
    PENDING=$(kubectl get pods --all-namespaces | grep 0/ | wc -l)
    PENDING_PODS=$PENDING
    sleep 15
    LIST_PENDING=$(kubectl get pods --all-namespaces -o wide | grep 0/ )
    echo "${LIST_PENDING}"
    echo "${PENDING} pending > ${FAILED_PODS_LIMIT} at the ${COUNTER}th 15 sec interval"
    echo ""
    COUNTER=$((COUNTER + 1 ))
    MAX_WAIT_PERIODS=$((MAX_WAIT_PERIODS - 1))
    if [ "$MAX_WAIT_PERIODS" -eq 0 ]; then
      FAILED_PODS_LIMIT=800
    fi
  done

  echo "report on non-running containers"
  PENDING=$(kubectl get pods --all-namespaces | grep 0/)
  PENDING_COUNT=$(kubectl get pods --all-namespaces | grep 0/ | wc -l)
  PENDING_COUNT_AAI=$(kubectl get pods -n $ENVIRON | grep aai- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_AAI" -gt 0 ]; then
    echo "down-aai=${PENDING_COUNT_AAI}"
  fi

  # todo don't stop if aai is down
  PENDING_COUNT_APPC=$(kubectl get pods -n $ENVIRON | grep appc- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_APPC" -gt 0 ]; then
    echo "down-appc=${PENDING_COUNT_APPC}"
  fi
  PENDING_COUNT_MR=$(kubectl get pods -n $ENVIRON | grep message-router- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_MR" -gt 0 ]; then
    echo "down-mr=${PENDING_COUNT_MR}"
  fi
  PENDING_COUNT_SO=$(kubectl get pods -n $ENVIRON | grep so- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_SO" -gt 0 ]; then
    echo "down-so=${PENDING_COUNT_SO}"
  fi
  PENDING_COUNT_POLICY=$(kubectl get pods -n $ENVIRON | grep policy- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_POLICY" -gt 0 ]; then
    echo "down-policy=${PENDING_COUNT_POLICY}"
  fi
  PENDING_COUNT_PORTAL=$(kubectl get pods -n $ENVIRON | grep portal- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_PORTAL" -gt 0 ]; then
    echo "down-portal=${PENDING_COUNT_PORTAL}"
  fi
  PENDING_COUNT_LOG=$(kubectl get pods -n $ENVIRON | grep log- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_LOG" -gt 0 ]; then
    echo "down-log=${PENDING_COUNT_LOG}"
  fi
  PENDING_COUNT_ROBOT=$(kubectl get pods -n $ENVIRON | grep robot- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_ROBOT" -gt 0 ]; then
    echo "down-robot=${PENDING_COUNT_ROBOT}"
  fi
  PENDING_COUNT_SDC=$(kubectl get pods -n $ENVIRON | grep sdc- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_SDC" -gt 0 ]; then
    echo "down-sdc=${PENDING_COUNT_SDC}"
  fi
  PENDING_COUNT_SDNC=$(kubectl get pods -n $ENVIRON | grep sdnc- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_SDNC" -gt 0 ]; then
    echo "down-sdnc=${PENDING_COUNT_SDNC}"
  fi
  PENDING_COUNT_VID=$(kubectl get pods -n $ENVIRON | grep vid- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_VID" -gt 0 ]; then
    echo "down-vid=${PENDING_COUNT_VID}"
  fi

  PENDING_COUNT_AAF=$(kubectl get pods -n $ENVIRON | grep aaf- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_AAF" -gt 0 ]; then
    echo "down-aaf=${PENDING_COUNT_AAF}"
  fi
  PENDING_COUNT_CONSUL=$(kubectl get pods -n $ENVIRON | grep consul- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_CONSUL" -gt 0 ]; then
    echo "down-consul=${PENDING_COUNT_CONSUL}"
  fi
  PENDING_COUNT_MSB=$(kubectl get pods -n $ENVIRON | grep msb- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_MSB" -gt 0 ]; then
    echo "down-msb=${PENDING_COUNT_MSB}"
  fi
  PENDING_COUNT_DCAE=$(kubectl get pods -n $ENVIRON | grep dcaegen2- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_DCAE" -gt 0 ]; then
    echo "down-dcae=${PENDING_COUNT_DCAE}"
  fi
  PENDING_COUNT_CLI=$(kubectl get pods -n $ENVIRON | grep cli- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_CLI" -gt 0 ]; then
    echo "down-cli=${PENDING_COUNT_CLI}"
  fi
  PENDING_COUNT_MULTICLOUD=$(kubectl get pods -n $ENVIRON | grep multicloud- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_MULTICLOUD" -gt 0 ]; then
    echo "down-multicloud=${PENDING_COUNT_MULTICLOUD}"
  fi
  PENDING_COUNT_CLAMP=$(kubectl get pods -n $ENVIRON | grep clamp- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_CLAMP" -gt 0 ]; then
    echo "down-clamp=${PENDING_COUNT_CLAMP}"
  fi
  PENDING_COUNT_VNFSDK=$(kubectl get pods -n $ENVIRON | grep vnfsdk- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_VNFSDK" -gt 0 ]; then
    echo "down-vnfsdk=${PENDING_COUNT_VNFSDK}"
  fi
  PENDING_COUNT_UUI=$(kubectl get pods -n $ENVIRON | grep uui- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_UUI" -gt 0 ]; then
    echo "down-uui=${PENDING_COUNT_UUI}"
  fi
  PENDING_COUNT_VFC=$(kubectl get pods -n $ENVIRON | grep vfc- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_VFC" -gt 0 ]; then
    echo "down-vfc=${PENDING_COUNT_VFC}"
  fi
  PENDING_COUNT_KUBE2MSB=$(kubectl get pods -n $ENVIRON | grep kube2msb- | grep 0/ | wc -l)
  if [ "$PENDING_COUNT_KUBE2MSB" -gt 0 ]; then
    echo "down-kube2msb=${PENDING_COUNT_KUBE2MSB}"
  fi
  echo "pending containers=${PENDING_COUNT}"
  echo "${PENDING}"

  echo "check filebeat 2/2 count for ELK stack logging consumption"
  FILEBEAT=$(kubectl get pods --all-namespaces -a | grep 2/)
  echo "${FILEBEAT}"
  echo "sleep 5 min - to allow rest frameworks to finish"
  sleep 300
  echo "List of ONAP Modules"
  LIST_ALL=$(kubectl get pods --all-namespaces -a  --show-all )
  echo "${LIST_ALL}"
  echo "run healthcheck 2 times to warm caches and frameworks so rest endpoints report properly - see OOM-447"

  echo "curl with aai cert to cloud-region PUT"

  curl -X PUT https://127.0.0.1:30233/aai/v11/cloud-infrastructure/cloud-regions/cloud-region/CloudOwner/RegionOne --data "@aai-cloud-region-put.json" -H "authorization: Basic TW9kZWxMb2FkZXI6TW9kZWxMb2FkZXI=" -H "X-TransactionId:jimmy-postman" -H "X-FromAppId:AAI" -H "Content-Type:application/json" -H "Accept:application/json" --cacert aaiapisimpledemoopenecomporg_20171003.crt -k

  echo "get the cloud region back"
  curl -X GET https://127.0.0.1:30233/aai/v11/cloud-infrastructure/cloud-regions/ -H "authorization: Basic TW9kZWxMb2FkZXI6TW9kZWxMb2FkZXI=" -H "X-TransactionId:jimmy-postman" -H "X-FromAppId:AAI" -H "Content-Type:application/json" -H "Accept:application/json" --cacert aaiapisimpledemoopenecomporg_20171003.crt -k

  # OOM-484 - robot scripts moved
  cd oom/kubernetes/robot
  echo "run healthcheck prep 1"
  # OOM-722 adds namespace parameter
  if [ "$BRANCH" == "amsterdam" ]; then
    ./ete-k8s.sh health > ~/health1.out
  else
    ./ete-k8s.sh $ENVIRON health > ~/health1.out
  fi
  echo "sleep 5 min"
  sleep 300
  echo "run healthcheck prep 2"
  if [ "$BRANCH" == "amsterdam" ]; then
    ./ete-k8s.sh health > ~/health2.out
  else
    ./ete-k8s.sh $ENVIRON health > ~/health2.out
  fi
  echo "run healthcheck for real - wait a further 5 min"
  sleep 300
  if [ "$BRANCH" == "amsterdam" ]; then
    ./ete-k8s.sh health
  else
    ./ete-k8s.sh $ENVIRON health
  fi
  echo "run partial vFW"
#  sudo chmod 777 /dockerdata-nfs/onap
#  if [ "$BRANCH" == "amsterdam" ]; then
#    ./demo-k8s.sh init_robot
#  else
#    ./demo-k8s.sh $ENVIRON init
#  fi
#  if [ "$BRANCH" == "amsterdam" ]; then
#    ./demo-k8s.sh init
#  else
#    ./demo-k8s.sh $ENVIRON init
#  fi
  echo "report results"
  cd ../../../

  # for use by continuous deployment only
#  if [[ "$REMOVE_OOM_AT_END" != false ]]; then
#    if [ "$BRANCH" == "master" ]; then
#      kubectl delete namespace $ENVIRON
#      sudo helm delete --purge onap
      # query for PV's

#    else
#      oom/kubernetes/oneclick/deleteAll.bash -n $ENVIRON
#    fi
#  fi
  
  echo "$(date)"
  #set +a
}

BRANCH=
ENVIRON=onap
APPLY_WORKAROUNDS=true
DELETE_PREV_OOM=false
REMOVE_OOM_AT_END=false
CLONE_NEW_OOM=true

while getopts ":u:b:e:c:d:w:r" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    b)
      BRANCH=${OPTARG}
      ;;
    e)
      ENVIRON=${OPTARG}
      ;;
    c)
      CLONE_NEW_OOM=${OPTARG}
      ;;
    d)
      DELETE_PREV_OOM=${OPTARG}
      ;;
    w)
      APPLY_WORKAROUNDS=${OPTARG}
      ;;
    r)
      REMOVE_OOM_AT_END=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

if [[ -z $BRANCH ]]; then
  usage
  exit 1
fi

deploy_onap  $BRANCH $ENVIRON $CLONE_NEW_OOM $DELETE_PREV_OOM $APPLY_WORKAROUNDS $REMOVE_OOM_AT_END

printf "**** Done ****\n"
