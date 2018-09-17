# First step is to open firewall for gluster on all nodes.
if [ $# -ne 2 ]; then
    echo $0: usage: deploy_gluster.bash "<dev path>" "namespace"
    echo "      e.g. $0 /dev/vdb onap "
    echo "    This script deploys a GlusterFS kubernetes on OpenStack to be used as Persistent Volumes"
    exit 1
fi

device_path=$1
namespace=$2

#device_path="/dev/vdb" 	#This is where Openstack volume is mounted

echo "Ensure that volume $device_path is mounted on kubernetes VMs in OpenStack! Press Enter to proceed..."
echo "It's best to destroy and remount device if previously used by Gluster"
read someinput

echo ################################################################################


cat << _ENDS_
#Please run the following commands on all nodes that will be running the GlusterFS nodes. We will run on this node for you...

iptables -N HEKETI
iptables -A HEKETI -p tcp -m state --state NEW -m tcp --dport 24007 -j ACCEPT
iptables -A HEKETI -p tcp -m state --state NEW -m tcp --dport 24008 -j ACCEPT
iptables -A HEKETI -p tcp -m state --state NEW -m tcp --dport 2222 -j ACCEPT
iptables -A HEKETI -p tcp -m state --state NEW -m multiport --dports 49152:49251 -j ACCEPT
service iptables save

modprobe dm_snapshot
modprobe dm_mirror
modprobe dm_thin_pool

lsmod |egrep 'dm_snapshot|dm_mirror|dm_thin_pool' 

#Hit enter once you've run this on all kubernetes nodes.
_ENDS_


iptables -N HEKETI
iptables -A HEKETI -p tcp -m state --state NEW -m tcp --dport 24007 -j ACCEPT
iptables -A HEKETI -p tcp -m state --state NEW -m tcp --dport 24008 -j ACCEPT
iptables -A HEKETI -p tcp -m state --state NEW -m tcp --dport 2222 -j ACCEPT
iptables -A HEKETI -p tcp -m state --state NEW -m multiport --dports 49152:49251 -j ACCEPT

read someinput

echo ################################################################################
# now we clone the heketi distribution

which git 2>/dev/null
if [ "$?" != 0 ]; then
	echo git not installed. Please install and retry.
	exit
fi
echo Downloading Heketi from gihub
git clone https://github.com/heketi/heketi.git 

cd heketi/extras/kubernetes

echo ################################################################################
echo Creating bootstrap config....
kubectl create -f glusterfs-daemonset.json --namespace=$namespace

echo ################################################################################
echo Adding label to nodes. Ignore errors that labels are already there...
for node in `kubectl get nodes --namespace=$namespace|grep -v NAME | awk '{print $1}'` ; do
	echo kubectl label node $node storagenode=glusterfs --namespace=$namespace
	kubectl label node $node storagenode=glusterfs --namespace=$namespace
done

echo Sleeping for 30 seconds
sleep 30

echo ################################################################################
echo Verify that theres at least 3 pods running 
kubectl get pods --namespace=$namespace  | egrep -e 'heketi|gluster'

echo Hit any key to proceed
read $input

echo Creating Service Account, ClusterRoleBinding, Secret
kubectl create -f heketi-service-account.json --namespace=$namespace

kubectl create clusterrolebinding heketi-gluster-admin --clusterrole=edit --serviceaccount=default:heketi-service-account --namespace=$namespace

kubectl create secret generic heketi-config-secret --from-file=./heketi.json --namespace=$namespace
echo ################################################################################
echo Verify...
kubectl get serviceaccount,clusterrolebinding,secret --namespace=$namespace | egrep -e 'heketi|gluster'
echo ################################################################################

echo Deploying Heketi deployment...
kubectl create -f heketi-bootstrap.json --namespace=$namespace

echo Sleeping for 30 seconds
sleep 30
echo ################################################################################
echo Verify deployment and service created....
kubectl get deployment,svc --namespace=$namespace |egrep 'heketi|gluster'
echo Confirm deployment and service have been created. Hit any key to proceed
read $input

#TO DO - loop this
kubectl get pod --namespace=$namespace |egrep 'deploy-heketi'
echo "^^^"
echo "Confirm heketi pod is running (and not Pending). "
echo "If not started, run the following in a different terminal until it shows Running..."
echo "kubectl get pod --namespace=$namespace |grep deploy-heketi"
read $input

#TO DO loop and wait until its running 

echo ################################################################################
echo "Setting up temporary port forwarding to run Heketi CLI commands"
echo "kubectl port-forward --namespace=$namespace \`kubectl get pods --namespace=$namespace |grep deploy-heketi|awk '{print \$1}' \` 57598:8080"
kubectl port-forward  --namespace=$namespace `kubectl get pods --namespace=$namespace |grep deploy-heketi|awk '{print $1}' ` 57598:8080 &
echo Sleeping for 15 seconds
sleep 15
export HEKETI_CLI_SERVER=http://localhost:57598
echo export HEKETI_CLI_SERVER=http://localhost:57598

echo verify that Heketi is accessible
curl http://localhost:57598/hello

echo "    "
echo "^^^"
echo "Abort (ctrl-c)  if we didnt receive Hello from Heketi. Hit any key to proceed"
read $input

echo ################################################################################
#TODO generate topology file...

echo Creating Topology file "topology.json"...

touch topology.json
cat > topology.json << _ENDS_
{
  "clusters": [
    {
      "nodes": [
_ENDS_
comma=""
for node in `kubectl get nodes --namespace=$namespace|grep -v NAME | awk '{print $1}'` ; do
#done
node_ip=`kubectl get nodes $node -o wide --namespace=$namespace |awk '{print $6}'|grep -v 'EXTERNAL-IP'`
cat >> topology.json << _ENDS_
$comma
        {
          "node": {
            "hostnames": {
              "manage": [
                "$node"
              ],
              "storage": [
                "$node_ip"
              ]
            },
            "zone": 1
          },
          "devices": [
            {
              "name": "$device_path",
              "destroydata": false
            }
          ]
        }
_ENDS_
comma=","
#need to remove the last comma somehow
done
cat >> topology.json << _ENDS_
      ]
    }
  ]
}
_ENDS_
echo "Done. Hit enter to view topology file..."
read $input
cat topology.json
echo "Hit enter to proceed..."
read $input

echo ################################################################################
echo Installing client...
#cd ~/
if [ ! -d "heketi-client" ]; then 
	wget https://github.com/heketi/heketi/releases/download/v7.0.0/heketi-client-v7.0.0.linux.amd64.tar.gz
	gunzip -cd heketi-client-v7.0.0.linux.amd64.tar.gz |tar xvf -
else
	echo "heketi-client already installed....Proceeding!"
fi

#To do implement a heketi client pod and exec commands there

echo Applying HEKETI configuration. Watch for errors...
heketi-client/bin/heketi-cli topology load --json=topology.json
echo Hit enter...
read $input


echo ################################################################################
echo Generating storage JSON
echo heketi-client/bin/heketi-cli setup-openshift-heketi-storage
heketi-client/bin/heketi-cli setup-openshift-heketi-storage
echo Abort if errors. Next step will fail if this one does...
echo Hit enter...
read $input
# TO DO if heketi-storage.json fails to create, abort!!
echo kubectl create -f heketi-storage.json --namespace=$namespace
kubectl create -f heketi-storage.json --namespace=$namespace
sleep 90
kubectl get endpoints,service --namespace=$namespace |grep heketi
echo Heketi service and endpoints should now be up!
echo Hit enter...
read $input
echo ################################################################################

echo Terminate the port forward since we are killing the pod...
echo pkill kubectl
pkill kubectl
sleep 1
echo Make sure the next line just says ok
ps -ef |grep port-forward|grep -v grep
echo ok
echo Hit enter...
read $input

echo Deleting bootstrap objects...
echo kubectl delete all,service,jobs,deployment,secret --selector="deploy-heketi"  --namespace=$namespace
kubectl delete all,service,jobs,deployment,secret --selector="deploy-heketi" --namespace=$namespace



echo Create the long-term Heketi instance:
kubectl create -f heketi-deployment.json --namespace=$namespace
sleep 15
echo Make sure the new heketi pod is running...
kubectl get pods --namespace=$namespace |egrep -e 'heketi|gluster'
echo Hit enter...
read $input

echo Create new port forward
#Might not be called deploy-heketi anymore?
echo kubectl port-forward --namespace=$namespace `kubectl get pods --namespace=$namespace |grep heketi|grep -v deploy|awk '{print $1}' ` 57598:8080
kubectl port-forward --namespace=$namespace `kubectl get pods --namespace=$namespace |grep heketi|grep -v deploy| awk '{print $1}' ` 57598:8080 &

# TO DO port forward fails here

# TODO CREATE HELPER pod

#heketi-client/bin/heketi-cli cluster list |tee cluster_info.txt
#heketi-client/bin/heketi-cli topology list |tee volume_info.txt

echo Creating storage Class "glusterfs-sc"
#get the heketi IP address...
HEKETI_IP=`kubectl get svc --namespace=$namespace |grep heketi|grep -v heketi-storage-endpoints| awk '{print $3}'`
#TODO check we got something. Maybe get this from a pod instead
echo The heketi service IP is $HEKETI_IP . You can do kubectl get svc to verify.

echo Hit enter to define storage class...
read $input

cat > storageClass.yaml << _ENDS_
apiVersion: storage.k8s.io/v1beta1
kind: StorageClass
metadata:
  name: glusterfs-sc
provisioner: kubernetes.io/glusterfs
parameters:
  resturl: "http://$HEKETI_IP:8080"     
  restuser: ""  
  restuserkey: ""
_ENDS_

echo Here is the storageClass configuration. 
cat storageClass.yaml

echo Hit enter to create storage class...
read $input
kubectl create -f storageClass.yaml --namespace=$namespace
sleep 5
kubectl get storageclass -o wide  --namespace=$namespace

echo Hit enter to cleanup ...
read $input

rm -rf heketi/
echo All done! 
