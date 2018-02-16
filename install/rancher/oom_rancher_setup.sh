#/**
#* ============LICENSE_START=======================================================
#* org.onap.oom
#* ================================================================================
#* Copyright © 2018 Amdocs
#* All rights reserved.
#* ================================================================================
#* Licensed under the Apache License, Version 2.0 (the "License");
#* you may not use this file except in compliance with the License.
#* You may obtain a copy of the License at
#*
#*    http://www.apache.org/licenses/LICENSE-2.0
#*
#* Unless required by applicable law or agreed to in writing, software
#* distributed under the License is distributed on an "AS IS" BASIS,
#* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#* See the License for the specific language governing permissions and
#* limitations under the License.
#* ============LICENSE_END=========================================================
#*/
#
# This installation is for a rancher managed install of kubernetes
# after this run the standard oom install
# this installation can be run on amy ubuntu 16.04 VM or physical host
# https://wiki.onap.org/display/DW/ONAP+on+Kubernetes
# Amsterdam
#     Rancher 1.6.10, Kubernetes 1.7.7, Kubectl 1.7.7, Helm 2.3.0, Docker 1.12
# master
#     Rancher 1.6.14, Kubernetes 1.8.6, Kubectl 1.8.6, Helm 2.6.1, Docker 17.03
# run as root - because of the logout that would be required after the docker user set

usage() {
cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-b [branch]         : branch = master or amsterdam (required)
-s [server]         : server = IP or DNS name (required)
EOF
}

install_onap() {

  if [ "$BRANCH" == "amsterdam" ]; then
    RANCHER_VERSION=1.6.10
    KUBECTL_VERSION=1.7.7
    HELM_VERSION=2.3.0
    DOCKER_VERSION=1.12
  else
    RANCHER_VERSION=1.6.14
    KUBECTL_VERSION=1.8.6
    HELM_VERSION=2.6.1
    DOCKER_VERSION=17.03
  fi

  echo "Installing on ${SERVER} for ${BRANCH}: Rancher: ${RANCHER_VERSION} Kubectl: ${KUBECTL_VERSION} Helm: ${HELM_VERSION} Docker: ${DOCKER_VERSION}"
  curl https://releases.rancher.com/install-docker/$DOCKER_VERSION.sh | sh
  # when running as non-root (ubuntu) run the following and logout/log back in
  sudo usermod -aG docker ubuntu
  docker run -d --restart=unless-stopped -p 8880:8080 --name rancher_server rancher/server:v$RANCHER_VERSION
  curl -LO https://storage.googleapis.com/kubernetes-release/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  mkdir ~/.kube
  wget http://storage.googleapis.com/kubernetes-helm/helm-v${HELM_VERSION}-linux-amd64.tar.gz
  tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
  sudo mv linux-amd64/helm /usr/local/bin/helm

  # create kubernetes environment on rancher using cli
  RANCHER_CLI_VER=0.6.7
  KUBE_ENV_NAME=onap
  wget https://releases.rancher.com/cli/v${RANCHER_CLI_VER}/rancher-linux-amd64-v${RANCHER_CLI_VER}.tar.gz
  tar -zxvf rancher-linux-amd64-v${RANCHER_CLI_VER}.tar.gz
  cp rancher-v${RANCHER_CLI_VER}/rancher .
  chmod +x ./rancher

  apt install jq -y
  APIRESPONSE=`curl -s 'http://127.0.0.1:8880/v2-beta/apikey' -d '{"type":"apikey","accountId":"1a1","name":"autoinstall","description":"autoinstall","created":null,"kind":null,"removeTime":null,"removed":null,"uuid":null}'`
  # Extract and store token
  echo "APIRESPONSE: $APIRESPONSE"
  KEY_PUBLIC=`echo $APIRESPONSE | jq -r .publicValue`
  KEY_SECRET=`echo $APIRESPONSE | jq -r .secretValue`
  echo "publicValue: $KEY_PUBLIC secretValue: $KEY_SECRET"

  export RANCHER_URL=http://${SERVER}:8880
  export RANCHER_ACCESS_KEY=$KEY_PUBLIC
  export RANCHER_SECRET_KEY=$KEY_SECRET
  ./rancher env ls
  echo "Creating kubernetes environment named ${KUBE_ENV_NAME}"
  ./rancher env create -t kubernetes $KUBE_ENV_NAME > kube_env_id.json
  ./rancher env ls

  # pending create of client host
  # see https://wiki.onap.org/display/DW/ONAP+on+Kubernetes#ONAPonKubernetes-Registeryourhost
  # pending token and paste to
  #vi ~/.kube/config
  echo "run the following after attaching the host if you installed a higher kubectl version than the server"
  echo "helm init --upgrade"
}

BRANCH=
SERVER=

while getopts ":b:s:u:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    b)
      BRANCH=${OPTARG}
      ;;
    s)
      SERVER=${OPTARG}
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

install_onap $BRANCH $SERVER

