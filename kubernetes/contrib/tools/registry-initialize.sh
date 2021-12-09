#!/bin/sh -x

# Copyright (c) 2021 AT&T. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Pre-requisite
# 1. Chart packages available under local directory provided as input/argument
# 2. helm client installed with push plugin
# 3. ONAP chartmuseum service deployed

usage()
{
    echo "Chart Base directory or helm chart from local repo must be provided as input!!"
    echo "Usage: registry-initialize.sh  -d chartdirectory \
<-n namespace override> <-r helmrelease override> <-p chart name prefix> | <-h helm charts from local repo>"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

# defaults
NAMESPACE=onap
RLS_NAME=onap
LOGIN=""
PASSWORD=""
PREF=""
HELM_REPO=local

while getopts ":d:n:r:p:h:c:" opt; do
    case $opt in
        d) BASEDIR="$OPTARG"
        ;;
        n) NAMESPACE="$OPTARG"
        ;;
        r) RLS_NAME="$OPTARG"
        ;;
        p) PREF="$OPTARG"
        ;;
        h) HELM_CHART="$OPTARG"
        ;;
        c) HELM_REPO="$OPTARG"
        ;;
        \?) echo "Invalid option -$OPTARG" >&2
        usage
        ;;
   esac
done


if  [ -z "$BASEDIR" ] && [ -z "$HELM_CHART" ] ; then
    echo "Chart base directory provided $BASEDIR and helm chart from local repo is empty"
    exit
fi

if  [ -n "$BASEDIR" ] && [ -n "$HELM_CHART" ] ; then
    echo "Both chart base directory $BASEDIR and helm chart from local repo $HELM_CHART cannot be used at the same time "
    exit
fi

if  [ -n "$BASEDIR" ]; then
    if [ "$(find $BASEDIR -maxdepth 1 -name '*tgz' -print -quit)" ]; then
        echo "$BASEDIR valid"
    else
        echo "No chart package on $BASEDIR provided"
        exit
    fi
fi

if  [ -n "$HELM_CHART" ]; then
    tmp_location=$(mktemp -d)
    helm pull $HELM_REPO/$HELM_CHART -d $tmp_location
    if [ $? -eq 0 ]; then
        echo "Helm chart $HELM_CHART has been pulled out from in $HELM_REPO repo"
        BASEDIR=$tmp_location
    else
        echo "No chart package $HELM_CHART on $HELM_REPO repo"
        exit
    fi
fi

if  [ -z "$PREF" ] && [ -z "$HELM_CHART" ] ; then
    PREF=dcae
fi

LOGIN=$(kubectl -n "$NAMESPACE" get secret \
 "${RLS_NAME}-chartmuseum-registrycred" \
 -o jsonpath='{.data.login}' | base64 -d)

PASSWORD=$(kubectl -n "$NAMESPACE" get secret \
 "${RLS_NAME}-chartmuseum-registrycred" \
 -o jsonpath='{.data.password}' | base64 -d)

if [ -z "$LOGIN" ] || [ -z "$PASSWORD" ]; then
    echo "Login/Password credential for target registry cannot be retrieved"
    exit 1
fi

# Expose cluster port via port-forwarding
kubectl -n $NAMESPACE port-forward service/chart-museum 27017:80 &
if [ $? -ne 0 ]; then
    echo "Error in port forwarding; registry cannot be added!!"
    exit 1
fi

sleep 5

# Add chartmuseum repo as helm repo
# Credentials should match config defined in
# oom\kubernetes\platform\components\chartmuseum\values.yaml
helm repo add k8s-registry http://127.0.0.1:27017 --username "$LOGIN" \
 --password "$PASSWORD"
if [ $? -ne 0 ]; then
    echo "registry cannot be added!!"
    pkill -f "port-forward service/chart-museum"
    exit 1
fi

# Initial scope is pushing only dcae charts
# can be expanded to include all onap charts if required
for file in $BASEDIR/$PREF*tgz; do
    # use helm plugin to push charts
    helm push $file k8s-registry
    if [ $? -eq 0 ]; then
        echo "$file uploaded to registry successfully"
    else
        echo "registry upload failed!!"
        pkill -f "port-forward service/chart-museum"
        helm repo remove k8s-registry
        exit 1
    fi
done

echo "All Helm charts successfully uploaded into internal repository"

# Remove the port-forwarding process
pkill -f "port-forward service/chart-museum"

# Remove helm registry from local
helm repo remove k8s-registry
