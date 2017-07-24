#!/bin/bash

. $(dirname "$0")/setenv.bash

delete_namespace() {
  _NS=$1-$2
  kubectl delete namespace $_NS
  printf "Waiting for namespace $_NS termination...\n"
  while kubectl get namespaces onap-sdc > /dev/null 2>&1; do
    sleep 2
  done
  printf "Namespace $_NS deleted.\n\n"
}

delete_registry_key() {
  kubectl --namespace $1-$2 delete secret onap-docker-registry-key
}

delete_service() {
  kubectl --namespace $1-$2 delete -f ../$2/all-services.yaml
}

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-s true             : Include services (default: false)
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

while getopts ":n:u:s:a:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
      ;;
    s)
      INCL_SVC=${OPTARG}
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
  ONAP_APPS=($APP)
fi

printf "\n********** Cleaning up ONAP: ${ONAP_APPS[*]}\n"

for i in ${ONAP_APPS[@]}; do

  # delete the deployments
  /bin/bash $i.sh $NS $i 'delete'

  if [[ "$INCL_SVC" == true ]]; then
    printf "\nDeleting services **********\n"
    delete_service $NS $i
    delete_namespace $NS $i
  fi

done


printf "\n********** Gone **********\n"
