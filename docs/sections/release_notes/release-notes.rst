.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

- :ref:`Oslo <release_notes_oslo>`
- :ref:`New Delhi <release_notes_newdelhi>`
- :ref:`Montreal <release_notes_montreal>`
- :ref:`London <release_notes_london>`
- :ref:`Kohn <release_notes_kohn>`
- :ref:`Jakarta <release_notes_jakarta>`
- :ref:`Istanbul <release_notes_istanbul>`
- :ref:`Honolulu <release_notes_honolulu>`
- :ref:`Guilin <release_notes_guilin>`
- :ref:`Frankfurt <release_notes_frankfurt>`
- :ref:`El Alto <release_notes_elalto>`
- :ref:`Dublin <release_notes_dublin>`
- :ref:`Casablanca <release_notes_casablanca>`
- :ref:`Beijing <release_notes_beijing>`
- :ref:`Amsterdam <release_notes_amsterdam>`

Abstract
========

This document provides the release notes for the Paris release.

Summary
=======

Release Data
============

+--------------------------------------+--------------------------------------+
| **Project**                          | OOM                                  |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Docker images**                    | N/A                                  |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release designation**              | Paris                                |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2025/06/26                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Tested on the latest K8S Infrastructure

  * Kubernetes (v1.32.5)
  * CertManager (1.17.2)
  * Istio (v1.26.1)
  * Keycloak (26.0.6)

* Support the latest Database Operators:

  * MariaDB-Operator (0.38.1)
  * K8ssandra-Operator (v1.23.2)
  * Postgres-Operator (CrunchyData) (5.8.1)
  * MongoDB-Operator (Percona) (1.19.1)
  * Strimzi Kafka Operator (0.46.0)

* Update the helm common templates (13.2.19) to:

  * Make Jobs GitOps ready
  * Fix security vulnerabilities

* cassandra (16.0.0)

  * Support for new cassandra version (4.1.8)
  * Fix security vulnerabilities

* mariadb-galera (16.0.0)

  * Support for new mariadb version (11.7.2)
  * Fix security vulnerabilities

* mariadb-init (16.0.0)

  * Use ‘mariadb’ client instead of ‘mysql’
  * Add Job Annotations

* mongodb (16.5.7)

  * Use the latest Bitnami charts

* mongodb-init (13.0.6)

  * Add Job Annotations
  * Harmonize resource labeling

* nginx (18.3.5)

  * New (Bitnami) Chart used for UUI

* postgres-init (13.0.6)

  * Add Job Annotations
  * Harmonize resource labeling

* readinessCheck (13.1.4)

  * Update to the latest image
  * Harmonize resource labeling

* timescaleDB (13.0.2)

  * Harmonize resource labeling

**Bug fixes**

A list of issues resolved in this release can be found here:
https://lf-onap.atlassian.net/projects/OOM/versions/10791

**Known Issues**


Deliverables
------------

Software Deliverables
~~~~~~~~~~~~~~~~~~~~~

OOM provides `Helm charts <https://nexus3.onap.org/service/rest/repository/browse/onap-helm-release/>`_

Documentation Deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~

- :ref:`Project Description <oom_project_description>` - a guide for developers
  of OOM
- :ref:`oom_dev_guide` - a guide for developers of OOM
- :ref:`oom_infra_guide` - a guide for those setting up the environments that
  OOM will use
- :ref:`oom_deploy_guide` - a guide for those deploying OOM on an existing
  cloud
- :ref:`oom_user_guide` - a guide for operators of an OOM instance
- :ref:`oom_access_info_guide` - a guide for operators who require access to
  OOM applications

Known Limitations, Issues and Workarounds
=========================================

Known Vulnerabilities
---------------------


Workarounds
-----------

Security Notes
--------------

**Fixed Security Issues**

References
==========

For more information on the ONAP Istanbul release, please see:

#. `ONAP Home Page`_
#. `ONAP Documentation`_
#. `ONAP Release Downloads`_
#. `ONAP Wiki Page`_


.. _`ONAP Home Page`: https://www.onap.org
.. _`ONAP Wiki Page`: https://lf-onap.atlassian.net/wiki
.. _`ONAP Documentation`: https://docs.onap.org
.. _`ONAP Release Downloads`: https://git.onap.org
.. _`Gateway-API`: https://istio.io/latest/docs/tasks/traffic-management/ingress/gateway-api/
