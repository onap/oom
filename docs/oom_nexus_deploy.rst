.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2021 Nokia

.. Links
.. _ONAP helm testing registry: https://nexus3.onap.org/#browse/search=keyword%3Donap-helm-testing
.. _ONAP helm release registry: https://nexus3.onap.org/#browse/search=keyword%3Donap-helm-release
.. _OOM master branch: https://gerrit.onap.org/r/gitweb?p=oom.git;a=shortlog;h=refs%2Fheads%2Fmaster

.. _oom_nexus_deploy:

OOM helm deployment using the Nexus registry
############################################

As an alternative to hosting a local helm chart registry to store the OOM charts,
beginning in Jakarta release, users can now pull the charts from the onap nexus
registry.

Currently, there are 2 registries being hosted.

`ONAP helm release registry`_.
The release registry stores charts from release 9.0.0 (Istanbul) onwards.
This is the officially supported registry for the deployment of OOM.

`ONAP helm testing registry`_.
The testing registry holds charts from release 8.0.0 (Honolulu) onwards.

.. note::
   The testing charts for earlier releases are not fully supported. Test at your own risk.

   The charts for the current release (10.0.0 Jakarta) are rebuilt from the head
   of the `OOM master branch`_., so will include the latest changes.

Adding the repos
================

- To add the onap release helm repo, execute the following::

    > helm repo add onap-release https://nexus3.onap.org/repository/onap-helm-release/


- To add the onap testing helm repo, execute the following::

    > helm repo add onap-testing https://nexus3.onap.org/repository/onap-helm-testing/


Deploying the charts
====================

.. note::
   Changes to the helm deploy plugin for Jakarta release requires this file to updated locally::

    > cp oom/kubernetes/helm/plugins/deploy/deploy.sh ~/.helm/plugins/deploy/deploy.sh

- To deploy a release, we need to target the repo added previously::

    >  helm deploy dev onap-release/onap --namespace onap --create-namespace --set global.masterPassword=myAwesomePasswordThatINeedToChange -f onap/resources/overrides/onap-all.yaml -f onap/resources/overrides/environment.yaml -f onap/resources/overrides/openstack.yaml --timeout 900s

This will deploy the latest release version of the charts. (ie. 10.0.0)


