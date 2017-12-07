########################################################################################
# This script wraps {$OOM}/kubernetes/config/createConfig.sh script                    #
# and will only terminated when the configuration is Completed or failed               #
#                                                                                      #
# To run it, just enter the following command:                                         #
#    ./autoCreateConfig.bash <namespace, default is "onap">                            #
########################################################################################
#!/bin/bash


NS=$1
if [[ -z $NS ]]
then
  echo "Namespace is not specified, use onap namespace."
  NS="onap"
fi

echo "Create $NS config under config directory..."
cd ../../config
./createConfig.sh -n $NS
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
>>>>>>>>>>>>>> pod : kubectl get pods -n $NS -a"
kubectl get pods -n $NS -a


while true
do
  echo "wait for $NS config pod reach to Completed STATUS"
  sleep 5
  echo "-----------------------------------------------"
  kubectl get pods -n $NS -a

  status=`kubectl get pods -n $NS -a |grep config |xargs echo | cut -d' ' -f3`

  if [ "$status" = "Completed" ]
  then
    echo "$NS config is Completed!!!"
    break
  fi

  if [ "$status" = "Error" ]
  then
    echo "
$NS config is failed with Error!!!
Logs are:"
    kubectl logs config -n $NS -f
    break
  fi
done
