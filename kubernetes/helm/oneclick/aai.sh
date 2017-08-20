#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "AAI....\n"
$KUBECTL_CMD/hbase-deployment.yaml
$KUBECTL_CMD/aai-deployment.yaml
$KUBECTL_CMD/modelloader-deployment.yaml
