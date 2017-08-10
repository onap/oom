#!/bin/bash
delete_namespace() {
  kubectl delete namespace $1-$2
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
                      vid, sdnc, portal, policy, appc, dcae
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
else
  ONAP_APPS=('sdc' 'aai' 'mso' 'message-router' 'robot' 'vid' 'sdnc' 'portal' 'policy' 'appc' 'dcae')
fi

printf "\n********** Cleaning up ONAP: ${ONAP_APPS[*]}\n"

for i in ${ONAP_APPS[@]}; do

  if [[ "$INCL_SVC" == true ]]; then
    printf "\nDeleting services **********\n"
    delete_service $NS $i
    delete_namespace $NS $i
  fi

  # delete the deployments
  /bin/bash $i.sh $NS $i 'delete'

done


printf "\n********** Gone **********\n"
