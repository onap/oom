.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada

.. _quick-start-label:

OOM Quick Start Guide
#####################

.. figure:: oomLogoV2-medium.png
   :align: right

Once a kubernetes environment is available (follow the instructions in
:ref:`cloud-setup-guide-label` if you don't have a cloud environment
available), follow the following instructions to deploy ONAP.

**Step 1.** Clone the OOM repository from ONAP gerrit::

  > git clone -b casablanca http://gerrit.onap.org/r/oom
  > cd oom/kubernetes

**Step 2.** Install Helm Plugins required to deploy the ONAP Casablanca release::

  > sudo cp -R ~/oom/kubernetes/helm/plugins/ ~/.helm

**Step 3.** Customize the helm charts like onap.values.yaml or an override.yaml
like integration-override.yaml file to suit your deployment with items like the
OpenStack tenant information.

 a. You may want to selectively enable or disable ONAP components by changing the `enabled: true/false` flags.

 b. Update the OpenStack parameters that will be used by robot, SO and APPC helm charts or use an override file to replace them.

 c. Encyrpt the OpenStack password using the shell tool for robot and put it in the robot helm charts or robot section of integration-override.yaml

 d. Encrypt the OpenStack password using the java based script for SO helm charts or SO section of integration-override.yaml.



a. Enabling/Disabling Components:
Here is an example of the override file entries that need to be provided.

.. literalinclude:: onap-values.yaml
   :language: yaml

b. Update the OpenStack parameters:

.. literalinclude:: example-integration-override.yaml
   :language: yaml

c. Generating ROBOT Encrypted Password:
The ROBOT encrypted Password uses the same encryption.key as SO but an openssl algorthim.

.. note::
  To generate ROBOT openStackEncryptedPasswordHere :

  ``root@olc-rancher:~# cd so/resources/config/mso/``

  ``root@olc-rancher:~/oom/kubernetes/so/resources/config/mso# echo -n "<openstack tenant password>" | openssl aes-128-ecb -e -K `cat encryption.key` -nosalt | xxd -c 256 -p``

d. Generating SO Encrypted Password:
The SO Encrypted Passowrd uses a java based encryption utility.

.. note::
  To generate SO openStackEncryptedPasswordHere :

  SO_ENCRYPTION_KEY=`cat ~/oom/kubenertes/so/resources/config/mso/encrypt.key`
  OS_PASSWORD=XXXX_OS_CLEARTESTPASSWORD_XXXX

  git clone http://gerrit.onap.org/r/integration
  cd integration/deployment/heat/onap-oom/scripts
  javac Crypto.java
  java Crypto "$OS_PASSWORD" "$SO_ENCRYPTION_KEY"



**Step 4.** To setup a local Helm server to server up the ONAP charts::

  > helm serve &

Note the port number that is listed and use it in the Helm repo add as
follows::

  > helm repo add local http://127.0.0.1:8879

**Step 5.** Verify your Helm repository setup with::

  > helm repo list
  NAME   URL
  local  http://127.0.0.1:8879

**Step 6.** Build a local Helm repository (from the kubernetes directory)::

  > make all; make onap

**Step 7.** Display the charts that available to be deployed::

  > helm search -l

.. literalinclude:: helm-search.txt

.. note::
  The setup of the Helm repository is a one time activity. If you make changes to your deployment charts or values be sure to use `make` to update your local Helm repository.

**Step 8.** Once the repo is setup, installation of ONAP can be done with a
single command

 a. If you updated the values directly use this command::

    > helm deploy dev local/onap --namespace onap


 b. If you are using an integration-override.yaml file use this command::

    > helm deploy dev local/onap -f /root/integration-override.yaml --namespace onap


 c. If you have a slower cloud environment you may want to use the public-cloud.yaml which has longer delay intervals on database updates.::

    > helm deploy dev local/onap -f /root/oom/kubernetes/onap/resources/environments/public-cloud.yaml -f /root/integration-override.yaml --namespace onap


**Step 9.** Commands to interact with the OOM installation

Use the following to monitor your deployment and determine when ONAP is ready for use::

  > kubectl get pods --all-namespaces -o=wide

Undeploying onap can be done using the following command::

  > helm undeploy dev --purge


More examples of using the deploy and undeploy plugins can be found here: https://wiki.onap.org/display/DW/OOM+Helm+%28un%29Deploy+plugins
