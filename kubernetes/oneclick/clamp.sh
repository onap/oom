#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "CLAMP....\n"

$KUBECTL_CMD/clamp-maraidb-deployment.yaml
$KUBECTL_CMD/clamp-deployment.yaml
