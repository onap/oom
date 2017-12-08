.. This work is licensed under a Creative Commons Attribution 4.0 International License.

.. _onap-operations-manager-project:

ONAP Operations Manager Project
###############################

Introduction
============

The ONAP Operations Manager (OOM) is responsible for life-cycle
management of the ONAP platform itself; components such as MSO, SDNC,
etc. It is not responsible for the management of services, VNFs or
infrastructure instantiated by ONAP or used by ONAP to host such
services or VNFs. OOM uses the open-source Kubernetes container
management system as a means to manage the Docker containers that
compose ONAP where the containers are hosted either directly on
bare-metal servers or on VMs hosted by a 3rd party management system.
OOM ensures that ONAP is easily deployable and maintainable throughout
its life cycle while using hardware resources efficiently. 

Quick Start Guide
=================

Once a kubernetes environment is available (check out `ONAP on Kubernetes <https://wiki.onap.org/display/DW/ONAP+on+Kubernetes>`__ if you're
getting started) and the deployment artifacts have been customized for your location, ONAP is ready to be installed. 

The first step is to setup
the \ `/oom/kubernetes/config/onap-parameters.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters.yaml;h=7ddaf4d4c3dccf2fad515265f0da9c31ec0e64b1;hb=refs/heads/master>`__
file with key-value pairs specific to your OpenStack environment.  There is a
`sample <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/onap-parameters-sample.yaml;h=3a74beddbbf7f9f9ec8e5a6abaecb7cb238bd519;hb=refs/heads/master>`__
that may help you out or even be usable directly if you don't intend to actually use OpenStack resources.

In-order to be able to support multiple ONAP instances within a single kubernetes environment a configuration set is required.
 The `createConfig.sh <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/createConfig.sh;h=f226ccae47ca6de15c1da49be4b8b6de974895ed;hb=refs/heads/master>`__ script
is used to do this.::

  > ./createConfig.sh -n onapTrial

The bash script 
\ `createAll.bash <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/oneclick/createAll.bash;h=5e5f2dc76ea7739452e757282e750638b4e3e1de;hb=refs/heads/master>`__ is
used to create an ONAP deployment with kubernetes. It has two primary
functions:

-  Creating the namespaces used to encapsulate the ONAP components, and

-  Creating the services, pods and containers within each of these
   namespaces that provide the core functionality of ONAP.

To deploy the containers and create your ONAP system enter::

  > ./createAll.bash -n onapTrial

Namespaces provide isolation between ONAP components as ONAP release 1.0
contains duplicate application (e.g. mariadb) and port usage. As
such createAll.bash requires the user to enter a namespace prefix string
that can be used to separate multiple deployments of onap. The result
will be set of 10 namespaces (e.g. onapTrial-sdc, onapTrial-aai,
onapTrial-mso, onapTrial-message-router, onapTrial-robot, onapTrial-vid,
onapTrial-sdnc, onapTrial-portal, onapTrial-policy, onapTrial-appc)
being created within the kubernetes environment.  A prerequisite pod
config-init (\ `pod-config-init.yaml <https://gerrit.onap.org/r/gitweb?p=oom.git;a=blob;f=kubernetes/config/pod-config-init.yaml;h=b1285ce21d61815c082f6d6aa3c43d00561811c7;hb=refs/heads/master>`__)
may need editing to match your environment and deployment into the
default namespace before running createAll.bash.

Demo Video
----------

If you'd like to see the installation of ONAP by OOM take a look at this
short video demonstration by Mike Elliott: 

.. raw:: html

   <video controls src="_static/OOM_Demo.mp4"></video>


OOM Architecture and Technical Details
======================================

OOM uses the \ `Kubernetes  <http://kubernetes.io/>`__\ container
management system to orchestrate the life cycle of the ONAP
infrastructure components.  If you'd like to learn more about how this
works or develop the deployment specifications for a project not already
managed by OOM look here: \ `OOM User
Guide <http://onap.readthedocs.io/en/latest/submodules/oom.git/docs/OOM%20User%20Guide/oom_user_guide.html>`__.


Links to Further Information
============================

-  Configuration data for all of the ONAP sub-projects is distributed by
   OOM.  For more information on how this is done see: \ `OOM
   Configuration Management <https://wiki.onap.org/display/DW/OOM+Configuration+Management>`__.
