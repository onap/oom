#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "Message Router....\n"
$KUBECTL_CMD/message-router-zookeeper.yaml
$KUBECTL_CMD/message-router-kafka.yaml
$KUBECTL_CMD/message-router-dmaap.yaml
