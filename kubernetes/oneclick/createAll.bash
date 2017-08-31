#!/bin/bash

. $(dirname "$0")/setenv.bash


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

create_namespace() {
  kubectl create namespace $1-$2
}

create_registry_key() {
  kubectl --namespace $1-$2 create secret docker-registry $3 --docker-server=$4 --docker-username=$5 --docker-password=$6 --docker-email=$7
}

create_onap_helm() {
  helm install ../$2/ --name $1-$2 --namespace $1 --set nsPrefix=$1 --set nodePortPrefix=$3
}


#MAINs
NS=
INCL_SVC=true
APP=
INSTANCE=1
MAX_INSTANCE=5
DU=$ONAP_DOCKER_USER
DP=$ONAP_DOCKER_PASS
_FILES_PATH=$(echo ../$i/templates)

while getopts ":n:u:s:i:a:du:dp:" PARAM; do
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
    du)
      DU=${OPTARG}
      ;;
    dp)
      DP=${OPTARG}
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


if [ "$INSTANCE" -gt "$MAX_INSTANCE" ];then
  printf "\n********** You choose to create ${INSTANCE}th instance of ONAP \n"
  printf "\n********** Due to port allocation only ${MAX_INSTANCE} instances of ONAP is allowed per kubernetes deployment\n"
  exit 1
fi

start=$((300+2*INSTANCE))
end=$((start+1))

printf "\n********** Creating instance ${INSTANCE} of ONAP with port range ${start}00 and ${end}99\n"


printf "\n********** Creating ONAP: ${ONAP_APPS[*]}\n"


printf "\n\n********** Creating deployments for ${HELM_APPS[*]} ********** \n"

for i in ${HELM_APPS[@]}; do
  printf "\nCreating namespace **********\n"
  create_namespace $NS $i 

  printf "\nCreating registry secret **********\n"
  create_registry_key $NS $i ${NS}-docker-registry-key $ONAP_DOCKER_REGISTRY $DU $DP $ONAP_DOCKER_MAIL

  printf "\nCreating deployments and services **********\n"
  create_onap_helm $NS $i $start

  printf "\n"
done

printf "\n**** Done ****\n"
