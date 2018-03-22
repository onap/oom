.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada

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
  Inclusion of a cloud technology or provider in this guide does not imply any
  endorsement of this technology.

.. _Kubernetes: https://kubernetes.io/

The versions of Kubernetes that are supported by OOM are as follows:

.. table:: OOM Software Requirements

  ==============  ==========  =====  =======  ========
  Release         Kubernetes  Helm   kubectl  Docker
  ==============  ==========  =====  =======  ========
  amsterdam       1.7.x       2.3.x  1.7.x    1.12.x
  beijing/master  1.8.5       2.7.x  1.8.5    1.12.x
  ==============  ==========  =====  =======  ========

Minimum Hardware Requirements
=============================


Cloud Installation
==================

#. OOM supports deployment on major public clouds. The following guides
   provide instructions on how to deploy ONAP on these clouds:

   - Microsoft Azure,
   - Amazon AWS,
   - Google GCD,
   - VMware VIO,
   - IBM, and
   - Openstack

#. Alternatively, OOM can be deployed on a private set of physical hosts or VMs
   (or even a combination of the two). The following guides describe how to
   create a Kubernetes cluster with popular tools:

   - Setting up Kubernetes with Rancher (recommended)
   - Setting up Kubernetes with Kubeadm
   - Setting up Kubernetes with Cloudify

