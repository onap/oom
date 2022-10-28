.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _ONAP Release Long Term Roadmap: https://wiki.onap.org/display/DW/Long+Term+Roadmap

.. _oom_deploy_guide:

OOM Deployment Guide
--------------------

.. figure:: ../../resources/images/oom_logo/oomLogoV2-medium.png
   :align: right

ONAP OOM supports several options for the deployment of ONAP using it's helm charts.

    * :ref:`oom_helm_release_repo_deploy`
    * :ref:`oom_helm_testing_repo_deploy`
    * :ref:`oom_dev_testing_local_deploy`

.. warning::
    | **Pre-requisites**
    | The following sections must be completed before continuing with deployment:

        | :ref:`Set up your base platform<oom_base_setup_guide>`


Each deployment method can be customized to deploy a subset of ONAP component applications.
See the :ref:`oom_customize_overrides` section for more details.


.. toctree::
  :hidden:

  oom_customize_overrides.rst
  oom_helm_release_repo_deploy.rst
  oom_helm_testing_repo_deploy.rst
  oom_dev_testing_local_deploy.rst


