#/bin/bash
set -x

function configure_dns_designate() {
    # Check whether the SIMPLEDEMO_ONAP_ORG_ZONE_ID exists
    EXISTING_ZONES=`openstack zone list -f=yaml -c=name | awk ' { print$3 } '`
    if [[ $EXISTING_ZONES =~ (^|[[:space:]])$SIMPLEDEMO_ONAP_ORG_ZONE_NAME($|[[:space:]]) ]]
    then
        echo "Zone $SIMPLEDEMO_ONAP_ORG_ZONE_NAME already exist, retrieving it's ID."
        SIMPLEDEMO_ONAP_ORG_ZONE_ID=`openstack zone list -f=yaml --name=simpledemo.onap.org. -c=id | awk ' { print $3 } '`
        echo "Zone $SIMPLEDEMO_ONAP_ORG_ZONE_NAME id is: $SIMPLEDEMO_ONAP_ORG_ZONE_ID"
    else
        echo "Zone $SIMPLEDEMO_ONAP_ORG_ZONE_NAME doens't exist, creating ..."
        SIMPLEDEMO_ONAP_ORG_ZONE_ID=`openstack zone create --email=oom@onap.org --description="DNS zone bridging DCAE and OOM" --type=PRIMARY $SIMPLEDEMO_ONAP_ORG_ZONE_NAME -f=yaml -c id | awk '{ print $2} '`

        echo "Create recordSet for $SIMPLEDEMO_ONAP_ORG_ZONE_NAME"
        openstack recordset create --type=A --ttl=10 --records=$NODE_IP $SIMPLEDEMO_ONAP_ORG_ZONE_ID vm1.aai
        openstack recordset create --type=A --ttl=10 --records=$NODE_IP $SIMPLEDEMO_ONAP_ORG_ZONE_ID vm1.sdc
        openstack recordset create --type=A --ttl=10 --records=$NODE_IP $SIMPLEDEMO_ONAP_ORG_ZONE_ID vm1.mr
        openstack recordset create --type=A --ttl=10 --records=$NODE_IP $SIMPLEDEMO_ONAP_ORG_ZONE_ID vm1.policy
        openstack recordset create --type=A --ttl=10 --records=$NODE_IP $SIMPLEDEMO_ONAP_ORG_ZONE_ID vm1.openo

        echo "Create CNAMEs for $SIMPLEDEMO_ONAP_ORG_ZONE_NAME"
        # AAI
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.aai.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c1.vm1.aai.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.aai.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c2.vm1.aai.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.aai.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c3.vm1.aai.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.aai.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID aai.api.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.aai.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID aai.ui.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.aai.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID aai.searchservice.$RANDOM_STRING.simpledemo.onap.org.

        # SDC
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.sdc.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c1.vm1.sdc.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.sdc.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c2.vm1.sdc.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.sdc.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c3.vm1.sdc.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.sdc.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c4.vm1.sdc.$RANDOM_STRING.simpledemo.onap.org.

        # Policy
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c1.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c2.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c3.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c4.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c5.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c6.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c7.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID c8.vm1.policy.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.policy.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID policy.api.$RANDOM_STRING.simpledemo.onap.org.

        # MR
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.mr.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID ueb.api.$RANDOM_STRING.simpledemo.onap.org.

        # Open-O
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.openo.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID msb.api.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.openo.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID mvim.api.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.openo.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID vnfsdk.api.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.openo.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID vfc.api.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.openo.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID uui.api.$RANDOM_STRING.simpledemo.onap.org.
        openstack recordset create --type=CNAME --ttl=86400 --records=vm1.openo.$RANDOM_STRING.simpledemo.onap.org. $SIMPLEDEMO_ONAP_ORG_ZONE_ID esr.api.$RANDOM_STRING.simpledemo.onap.org.
    fi
}

function monitor_nginx_node_ip() {
    echo "Monitor DCAE nginx host ip..."
    while true
    do
        # Get the Kubernetes Node IP hosting the DCAE NGINX pod
        NODE_IP=`kubectl get services dcaegen2 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`

        # Lookup the IP for the first DNS record entry
        # Assumption is made all entried are sharing the same IP, hence if the first one is different
        # We update the whole table
        CURRENT_NODE_IP=`openstack recordset list $SIMPLEDEMO_ONAP_ORG_ZONE_ID -c records --type=A -f yaml | head -n 1 | awk ' { print $3 } '`

        if [ "$NODE_IP" != "$CURRENT_NODE_IP" ]; then
            refresh_dns_records
        fi

        # refresh every 10 seconds
        sleep 10
    done
}

function refresh_dns_records() {
    echo "DCAE nginx host ip has changed, update DNS records..."
    # Get the Kubernetes Node IP hosting the DCAE NGINX pod
    NODE_IP=`kubectl get services dcaegen2 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`

    # Update all the simpledemo record
    SIMPLEDEMO_ONAP_ORG_RECORD_TYPE_A_IDS=`openstack recordset list $SIMPLEDEMO_ONAP_ORG_ZONE_ID --type=A -c=id -f=yaml | awk ' { print $3 } '`
    for record_id in $SIMPLEDEMO_ONAP_ORG_RECORD_TYPE_A_IDS
    do
        openstack recordset set --records=$NODE_IP $SIMPLEDEMO_ONAP_ORG_ZONE_ID $record_id
    done
}

#############################################################################################################
#                                           Script starts here                                              #
#############################################################################################################

# Retrieve the namespace
if [ "$#" -ne 1 ]; then
	echo "Usage: $(basename $0) <namespace>"
	exit 1
fi
NAMESPACE=$1

# K8S variable
MR_ZONE="$NAMESPACE-message-router"

# Heat variable
STACK_NAME="dcae"

# DNS variables
SIMPLEDEMO_ONAP_ORG_ZONE_NAME="simpledemo.onap.org."
SIMPLEDEMO_ONAP_ORG_ZONE_ID=""
RANDOM_STRING=""

# Install required packages to interfact with OpenStack CLIs
apt update -y
apt -y install python-pip
pip install python-openstackclient
pip install python-heatclient
pip install python-designateclient

# Instal kubectl commands
apt -y install curl
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl

# Get the Kubernetes Node IP hosting the DCAE NGINX pod
NODE_IP=`kubectl get services dcaegen2 -o jsonpath='{.status.loadBalancer.ingress[0].ip}'`

# Source OpenStack parameters to deploy DCAE
if [ "DCAE_OS_API_VERSION_HERE" = "v2.0" ]
then
    source /opt/heat/DCAE-openrc-v2.sh
else
    source /opt/heat/DCAE-openrc-v3.sh
fi

# Create stasck if doens't exist
EXISTING_STACKS=`openstack stack list -c 'Stack Name' -f yaml | awk '{ print $4}'`
if ! [[ $EXISTING_STACKS =~ (^|[[:space:]])$STACK_NAME($|[[:space:]]) ]]
then
    # create the DCAE stack
    openstack stack create -t /opt/heat/onap_dcae.yaml -e /opt/heat/onap_dcae.env $STACK_NAME

    # wait 10 seconds to let the stack start, so the ips have been assigned.
    sleep 10

    # get the DCAE Boostrap VM ip, to configure Robot with it, for Healthcheck
    DCAE_CONTROLLER_IP=`openstack stack output show $STACK_NAME dcae_floating_ip -c output_value -f yaml | awk '{ print $2}'`
    sed -i -e "s/DCAE_CONTROLLER_IP_HERE/$DCAE_CONTROLLER_IP/g" /opt/robot/vm_properties.py;

    # Retrieve current deployment random string
    RANDOM_STRING=`openstack stack output show $STACK_NAME random_string -c output_value -f yaml | awk '{ print $2}'`
    SIMPLEDEMO_ONAP_ORG_ZONE_NAME="$RANDOM_STRING.$SIMPLEDEMO_ONAP_ORG_ZONE_NAME"
fi

# Source OpenStack parameters for DNS Designate
if [ "DNSAAS_API_VERSION_HERE" = "v2.0" ]
then
    source /opt/heat/DNS-openrc-v2.sh
else
    source /opt/heat/DNS-openrc-v3.sh
fi

configure_dns_designate

monitor_nginx_node_ip