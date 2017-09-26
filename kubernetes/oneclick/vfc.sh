#!/bin/bash
KUBECTL_CMD="kubectl --namespace $1-$2 $3 -f ../$2"

printf "vfc....\n"
$KUBECTL_CMD/vfc-catalog-deployment.yaml
$KUBECTL_CMD/vfc-emsdriver-deployment.yaml
$KUBECTL_CMD/vfc-gvnfmdriver-deployment.yaml
$KUBECTL_CMD/vfc-hwvnfmdriver-deployment.yaml
$KUBECTL_CMD/vfc-jujudriver-deployment.yaml
$KUBECTL_CMD/vfc-nslcm-deployment.yaml
$KUBECTL_CMD/vfc-resmgr-deployment.yaml
$KUBECTL_CMD/vfc-vnflcm-deployment.yaml
$KUBECTL_CMD/vfc-vnfmgr-deployment.yaml
$KUBECTL_CMD/vfc-vnfres-deployment.yaml
$KUBECTL_CMD/vfc-workflow-deployment.yaml
$KUBECTL_CMD/vfc-ztesdncdriver-deployment.yaml
$KUBECTL_CMD/vfc-ztevmanagerdriver-deployment.yaml
