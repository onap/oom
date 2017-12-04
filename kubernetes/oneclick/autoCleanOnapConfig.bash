########################################################################################
# This script wraps {$OOM}/kubernetes/oneclick/deleteAll.sh script along with          #
# the following steps to clean up ONAP configure:                                      #
#     - remove ONAP namespace                                                          #
#     - remove ONAP release                                                            #
#     - remove ONAP shared directory                                                   #
#                                                                                      #
# Before using it, do the following to prepare the bash file:                          #
#   1, cd {$OOM}/kumbernetes/oneclick                                                  #
#   2, vi autoCleanOnapConfig.bash                                                     #
#   3, paste the full content here to autoCleanOnapConfig.bash file and save the file  #
#   4, chmod 777 autoCleanOnapConfig.bash                                              #
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
