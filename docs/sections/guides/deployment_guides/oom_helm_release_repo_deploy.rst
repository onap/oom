.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _ONAP helm release repository: https://nexus3.onap.org/service/rest/repository/browse/onap-helm-release/
.. _ONAP Release Long Term Roadmap: https://wiki.onap.org/display/DW/Long+Term+Roadmap

.. _oom_helm_release_repo_deploy:

OOM Helm Release Deployment
===========================

ONAP hosts the OOM release helm charts in it's `ONAP helm release repository`_.

This is the officially supported repository for the deployment of OOM.

.. note::
    ONAP supports up to N-1 releases. See `ONAP Release Long Term Roadmap`_ for more details.

Add the OOM release repo & Deploy
---------------------------------
Add the repository:

- To add the onap release helm repo, execute the following::

    > helm repo add onap-release https://nexus3.onap.org/repository/onap-helm-release/

.. note::
    The following helm command will deploy ONAP charts, with `all` OOM components enabled as per the onap-all.yml overrides file provided to the `-f` flag.

    To customize what applications are deployed, see the :ref:`oom_customize_overrides` section for more details, to provide your own custom overrides yaml file.

- To deploy a release, execute the following, substituting the <version> tag with your preferred release (ie. 13.0.0)::

    >  helm deploy dev onap-release/onap --namespace onap --create-namespace --set global.masterPassword=myAwesomePasswordThatINeedToChange --version <version> -f oom/kubernetes/onap/resources/overrides/onap-all.yaml







