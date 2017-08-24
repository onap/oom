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
  helm install ../$2/ --name $2
}

configure_app() {
  # if previous configuration exists put back original template file
  for file in $3/*.yaml; do
    if [ -e "$file-template" ]; then
      mv "$file-template" "${file%}"
    fi
  done
  
  if [ -e "$2/Chart.yaml" ]; then
    sed -i-- 's/nodePort: [0-9]\{2\}[02468]\{1\}/nodePort: '"$4"'/g' $3/all-services.yaml
    sed -i-- 's/nodePort: [0-9]\{2\}[13579]\{1\}/nodePort: '"$5"'/g' $3/all-services.yaml
    sed -i "s/onap-/$1-/g" ../$2/values.yaml
  fi


  # replace the default 'onap' namespace qualification of K8s hostnames within
  # the config files
  # note: this will create a '-template' file within the component's directory
  #       this is not ideal and should be addressed (along with the replacement
  #       of sed commands for configuration) by the future configuration
  #       user stories (ie. OOM-51 to OOM-53)
  find $3 -type f -exec sed -i -- "s/onap-/$1-/g" {} \;

  # replace the default '/dockerdata-nfs/onapdemo' volume mount paths
  find $3 -iname "*.yaml" -type f -exec sed -i -e 's/dockerdata-nfs\/[a-zA-Z0-9\\-]*\//dockerdata-nfs\/'"$1"'\//g' {} \;
  rm -f $3/*.yaml-e
}


#MAINs
NS=
INCL_SVC=true
APP=
INSTANCE=1
MAX_INSTANCE=5
DU=$ONAP_DOCKER_USER
DP=$ONAP_DOCKER_PASS

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
  create_registry_key $NS $i $ONAP_DOCKER_REGISTRY_KEY $ONAP_DOCKER_REGISTRY $DU $DP $ONAP_DOCKER_MAIL

  printf "\nCreating deployments and services **********\n"
  _FILES_PATH=$(echo ../$i/templates)
  configure_app $NS $i $_FILES_PATH $start $end
  create_onap_helm $NS $i

  printf "\n"
done

printf "\n**** Done ****\n"

