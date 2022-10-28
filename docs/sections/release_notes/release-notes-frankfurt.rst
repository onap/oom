.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_frankfurt:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

- :ref:`El Alto <release_notes_elalto>`
- :ref:`Dublin <release_notes_dublin>`
- :ref:`Casablanca <release_notes_casablanca>`
- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`

Abstract
========

This document provides the release notes for the Frankfurt release.

Summary
=======

The focus of this release is to strengthen the foundation of OOM installer.

Release Data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | OOM                                  |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Docker images**                    | N/A                                  |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release designation**              | Frankfurt                            |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2020/06/15                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Ingress deployment is getting more and more usable
* Use of dynamic Persistent Volume is available

**Bug fixes**

A list of issues resolved in this release can be found here:
https://jira.onap.org/projects/OOM/versions/10826

**Known Issues**

- `OOM-1237 <https://jira.onap.org/browse/OOM-1237>`_ Source Helm Charts from
  ONAP Repo. Having helm charts repo is not possible for Frankfurt release.
- `OOM-1720 <https://jira.onap.org/browse/OOM-1237>`_ galera container is
  outdated. containers used for mariadb are outdated and not supported anymore.
- `OOM-1817 <https://jira.onap.org/browse/OOM-1817>`_ Use of global.repository
  inconsistent across Helm Charts. it's then may be hard to retrieve some
  containers when deploying in constrained environment.
- `OOM-2075 <https://jira.onap.org/browse/OOM-2075>`_ Invalid MTU for Canal CNI
  interfaces
- `OOM-2227 <https://jira.onap.org/browse/OOM-2227>`_ Cassandra Backup Mechanism
  works only on "static PV" mode.
- `OOM-2230 <https://jira.onap.org/browse/OOM-2230>`_ Missing requests/limits
  for some PODS. This can lead to "memory bombing" so cautious monitoring of
  Kubernetes resources usage must be set up.
- `OOM-2279 <https://jira.onap.org/browse/OOM-2279>`_ OOM El Alto and master
  clamp mariadb resources doesn't match chart.
- `OOM-2285 <https://jira.onap.org/browse/OOM-2285>`_ deploy.sh does not work
  for mariadb-galera. deploy script doesn't behave well with "-" in the
  component name.
- `OOM-2369 <https://jira.onap.org/browse/OOM-2369>`_ DMAAP Helm install takes
  too long and often fails.
- `OOM-2418 <https://jira.onap.org/browse/OOM-2418>`_ Readiness-check 2.0.2 not
  working properly for stateful set.
- `OOM-2421 <https://jira.onap.org/browse/OOM-2421>`_ OOM NBI chart deployment
  error. In some case, NBI deployment fails.
- `OOM-2422 <https://jira.onap.org/browse/OOM-2422>`_ Portal App is unreachable
  when deploying without HTTPs


Deliverables
------------

Software Deliverables
~~~~~~~~~~~~~~~~~~~~~


Documentation Deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~

Known Limitations, Issues and Workarounds
=========================================

Known Vulnerabilities
---------------------

Workarounds
-----------

- `OOM-1237 <https://jira.onap.org/browse/OOM-1237>`_ Workaround is to generate
  them as explained in documentation.
- `OOM-1817 <https://jira.onap.org/browse/OOM-1817>`_ Workaround is to use
  offline installer if needed.
- `OOM-2227 <https://jira.onap.org/browse/OOM-2227>`_ Workaround is to stick to
  "static PV" (so, not using storage class) if backup is needed.
- `OOM-2285 <https://jira.onap.org/browse/OOM-2285>`_ Workaround is to use
  directly helm upgrade if needed.
- `OOM-2369 <https://jira.onap.org/browse/OOM-2369>`_ Workaround is to play
  postinstall jobs by hand.
- `OOM-2418 <https://jira.onap.org/browse/OOM-2418>`_ Workaround is to use
  version 2.2.2 in global part of override file if the new check is needed.
- `OOM-2421 <https://jira.onap.org/browse/OOM-2421>`_ Workaround is to
  undeploy/redeploy NBI.
- `OOM-2422 <https://jira.onap.org/browse/OOM-2422>`_ Workaround is to create
  first portal app service with service type Cluster IP then changing it to
  NodePort or LoadBalancer so all the port are available.

Security Notes
--------------

**Fixed Security Issues**

- In default deployment OOM (consul-server-ui) exposes HTTP port 30270 outside
  of cluster. [`OJSI-134 <https://jira.onap.org/browse/OJSI-134>`_]
- CVE-2019-12127 - OOM exposes unprotected API/UI on port 30270
  [`OJSI-202 <https://jira.onap.org/browse/OJSI-202>`_]

References
==========

For more information on the ONAP Frankfurt release, please see:

#. `ONAP Home Page`_
#. `ONAP Documentation`_
#. `ONAP Release Downloads`_
#. `ONAP Wiki Page`_


.. _`ONAP Home Page`: https://www.onap.org
.. _`ONAP Wiki Page`: https://wiki.onap.org
.. _`ONAP Documentation`: https://docs.onap.org
.. _`ONAP Release Downloads`: https://git.onap.org
