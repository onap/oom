#!/bin/bash

KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "Portal....\n"
$KUBECTL_CMD/framework-deployment.yaml
$KUBECTL_CMD/multicloud-vio-deployment.yaml


