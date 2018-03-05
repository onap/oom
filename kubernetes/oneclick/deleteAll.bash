#!/bin/bash

. $(dirname "$0")/setenv.bash

delete_namespace() {
  kubectl delete namespace $1
}

delete_service_account() {
    kubectl delete clusterrolebinding $1-admin-binding
}

delete_registry_key() {
  kubectl --namespace $1 delete secret ${1}-docker-registry-key
}

delete_app_helm() {
  helm delete $1-$2 --purge
}

wait_terminate() {
  printf "Waiting for namespaces termination...\n"
  while true; do
    declare -i _STATUS=0
    for i in ${HELM_APPS[@]}; do
      kubectl get pods --namespace $1 | grep -w " $i" > /dev/null 2>&1
      if [ "$?" -ne "0" ]; then
        _STATUS=1
        break
      fi
    done

    if [ "$SINGLE_COMPONENT" == "false" ]; then
      kubectl get namespaces $1 > /dev/null 2>&1
      _STATUS=$?
    fi
    if [ "$_STATUS" -ne "0" ]; then
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
-c                  : kubectl context (default: current context)
-y                  : Skip interactive confirmation (default: no)
-a [APP]            : Specify a specific ONAP component (default: all)
                      from the following choices:
                      sdc, aai ,mso, message-router, robot, vid, aaf, uui
                      sdnc, portal, policy, appc, multicloud, clamp, consul, vnfsdk
-N                  : Do not wait for deletion of namespace and its objects
EOF
}

#MAINs
NS=
INCL_SVC=false
APP=
WAIT_TERMINATE=true
SKIP_INTERACTIVE_CONFIRMATION=no
KUBECTL_CONTEXT=
SINGLE_COMPONENT=false
while getopts ":c:n:u:s:a:yN" PARAM; do
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
      SINGLE_COMPONENT=true
      ;;
    N)
      WAIT_TERMINATE=false
      ;;
    y)
      SKIP_INTERACTIVE_CONFIRMATION=yes
      ;;
    c)
      KUBECTL_CONTEXT=${OPTARG}
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

if [[ "$SKIP_INTERACTIVE_CONFIRMATION" != yes ]]; then
  current_kubectl_context=$(kubectl config get-contexts |grep "*" |awk '{print $2}')
  if test "$KUBECTL_CONTEXT" != "$current_kubectl_context"; then
    printf "Current kubectl context does not match context specified:\x1b[31m $current_kubectl_context\x1b[0m\n"
    if [ ! -z "$KUBECTL_CONTEXT" -a "$KUBECTL_CONTEXT" != " " ]; then
      read -p "Do you wish to switch context to $KUBECTL_CONTEXT and continue?" yn
      case $yn in
        [Yy]* ) kubectl config use-context $KUBECTL_CONTEXT;;
        * ) printf "Skipping delete...\n"; exit;;
      esac
    else
      printf "You are about to delete deployment from:\x1b[31m $current_kubectl_context\x1b[0m\n"
      read -p "To continue enter context name: " response

      if test "$response" != "$current_kubectl_context"
      then
        printf "Your response does not match current context! Skipping delete ...\n"
        exit 1
      fi
    fi
  fi
fi

if [[ ! -z "$APP" ]]; then
  HELM_APPS=($APP)
fi

printf "\n********** Cleaning up ONAP: ${ONAP_APPS[*]}\n"

for i in ${HELM_APPS[@]}; do
  delete_app_helm $NS $i
done

if [ "$SINGLE_COMPONENT" == "false" ]
then
    delete_app_helm $NS "config"
    delete_namespace $NS
    delete_registry_key $NS
    delete_service_account $NS
fi

if $WAIT_TERMINATE; then
  wait_terminate $NS
fi

printf "\n********** Gone **********\n"
