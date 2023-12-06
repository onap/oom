.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _Kubernetes: https://kubernetes.io/


.. _oom_infra_guide:

OOM Infrastructure Guide
========================

.. figure:: ../../resources/images/oom_logo/oomLogoV2-medium.png
   :align: right

OOM deploys and manages ONAP on a pre-established Kubernetes_ cluster - the
creation of this cluster is outside of the scope of the OOM project as there
are many options including public clouds with pre-established environments.
If creation of a Kubernetes cluster is required, the life-cycle of this
cluster is independent of the life-cycle of the ONAP components themselves.

For more information about functionality and processes please refer to the
following documents:

.. toctree::
  :maxdepth: 1

  oom_infra_deployment_options.rst
  oom_infra_deployment_requirements.rst
  oom_infra_base_config_setup.rst
  oom_infra_optional_addons.rst
