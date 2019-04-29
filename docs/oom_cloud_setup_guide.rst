.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2019 Amdocs, Bell Canada

.. Links
.. _Microsoft Azure: https://wiki.onap.org/display/DW/Cloud+Native+Deployment#CloudNativeDeployment-MicrosoftAzure
.. _Amazon AWS: https://wiki.onap.org/display/DW/Cloud+Native+Deployment#CloudNativeDeployment-AmazonAWS
.. _Google GCE: https://wiki.onap.org/display/DW/Cloud+Native+Deployment#CloudNativeDeployment-GoogleGCE
.. _VMware VIO: https://wiki.onap.org/display/DW/ONAP+on+VMware+Integrated+OpenStack+-+Container+Orchestration
.. _OpenStack: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+OpenStack?src=contextnavpagetreemode
.. _Setting Up Kubernetes with Rancher: https://wiki.onap.org/display/DW/Cloud+Native+Deployment
.. _Setting Up Kubernetes with Kubeadm: https://wiki.onap.org/display/DW/Deploying+Kubernetes+Cluster+with+kubeadm
.. _Cloud Native Deployment Wiki: https://wiki.onap.org/display/DW/Cloud+Native+Deployment
.. _ONAP Development - 110 pod limit Wiki: https://wiki.onap.org/display/DW/ONAP+Development#ONAPDevelopment-Changemax-podsfromdefault110podlimit

.. figure:: oomLogoV2-medium.png
   :align: right

.. _cloud-setup-guide-label:

OOM Cloud Setup Guide
#####################

OOM deploys and manages ONAP on a pre-established Kubernetes_ cluster - the
creation of this cluster is outside of the scope of the OOM project as there
are many options including public clouds with pre-established environments.
However, this guide includes instructions for how to create and use some of the
more popular environments which could be used to host ONAP. If creation of a
Kubernetes cluster is required, the life-cycle of this cluster is independent
of the life-cycle of the ONAP components themselves. Much like an OpenStack
environment, the Kubernetes environment may be used for an extended period of
time, possibly spanning multiple ONAP releases.

.. note::
  Inclusion of a cloud technology or provider in this guide does not imply an
  endorsement.

.. _Kubernetes: https://kubernetes.io/

Software Requirements
=====================

The versions of Kubernetes that are supported by OOM are as follows:

.. table:: OOM Software Requirements

  ==============     ===========  =====  ========  ========
  Release            Kubernetes   Helm   kubectl   Docker
  ==============     ===========  =====  ========  ========
  amsterdam          1.7.x        2.3.x  1.7.x     1.12.x
  beijing            1.8.10       2.8.2  1.8.10    17.03.x
  casablanca         1.11.5       2.9.1  1.11.5    17.03.x
  dublin             1.13.5       2.12.3 1.13.5    18.09.5
  ==============     ===========  =====  ========  ========

Minimum Hardware Configuration
==============================

The hardware requirements are provided below. Note that this is for a
full ONAP deployment (all components). Customizing ONAP to deploy only
components that are needed will drastically reduce the requirements.

.. table:: OOM Hardware Requirements

  =====  =====  ======  ====================
  RAM    HD     vCores  Ports
  =====  =====  ======  ====================
  224GB  160GB  112     0.0.0.0/0 (all open)
  =====  =====  ======  ====================

.. note::
  Kubernetes supports a maximum of 110 pods per node - configurable in the --max-pods=n setting off the
  "additional kubelet flags" box in the kubernetes template window described in 'ONAP Development - 110 pod limit Wiki'
  - this limit does not need to be modified . The use of many small
  nodes is preferred over a few larger nodes (for example 14x16GB - 8 vCores each).
  Subsets of ONAP may still be deployed on a single node.

Cloud Installation
==================

.. #. OOM supports deployment on major public clouds. The following guides
..    provide instructions on how to deploy ONAP on these clouds:
..
..    - `Microsoft Azure`_,
..    - `Amazon AWS`_,
..    - `Google GCE`_,
..    - `VMware VIO`_,
..    - IBM, and
..    - `Openstack`_.
..
.. #. Alternatively, OOM can be deployed on a private set of physical hosts or VMs
..    (or even a combination of the two). The following guides describe how to
..    create a Kubernetes cluster with popular tools:
..
..    - `Setting up Kubernetes with Rancher`_ (recommended)
..    - `Setting up Kubernetes with Kubeadm`_
..    - `Setting up Kubernetes with Cloudify`_

OOM can be deployed on a private set of physical hosts or VMs (or even a
combination of the two). The following guide describe the recommended method to
setup a Kubernetes cluster: :ref:`onap-on-kubernetes-with-rancher`.

There are alternative deployment methods described on the `Cloud Native Deployment Wiki`_
