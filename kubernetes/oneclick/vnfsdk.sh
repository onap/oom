#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "VNFSDK....\n"

$KUBECTL_CMD/postgres-deployment.yaml
$KUBECTL_CMD/refrepo-deployment.yaml
