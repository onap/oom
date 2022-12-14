## **Quick Start Guide**

> **WARNING**: This README is no longer maintained and will be deprecated.
> Please refer to the official OOM guide here - [OOM Guide](https://docs.onap.org/projects/onap-oom/en/latest/sections/oom_project_description.html)


This is a quick start guide describing how to deploy ONAP on Kubernetes using Helm.

Pre-requisites:

-  Your Kubernetes environment must be available. For more information see, [ONAP on Kubernetes](https://wiki.onap.org/display/DW/ONAP+on+Kubernetes).
-  Deployment artifacts are customized for your location.


### **Deploy ONAP Instance**

Step 1. Clone the OOM repository from ONAP gerrit:

```
> git clone http://gerrit.onap.org/r/oom
> cd oom/kubernetes
```

Step 2. Customize the oom/kubernetes/onap parent chart, like the values.yaml file, to suit your deployment. You may want to selectively enable or disable ONAP components by changing the subchart **enabled** flags to *true* or *false*.  The .yaml file for OpenStackEncryptedPassword should be the MSO ecnrypted value of the openstack tenant password
```
Example:
...
robot: # Robot Health Check
  enabled: true
sdc:
  enabled: false
sdnc:
  enabled: false
so: # Service Orchestrator
  enabled: true
...
```
Step 3. To setup a local Helm repository to serve up the local ONAP charts:
        [Note: ensure helm init has been executed on the node, or run helm init --client-only]
```
> helm serve &
```
Note the port number that is listed and use it in the Helm repo add as follows:
```
> helm repo add local http://127.0.0.1:8879
```

Step 4. Build a local Helm repository (from the kubernetes directory):
```
> make all
```

Step 5. Display the charts that are available to be deployed:
```
> helm search -l
NAME                    VERSION    DESCRIPTION
local/clamp             2.0.0      ONAP Clamp
local/onap              2.0.0      Open Network Automation Platform (ONAP)
local/robot             2.0.0      A helm Chart for kubernetes-ONAP Robot
local/so                2.0.0      ONAP Service Orchestrator
...
```

**Note:**
Setup of this Helm repository is a one time activity. If you make changes to your deployment charts or values be sure to use **make** to update your local Helm repository.

Step 6. Once the repo is setup, installation of ONAP can be done with a single command:
```
> helm install local/onap --name dev --namespace onap
```
**Note:** the **--namespace onap** is currently required while all onap helm charts are migrated to version 2.0. After this activity is complete, namespaces will be optional.

Use the following to monitor your deployment and determine when ONAP is ready for use:
```
> kubectl get pods --all-namespaces -o=wide
```


#### **Cleanup deployed ONAP instance**

To delete a deployed instance, use the following command:
```
> helm del dev --purge
```



For more information on OOM project documentation, refer to:

 -  [Quick Start Guide on Wiki](https://wiki.onap.org/display/DW/ONAP+Operations+Manager+Project#ONAPOperationsManagerProject-QuickStartGuide)
 -  [Quick Start Guide on readthedocs](http://onap.readthedocs.io/en/latest/submodules/oom.git/docs/OOM%20Project%20Description/oom_project_description.html#quick-start-guide)
