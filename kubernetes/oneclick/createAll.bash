#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
-s false            : Exclude services (default: true)
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

create_service() {
  sed -i -- 's/nodePort: [0-9]\{2\}[02468]\{1\}/nodePort: '"$3"'/g' ../$2/all-services.yaml
  sed -i -- 's/nodePort: [0-9]\{2\}[13579]\{1\}/nodePort: '"$4"'/g' ../$2/all-services.yaml
  kubectl --namespace $1-$2 create -f ../$2/all-services.yaml
  mv ../$2/all-services.yaml-- ../$2/all-services.yaml
}


#MAINs
NS=
INCL_SVC=true
APP=
INSTANCE=1
MAX_INSTANCE=5

while getopts ":n:u:s:i:a:" PARAM; do
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
  ONAP_APPS=($APP)
else
  ONAP_APPS=('sdc' 'aai' 'mso' 'message-router' 'robot' 'vid' 'sdnc' 'portal' 'policy' 'appc')
fi

if [[ "$INCL_SVC" == true ]]; then

  if [ "$INSTANCE" -gt "$MAX_INSTANCE" ];then
    printf "\n********** You choose to create ${INSTANCE}th instance of ONAP \n"
    printf "\n********** Due to port allocation only ${MAX_INSTANCE} instances of ONAP is allowed per kubernetes deployment\n"
    exit 1
  fi

  start=$((300+2*INSTANCE))
  end=$((start+1))
  printf "\n********** Creating instance ${INSTANCE} of ONAP with port range ${start}00 and ${end}99\n"

fi

printf "\n********** Creating up ONAP: ${ONAP_APPS[*]}\n"

for i in ${ONAP_APPS[@]}; do
  printf "\nCreating namespaces **********\n"
  create_namespace $NS $i

  if [[ "$INCL_SVC" == true ]]; then
    printf "\nCreating services **********\n"
    create_service $NS $i $start $end
  fi

  printf "\n"
done

printf "\n\n********** Creating deployments for  ${ONAP_APPS[*]} ********** \n"
for i in ${ONAP_APPS[@]}; do
  /bin/bash $i.sh $NS $i 'create'
done

printf "\n**** Done ****\n"
