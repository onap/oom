#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "Portal....\n"
$KUBECTL_CMD/portal-mariadb-deployment.yaml
$KUBECTL_CMD/portal-apps-deployment.yaml
$KUBECTL_CMD/portal-widgets-deployment.yaml
$KUBECTL_CMD/portal-vnc-dep.yaml
