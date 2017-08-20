#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "VID....\n"
$KUBECTL_CMD/vid-mariadb-deployment.yaml
$KUBECTL_CMD/vid-server-deployment.yaml
