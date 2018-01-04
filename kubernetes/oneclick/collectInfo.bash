#!/bin/bash

NS=
OUT_NAME=onap_info_$(date +%y.%m.%d_%H.%M.%S.%N)
OUT_FILE=
OUT_DIR=$(dirname "$0")
TMP_DIR=$(dirname $(mktemp -u))
CONTAINER_LOGS_PATH=/var/log/onap
CP_CONTAINER_LOGS=false

if [ ! -z "$DEBUG" ]; then
  set -x
fi

usage() {
  cat <<EOF
Utility script collecting vairious information about ONAP deployment on kubernetes.

Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-a [APP]            : Specify a specific ONAP component (default: all)
-d [OUT_DIR]        : Specify output folder for the collected info pack file
                      (default: current dir)
-f [OUT_FILE]       : Specify output file for the collected info
                      (default: file name with timestamp)
-c                  : Collect log files from containers, from path ${CONTAINER_LOGS_PATH}
EOF
}

call_with_log() {
  local _cmd=$1
  local _log=$2
  # Make sure otput dir exists
  mkdir -p "$(dirname "$_log")"
  printf "Command: ${_cmd}\n" >> ${_log}
  printf "================================================================================\n" >> ${_log}
  eval "${_cmd}" >> ${_log} 2>&1
  printf "================================================================================\n" >> ${_log}
}

collect_pod_info() {
  local _ns=$1
  local _id=$2
  local _log_dir=$3
  local _cp_logs=$4
  declare -i _i=0
  kubectl -n $_ns get pods $_id -o=jsonpath='{range .spec.containers[*]}{.name}{"\n"}{end}' | while read c; do
    call_with_log "kubectl -n $_ns logs $_id -c $c" "$_log_dir/$_id-$c.log"
    if [ "$_i" -eq "0" ] && [ "$_cp_logs" == "true" ]; then
      # copy logs from 1st container only as logs dir is shared between the containers
      local _cmd="kubectl cp $_ns/$_id:${CONTAINER_LOGS_PATH} $_log_dir/$_id-$c -c $c"
      if [ -z "$DEBUG" ]; then
        _cmd+=" > /dev/null 2>&1"
      fi
      eval "${_cmd}"
    fi
    ((_i++))
  done
}

collect_ns_info() {
  local _ns=$1
  local _log_dir=$2/$_ns
  call_with_log "kubectl -n $NS-$i get services -o=wide" "$_log_dir/list_services.log"
  kubectl -n "$_ns" get services | while read i; do
    local _id=`echo -n $i | tr -s ' ' | cut -d' ' -n -f1`
    if [ "$_id" == "NAME" ]; then
      continue
    fi
    call_with_log "kubectl -n $_ns describe services $_id" "$_log_dir/describe_services/$_id.log"
  done
  call_with_log "kubectl -n $NS-$i get pods -o=wide" "$_log_dir/list_pods.log"
  kubectl -n "$_ns" get pods | while read i; do
    local _id=`echo -n $i | tr -s ' ' | cut -d' ' -n -f1`
    if [ "$_id" == "NAME" ]; then
      continue
    fi
    call_with_log "kubectl -n $_ns describe pods $_id" "$_log_dir/describe_pods/$_id.log"
    collect_pod_info "$_ns" "$_id" "$_log_dir/logs" "${CP_CONTAINER_LOGS}"
  done
}

while getopts ":un:a:d:f:c" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
      ;;
    a)
      APP=${OPTARG}
      if [[ -z $APP ]]; then
        usage
        exit 1
      fi
      ;;
    d)
      OUT_DIR=${OPTARG}
      if [[ -z $OUT_DIR ]]; then
        usage
        exit 1
      fi
      ;;
    f)
      OUT_FILE=${OPTARG}
      if [[ -z $OUT_FILE ]]; then
        usage
        exit 1
      fi
      ;;
    c)
      CP_CONTAINER_LOGS=true
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

if [ -z "$NS" ]; then
  usage
  exit 1
fi

if [[ -z $OUT_FILE ]]; then
  OUT_FILE=$OUT_NAME.tgz
fi

if [ ! -z "$APP" ]; then
  _APPS=($APP)
else
  _APPS=(`kubectl get namespaces | grep "^$NS-" | tr -s ' ' | cut -d' ' -n -f1 | sed -e "s/^$NS-//"`)
fi

printf "Collecting information about ONAP deployment...\n"
printf "Components: %s\n" "${_APPS[*]}"

# Collect common info
mkdir -p ${TMP_DIR}/${OUT_NAME}/
echo "${_APPS[*]}" > ${TMP_DIR}/${OUT_NAME}/component-list.log
printf "Collecting Helm info\n"
call_with_log "helm version" "${TMP_DIR}/${OUT_NAME}/helm-version.log"
call_with_log "helm list" "${TMP_DIR}/${OUT_NAME}/helm-list.log"

printf "Collecting Kubernetes info\n"
call_with_log "kubectl version" "${TMP_DIR}/${OUT_NAME}/k8s-version.log"
call_with_log "kubectl get nodes -o=wide" "${TMP_DIR}/${OUT_NAME}/k8s-nodes.log"
call_with_log "kubectl cluster-info" "${TMP_DIR}/${OUT_NAME}/k8s-cluster-info.log"
call_with_log "kubectl cluster-info dump" "${TMP_DIR}/${OUT_NAME}/k8s-cluster-info-dump.log"
call_with_log "kubectl top node" "${TMP_DIR}/${OUT_NAME}/k8s-top-node.log"

# Collect per-component info
for i in ${_APPS[@]}; do
  printf "Writing Kubernetes info of component $i\n"
  collect_ns_info "$NS-$i" "${TMP_DIR}/${OUT_NAME}"
done

# Pack and cleanup
mkdir -p ${OUT_DIR}
_OUT_DIR=`readlink -e ${OUT_DIR}`
printf "Packing output to ${_OUT_DIR}/${OUT_FILE}...\n"
cd ${TMP_DIR}
tar cfz ${_OUT_DIR}/${OUT_FILE} ${OUT_NAME}
cd -
printf "Cleaning up...\n"
rm -rf ${TMP_DIR}/${OUT_NAME}
printf "Done\n"
