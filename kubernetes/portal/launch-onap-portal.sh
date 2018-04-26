#!/bin/bash

usage () { echo "Usage : $0 <namespace> <helm release name>"; }

READY_JSONPATH='{range .items[*]}{@.metadata.name}:{range @.status.conditions[*]}{@.type}={@.status};{end}{end}'

NAMESPACE=$1
RELEASE_NAME=$2

if [ ! "$NAMESPACE" ] || [ ! "$RELEASE_NAME" ]
then
  usage
  exit 1
fi

PORTAL_POD_NAME=`kubectl get pods --namespace $NAMESPACE --selector=app=portal-app,release=$RELEASE_NAME \
-o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True"|awk -F: '{print $1}' `
SDC_POD_NAME=`kubectl get pods --namespace $NAMESPACE --selector=app=sdc-fe,release=$RELEASE_NAME \
-o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True" |awk -F: '{print $1}'`
VID_POD_NAME=`kubectl get pods --namespace $NAMESPACE --selector=app=vid,release=$RELEASE_NAME \
-o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True" |awk -F: '{print $1}'`
POLICY_POD_NAME=`kubectl get pods --namespace $NAMESPACE --selector=app=pap,release=$RELEASE_NAME \
-o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True" |awk -F: '{print $1}'`
PORTALSDK_POD_NAME=`kubectl get pods --namespace $NAMESPACE --selector=app=portal-sdk,release=$RELEASE_NAME \
-o jsonpath='{.items[*].metadata.name}' -o jsonpath="$READY_JSONPATH" | grep "Ready=True" |awk -F: '{print $1}'`

#TODO: Add more as testing progresses
[[ -z "$PORTAL_POD_NAME" ]] && { echo "WARNING: portal-app is not running in your Kubernetes cluster"; }
[[ -z "$SDC_POD_NAME" ]] && { echo "WARNING: sdc-fe is not running in your Kubernetes cluster"; }
[[ -z "$VID_POD_NAME" ]] && { echo "WARNING: vid is not running in your Kubernetes cluster"; }
[[ -z "$POLICY_POD_NAME" ]] && { echo "WARNING: pap is not running in your Kubernetes cluster"; }
[[ -z "$PORTALSDK_POD_NAME" ]] && { echo "WARNING: portal-sdk is not running in your Kubernetes cluster"; }

if [ ! -z "$PORTAL_POD_NAME" ]
then
  kubectl -n $NAMESPACE port-forward "$PORTAL_POD_NAME" 8989:8080 &
  PORTAL_PID=$!
fi

if [ ! -z "$VID_POD_NAME" ]
then
  kubectl -n $NAMESPACE port-forward "$VID_POD_NAME" 8080:8080 &
  VID_PID=$!
fi

if [ ! -z "$SDC_POD_NAME" ]
then
  kubectl -n $NAMESPACE port-forward "$SDC_POD_NAME" 8181:8181 &
  SDC_PID=$!
fi

if [ ! -z "$POLICY_POD_NAME" ]
then
  kubectl -n $NAMESPACE port-forward "$POLICY_POD_NAME" 8443:8443 &
  POLICY_PID=$!
fi

if [ ! -z "$PORTALSDK_POD_NAME" ]
then
  kubectl -n $NAMESPACE port-forward "$PORTALSDK_POD_NAME" 8990:8080 &
  PORTALSDK_PID=$!
fi

trap "{ kill -9 $PORTAL_PID $VID_PID $SDC_PID $POLICY_PID $PORTALSDK_PID; exit 0; }" INT
echo -e $'Press Ctrl+C to exit...\n'

while :
do
  sleep 60
done