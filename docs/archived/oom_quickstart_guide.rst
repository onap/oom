.. This work is licensed under a
.. Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019-2020 Amdocs, Bell Canada, Orange, Samsung
.. _oom_quickstart_guide:
.. _quick-start-label:

OOM Quick Start Guide
#####################

.. figure:: images/oom_logo/oomLogoV2-medium.png
   :align: right

Once a Kubernetes environment is available (follow the instructions in
:ref:`cloud-setup-guide-label` if you don't have a cloud environment
available), follow the following instructions to deploy ONAP.

**Step 1.** Clone the OOM repository from ONAP gerrit::

  > git clone -b <BRANCH> http://gerrit.onap.org/r/oom --recurse-submodules
  > cd oom/kubernetes

where <BRANCH> can be an official release tag, such as

* 4.0.0-ONAP for Dublin
* 5.0.1-ONAP for El Alto
* 6.0.0 for Frankfurt
* 7.0.0 for Guilin
* 8.0.0 for Honolulu
* 9.0.0 for Istanbul
* 10.0.0 for Jakarta
* 11.0.0 for Kohn
* 12.0.0 for London

**Step 2.** Install Helm Plugins required to deploy ONAP::

  > cp -R ~/oom/kubernetes/helm/plugins/ ~/.local/share/helm/plugins
  > helm plugin install https://github.com/chartmuseum/helm-push.git \
      --version 0.9.0

.. note::
  The ``--version 0.9.0`` is required as new version of helm (3.7.0 and up) is
  now using ``push`` directly and helm-push is using ``cm-push`` starting
  version ``0.10.0`` and up.

**Step 3.** Install Chartmuseum::

  > curl -LO https://s3.amazonaws.com/chartmuseum/release/latest/bin/linux/amd64/chartmuseum
  > chmod +x ./chartmuseum
  > mv ./chartmuseum /usr/local/bin

**Step 4.** Install Cert-Manager::

  > kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.yaml

More details can be found :doc:`here <oom_setup_paas>`.

**Step 4.1** Install Strimzi Kafka Operator:

- Add the helm repo::

    > helm repo add strimzi https://strimzi.io/charts/

- Install the operator::

    > helm install strimzi-kafka-operator strimzi/strimzi-kafka-operator --namespace strimzi-system --version 0.28.0 --set watchAnyNamespace=true --create-namespace

More details can be found :doc:`here <oom_setup_paas>`.

**Step 5.** Customize the Helm charts like `oom/kubernetes/onap/values.yaml` or
an override file like `onap-all.yaml`, `onap-vfw.yaml` or `openstack.yaml` file
to suit your deployment with items like the OpenStack tenant information.

.. note::
  Standard and example override files (e.g. `onap-all.yaml`, `openstack.yaml`)
  can be found in the `oom/kubernetes/onap/resources/overrides/` directory.


 a. You may want to selectively enable or disable ONAP components by changing
    the ``enabled: true/false`` flags.


 b. Encrypt the OpenStack password using the shell tool for Robot and put it in
    the Robot Helm charts or Robot section of `openstack.yaml`


 c. Encrypt the OpenStack password using the java based script for SO Helm
    charts or SO section of `openstack.yaml`.


 d. Update the OpenStack parameters that will be used by Robot, SO and APPC Helm
    charts or use an override file to replace them.

 e. Add in the command line a value for the global master password
    (global.masterPassword).



a. Enabling/Disabling Components:
Here is an example of the nominal entries that need to be provided.
We have different values file available for different contexts.

.. literalinclude:: ../kubernetes/onap/values.yaml
   :language: yaml


b. Generating ROBOT Encrypted Password:
The Robot encrypted Password uses the same encryption.key as SO but an
openssl algorithm that works with the python based Robot Framework.

.. note::
  To generate Robot ``openStackEncryptedPasswordHere``::

    cd so/resources/config/mso/
    /oom/kubernetes/so/resources/config/mso# echo -n "<openstack tenant password>" | openssl aes-128-ecb -e -K `cat encryption.key` -nosalt | xxd -c 256 -p``

c. Generating SO Encrypted Password:
The SO Encrypted Password uses a java based encryption utility since the
Java encryption library is not easy to integrate with openssl/python that
Robot uses in Dublin and upper versions.

.. note::
  To generate SO ``openStackEncryptedPasswordHere`` and ``openStackSoEncryptedPassword``
  ensure `default-jdk` is installed::

    apt-get update; apt-get install default-jdk

  Then execute::

    SO_ENCRYPTION_KEY=`cat ~/oom/kubernetes/so/resources/config/mso/encryption.key`
    OS_PASSWORD=XXXX_OS_CLEARTESTPASSWORD_XXXX

    git clone http://gerrit.onap.org/r/integration
    cd integration/deployment/heat/onap-rke/scripts

    javac Crypto.java
    java Crypto "$OS_PASSWORD" "$SO_ENCRYPTION_KEY"

d. Update the OpenStack parameters:

There are assumptions in the demonstration VNF Heat templates about the
networking available in the environment. To get the most value out of these
templates and the automation that can help confirm the setup is correct, please
observe the following constraints.


``openStackPublicNetId:``
  This network should allow Heat templates to add interfaces.
  This need not be an external network, floating IPs can be assigned to the
  ports on the VMs that are created by the heat template but its important that
  neutron allow ports to be created on them.

``openStackPrivateNetCidr: "10.0.0.0/16"``
  This ip address block is used to assign OA&M addresses on VNFs to allow ONAP
  connectivity. The demonstration Heat templates assume that 10.0 prefix can be
  used by the VNFs and the demonstration ip addressing plan embodied in the
  preload template prevent conflicts when instantiating the various VNFs. If
  you need to change this, you will need to modify the preload data in the
  Robot Helm chart like integration_preload_parameters.py and the
  demo/heat/preload_data in the Robot container. The size of the CIDR should
  be sufficient for ONAP and the VMs you expect to create.

``openStackOamNetworkCidrPrefix: "10.0"``
  This ip prefix mush match the openStackPrivateNetCidr and is a helper
  variable to some of the Robot scripts for demonstration. A production
  deployment need not worry about this setting but for the demonstration VNFs
  the ip asssignment strategy assumes 10.0 ip prefix.

Example Keystone v2.0

.. literalinclude:: yaml/example-integration-override.yaml
   :language: yaml

Example Keystone v3  (required for Rocky and later releases)

.. literalinclude:: yaml/example-integration-override-v3.yaml
   :language: yaml


**Step 6.** To setup a local Helm server to server up the ONAP charts::

  > chartmuseum --storage local --storage-local-rootdir ~/helm3-storage -port 8879 &

Note the port number that is listed and use it in the Helm repo add as
follows::

  > helm repo add local http://127.0.0.1:8879

**Step 7.** Verify your Helm repository setup with::

  > helm repo list
  NAME   URL
  local  http://127.0.0.1:8879

**Step 8.** Build a local Helm repository (from the kubernetes directory)::

  > make SKIP_LINT=TRUE [HELM_BIN=<HELM_PATH>] all ; make SKIP_LINT=TRUE [HELM_BIN=<HELM_PATH>] onap

`HELM_BIN`
  Sets the helm binary to be used. The default value use helm from PATH


**Step 9.** Display the onap charts that available to be deployed::

  > helm repo update
  > helm search repo onap

.. literalinclude:: helm/helm-search.txt

.. note::
  The setup of the Helm repository is a one time activity. If you make changes
  to your deployment charts or values be sure to use ``make`` to update your
  local Helm repository.

**Step 10.** Once the repo is setup, installation of ONAP can be done with a
single command

.. note::
  The ``--timeout 900s`` is currently required in Dublin and later
  versions up to address long running initialization tasks for DMaaP
  and SO. Without this timeout value both applications may fail to
  deploy.

.. danger::
  We've added the master password on the command line.
  You shouldn't put it in a file for safety reason
  please don't forget to change the value to something random

  A space is also added in front of the command so "history" doesn't catch it.
  This masterPassword is very sensitive, please be careful!


To deploy all ONAP applications use this command::

    > cd oom/kubernetes
    >  helm deploy dev local/onap --namespace onap --create-namespace --set global.masterPassword=myAwesomePasswordThatINeedToChange -f onap/resources/overrides/onap-all.yaml -f onap/resources/overrides/environment.yaml -f onap/resources/overrides/openstack.yaml --timeout 900s

All override files may be customized (or replaced by other overrides) as per
needs.

`onap-all.yaml`
  Enables the modules in the ONAP deployment. As ONAP is very modular, it is
  possible to customize ONAP and disable some components through this
  configuration file.

`onap-all-ingress-nginx-vhost.yaml`
  Alternative version of the `onap-all.yaml` but with global ingress controller
  enabled. It requires the cluster configured with the nginx ingress controller
  and load balancer. Please use this file instead `onap-all.yaml` if you want
  to use experimental ingress controller feature.

`environment.yaml`
  Includes configuration values specific to the deployment environment.

  Example: adapt readiness and liveness timers to the level of performance of
  your infrastructure

`openstack.yaml`
  Includes all the OpenStack related information for the default target tenant
  you want to use to deploy VNFs from ONAP and/or additional parameters for the
  embedded tests.

**Step 11.** Verify ONAP installation

Use the following to monitor your deployment and determine when ONAP is ready
for use::

  > kubectl get pods -n onap -o=wide

.. note::
  While all pods may be in a Running state, it is not a guarantee that all
  components are running fine.

  Launch the healthcheck tests using Robot to verify that the components are
  healthy::

    > ~/oom/kubernetes/robot/ete-k8s.sh onap health

**Step 12.** Undeploy ONAP
::

  > helm undeploy dev

More examples of using the deploy and undeploy plugins can be found here:
https://wiki.onap.org/display/DW/OOM+Helm+%28un%29Deploy+plugins
