#!/bin/bash
helm delete onap-$2 --purge
kubectl delete namespace onap-$2
kubectl delete clusterrolebinding onap-$2-admin-binding



