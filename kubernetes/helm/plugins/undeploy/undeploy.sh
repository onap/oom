#!/bin/bash

usage() {
cat << EOF
Delete an umbrella Helm Chart, and its subcharts, that was previously deployed using 'Helm deploy'.

Example of deleting all Releases that have the prefix 'demo'.
  $ helm undeploy demo

  $ helm undeploy demo --purge

Usage:
  helm undeploy [RELEASE] [flags]

Flags:
      --purge     remove the releases from the store and make its name free for later use
EOF
}

undeploy() {
  RELEASE=$1
  FLAGS=$2

  array=($(helm ls -q --all | grep $RELEASE))
  n=${#array[*]}
  for (( i = n-1; i >= 0; i-- ))
  do
    helm del "${array[i]}" $FLAGS
  done
}

if [[ $# < 1 ]]; then
  echo "Error: command 'undeploy' requires a release name"
  exit 0
fi

case "${1:-"help"}" in
  "help")
    usage
    ;;
  "--help")
    usage
    ;;
  "-h")
    usage
    ;;
  *)
    undeploy $1 ${@:2}
    ;;
esac

exit 0