#!/bin/bash

DOCKER_VERSION=18.09.5

apt-get update

curl https://releases.rancher.com/install-docker/$DOCKER_VERSION.sh | sh
mkdir -p /etc/systemd/system/docker.service.d/
cat > /etc/systemd/system/docker.service.d/docker.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --insecure-registry=nexus3.onap.org:10001
EOF

sudo usermod -aG docker ubuntu

systemctl daemon-reload
systemctl restart docker
apt-mark hold docker-ce

IP_ADDR=`ip address |grep ens|grep inet|awk '{print $2}'| awk -F / '{print $1}'`
HOSTNAME=`hostname`

echo "$IP_ADDR $HOSTNAME" >> /etc/hosts

docker login -u docker -p docker nexus3.onap.org:10001

sudo apt-get install make -y

# install nfs
sudo apt-get install nfs-common -y


exit 0
