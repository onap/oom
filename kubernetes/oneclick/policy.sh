#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "Policy....\n"

$KUBECTL_CMD/dep-maria.yaml
$KUBECTL_CMD/dep-nexus.yaml
$KUBECTL_CMD/dep-pap.yaml
$KUBECTL_CMD/dep-pdp.yaml
$KUBECTL_CMD/dep-brmsgw.yaml
$KUBECTL_CMD/dep-pypdp.yaml
$KUBECTL_CMD/dep-drools.yaml
