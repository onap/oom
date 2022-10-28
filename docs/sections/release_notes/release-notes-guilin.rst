.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_guilin:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

- :ref:`Frankfurt <release_notes_frankfurt>`
- :ref:`El Alto <release_notes_elalto>`
- :ref:`Dublin <release_notes_dublin>`
- :ref:`Casablanca <release_notes_casablanca>`
- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`

Abstract
========

This document provides the release notes for the Guilin release.

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
| **Release designation**              | Guilin                               |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2020/12/03                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Kubernetes support for version up to 1.19
* Helm (experimental) support for version up to 3.3
* Limits are set for most of the components

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
- `OOM-2227 <https://jira.onap.org/browse/OOM-2227>`_ Cassandra Backup Mechanism
  works only on "static PV" mode.
- `OOM-2285 <https://jira.onap.org/browse/OOM-2285>`_ deploy.sh does not work
  for mariadb-galera. deploy script doesn't behave well with "-" in the
  component name.
- `OOM-2421 <https://jira.onap.org/browse/OOM-2421>`_ OOM nbi chart deployment
  error
- `OOM-2534 <https://jira.onap.org/browse/OOM-2534>`_ Cert-Service leverages
  runtime external dependency
- `OOM-2554 <https://jira.onap.org/browse/OOM-2554>`_ Common pods have java 8
- `OOM-2588 <https://jira.onap.org/browse/OOM-2588>`_ Various subcharts not
  installing due to helm size issues
- `OOM-2629 <https://jira.onap.org/browse/OOM-2629>`_ NetBox demo entry setup
  not complete


Deliverables
------------

Software Deliverables
~~~~~~~~~~~~~~~~~~~~~

OOM provides `Helm charts <https://git.onap.org/oom/>`_ that needs to be
"compiled".

Documentation Deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~


Known Limitations, Issues and Workarounds
=========================================

Known Vulnerabilities
---------------------

- Hard coded password used for all OOM deployments
  [`OJSI-188 <https://jira.onap.org/browse/OJSI-188>`_]

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
- `OOM-2534 <https://jira.onap.org/browse/OOM-2534>`_ Workaround is to download
  in advance docker.io/openjdk:11-jre-slim where you will generate the charts

Security Notes
--------------

**Fixed Security Issues**

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
