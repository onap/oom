.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_newdelhi:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

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

This document provides the release notes for the New Delhi release.

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
| **Release designation**              | New Delhi                            |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2024/06/13                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* authentication (14.0.0) - add configurable Keycloak Realm and enable Ingress
  Interface Authentication and Authorization
* Update the helm common templates (13.2.0) to:

  * Support the latest Database Operators:

    * MariaDB-Operator (0.28.1)
    * K8ssandra-Operator (v0.16.0)
    * Postgres-Operator (CrunchyData) (5.5.0)

* cassandra (13.1.0) - support for new K8ssandra-Operator
* mariadb-galera (13.1.0) - support for new MariaDB-Operator
* mongodb (14.12.3) - update to latest bitnami chart version
* postgres (13.1.0) - support for new Postgres-Operator
* postgres-init (13.0.1) - support for new Postgres-Operator
* readinessCheck (13.1.0) - added check for "Service" readiness
* serviceAccount (13.0.1) - add default role creation

**Bug fixes**

A list of issues resolved in this release can be found here:
https://lf-onap.atlassian.net/projects/OOM/versions/11502

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
