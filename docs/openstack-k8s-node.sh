#!/bin/bash

DOCKER_VERSION=17.03
KUBECTL_VERSION=1.8.10
HELM_VERSION=2.8.2

# setup root access - default login: oom/oom - comment out to restrict access too ssh key only
sed -i 's/PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
service sshd restart
echo -e "oom\noom" | passwd root

apt-get update
curl https://releases.rancher.com/install-docker/$DOCKER_VERSION.sh | sh
mkdir -p /etc/systemd/system/docker.service.d/
cat > /etc/systemd/system/docker.service.d/docker.conf << EOF
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// --insecure-registry=nexus3.onap.org:10001
EOF
systemctl daemon-reload
systemctl restart docker
apt-mark hold docker-ce

IP_ADDY=`ip address |grep ens|grep inet|awk '{print $2}'| awk -F / '{print $1}'`
HOSTNAME=`hostname`

echo "$IP_ADDY $HOSTNAME" >> /etc/hosts

docker login -u docker -p docker nexus3.onap.org:10001

sudo apt-get install make -y

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo mkdir ~/.kube
wget http://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
sudo tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm

# install nfs
sudo apt-get install nfs-common -y


exit 0
