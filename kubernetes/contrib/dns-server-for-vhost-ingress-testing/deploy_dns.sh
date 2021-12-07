#!/bin/sh -e

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
DNS_PORT=31555
CLUSTER_CONTROL=$( kubectl get no -l node-role.kubernetes.io/controlplane=true -o jsonpath='{.items..metadata.name}')
CLUSTER_IP=$(kubectl get no $CLUSTER_CONTROL  -o jsonpath='{.metadata.annotations.rke\.cattle\.io/external-ip }')
SPATH="$( dirname "$( which "$0" )" )"



usage() {
cat << ==usage
$0 [cluster_domain] [lb_ip] [helm_chart_args] ...
    [cluster_domain] Default value simpledemo.onap.org
    [lb_ip] Default value LoadBalancer IP
    [helm_chart_args] ... Optional arguments passed to helm install command
$0 --help This message
$0 --info Display howto configure target machine
==usage
}


target_machine_notice_info()
{
cat << ==infodeploy
Extra DNS server already deployed:
1. You can add the DNS server to the target machine using following commands:
    sudo iptables -t nat -A OUTPUT -p tcp -d 192.168.211.211 --dport 53 -j DNAT --to-destination $CLUSTER_IP:$DNS_PORT
    sudo iptables -t nat -A OUTPUT -p udp -d 192.168.211.211 --dport 53 -j DNAT --to-destination $CLUSTER_IP:$DNS_PORT
    sudo sysctl -w net.ipv4.conf.all.route_localnet=1
    sudo sysctl -w net.ipv4.ip_forward=1
2. Update /etc/resolv.conf file with nameserver 192.168.211.211 entry on your target machine
==infodeploy
}


list_node_with_external_addrs()
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
            break
        fi
    done
}

ingress_controller_ip() {
    local metal_ns
    metal_ns=$(kubectl get ns --no-headers --output=custom-columns=NAME:metadata.name |grep metallb-system)
    if [ -z $metal_ns ]; then
        echo $CLUSTER_IP
    else
        list_node_with_external_addrs
    fi
}

deploy() {
    local ingress_ip
    ingress_ip=$(ingress_controller_ip)
    initdir = $(pwd)
    cd $SPATH/bind9dns
    if [ $# -eq 0 ]; then
        local cl_domain
        cl_domain="simpledemo.onap.org"
    else
        local cl_domain
        cl_domain=$1
        shift
    fi
    if [ $# -ne 0 ]; then
        ingress_ip=$1
        shift
    fi
    helm install . --set dnsconf.wildcard="$cl_domain=$ingress_ip" $@
    cd $initdir
    target_machine_notice_info
}

if [ $# -eq 1 ] && [ "$1" = "-h" ]; then
    usage
elif [ $# -eq 1 ] && [ "$1" = "--help" ]; then
    usage
elif [ $# -eq 1 ] && [ "$1" = "--info" ]; then
       target_machine_notice_info
else
    deploy $@
fi
