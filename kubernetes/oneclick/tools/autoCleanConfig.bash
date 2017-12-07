########################################################################################
# This script wraps {$OOM}/kubernetes/oneclick/deleteAll.sh script along with          #
# the following steps to clean up ONAP configure:                                      #
#     - remove ONAP namespace                                                          #
#     - remove ONAP release                                                            #
#     - remove ONAP shared directory                                                   #
#                                                                                      #
# To run it, just enter the following command:                                         #
#    ./autoCleanOnapConfig.bash                                                        #
########################################################################################
#!/bin/bash


NS=$1
if [[ -z $NS ]]
then
  echo "Namespace is not specified, use onap namespace."
  NS="onap"
fi

echo "Clean up $NS configuration"
cd ..
./deleteAll.bash -n $NS
cd -

echo "----------------------------------------------
Force remove namespace..."
kubectl delete namespace $NS
echo "...done : kubectl get namespace
-----------------------------------------------
>>>>>>>>>>>>>> k8s namespace"
kubectl get namespace
while [[ ! -z `kubectl get namespace|grep $NS` ]]
do
  echo "Wait for namespace $NS to be deleted
-----------------------------------------------
>>>>>>>>>>>>>> k8s namespace"
  kubectl get namespace
  sleep 2
done

echo "Force delete helm process ..."
helm delete $NS-config --purge --debug
echo "...done : helm ls --all
 -----------------------------------------------
>>>>>>>>>>>>>> helm"
helm ls --all

echo "Remove $NS dockerdata..."
sudo rm -rf /dockerdata-nfs/onap
echo "...done : ls -altr /dockerdata-nfs
 -----------------------------------------------
>>>>>>>>>>>>>> /dockerdata-nfs directory"
ls -altr /dockerdata-nfs
