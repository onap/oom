ONAP on Kubernetes
====================

Under construction...


Creating an ONAP deployment instance requires creating base configuration on the
host node and then deploying the runtime containers.

The following is an example of creating the first deployed instance in a K8s
cluster. The name given to the instance is 'dev1'. This will serve as the
Namespace prefix for each deployed ONAP component (ie. dev1-mso).

  1. oom/kubernetes/config/createConfig.sh -n dev1

  2. oom/kubernetes/oneclick/createAll.bash -n dev1

To delete the runtime containers for the deployed instance, use the following:

  3. oom/kubernetes/oneclick/deleteAll.bash -n dev1

Note that deleting the runtime containers does not remove the configuration
created in step 1.


To deploy more than one ONAP instance within the same Kubernetes cluster, you
will need to specify an Instance number. This is currently required due to the
use of NodePort ranges. NodePorts allow external IP:Port access to containers
that are running inside a Kubernetes cluster.

Example if this is the 2 instance of an ONAP deployment in the cluster:

  1. oom/kubernetes/config/createConfig.sh -n test

  2. oom/kubernetes/oneclick/createAll.bash -n test -i 2
