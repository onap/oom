.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 Bell Canada & Amdocs Intellectual Property.  All rights
.. reserved.
.. _release_notes_elalto:

:orphan:

ONAP Operations Manager Release Notes
=====================================

Version 5.0.1 (El Alto Release)
-------------------------------

:Release Date: 2019-10-10

**Previous Release Notes**

- :ref:`Dublin <release_notes_dublin>`
- :ref:`Casablanca <release_notes_casablanca>`
- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`


Summary
-------

The focus of this release was on maintenance and as such no new features were
delivered.
A list of issues resolved in this release can be found here: https://jira.onap.org/projects/OOM/versions/10726

**New Features**

**Bug Fixes**

* 25 defects addressed (see link above)

**Known Issues**

The following known issues will be addressed in a future release:

* [`OOM-1480 <https://jira.onap.org/browse/OOM-1480>`_] - postgres chart does not set root password when installing on an existing database instances
* [`OOM-1966 <https://jira.onap.org/browse/OOM-1966>`_] - ONAP on HA Kubernetes Cluster - Documentation update
* [`OOM-1995 <https://jira.onap.org/browse/OOM-1995>`_] - Mariadb Galera cluster pods keep failing
* [`OOM-2061 <https://jira.onap.org/browse/OOM-2061>`_] - Details Missing for installing the kubectl section
* [`OOM-2075 <https://jira.onap.org/browse/OOM-2075>`_] - Invalid MTU for Canal CNI interfaces
* [`OOM-2080 <https://jira.onap.org/browse/OOM-2080>`_] - Need for "ReadWriteMany" access on storage when deploying on Kubernetes?
* [`OOM-2091 <https://jira.onap.org/browse/OOM-2091>`_] - incorrect release deployed
* [`OOM-2132 <https://jira.onap.org/browse/OOM-2132>`_] - Common Galera server.cnf does not contain Camunda required settings

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


Version 5.0.0 (El Alto Early Drop)
----------------------------------

:Release Date: 2019-08-19

Summary
-------

**Software Requirements**

* Upgraded to Kubernetes 1.15.x and Helm 1.14.x
