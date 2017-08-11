#!/bin/bash

# CDAP 0
kubectl --namespace=onap-dcae delete deployment cdap0

# CDAP 1
kubectl --namespace=onap-dcae delete deployment cdap1

# CDAP 2
kubectl --namespace=onap-dcae delete deployment cdap2