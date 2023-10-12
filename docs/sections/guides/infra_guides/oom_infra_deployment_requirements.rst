.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _Kubernetes: https://kubernetes.io/
.. _Kubernetes best practices: https://kubernetes.io/docs/setup/best-practices/cluster-large/
.. _kubelet config guide: https://kubernetes.io/docs/reference/command-line-tools-reference/kubelet/



ONAP Deployment Requirements
============================

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
    | See the `kubelet config guide`_ for more information.

    | The use of many small nodes is preferred over a few larger nodes (for example 14 x 16GB - 8 vCores each).

    | OOM can be deployed on a private set of physical hosts or VMs (or even a combination of the two).

.. rubric:: Software Requirements

The versions of software that are supported by OOM are as follows:

.. _versions_table:

.. table:: OOM Software Requirements (base)

  ==============     ===========  =======  ========  ========  =============  ========
  Release            Kubernetes   Helm     kubectl   Docker    Cert-Manager   Strimzi
  ==============     ===========  =======  ========  ========  =============  ========
  Kohn               1.23.8       3.8.2    1.23.8    20.10.x   1.8.0          0.32.0
  London             1.23.8       3.8.2    1.23.x    20.10.x   1.12.2         0.35.0
  Montreal           1.23.8       3.10.2   1.23.x    20.10.x   1.12.2         0.35.0
  ==============     ===========  =======  ========  ========  =============  ========

.. table:: OOM Software Requirements (production)

  ==============     ======  ============ ==============
  Release            Istio   Gateway-API  Keycloak
  ==============     ======  ============ ==============
  London             1.17.2  v0.6.2       19.0.3-legacy
  Montreal           1.17.2  v0.6.2       19.0.3-legacy
  ==============     ======  ============ ==============

.. table:: OOM Software Requirements (optional)

  ==============     ================= ========== =================
  Release            Prometheus Stack  K8ssandra  MariaDB-Operator
  ==============     ================= ========== =================
  Kohn               35.x
  London             45.x              1.6.1
  Montreal           45.x              1.9.1      0.21.0
  ==============     ================= ========== =================
