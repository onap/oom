#!/bin/sh

# ============LICENSE_START=======================================================
# OOM
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
spec_configmap_filename=$1
k8s_configmap_name=$2

# Constants
MAX_SPEC_SIZE=262144

# Alias
alias kubectl_onap="kubectl -n onap"

# Checks whether ConfigMap $spec_configmap_filename exists
# When file does not exist exits with return code 1
checkIfSpecExists() {
  if [ ! -f "$spec_configmap_filename" ]; then
    echo "Spec file $spec_configmap_filename does not exist."
    # todo add location of spec with filename
    exit 1
  fi
}

# Uploads ConfigMap spec $spec_configmap_filename to Kubernetes
uploadConfigMap() {
  spec_size=$(stat --printf="%s" "$spec_configmap_filename")
  if [ "$spec_size" -ge $MAX_SPEC_SIZE ]; then
    echo "ConfigMap spec file is too long for 'kubectl apply'. Actual spec length: $spec_size, max spec length: $MAX_SPEC_SIZE"
    echo "Creating new ConfigMap $k8s_configmap_name"
    kubectl_onap create -f "$spec_configmap_filename"
  else
    echo "Applying ConfigMap $k8s_configmap_name"
    kubectl_onap apply -f "$spec_configmap_filename"
  fi
}

main() {
  checkIfSpecExists
  uploadConfigMap
}

main

