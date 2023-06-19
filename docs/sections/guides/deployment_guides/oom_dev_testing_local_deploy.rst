.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links

.. _oom_dev_testing_local_deploy:

OOM Developer Testing Deployment
================================

Developing and testing changes to the existing OOM project can be done locally by setting up some additional
tools to host the updated helm charts.

**Step 1.** Clone the OOM repository from ONAP gerrit::

  > git clone http://gerrit.onap.org/r/oom

  > cd oom/kubernetes


**Step 2.** Install Helm Plugin required to push helm charts to local repo::

  > helm plugin install https://github.com/chartmuseum/helm-push.git --version 0.9.0

.. note::
  The ``--version 0.9.0`` is required as new version of helm (3.7.0 and up) is
  now using ``push`` directly and helm-push is using ``cm-push`` starting
  version ``0.10.0`` and up.

**Step 3.** Install Chartmuseum

Chart museum is required to host the helm charts locally when deploying in a development environment::

  > curl https://raw.githubusercontent.com/helm/chartmuseum/main/scripts/get-chartmuseum | bash

**Step 4.** To setup a local Helm server to store the ONAP charts::

  > mkdir -p ~/helm3-storage

  > chartmuseum --storage local --storage-local-rootdir ~/helm3-storage -port 8879 &

Note the port number that is listed and use it in the Helm repo add as follows::

  > helm repo add local http://127.0.0.1:8879

**Step 5.** Verify your Helm repository setup with::

  > helm repo list
  NAME   URL
  local  http://127.0.0.1:8879

**Step 6.** Build a local Helm repository (from the kubernetes directory)::

  > make SKIP_LINT=TRUE [HELM_BIN=<HELM_PATH>] all

`HELM_BIN`
  Sets the helm binary to be used. The default value use helm from PATH


**Step 7.** Display the onap charts that are available to be deployed::

  > helm repo update

  > helm search repo local


.. collapse:: Helm search repo output

    .. include:: ../../resources/helm/helm-search.txt
       :code: yaml

|

.. note::
  The setup of the Helm repository is a one time activity. If you make changes
  to your deployment charts or values be sure to use ``make`` to update your
  local Helm repository.




