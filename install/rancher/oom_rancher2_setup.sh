#!/bin/bash
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
-s [server]         : server = IP or DNS name (required)
EOF
}

install_rancher() {
# from
# https://rancher.com/blog/
echo "Installing rancher server/client for $SERVER"
CLUSTERNAME=yournewcluster
NEWPASSWORD=thisisyournewpassword
curl https://releases.rancher.com/install-docker/17.03.sh | sh
apt install jq -y
#docker run -d -p 80:80 -p 443:443 --name rancher-server rancher/server:preview --http-only
docker run -d -p 80:80 -p 443:443 --name rancher-server rancher/server:preview
while ! curl -k https://localhost/ping; do sleep 3; done
# Login
LOGINRESPONSE=`curl -s 'https://127.0.0.1/v3-public/localProviders/local?action=login' -H 'content-type: application/json' --data-binary '{"username":"admin","password":"admin"}' --insecure`
LOGINTOKEN=`echo $LOGINRESPONSE | jq -r .token`
echo "LOGINTOKEN: $LOGINTOKEN"
# Change password
curl -s 'https://127.0.0.1/v3/users?action=changepassword' -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"currentPassword":"admin","newPassword":"thisisyournewpassword"}' --insecure
# Create API key
APIRESPONSE=`curl -s 'https://127.0.0.1/v3/token' -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"automation"}' --insecure`
# Extract and store token
APITOKEN=`echo $APIRESPONSE | jq -r .token`
echo "APITOKEN: $APITOKEN"

# Create cluster
CLUSTERRESPONSE=`curl -s 'https://127.0.0.1/v3/cluster' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" --data-binary '{"type":"cluster","nodes":[],"rancherKubernetesEngineConfig":{"ignoreDockerVersion":true},"name":"'$CLUSTERNAME'"}' --insecure`
echo "CLUSTERRESPONSE: $CLUSTERRESPONSE"
# Extract clusterid to use for generating the docker run command
CLUSTERID=`echo $CLUSTERRESPONSE | jq -r .id`
echo "CLUSTERRID: $CLUSTERID"
# Generate docker run
AGENTIMAGE=`curl -s -H "Authorization: Bearer $APITOKEN" https://127.0.0.1/v3/settings/agent-image --insecure | jq -r .value`
ROLEFLAGS="--etcd --controlplane --worker"
RANCHERSERVER="https://$SERVER"
# Generate token (clusterRegistrationToken)
AGENTTOKEN=`curl -s 'https://127.0.0.1/v3/clusterregistrationtoken' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" --data-binary '{"type":"clusterRegistrationToken","clusterId":"'$CLUSTERID'"}' --insecure | jq -r .token`
echo "AGENTTOKEN: $AGENTTOKEN"
# Retrieve CA certificate and generate checksum
CACHECKSUM=`curl -s -H "Authorization: Bearer $APITOKEN" https://127.0.0.1/v3/settings/cacerts --insecure | jq -r .value | sha256sum | awk '{ print $1 }'`
CERT=`curl -s -H "Authorization: Bearer $APITOKEN" https://127.0.0.1/v3/settings/cacerts --insecure | jq -r .value`

# Assemble the docker run command
AGENTCOMMAND="docker run -d --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock --net=host $AGENTIMAGE $ROLEFLAGS --server $RANCHERSERVER --token $AGENTTOKEN --ca-checksum $CACHECKSUM"
# run the agent
echo "AGENTCOMMAND: $AGENTCOMMAND"
$AGENTCOMMAND

# install helm, kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.8.6/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
mkdir ~/.kube
#helm version
wget http://storage.googleapis.com/kubernetes-helm/helm-v2.6.1-linux-amd64.tar.gz
tar -zxvf helm-v2.6.1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/helm
# wait for cluster
#read -p "wait for cluster up before generating .kube/config"

# replace with apitoken
FILE="config"
/bin/cat <<EOM >$FILE
apiVersion: v1
kind: Config
clusters:
- name: "$CLUSTERNAME"
  cluster:
    server: "https://$SERVER/k8s/clusters/$CLUSTERID"
    api-version: v1
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM3a\\
      kNDQWRhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFvTVJJd0VBWURWUVFLRXdsM\\
      GFHVXQKY21GdVkyZ3hFakFRQmdOVkJBTVRDV05oZEhSc1pTMWpZVEFlRncweE9EQXlNVGd3T\\
      mpFeE5USmFGdzB5T0RBeQpNVFl3TmpFeE5USmFNQ2d4RWpBUUJnTlZCQW9UQ1hSb1pTMXlZV\\
      zVqYURFU01CQUdBMVVFQXhNSlkyRjBkR3hsCkxXTmhNSUlCSWpBTkJna3Foa2lHOXcwQkFRR\\
      UZBQU9DQVE4QU1JSUJDZ0tDQVFFQXgwSDN6UzE2c2ZaaGNrYkcKZVhRRUFkbDQ4ZGp1ejQyW\\
      HRKUHFKU3pkbjh2dERpSWd0VTBWY2JLTE9kWjNXWWRNb1l5Z0FuOHBacXZ0RUhGcApHQjVYc\\
      XJNaExPNHJNb0pzekFaU1drdkpoYkd2d1BxUkN2SmQ4dU9JaWJ6TXFmSjlHM2IweUg2QWx6Z\\
      1ROaGdxCmc5bE8wcG9ZYkYyOXhIN2pHYWJkemxsOFFxMzFIdjA5enNlREJ3M1FNcHlwTEpJY\\
      mRHM2JjeXBrNjRsMEpSckQKTDVES3o0ZnNVREltK09wTTZ0dktuU01QNkFlbmtZSm1mZnAzc\\
      XhudlpVMWZvQ0pGY0NLZUthTVluT0lOcVNTVAo1Mi9mM2h3MVd1U3I1bTc2bVFuWmFSYkgzU\\
      0lSYTlaNC9NTEo3TExjVWdYTDJzOENKMmxFaGJQazBZcUJrQ0gzCkRmTGhYUUlEQVFBQm95T\\
      XdJVEFPQmdOVkhROEJBZjhFQkFNQ0FxUXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QU4KQmdrc\\
      WhraUc5dzBCQVFzRkFBT0NBUUVBT1dvQW9uWGRlNHQ0eUYxYkpIbEdSb0pyaUFKcWR4ZmJ3c\\
      mUxVjBTYQpCblg2MTE0cU1FOUhzMTIzLzgrbGoyWWliTThFRHFwRWJ5Y2k0WWNXc2Q0MWljc\\
      1FwYWRoN0RTbks5WkM3Y0FLCnJKM1cyc1NaTFBwdnIyTEN2YU9GUFEvTGFqbUxKVTdKWGwwR\\
      DFJbnRMRUp0Zkl2RU01all2U255YXVwSE5raTIKOEUxZEU4cjVRcjhhT0NOQndlbEl1cFJrM\\
      25Yb015QmtFYUZxTUhhQzkvRGhBNlRXZ1F3VmlWUTZCUnBuNGllZgpnejBONlBIQ2ppY2RhV\\
      mI5Y1IzTjFHNGNra2lHb3ZSdEVwZ1QwalRzUVREZzBoVFd5dGZYOHJOVlZlMGl2TEg1CldCM\\
      kxITGFrcEtoK3dkWk1QNVFBY3RZNDluWjV5djlHUnRIQitudG5nNTRXZ0E9PQotLS0tLUVOR\\
      CBDRVJUSUZJQ0FURS0tLS0t"

users:
- name: "admin"
  user:
    token: "$APITOKEN"

contexts:
- name: "$CLUSTERNAME"
  context:
    user: "admin"
    cluster: "$CLUSTERNAME"

current-context: "$CLUSTERNAME"
EOM
# certificate-authority-data is slightly different for every install
echo "When the cluster is ready - copy the generated 'Kubeconfig File' text to ~/.kube/config"
echo "then test using 'kubectl get pods --all-namespaces'"
#cp config ~/.kube/
}

SERVER=

while getopts ":s:u:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
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

if [[ -z $SERVER ]]; then
   usage
   exit 1
fi

install_rancher $SERVER

