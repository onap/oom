





#!/bin/bash

. $(dirname "$0")/setenv.bash

delete_namespace() {
  _NS=$1-$2
  kubectl delete namespace $_NS
   printf "Waiting for namespace $_NS termination...\n"
   while kubectl get namespaces $_NS > /dev/null 2>&1; do
     sleep 2
   done
  printf "Namespace $_NS deleted.\n\n"
}

delete_registry_key() {
  kubectl --namespace $1-$2 delete secret ${1}-docker-registry-key
}

delete_app_helm() {
  helm delete $1-$2-$3 --purge
}

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-i [INSTANCE]       : ONAP deployment instance # (default: 1)
-a [APP]            : Specify a specific ONAP component (default: all)
                      from the following choices:
                      sdc, aai ,mso, message-router, robot,
                      vid, sdnc, portal, policy, appc
EOF
}

#MAINs
NS=
INCL_SVC=false
APP=
INSTANCE=1

while getopts ":n:u:s:a:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
      ;;
    i)
      INSTANCE=${OPTARG}
      ;;
    a)
      APP=${OPTARG}
      if [[ -z $APP ]]; then
        usage
        exit 1
      fi
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

  delete_app_helm $NS $i $INSTANCE
  delete_namespace $NS $i

done


printf "\n********** Gone **********\n"
