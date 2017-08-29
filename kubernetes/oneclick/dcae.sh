#!/bin/bash
# manual deployment order is mentioned - but we need to specify dependencies in the service
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "dcae....\n"
$KUBECTL_CMD/message-router/dcae-zookeeper.yaml
$KUBECTL_CMD/message-router/dcae-kafka.yaml
$KUBECTL_CMD/message-router/dcae-dmaap.yaml

$KUBECTL_CMD/pgaas/pgaas.yaml

$KUBECTL_CMD/dcae-collector-common-event.yaml
$KUBECTL_CMD/dcae-collector-dmaapbc.yaml
$KUBECTL_CMD/dcae-collector-pvs.yaml

$KUBECTL_CMD/cdap/cdap0-dep.yaml
$KUBECTL_CMD/cdap/cdap1-dep.yaml
$KUBECTL_CMD/cdap/cdap2-dep.yaml