#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "MSO....\n"

$KUBECTL_CMD/db-deployment.yaml
$KUBECTL_CMD/mso-deployment.yaml
