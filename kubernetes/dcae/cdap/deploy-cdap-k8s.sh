#!/bin/bash

kubectl --namespace=onap-dcae create -f cdap0-dep.yaml

kubectl --namespace=onap-dcae create -f cdap1-dep.yaml

kubectl --namespace=onap-dcae create -f cdap2-dep.yaml