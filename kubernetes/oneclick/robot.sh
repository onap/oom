#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "Robot....\n"
$KUBECTL_CMD/robot-deployment.yaml
