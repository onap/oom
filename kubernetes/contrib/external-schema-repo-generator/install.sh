#!/bin/bash

# ============LICENSE_START=======================================================
# VES
# ================================================================================
# Copyright (C) 2020 Nokia. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#      http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================

# Arguments renaming
SPEC_CONFIGMAP_FILENAME=$1
K8S_CONFIGMAP_NAME=$2

# Constants
MAX_SPEC_SIZE=262144
KUBECTL_ONAP="kubectl -n onap"

uploadConfigMap() {
  local SPEC_SIZE=$(stat --printf="%s" "$SPEC_CONFIGMAP_FILENAME")
  if [ "$SPEC_SIZE" -ge $MAX_SPEC_SIZE ]; then
    echo "ConfigMap spec file is too long for 'kubectl apply'. Actual spec length: $SPEC_SIZE, max spec lenth: $MAX_SPEC_SIZE"
    echo "Creating new ConfigMap $K8S_CONFIGMAP_NAME"
    $KUBECTL_ONAP create -f "$SPEC_CONFIGMAP_FILENAME"
  else
    echo "Applying ConfigMap $K8S_CONFIGMAP_NAME"
    $KUBECTL_ONAP apply -f "$SPEC_CONFIGMAP_FILENAME"
  fi
}

uploadConfigMap