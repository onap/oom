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
 
./deleteAll.bash -n onap
 
echo "----------------------------------------------
Force remove namespace..."
kubectl delete namespace onap
echo "...done"
kubectl get namespace
 
echo "Force delete helm process ..."
helm delete onap-config --purge --debug
echo "...done"
helm ls --all
 
echo "Remove ONAP dockerdata..."
sudo rm -rf /dockerdata-nfs/onap
echo "...done"
ls -altr /dockerdata-nfs
