#!/bin/bash -e
DNS_PORT=31555
CLUSTER_CONTROL=$( kubectl get no -l node-role.kubernetes.io/controlplane=true -o jsonpath='{.items..metadata.name}')
CLUSTER_IP=$(kubectl get no $CLUSTER_CONTROL  -o jsonpath='{.metadata.annotations.rke\.cattle\.io/external-ip }')
SPATH="$( dirname "$( which "$0" )" )"
pushd "$SPATH/bind9dns" > /dev/null
helm install . --set dnsconf.wildcard="simpledemo.onap.org=$CLUSTER_IP"
popd > /dev/null
cat << ==infodeploy
Extra DNS server already deployed:
1. You can add the DNS server to the target machine using following commands:
	sudo iptables -t nat -A OUTPUT -p tcp -d 66.66.66.66 --dport 53 -j DNAT --to-destination $CLUSTER_IP:$DNS_PORT
	sudo iptables -t nat -A OUTPUT -p udp -d 66.66.66.66 --dport 53 -j DNAT --to-destination $CLUSTER_IP:$DNS_PORT
	sudo sysctl -w net.ipv4.conf.all.route_localnet=1
	sudo sysctl -w net.ipv4.ip_forward=1
2. Update /etc/resolv.conf file with nameserver 66.66.66.66 entry on your target machine
==infodeploy
