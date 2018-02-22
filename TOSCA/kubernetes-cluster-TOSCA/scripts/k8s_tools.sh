#!/bin/sh

# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2017 AT&T
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#============LICENSE_END============================================

# this script will install dashboard on k8s master.

#install heapster
git clone -b release-1.5 https://github.com/kubernetes/heapster.git

kubectl create -f heapster/deploy/kube-config/influxdb/
kubectl create -f heapster/deploy/kube-config/rbac/heapster-rbac.yaml

#install dashboard
kubectl  apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/alternative/kubernetes-dashboard.yaml

##Change spec.type from ClusterIP to NodePort  and save.
kubectl get svc kubernetes-dashboard --namespace=kube-system -o yaml | sed 's/type: ClusterIP/type: NodePort/' | kubectl replace -f -

cat <<EOF >>dashboard-admin.yaml
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system
EOF

kubectl create -f dashboard-admin.yaml

#install helm
wget http://storage.googleapis.com/kubernetes-helm/helm-$1-linux-amd64.tar.gz
tar -zxvf helm-$1-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/bin/helm

kubectl -n kube-system create sa tiller
kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --service-account tiller