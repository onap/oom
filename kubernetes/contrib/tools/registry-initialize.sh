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

if [ $# -eq 0 ]; then
    echo "Chart Base directory must be provided as input!!"
    echo "Usage: registry-initialize.sh <chart directory>"
    exit 1
fi


BASEDIR=$1
if [ -z "$BASEDIR" ]; then
    exit "Chart base directory provided $BASEDIR is empty"
fi


if [ "$(find $BASEDIR -maxdepth 1 -name '*tgz' -print -quit)" ]; then
    echo "$BASEDIR valid"
else
    exit "No chart package on $BASEDIR provided"
fi

# Expose cluster port via port-forwarding
kubectl -n onap port-forward service/chart-museum 27017:80 &
if [ $? -ne 0 ]; then
    echo "Error in portforwarding; registry cannot be added!!"
    exit 1
fi

sleep 5

# Add chartmuseum repo as helm repo
# Credentials should match config defined in oom\kubernetes\platform\components\chartmuseum\values.yaml
helm repo add k8s-registry http://127.0.0.1:27017 --username "onapintializer" --password "demo123456!"
if [ $? -ne 0 ]; then
    echo "registry cannot be added!!"
    pkill -f "port-forward service/chart-museum"
    exit 1
fi

# Initial scope is pushing only dcae charts
# can be expanded to include all onap charts if required
for file in $BASEDIR/dcae*tgz; do
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
