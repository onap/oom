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

Some recommended hardware requirements are provided below. Note that this is
for a full ONAP deployment (all components).

.. table:: OOM Hardware Requirements

  =====  =====  ======  ====================
  RAM    HD     vCores  Ports
  =====  =====  ======  ====================
  224GB  160GB  112     0.0.0.0/0 (all open)
  =====  =====  ======  ====================

Customizing ONAP to deploy only components that are needed will drastically
reduce these requirements.
See the :ref:`OOM customized deployment<oom_customize_overrides>` section for
more details.

.. note::
    | Kubernetes supports a maximum of 110 pods per node - this can be overcome by modifying your kubelet config.
    | See the `kubelet config guide`_ for more information.

    | The use of many small nodes is preferred over a few larger nodes (for example 14 x 16GB - 8 vCores each).

    | OOM can be deployed on a private set of physical hosts or VMs (or even a combination of the two).

.. rubric:: Software Requirements

The versions of software that are supported and tested by OOM are as follows:

.. _versions_table:

.. table:: OOM Software Requirements (base)

  ==============     ===========  =======  ========  ========  =============  ========
  Release            Kubernetes   Helm     kubectl   Docker    Cert-Manager   Strimzi
  ==============     ===========  =======  ========  ========  =============  ========
  New Delhi          1.28.6       3.13.1   1.28.x    20.10.x   1.14.4         0.41.0
  Oslo               1.28.6       3.13.1   1.30.x    23.0.x    1.16.2         0.44.0
  Paris              1.32.5       3.16.4   1.32.x    23.0.x    1.17.2         0.46.0
  ==============     ===========  =======  ========  ========  =============  ========

.. table:: OOM Software Requirements (production)

  ==============     ======  ============ ==============
  Release            Istio   Gateway-API  Keycloak
  ==============     ======  ============ ==============
  New Delhi          1.21.0  v1.0.0       22.0.4
  Oslo               1.24.1  v1.2.1       26.0.6
  Paris              1.25.2  v1.2.1       26.0.6
  ==============     ======  ============ ==============

.. table:: OOM Software Requirements (optional)

  ==============     =========== ========== =========== ============ ===========
  Release            Prometheus  K8ssandra  MariaDB-Op  Postgres-Op  MongoDB-Op
  ==============     =========== ========== =========== ============ ===========
  New Delhi          45.x        1.16.0     0.28.1      -            -
  Oslo               45.x        1.20.2     0.36.0      5.7.2        1.18.0
  Paris              71.x        1.21.2     0.38.1      5.7.2        1.19.1
  ==============     =========== ========== =========== ============ ===========
