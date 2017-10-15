#!/bin/bash

. $(dirname "$0")/setenv.bash

delete_namespace() {
  _NS=$1-$2
  kubectl delete namespace $_NS
}

delete_service_account() {
    kubectl delete clusterrolebinding $1-$2-admin-binding
    printf "Service account $1-$2-admin-binding deleted.\n\n"
}

delete_registry_key() {
  kubectl --namespace $1-$2 delete secret ${1}-docker-registry-key
}

delete_app_helm() {
  helm delete $1-$2 --purge
}

wait_terminate() {
  printf "Waiting for namespaces termination...\n"
  while true; do
    declare -i _STATUS=0
    for i in ${HELM_APPS[@]}; do
      kubectl get namespaces $1-$i > /dev/null 2>&1
      if [ "$?" -eq "0" ]; then
        _STATUS=1
        break
      fi
    done
    if [ "$_STATUS" -eq "0" ]; then
      break
    fi
    sleep 2
  done
}

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-a [APP]            : Specify a specific ONAP component (default: all)
                      from the following choices:
                      sdc, aai ,mso, message-router, robot, vid, aaf
                      sdnc, portal, policy, appc, multicloud, clamp, consul, vnfsdk
-N                  : Do not wait for deletion of namespace and its objects
EOF
}

#MAINs
NS=
INCL_SVC=false
APP=
WAIT_TERMINATE=true

while getopts ":n:u:s:a:N" PARAM; do
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
    N)
      WAIT_TERMINATE=false
      ;;
    ?)
      usage
      exit
      ;;
  esac
done

if [[ -z $NS ]]; then
  usage
  exit 1
fi

if [[ ! -z "$APP" ]]; then
  HELM_APPS=($APP)
fi

printf "\n********** Cleaning up ONAP: ${ONAP_APPS[*]}\n"


for i in ${HELM_APPS[@]}; do

  delete_app_helm $NS $i
  delete_namespace $NS $i
  delete_service_account $NS $i

done

if $WAIT_TERMINATE; then
  wait_terminate $NS
fi

printf "\n********** Gone **********\n"
