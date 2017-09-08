#!/bin/bash

usage() {
  cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-n [NAMESPACE]      : Kubernetes namespace (required)
EOF
}

create_namespace() {
  kubectl create namespace $1
}

create_configuration() {
  create_namespace $1
  helm install . --name "$1-config" --namespace $1 --set nsPrefix=$1
}

#MAINs
NS=

while getopts ":n:u:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    n)
      NS=${OPTARG}
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

printf "\n**** Creating configuration for ONAP instance: $NS\n"
create_configuration $NS

printf "**** Done ****\n"
