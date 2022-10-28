.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 Bell Canada & Amdocs Intellectual Property.  All rights
.. reserved.
.. _release_notes_casablanca:

:orphan:

ONAP Operations Manager Release Notes
=====================================

Version 3.0.0 Casablanca Release
--------------------------------

:Release Date: 2018-11-30

**Previous Release Notes**

- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`

Summary
-------

The focus of this release was on incremental improvements in the following
areas:

* Pluggable persistent storage with support for GlusterFS as the first storage
  class provisioner

* CPU and Memory limits in Helm Charts to improve Pod placement based on
  resource availability in Kubernetes Cluster

* Support of Node Selectors for Pod placement

* Common "shared" Helm Charts referencing common images

  - mariadb-galera
  - postgres
  - cassandra
  - mysql
  - mongo

* Integration of ARK Backup and Restore solution

* Introduction of Helm deploy and undeploy plugins to better manage ONAP
  deployments


**Security Notes**

OOM code has been formally scanned during build time using NexusIQ and no
Critical vulnerability was found.

Quick Links:

  - `OOM project page <https://wiki.onap.org/display/DW/ONAP+Operations+Manager+Project>`_

  - `Passing Badge information for OOM <https://bestpractices.coreinfrastructure.org/en/projects/1631>`_


**Known Issues**

 * **Problem**:        kubectl connections to pods (kubectl exec|logs) will
   fail after a while due to a known bug in Kubernetes (1.11.2)

   **Workaround**:     Restart of the kubelet daemons on the k8s hosts

   **Fix**:            Will be delivered in the next release via a new
   Kubernetes version (1.12)

   - `K8S Bug Report <https://github.com/kubernetes/kubernetes/issues/67659>`_
   - `OOM-1532 <https://jira.onap.org/browse/OOM-1532>`_
   - `OOM-1516 <https://jira.onap.org/browse/OOM-1516>`_
   - `OOM-1520 <https://jira.onap.org/browse/OOM-1520>`_

End of Release Notes
