#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "Portal....\n"
$KUBECTL_CMD/cli-deployment.yaml
