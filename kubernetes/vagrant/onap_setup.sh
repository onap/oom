#!/bin/bash

cp /vagrant/admin.conf ~
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> $HOME/.bash_profile

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
cp -r /oom .
sed -i "s/vfc//" oom/kubernetes/oneclick/setenv.bash
source oom/kubernetes/oneclick/setenv.bash
cd oom/kubernetes/config
cp onap-parameters-sample.yaml onap-parameters.yaml 
./createConfig.sh -n onap
cd ../oneclick
sed -i "s/discoveryClusterIP:.*/discoveryClusterIP: 192.168.1.9/" ../msb/values.yaml
./createAll.bash -n onap
