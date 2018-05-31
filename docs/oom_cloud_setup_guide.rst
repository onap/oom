.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada

.. Links
.. _Microsoft Azure: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+Microsoft+Azure
.. _Amazon AWS: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+Amazon+EC2
.. _Google GCE: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+Google+Compute+Engine
.. _VMware VIO: https://wiki.onap.org/display/DW/ONAP+on+VMware+Integrated+OpenStack+-+Container+Orchestration
.. _OpenStack: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+OpenStack?src=contextnavpagetreemode
.. _Setting Up Kubernetes with Rancher: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+Rancher
.. _Setting Up Kubernetes with Kubeadm: https://wiki.onap.org/display/DW/Deploying+Kubernetes+Cluster+with+kubeadm
.. _Setting Up Kubernetes with Cloudify: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes+on+Cloudify
.. _ONAP on Kubernetes Wiki: https://wiki.onap.org/display/DW/ONAP+on+Kubernetes

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

  ==============  ==========  =====  =======  ========
  Release         Kubernetes  Helm   kubectl  Docker
  ==============  ==========  =====  =======  ========
  amsterdam       1.7.x       2.3.x  1.7.x    1.12.x
  beijing/master  1.8.10      2.8.2  1.8.10   17.03.x
  ==============  ==========  =====  =======  ========

Minimum Hardware Configuration
==============================

The minimum hardware requirements are provided below.  Note that although ONAP
may operate on a single node as described production deployments will need at
least three if not six nodes to ensure there is no single point of failure.

.. table:: OOM Hardware Requirements

  =====  =====  ======  ====================
  RAM    HD     vCores  Ports
  =====  =====  ======  ====================
  128GB  160GB  32      0.0.0.0/0 (all open)
  =====  =====  ======  ====================

.. note::
  Kubernetes supports a maximum of 110 pods per node which forces one to use at
  least two nodes to deploy all of ONAP although at least three are recommended
  (for example 4x32GB - 8 vCores each). Subsets of ONAP may still be deployed
  on a single node.

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

There are alternative deployment methods described on the `ONAP on Kubernetes Wiki`_
