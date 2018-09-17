if [ $# -ne 1 ]; then
    echo $0: usage: $0   "namespace"
    echo "    This script destroys a GlusterFS kubernetes on OpenStack to be used as Persistent Volumes"
    exit 1
fi

namespace=$1


for object in `kubectl get all,endpoints,ds,svc,serviceaccount,clusterrolebinding,secret --namespace=$namespace |egrep 'heketi|gluster'|awk '{print $1}'`; do
	echo Deleting $object ...
	kubectl delete $object --namespace=$namespace
done

#Remove local heketi stuff
rm -rf /var/lib/heketi \
   /etc/glusterfs \
   /var/lib/glusterd \
   /var/log/glusterfs

echo on each VM hosting heketi volume run the following \(where vdb is whatever path your volume is\) :
echo wipefs -a /dev/vdb

#You may need to delete the cluster info... (change the IDs to output from output)
#heketi-client/bin/heketi-cli topology info
#heketi-client/bin/heketi-cli volume list
#heketi-client/bin/heketi-cli cluster info 606f3fd2f1e8c3d45822493c1c92e539
#heketi-client/bin/heketi-cli node disable  6ade80e1660b1bd8d0f399d359afcd33
#heketi-client/bin/heketi-cli node disable  a7f10afe13d88c2fe945b5f295647038
#heketi-client/bin/heketi-cli node disable  ea13f4253936e21e6cd77bb52430c443
#heketi-client/bin/heketi-cli cluster info 606f3fd2f1e8c3d45822493c1c92e539
#heketi-client/bin/heketi-cli node delete 6ade80e1660b1bd8d0f399d359afcd33 
#heketi-client/bin/heketi-cli node delete a7f10afe13d88c2fe945b5f295647038
#heketi-client/bin/heketi-cli node delete ea13f4253936e21e6cd77bb52430c443
#heketi-client/bin/heketi-cli cluster delete 606f3fd2f1e8c3d45822493c1c92e539
#If necessary, you may need to unmount and remount the volumes in Openstack!
