#!/bin/bash

. $(dirname "$0")/setenv.bash


usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-v [VALUES]         : HELM values filepath (usefull when deploying one component at a time)
-l [LOCATION]       : Location of oom project
-i [INSTANCE]       : ONAP deployment instance # (default: 1)
-a [APP]            : Specify a specific ONAP component (default: all)
                      from the following choices:
                      sdc, aai ,mso, message-router, robot, vid, aaf, uui
                      sdnc, portal, policy, appc, multicloud, clamp, consul, vnfsdk
EOF
}

check_return_code(){
  ret=$?
  if [ $ret -ne 0 ]; then
    printf "The command $1 returned with error code $ret \n" 1>&2
    exit $ret
  fi
}

create_service_account() {
  cmd=`echo kubectl create clusterrolebinding $1-$2-admin-binding --clusterrole=cluster-admin --serviceaccount=$1-$2:default`
  eval ${cmd}
  check_return_code $cmd
}

create_namespace() {
  cmd=`echo kubectl create namespace $1-$2`
  eval ${cmd}
  check_return_code $cmd
}

create_registry_key() {
  cmd=`echo kubectl --namespace $1-$2 create secret docker-registry $3 --docker-server=$4 --docker-username=$5 --docker-password=$6 --docker-email=$7`
  eval ${cmd}
  check_return_code $cmd
}

create_onap_helm() {
  HELM_VALUES_ADDITION=""
  if [[ ! -z $HELM_VALUES_FILEPATH ]]; then
    HELM_VALUES_ADDITION="--values=$HELM_VALUES_FILEPATH"
  fi

  cmd=`echo helm install $LOCATION/$2/ --name $1-$2 --namespace $1 --set nsPrefix=$1,nodePortPrefix=$3 ${HELM_VALUES_ADDITION}`
  eval ${cmd}
  check_return_code $cmd
}

#MAINs
NS=
HELM_VALUES_FILEPATH=""
LOCATION="../"
INCL_SVC=true
APP=
INSTANCE=1
MAX_INSTANCE=5
DU=$ONAP_DOCKER_USER
DP=$ONAP_DOCKER_PASS

while getopts ":n:u:s:i:a:du:dp:l:v:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
      ;;
    v)
      HELM_VALUES_FILEPATH=${OPTARG}
      ;;
    i)
      INSTANCE=${OPTARG}
      ;;
    l)
      LOCATION=${OPTARG}
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

  printf "\nCreating service account **********\n"
  create_service_account $NS $i

  printf "\nCreating registry secret **********\n"
  create_registry_key $NS $i ${NS}-docker-registry-key $ONAP_DOCKER_REGISTRY $DU $DP $ONAP_DOCKER_MAIL

  printf "\nCreating deployments and services **********\n"
  create_onap_helm $NS $i $start

  printf "\n"
done

printf "\n**** Done ****\n"
