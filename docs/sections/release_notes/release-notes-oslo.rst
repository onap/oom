.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_oslo:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

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

This document provides the release notes for the Oslo release.

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
| **Release designation**              | Oslo                                 |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2025/01/09                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Support the latest Database Operators:

  * MariaDB-Operator (0.36.0)
  * K8ssandra-Operator (v0.20.2)
  * Postgres-Operator (CrunchyData) (5.7.2)
  * MongoDB-Operator (Percona) (1.18.0)

* authentication (15.0.0)

  * support for REALM Client AuthorizationSettings
  * update oauth2-proxy and keycloak-config-cli versions
  * add support for latest keycloak version 26.x

* Update the helm common templates (13.2.10) to:

  * add SecurityContext settings for Production readiness

* cassandra (13.1.1)

  * support for new cassandra version (4.1.6)
  * add SecurityContext settings for Production readiness

* mariadb-galera (13.2.3)

  * add SecurityContext settings for Production readiness

* mariadb-init (13.0.2)

  * add SecurityContext settings for Production readiness

* mongodb (14.12.4)

  * add SecurityContext settings for Production readiness

* mongodb-init (13.0.2)

  * new chart to support external mongodb initialization

* postgres (13.1.0)

  * add SecurityContext settings for Production readiness

* postgres-init (13.0.3)

  * add SecurityContext settings for Production readiness

* readinessCheck (13.1.1)

  * add SecurityContext settings for Production readiness

* serviceAccount (13.0.2)

  * adjust default role mapping

**Bug fixes**

A list of issues resolved in this release can be found here:
https://lf-onap.atlassian.net/projects/OOM/versions/10783

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
