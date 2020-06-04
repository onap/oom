.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada
.. _oom_project_description:

ONAP Operations Manager Project
###############################

The ONAP Operations Manager (OOM) is responsible for life-cycle management of
the ONAP platform itself; components such as SO, SDNC, etc. It is not
responsible for the management of services, VNFs or infrastructure instantiated
by ONAP or used by ONAP to host such services or VNFs. OOM uses the open-source
Kubernetes container management system as a means to manage the Docker
containers that compose ONAP where the containers are hosted either directly on
bare-metal servers or on VMs hosted by a 3rd party management system. OOM
ensures that ONAP is easily deployable and maintainable throughout its life
cycle while using hardware resources efficiently.

.. figure:: oomLogoV2-medium.png
   :align: right

In summary OOM provides the following capabilities:

- **Deploy** - with built-in component dependency management
- **Configure** - unified configuration across all ONAP components
- **Monitor** - real-time health monitoring feeding to a Consul UI and Kubernetes
- **Heal**- failed ONAP containers are recreated automatically
- **Scale** - cluster ONAP services to enable seamless scaling
- **Upgrade** - change-out containers or configuration with little or no service impact
- **Delete** - cleanup individual containers or entire deployments

OOM supports a wide variety of Kubernetes private clouds - built with Rancher,
Kubeadm or Cloudify - and public cloud infrastructures such as: Microsoft Azure,
Amazon AWS, Google GCD, VMware VIO, and Openstack.

The OOM documentation is broken into four different areas each targeted at a different user:

- :ref:`quick-start-label` - deploy ONAP on an existing cloud
- :ref:`user-guide-label` - a guide for operators of an ONAP instance
- :ref:`developer-guide-label` - a guide for developers of OOM and ONAP
- :ref:`cloud-setup-guide-label` - a guide for those setting up cloud environments that ONAP will use
- :ref:`hardcoded-certiticates-label` - the list of all hardcoded certificates sets in ONAP installation

The :ref:`release_notes` for OOM describe the incremental features per release.

Component Orchestration Overview
================================
Multiple technologies, templates, and extensible plug-in frameworks are used in
ONAP to orchestrate platform instances of software component artifacts. A few
standard configurations are provide that may be suitable for test, development,
and some production deployments by substitution of local or platform wide
parameters. Larger and more automated deployments may require integration the
component technologies, templates, and frameworks with a higher level of
automated orchestration and control software. Design guidelines are provided to
insure the component level templates and frameworks can be easily integrated
and maintained. The following diagram provides an overview of these with links
to examples and templates for describing new ones.

.. graphviz::

   digraph COO {
      rankdir="LR";

      {
         node      [shape=folder]
         oValues   [label="values"]
         cValues   [label="values"]
         comValues [label="values"]
         sValues   [label="values"]
         oCharts   [label="charts"]
         cCharts   [label="charts"]
         comCharts [label="charts"]
         sCharts   [label="charts"]
         blueprint [label="TOSCA blueprint"]
      }
      {oom [label="ONAP Operations Manager"]}
      {hlo [label="High Level Orchestrator"]}


      hlo -> blueprint
      hlo -> oom
      oom -> oValues
      oom -> oCharts
      oom -> component
      oom -> common
      common -> comValues
      common -> comCharts
      component -> cValues
      component -> cCharts
      component -> subcomponent
      subcomponent -> sValues
      subcomponent -> sCharts
      blueprint -> component
   }
