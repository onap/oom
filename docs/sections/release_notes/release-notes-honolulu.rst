.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_honolulu:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

- :ref:`Guilin <release_notes_guilin>`
- :ref:`Frankfurt <release_notes_frankfurt>`
- :ref:`El Alto <release_notes_elalto>`
- :ref:`Dublin <release_notes_dublin>`
- :ref:`Casablanca <release_notes_casablanca>`
- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`

Abstract
========

This document provides the release notes for the Honolulu release.

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
| **Release designation**              | Honolulu                             |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2021/04/29                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Kubernetes support for version up to 1.20
* Helm support for version up to 3.5
* Limits are set for most of the components
* Portal-Cassandra image updated to Bitnami, supporting IPv4/IPv6 Dual Stack
* CMPv2 external issuer implemented which extends Cert-Manager with ability  to
  enroll X.509 certificates from CMPv2 servers
* New version for mariadb galera using Bitnami image, supporting IPv4/IPv6 Dual
  Stack
* Bump version of common PostgreSQL and ElasticSearch
* Move to automatic certificates retrieval for 80% of the components
* Consistent retrieval of docker images, with ability to configure proxy for
  the 4 repositories used by ONAP

**Bug fixes**

A list of issues resolved in this release can be found here:
https://jira.onap.org/projects/OOM/versions/11073

major issues solved:

* Better handling of persistence on PostgreSQL
* Better Ingress templating
* Better Service templating

**Known Issues**

- `OOM-2554 <https://jira.onap.org/browse/OOM-2554>`_ Common pods have java 8
- `OOM-2435 <https://jira.onap.org/browse/OOM-2435>`_ SDNC karaf shell:
  log:list: Error executing command: Unrecognized configuration
- `OOM-2629 <https://jira.onap.org/browse/OOM-2629>`_ NetBox demo entry setup
  not complete
- `OOM-2706 <https://jira.onap.org/browse/OOM-2706>`_ CDS Blueprint Processor
  does not work with local DB
- `OOM-2713 <https://jira.onap.org/browse/OOM-2713>`_ Problem on onboarding
  custom cert to SDNC ONAP during deployment
- `OOM-2698 <https://jira.onap.org/browse/OOM-2698>`_ SO helm override fails in
  for value with multi-level replacement
- `OOM-2697 <https://jira.onap.org/browse/OOM-2697>`_ SO with local MariaDB
  deployment fails
- `OOM-2538 <https://jira.onap.org/browse/OOM-2538>`_ strange error with
  CertInitializer template
- `OOM-2547 <https://jira.onap.org/browse/OOM-2547>`_ Health Check failures
  seen after bringing down/up control plane & worker node VM instances on which
  ONAP hosted
- `OOM-2699 <https://jira.onap.org/browse/OOM-2699>`_ SO so-mariadb
  readinessCheck fails for local MariaDB instance
- `OOM-2705 <https://jira.onap.org/browse/OOM-2705>`_ SDNC DB installation fails
  on local MariaDB instance
- `OOM-2603 <https://jira.onap.org/browse/OOM-2603>`_ [SDNC] allign password for
  scaleoutUser/restconfUser/odlUser

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
- `Hard coded certificates <../oom_hardcoded_certificates>` in Helm packages

Workarounds
-----------

- `<https://github.com/bitnami/charts/issues>`_
  Workaround is to generate a password with "short" strength or pregenerate
  passwords without single quote in it. Default deployment is using "short"
  password generation for mariadb.

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
