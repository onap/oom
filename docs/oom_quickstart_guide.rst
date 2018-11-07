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
  sudo cp -R ~/oom/kubernetes/helm/plugins/ ~/.helm

**Step 3.** Customize the onap/values.yaml file to suit your deployment. You
may want to selectively enable or disable ONAP components by changing the
`enabled: true/false` flags as shown below:

.. literalinclude:: onap-values.yaml
   :language: yaml

.. note::
  To generate openStackEncryptedPasswordHere :

  ``root@olc-rancher:~# cd so/resources/config/mso/``

  ``root@olc-rancher:~/oom/kubernetes/so/resources/config/mso# echo -n "<openstack tenant password>" | openssl aes-128-ecb -e -K `cat encryption.key` -nosalt | xxd -c 256 -p``

**Step 3.** To setup a local Helm server to server up the ONAP charts::

  > helm serve &

Note the port number that is listed and use it in the Helm repo add as
follows::

  > helm repo add local http://127.0.0.1:8879

**Step 4.** Verify your Helm repository setup with::

  > helm repo list
  NAME   URL
  local  http://127.0.0.1:8879

**Step 5.** Build a local Helm repository (from the kubernetes directory)::

  > make all; make onap

**Step 6.** Display the charts that available to be deployed::

  > helm search -l
.. literalinclude:: helm-search.txt

.. note::
  The setup of the Helm repository is a one time activity. If you make changes to your deployment charts or values be sure to use `make` to update your local Helm repository.

**Step 7.** Once the repo is setup, installation of ONAP can be done with a
single command::

  > helm deploy dev local/onap --namespace onap


Use the following to monitor your deployment and determine when ONAP is ready for use::

  > kubectl get pods --all-namespaces -o=wide

Undeploying onap can be done using the following command::
  > helm undeploy dev --purge


More examples of using the deploy and undeploy plugins can be found here: https://wiki.onap.org/display/DW/OOM+Helm+%28un%29Deploy+plugins