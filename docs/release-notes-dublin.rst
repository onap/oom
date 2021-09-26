.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 Bell Canada & Amdocs Intellectual Property.  All rights
.. reserved.
.. _release_notes_dublin:

:orphan:

ONAP Operations Manager Release Notes
=====================================

Version 4.0.0 (Dublin Release)
------------------------------

:Release Date: 2019-06-26

**Previous Release Notes**

- :ref:`Casablanca <release_notes_casablanca>`
- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`


Summary
-------

**Platform Resiliency**

* Documentation of a Highly-Available Kubernetes Cluster Deployment
* Availability of a Default Storage Class Provisioner for improved Persistent
  Storage resiliency
* Availability of a CNI reference integration for Multi-site support

  * applications can take advantage of multi-site by using POD and/or Node
    (anti)affinity, taints/tolerations, labels per application

**Footprint Optimization**

* Shared MariaDB-Galera Cluster - current clients in Dublin: SO, SDNC
* Shared Cassandra Cluster - current clients in Dublin: AAI, SDC
* Optional deployment of independent clusters (backward compatibility)

**Platform Upgradability**

* Introduction of an Upgrade Framework supporting:

  * Automated rolling upgrades for applications
  * In-place schema and data migrations
  * Blue-Green deployment environment migration (e.g. Pre-prod to Prod)
  * Upgrades from embedded database instance into shared database instance

* Release-to-release upgrade support delivered for the following projects

  * A&AI
  * SDNC
  * SO

**Security Notes**

*Fixed Security Issues*

*Known Security Issues*

* In default deployment OOM (consul-server-ui) exposes HTTP port 30270 outside of cluster. [`OJSI-134 <https://jira.onap.org/browse/OJSI-134>`_]
* Hard coded password used for all oom deployments [`OJSI-188 <https://jira.onap.org/browse/OJSI-188>`_]
* CVE-2019-12127 - OOM exposes unprotected API/UI on port 30270 [`OJSI-202 <https://jira.onap.org/browse/OJSI-202>`_]

*Known Vulnerabilities in Used Modules*

OOM code has been formally scanned during build time using NexusIQ and no
Critical vulnerability was found.

Quick Links:

  - `OOM project page <https://wiki.onap.org/display/DW/ONAP+Operations+Manager+Project>`_

  - `Passing Badge information for OOM <https://bestpractices.coreinfrastructure.org/en/projects/1631>`_


**Known Issues**

End of Release Notes
