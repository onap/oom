#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "SDNC....\n"
$KUBECTL_CMD/db-deployment.yaml
$KUBECTL_CMD/sdnc-deployment.yaml
$KUBECTL_CMD/dgbuilder-deployment.yaml
$KUBECTL_CMD/web-deployment.yaml
