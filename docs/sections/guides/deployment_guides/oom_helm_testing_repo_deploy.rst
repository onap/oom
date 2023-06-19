.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _ONAP helm testing repository: https://nexus3.onap.org/service/rest/repository/browse/onap-helm-testing/
.. _OOM: https://github.com/onap/oom

.. _oom_helm_testing_repo_deploy:

OOM Helm Testing Deployment
===========================

ONAP hosts the OOM `testing` helm charts in it's `ONAP helm testing repository`_.

This is helm repo contains:

    * The `latest` charts built from the head of the `OOM`_ project's master
      branch, tagged with the version number of the current development cycle (ie. 12.0.0).


Add the OOM testing repo & Deploy
---------------------------------
.. note::
   The testing helm charts for earlier releases are not fully supported. Test at your own risk.

Add the repository:

- To add the onap testing helm repo, execute the following::

    > helm repo add onap-testing https://nexus3.onap.org/repository/onap-helm-testing/

.. note::
    The following helm command will deploy ONAP charts, with `all` OOM components enabled as per the onap-all.yml overrides file provided to the `-f` flag.

    To customize what applications are deployed, see the :ref:`oom_customize_overrides` section for more details, to provide your own custom overrides yaml file.

- To deploy the latest charts, we need to target the repo added previously::

    >  helm deploy dev onap-testing/onap --namespace onap --create-namespace --set global.masterPassword=myAwesomePasswordThatINeedToChange -f oom/kubernetes/onap/resources/overrides/onap-all.yaml

This will deploy the latest testing version of the OOM helm charts.



