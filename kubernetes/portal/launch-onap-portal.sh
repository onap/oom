#!/bin/bash

READY_JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'

PORTAL_POD_NAME=`kubectl get pods --namespace onap --selector=app=portal-app -o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True"|awk -F: '{print $1}' `
SDC_POD_NAME=`kubectl get pods --namespace onap --selector=app=sdc-fe -o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True" |awk -F: '{print $1}'`
VID_POD_NAME=`kubectl get pods --namespace onap --selector=app=vid -o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True" |awk -F: '{print $1}'`

#TODO: Add more as testing progresses
[[ -z "$PORTAL_POD_NAME" ]] && { echo "WARNING: portal-app is not running in your Kubernetes cluster"; }
[[ -z "$SDC_POD_NAME" ]] && { echo "WARNING: sdc-fe is not running in your Kubernetes cluster"; }
[[ -z "$VID_POD_NAME" ]] && { echo "WARNING: vid is not running in your Kubernetes cluster"; }

if [ ! -z "$PORTAL_POD_NAME" ]
then
  kubectl -n onap port-forward "$PORTAL_POD_NAME" 8989:8080 &
  PORTAL_PID=$!
fi

if [ ! -z "$VID_POD_NAME" ]
then
  kubectl -n onap port-forward "$VID_POD_NAME" 8080:8080 &
  VID_PID=$!
fi

if [ ! -z "$SDC_POD_NAME" ]
then
  kubectl -n onap port-forward "$SDC_POD_NAME" 8181:8181 &
  SDC_PID=$!
fi

trap "{ kill -9 $PORTAL_PID $VID_PID $SDC_PID; exit 0; }" INT
echo -e $'Press Ctrl+C to exit...\n' 

while :
do
  sleep 60
done