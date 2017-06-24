#!/bin/bash

KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "App-c....\n"
$KUBECTL_CMD/db-deployment.yaml
$KUBECTL_CMD/appc-deployment.yaml
$KUBECTL_CMD/dgbuilder-deployment.yaml
