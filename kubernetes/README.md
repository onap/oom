ONAP on Kubernetes
====================

Under construction...


Creating an ONAP deployment instance requires creating base configuration on the host node and then deploying the runtime containers.

The following is an example of creating the first deployed instance in a K8s cluster. The name given to the instance is 'dev1'. This will serve as the
Namespace prefix for each deployed ONAP component (ie. dev1-mso).

  1. oom/kubernetes/config/createConfig.sh -n dev1

  2. oom/kubernetes/oneclick/createAll.bash -n dev1

To delete the runtime containers for the deployed instance, use the following:

  3. oom/kubernetes/oneclick/deleteAll.bash -n dev1

Note that deleting the runtime containers does not remove the configuration created in step 1.


To deploy more than one ONAP instance within the same Kubernetes cluster, you will need to specify an Instance number. This is currently required due to the use of NodePort ranges. NodePorts allow external IP:Port access to containers that are running inside a Kubernetes cluster.

Example if this is the 2 instance of an ONAP deployment in the cluster:

  1. oom/kubernetes/config/createConfig.sh -n test

  2. oom/kubernetes/oneclick/createAll.bash -n test -i 2
  
Quick Start Guide
=================

Once a kubernetes environment is available (check out [ONAP on Kubernetes](https://wiki.onap.org/display/DW/ONAP+on+Kubernetes) if you're getting started) and the deployment artifacts have been customized for your location, ONAP is ready to be installed. 

The first step is to setup the [/oom/kubernetes/config/onap-parameters.yaml](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters.yaml;h=7ddaf4d4c3dccf2fad515265f0da9c31ec0e64b1;hb=refs/heads/master) file with key-value pairs specific to your OpenStack environment.  There is a [sample](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters-sample.yaml;h=3a74beddbbf7f9f9ec8e5a6abaecb7cb238bd519;hb=refs/heads/master) that may help you out or even be usable directly if you don't intend to actually use OpenStack resources.

In-order to be able to support multiple ONAP instances within a single kubernetes environment a configuration set is required.
 The [createConfig.sh](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/createConfig.sh;h=f226ccae47ca6de15c1da49be4b8b6de974895ed;hb=refs/heads/master) script is used to do this:

  > ./createConfig.sh -n onapTrial

The bash script [createAll.bash](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/oneclick/createAll.bash;h=5e5f2dc76ea7739452e757282e750638b4e3e1de;hb=refs/heads/master) is used to create an ONAP deployment with kubernetes. It has two primary functions:

-  Creating the namespaces used to encapsulate the ONAP components, and

-  Creating the services, pods and containers within each of these
   namespaces that provide the core functionality of ONAP.

To deploy the containers and create your ONAP system enter::

  > ./createAll.bash -n onapTrial

Namespaces provide isolation between ONAP components as ONAP release 1.0 contains duplicate application (e.g. mariadb) and port usage. As
such createAll.bash requires the user to enter a namespace prefix string that can be used to separate multiple deployments of onap. The result
will be set of 10 namespaces (e.g. onapTrial-sdc, onapTrial-aai, onapTrial-mso, onapTrial-message-router, onapTrial-robot, onapTrial-vid,
onapTrial-sdnc, onapTrial-portal, onapTrial-policy, onapTrial-appc) being created within the kubernetes environment.  A prerequisite pod
config-init ([pod-config-init.yaml](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/pod-config-init.yaml;h=b1285ce21d61815c082f6d6aa3c43d00561811c7;hb=refs/heads/master)) may need editing to match your environment and deployment into the default namespace before running createAll.bash.

For more information on OOM project documentation, refer to:

 -  [Quick Start Guide on Wiki](https://wiki.onap.org/display/DW/ONAP+Operations+Manager+Project#ONAPOperationsManagerProject-QuickStartGuide)
 -  [Quick Start Guide on readthedocs](http://onap.readthedocs.io/en/latest/submodules/oom.git/docs/OOM%20Project%20Description/oom_project_description.html#quick-start-guide)
