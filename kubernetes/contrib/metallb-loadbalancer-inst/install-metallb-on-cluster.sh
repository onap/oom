#!/bin/sh -e

#
#   Copyright 2020 Samsung Electronics Co., Ltd.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

usage()
{
cat << ==usage
$0 Automatic configuration using external addresess from nodes
$0 --help This message
$0 -h This message
$0 [cluster_ip1] ... [cluster_ipn]  Cluster address or ip ranges
==usage
}


find_nodes_with_external_addrs()
{
    local WORKER_NODES
    WORKER_NODES=$(kubectl get no -l node-role.kubernetes.io/worker=true -o jsonpath='{.items..metadata.name}')
    for worker in $WORKER_NODES; do
        local external_ip
        external_ip=$(kubectl get no $worker  -o jsonpath='{.metadata.annotations.rke\.cattle\.io/external-ip }')
        local internal_ip
        internal_ip=$(kubectl get no $worker  -o jsonpath='{.metadata.annotations.rke\.cattle\.io/internal-ip }')
        if [ $internal_ip != $external_ip ]; then
            echo $external_ip
        fi
    done
}

generate_config_map()
{
cat <<CNFEOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: metallb-system
  name: config
data:
  config: |
    address-pools:
    - name: default
      protocol: layer2
      addresses:
$(for value in "$@"; do echo -e "      - $value"; done)
CNFEOF
}

generate_config_from_single_addr() {
    generate_config_map "$1 - $1"
}

install_metallb() {
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/namespace.yaml
    kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.9.3/manifests/metallb.yaml
    # Only when install
    kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
}

automatic_configuration() {
    install_metallb
    generate_config_from_single_addr $(find_nodes_with_external_addrs)
}

manual_configuration() {
    install_metallb
    generate_config_map $@
}

if [ $# -eq 1 ] && [ "$1" = "-h" ]; then
    usage
if [ $# -eq 1 ] && [ "$1" = "--help" ]; then
    usage
elif [ $# -eq 0 ]; then
    automatic_configuration
else
    manual_configuration $@
fi
