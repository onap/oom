########################################################################################
# This script replaces {$OOM}/kubernetes/config/createConfig.sh script                 #
# and will only terminated when the ONAP configuration is Completed                    #
#                                                                                      #
# Before using it, do the following to prepare the bash file:                          #
#   1, cd {$OOM}/kumbernetes/oneclick                                                  #
#   2, vi autoCreateOnapConfig.bash                                                    #
#   3, paste the full content here to autoCreateOnapConfig.bash file and save the file #
#   4, chmod 777 autoCreateOnapConfig.bash                                             #
# To run it, just enter the following command:                                         #
#    ./autoCreateOnapConfig.bash                                                       #
########################################################################################
#!/bin/bash
 
 
echo "Create ONAP config under config directory..."
cd ../config
./createConfig.sh -n onap
cd -
 
 
echo "...done : kubectl get namespace
-----------------------------------------------
>>>>>>>>>>>>>> k8s namespace"
kubectl get namespace
 
 
echo "
-----------------------------------------------
>>>>>>>>>>>>>> helm : helm ls --all"
helm ls --all
 
 
echo "
-----------------------------------------------
>>>>>>>>>>>>>> pod : kubectl get pods --all-namespaces -a"
kubectl get pods --all-namespaces -a
 
 
status=`kubectl get pods --all-namespaces -a |grep onap |xargs echo | cut -d' ' -f4`
while true
do
  echo "wait for onap config pod reach to Completed STATUS"
  sleep 5
  echo "-----------------------------------------------"
  kubectl get pods --all-namespaces -a
  status=`kubectl get pods --all-namespaces -a |grep onap |xargs echo | cut -d' ' -f4`
  if [ "$status" = "Completed" ]
  then
    echo "onap config is Completed!!!"
    break
  fi
done
