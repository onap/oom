#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "UUI....\n"
$KUBECTL_CMD/uui-deployment.yaml
