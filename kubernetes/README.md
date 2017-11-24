## **Quick Start Guide - ONAP on Kubernetes**


This is a quick start guide to help you get started on ONAP installation. Creating an ONAP deployment instance requires creating base configuration on the host node and then deploying the runtime containers.

Pre-requisites:

-  Your Kubernetes environment must be available. For more information see, [ONAP on Kubernetes](https://wiki.onap.org/display/DW/ONAP+on+Kubernetes).
-  Deployment artifacts are customized for your location.

Step 1

Review and optionally change configuration parameters:

Setup the [/oom/kubernetes/config/onap-parameters.yaml](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters.yaml;h=7ddaf4d4c3dccf2fad515265f0da9c31ec0e64b1;hb=refs/heads/master) file with key-value pairs specific to your OpenStack environment.

OR

There is a [sample](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters-sample.yaml;h=3a74beddbbf7f9f9ec8e5a6abaecb7cb238bd519;hb=refs/heads/master) that may help you out or even be usable directly if you don't intend to actually use OpenStack resources.


Step 2

In-order to be able to support multiple ONAP instances within a single kubernetes environment, a configuration set is required. To do this, execute the [createConfig.sh](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/createConfig.sh;h=f226ccae47ca6de15c1da49be4b8b6de974895ed;hb=refs/heads/master) script:

> oom/kubernetes/config/createConfig.sh -n onap

Where:
'onap' refers to the name of the instance. This serves as the Namespace prefix for each deployed ONAP component (for example, onap-mso).

Step 3

The bash script [createAll.bash](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/oneclick/createAll.bash;h=5e5f2dc76ea7739452e757282e750638b4e3e1de;hb=refs/heads/master) is used to create an ONAP deployment with kubernetes. It has two primary functions:

-  Creating the namespaces used to encapsulate the ONAP components, and
-  Creating the services, pods and containers within each of these namespaces that provide the core functionality of ONAP.

Before you execute the createAll.bash. script, pod config-init ([pod-config-init.yaml](https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/pod-config-init.yaml;h=b1285ce21d61815c082f6d6aa3c43d00561811c7;hb=refs/heads/master)) may need editing to match your environment and deployment into the default namespace.

To deploy the containers and create your ONAP system, execute the following command:

> oom/kubernetes/oneclick/createAll.bash -n onap

#### **Additional information on usage of createAll.bash**

Namespaces provide isolation between ONAP components as ONAP release 1.0 contains duplicate application (for example, mariadb) and port usage.

As such createAll.bash requires the user to enter a namespace prefix string that can be used to separate multiple deployments of onap. The result will be set of 10 namespaces (for example, onap-sdc, onap-aai, onap-mso, onap-message-router, onap-robot, onap-vid, onap-sdnc, onap-portal, onap-policy, onap-appc) being created within the kubernetes environment.


#### **Deploying multiple ONAP instances within the same Kubernetes cluster**

To deploy multiple ONAP instances, you must specify the number of Instances you would like to create in a Kubernetes cluster using createAllbash.

This is currently required due to the use of NodePort ranges. NodePorts allow external IP:Port access to containers that are running inside a Kubernetes cluster.

To create multiple instances of an ONAP deployment in the cluster, use the following commands:

> oom/kubernetes/config/createConfig.sh -n onap

> oom/kubernetes/oneclick/createAll.bash -n onap -i 2

Where:

-  'onap' refers to the name of the instance.

-  ‘i 2’ refers to the number of instances of an ONAP deployment in the cluster.

#### **To delete a deployed instance**

To delete a deployed instance, use the following command:

> oom/kubernetes/oneclick/deleteAll.bash -n onap

**Note:** Deleting the runtime containers does not remove the configuration created in step 2.

For more information on OOM project documentation, refer to:

 -  [Quick Start Guide on Wiki](https://wiki.onap.org/display/DW/ONAP+Operations+Manager+Project#ONAPOperationsManagerProject-QuickStartGuide)
 -  [Quick Start Guide on readthedocs](http://onap.readthedocs.io/en/latest/submodules/oom.git/docs/OOM%20Project%20Description/oom_project_description.html#quick-start-guide)
