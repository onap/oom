#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-s false            : Exclude services (default: true)
-a [APP]            : Specify a specific ONAP component (default: all)
                      from the following choices:
                      sdc, aai ,mso, message-router, robot,
                      vid, sdnc, portal, policy, appc
EOF
}

create_namespace() {
  kubectl create namespace $1-$2
}

create_service() {
  kubectl --namespace $1-$2 create -f ../$2/all-services.yaml
}

#MAINs
NS=
INCL_SVC=true
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
  ONAP_APPS=('sdc' 'aai' 'mso' 'message-router' 'robot' 'vid' 'sdnc' 'portal' 'policy' 'appc')
fi

printf "\n********** Creating up ONAP: ${ONAP_APPS[*]}\n"

for i in ${ONAP_APPS[@]}; do
  printf "\nCreating namespaces **********\n"
  create_namespace $NS $i

  if [[ "$INCL_SVC" == true ]]; then
    printf "\nCreating services **********\n"
    create_service $NS $i
  fi

  printf "\n"
done

printf "\n\n********** Creating deployments for  ${ONAP_APPS[*]} ********** \n"
for i in ${ONAP_APPS[@]}; do
  /bin/bash $i.sh $NS $i 'create'
done

printf "**** Done ****"
