#!/bin/bash
#############################################################################
# Copyright © 2019 Bell.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################################################################
#
# This installation is for an RKE install of kubernetes
# after this run the standard oom install
# this installation can be run on amy ubuntu 16.04 VM, RHEL 7.6 (root only), physical or cloud azure/aws host
# https://wiki.onap.org/display/DW/OOM+RKE+Kubernetes+Deployment
# source from https://jira.onap.org/browse/OOM-1598
#
# master/dublin 
#     Rancher 1.6.25, Kubernetes 1.11.5, kubectl 1.11.5, Helm 2.9.1, Docker 17.03

usage() {
cat <<EOF
Usage: $0 [PARAMs]
example
sudo ./rke_setup.sh -b dublin -s rke.onap.cloud -e onap -l amdocs -v true
-u                  : Display usage
-b [branch]         : branch = master or dublin (required)
-s [server]         : server = IP or DNS name (required)
-e [environment]    : use the default (onap)
-l [username]       : login username account (use ubuntu for example)
EOF
}

install_onap() {
  #constants
  PORT=8880
  if [ "$BRANCH" == "dublin" ]; then
    KUBERNETES_VERSION=
    RKE_VERSION=0.1.15
    KUBECTL_VERSION=1.11.3
    HELM_VERSION=2.9.1
    DOCKER_VERSION=17.03
  else
    KUBERNETES_VERSION=
    RKE_VERSION=0.1.16
    KUBECTL_VERSION=1.11.6
    HELM_VERSION=2.9.1
    DOCKER_VERSION=18.06
  fi
 
  # copy your private ssh key and cluster.yml file to the vm
  # on your dev machine
  #sudo cp ~/.ssh/onap_rsa .
  #sudo chmod 777 onap_rsa 
  #scp onap_rsa ubuntu@192.168.241.132:~/
  # on this vm
  #sudo chmod 400 onap_rsa 
  #sudo cp onap_rsa ~/.ssh
  # make sure public key is insetup correctly in 
  # sudo vi ~/.ssh/authorized_keys

  echo "please supply your ssh key in the path specified in your supplied cluster.yml"
  echo "generate your RKE version specific cluster.yaml (note the docker versions are specific the RKE version) by answering all the questions via..."
  echo "rke config --name cluster.yml"
  echo "specifically"
  echo "address: IP or DNS name"
  echo "user: "
  echo "ssh_key_path: - both top level and in each node" 
  
  RKETOOLS=
  HYPERCUBE=
  POD_INFRA_CONTAINER=
  if [ "$RKE_VERSION" == "0.1.16" ]; then  
    RKETOOLS=0.1.15
    HYPERCUBE=1.11.6-rancher1
    POD_INFRA_CONTAINER=rancher/pause-amd64:3.1
  else
    # 0.1.15
    RKETOOLS=0.1.14
    HYPERCUBE=1.11.3-rancher1
    POD_INFRA_CONTAINER=gcr.io.google_containers/pause-amd64:3.1
  fi

  cat > cluster.yml <<EOF
# generated from rke_setup.sh
nodes:
- address: $SERVER
  port: "22"
  internal_address: ""
  role:
  - controlplane
  - worker
  - etcd
  hostname_override: ""
  user: $USERNAME
  docker_socket: /var/run/docker.sock
  ssh_key: ""
  ssh_key_path: $SSHPATH
  labels: {}
services:
  etcd:
    image: ""
    extra_args: {}
    extra_binds: []
    extra_env: []
    external_urls: []
    ca_cert: ""
    cert: ""
    key: ""
    path: ""
    snapshot: null
    retention: ""
    creation: ""
  kube-api:
    image: ""
    extra_args: {}
    extra_binds: []
    extra_env: []
    service_cluster_ip_range: 10.43.0.0/16
    service_node_port_range: ""
    pod_security_policy: false
  kube-controller:
    image: ""
    extra_args: {}
    extra_binds: []
    extra_env: []
    cluster_cidr: 10.42.0.0/16
    service_cluster_ip_range: 10.43.0.0/16
  scheduler:
    image: ""
    extra_args: {}
    extra_binds: []
    extra_env: []
  kubelet:
    image: ""
    extra_args:
      max-pods: 900
    extra_binds: []
    extra_env: []
    cluster_domain: cluster.local
    infra_container_image: ""
    cluster_dns_server: 10.43.0.10
    fail_swap_on: false
  kubeproxy:
    image: ""
    extra_args: {}
    extra_binds: []
    extra_env: []
network:
  plugin: canal
  options: {}
authentication:
  strategy: x509
  options: {}
  sans: []
system_images:
  etcd: rancher/coreos-etcd:v3.2.18
  alpine: rancher/rke-tools:v$RKETOOLS
  nginx_proxy: rancher/rke-tools:v$RKETOOLS
  cert_downloader: rancher/rke-tools:v$RKETOOLS
  kubernetes_services_sidecar: rancher/rke-tools:v$RKETOOLS
  kubedns: rancher/k8s-dns-kube-dns-amd64:1.14.10
  dnsmasq: rancher/k8s-dns-dnsmasq-nanny-amd64:1.14.10
  kubedns_sidecar: rancher/k8s-dns-sidecar-amd64:1.14.10
  kubedns_autoscaler: rancher/cluster-proportional-autoscaler-amd64:1.0.0
  kubernetes: rancher/hyperkube:v$HYPERCUBE
  flannel: rancher/coreos-flannel:v0.10.0
  flannel_cni: rancher/coreos-flannel-cni:v0.3.0
  calico_node: rancher/calico-node:v3.1.3
  calico_cni: rancher/calico-cni:v3.1.3
  calico_controllers: ""
  calico_ctl: rancher/calico-ctl:v2.0.0
  canal_node: rancher/calico-node:v3.1.3
  canal_cni: rancher/calico-cni:v3.1.3
  canal_flannel: rancher/coreos-flannel:v0.10.0
  wave_node: weaveworks/weave-kube:2.1.2
  weave_cni: weaveworks/weave-npc:2.1.2
  pod_infra_container: $POD_INFRA_CONTAINER
  ingress: rancher/nginx-ingress-controller:0.16.2-rancher1
  ingress_backend: rancher/nginx-ingress-controller-defaultbackend:1.4
  metrics_server: rancher/metrics-server-amd64:v0.2.1
ssh_key_path: $SSHPATH
ssh_agent_auth: false
authorization:
  mode: rbac
  options: {}
ignore_docker_version: false
kubernetes_version: "$KUBERNETES_VERSION"
private_registries: []
ingress:
  provider: ""
  options: {}
  node_selector: {}
  extra_args: {}
cluster_name: ""
cloud_provider:
  name: ""
prefix_path: ""
addon_job_timeout: 0
bastion_host:
  address: ""
  port: ""
  user: ""
  ssh_key: ""
  ssh_key_path: ""
monitoring:
  provider: ""
  options: {}
EOF



  echo "Installing on ${SERVER} for ${BRANCH}: RKE: ${RKE_VERSION} Kubectl: ${KUBECTL_VERSION} Helm: ${HELM_VERSION} Docker: ${DOCKER_VERSION} username: ${USERNAME}"
  sudo echo "127.0.0.1 ${SERVER}" >> /etc/hosts
  echo "Install docker - If you must install as non-root - comment out the docker install below - run it separately, run the user mod, logout/login and continue this script"
  curl https://releases.rancher.com/install-docker/$DOCKER_VERSION.sh | sh
  sudo usermod -aG docker $USERNAME

  echo "Install RKE"
  sudo wget https://github.com/rancher/rke/releases/download/v$RKE_VERSION/rke_linux-amd64
  mv rke_linux-amd64 rke
  sudo chmod +x rke
  sudo mv ./rke /usr/local/bin/rke

  echo "Install make - required for beijing+ - installed via yum groupinstall Development Tools in RHEL"
  # ubuntu specific
  sudo apt-get install make -y

  sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
  sudo chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  sudo mkdir ~/.kube
  wget http://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
  sudo tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
  sudo mv linux-amd64/helm /usr/local/bin/helm

  echo "Bringing RKE up - using supplied cluster.yml"
  sudo rke up
  echo "wait 2 extra min for the cluster"
  sleep 60
  echo "1 more min"
  sleep 60
  echo "copy kube_config_cluter.yaml generated - to ~/.kube/config"
  sudo cp kube_config_cluster.yml ~/.kube/config
  # avoid using sudo for kubectl
  sudo chmod 777 ~/.kube/config
  echo "Verify all pods up on the kubernetes system - will return localhost:8080 until a host is added"
  echo "kubectl get pods --all-namespaces"
  kubectl get pods --all-namespaces
  echo "install tiller/helm"
  kubectl -n kube-system create serviceaccount tiller
  kubectl create clusterrolebinding tiller --clusterrole=cluster-admin --serviceaccount=kube-system:tiller
  helm init --service-account tiller
  kubectl -n kube-system  rollout status deploy/tiller-deploy
  echo "upgrade server side of helm in kubernetes"
  if [ "$USERNAME" == "root" ]; then
    helm version
  else
    sudo helm version
  fi
  echo "sleep 30"
  sleep 30
  if [ "$USERNAME" == "root" ]; then
    helm init --upgrade
  else
    sudo helm init --upgrade
  fi
  echo "sleep 30"
  sleep 30
  echo "verify both versions are the same below"
  if [ "$USERNAME" == "root" ]; then
    helm version
  else
    sudo helm version
  fi
  echo "start helm server"
  if [ "$USERNAME" == "root" ]; then
    helm serve &
  else
    sudo helm serve &
  fi
  echo "sleep 30"
  sleep 30
  echo "add local helm repo"
  if [ "$USERNAME" == "root" ]; then
    helm repo add local http://127.0.0.1:8879
    helm repo list
  else
    sudo helm repo add local http://127.0.0.1:8879
    sudo helm repo list
  fi
  echo "To enable grafana dashboard - do this after running cd.sh which brings up onap - or you may get a 302xx port conflict"
  echo "kubectl expose -n kube-system deployment monitoring-grafana --type=LoadBalancer --name monitoring-grafana-client"
  echo "to get the nodeport for a specific VM running grafana"
  echo "kubectl get services --all-namespaces | grep graf"
  sudo docker version
  helm version
  kubectl version
  kubectl get services --all-namespaces
  kubectl get pods --all-namespaces
  echo "finished!"
}

BRANCH=
SERVER=
ENVIRON=
VALIDATE=false
USERNAME=ubuntu
SSHPATH=~/.ssh/onap_rsa

while getopts ":b:s:e:u:l:v" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    b)
      BRANCH=${OPTARG}
      ;;
    e)
      ENVIRON=${OPTARG}
      ;;
    s)
      SERVER=${OPTARG}
      ;;
    l)
      USERNAME=${OPTARG}
      ;;
    v)
      VALIDATE=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
    esac
done

if [[ -z $BRANCH ]]; then
  usage
  exit 1
fi

install_onap $BRANCH $SERVER $ENVIRON $USERNAME $SSHPATH $VALIDATE
