.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _Kubernetes: https://kubernetes.io/
.. _Kubernetes best practices: https://kubernetes.io/docs/setup/best-practices/cluster-large/
.. _kubelet confg guide: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/

.. _oom_infra_setup_guide:

OOM Infrastructure Guide
########################

.. figure:: ../../resources/images/oom_logo/oomLogoV2-medium.png
   :align: right

OOM deploys and manages ONAP on a pre-established Kubernetes_ cluster - the
creation of this cluster is outside of the scope of the OOM project as there
are many options including public clouds with pre-established environments.
If creation of a Kubernetes cluster is required, the life-cycle of this
cluster is independent of the life-cycle of the ONAP components themselves.

.. rubric::  Minimum Hardware Configuration

Some recommended hardware requirements are provided below. Note that this is for a
full ONAP deployment (all components).

.. table:: OOM Hardware Requirements

  =====  =====  ======  ====================
  RAM    HD     vCores  Ports
  =====  =====  ======  ====================
  224GB  160GB  112     0.0.0.0/0 (all open)
  =====  =====  ======  ====================

Customizing ONAP to deploy only components that are needed will drastically reduce these requirements.
See the :ref:`OOM customized deployment<oom_customize_overrides>` section for more details.

.. note::
    | Kubernetes supports a maximum of 110 pods per node - this can be overcome by modifying your kubelet config.
    | See the `kubelet confg guide`_ for more information.

    | The use of many small nodes is preferred over a few larger nodes (for example 14 x 16GB - 8 vCores each).

    | OOM can be deployed on a private set of physical hosts or VMs (or even a combination of the two).

.. rubric:: Software Requirements

The versions of software that are supported by OOM are as follows:

.. _versions_table:

.. table:: OOM Software Requirements (base)

  ==============     ===========  =======  ========  ========  ============  =======
  Release            Kubernetes   Helm     kubectl   Docker    Cert-Manager  Strimzi
  ==============     ===========  =======  ========  ========  ============  =======
  Jakarta            1.22.4       3.6.3    1.22.4    20.10.x   1.8.0         0.28.0
  Kohn               1.23.8       3.8.2    1.23.8    20.10.x   1.8.0         0.32.0
  ==============     ===========  =======  ========  ========  ============  =======

.. table:: OOM Software Requirements (optional)

  ==============     =================  ======
  Release            Prometheus Stack   Istio
  ==============     =================  ======
  Jakarta            35.x               ---
  Kohn               35.x               1.15.1
  ==============     =================  ======


.. toctree::
  :hidden:

  oom_base_config_setup.rst
  oom_base_optional_addons.rst
  oom_setup_ingress_controller.rst


