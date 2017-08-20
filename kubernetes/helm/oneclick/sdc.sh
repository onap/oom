#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "SDC....\n"
$KUBECTL_CMD/sdc-es.yaml
$KUBECTL_CMD/sdc-cs.yaml
$KUBECTL_CMD/sdc-kb.yaml
$KUBECTL_CMD/sdc-be.yaml
$KUBECTL_CMD/sdc-fe.yaml
