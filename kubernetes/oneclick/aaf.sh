#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "AAF....\n"

$KUBECTL_CMD/aaf-deployment.yaml
$KUBECTL_CMD/aaf-cs-deployment.yaml
