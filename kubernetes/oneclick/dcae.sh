#!/bin/bash
# manual deployment order is mentioned - but we need to specify dependencies in the service
kubectl --namespace=onap-dcae create -f message-router/dcae-zookeeper.yaml
kubectl --namespace=onap-dcae create -f message-router/dcae-kafka.yaml
kubectl --namespace=onap-dcae create -f message-router/dcae-dmaap.yaml

#pgass/setup.sh
kubectl --namespace=onap-dcae create -f pgaas/pgaas.yaml

kubectl --namespace=onap-dcae create -f dcae-collector-common-event.yaml
kubectl --namespace=onap-dcae create -f dcae-collector-dmaapbc.yaml
kubectl --namespace=onap-dcae create -f dcae-collector-pvs.yaml
# not required (no secondary orchestration for DCAE)
#kubectl --namespace=onap-dcae create -f dcae-controller.yaml
#kubectl --namespace=onap-dcae create -f dcae-controller-pvs.yaml
kubectl --namespace=onap-dcae create -f dcae-dcae.yaml

#cdap/deploy-cdap-k8s.sh
kubectl --namespace=onap-dcae create -f cdap/cdap0-dep.yaml
kubectl --namespace=onap-dcae create -f cdap/cdap1-dep.yaml
kubectl --namespace=onap-dcae create -f cdap/cdap2-dep.yaml
