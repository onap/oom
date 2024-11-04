.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_montreal:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

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

This document provides the release notes for the Montreal release.

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
| **Release designation**              | Montreal                             |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2023/12/14                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Introduction of "Production" ONAP setup, including:

  * Besides the Istio Ingress APIs now the support for `Gateway-API`_
    is added to the templates, which includes:

    * TCP Routes
    * UDP Routes

* Update of Helmcharts to use common templates and practices
* Default support for Cassandra 4.x using k8ssandra-operator
* Default support for MariaDB 11.x using mariadb-operator

**Bug fixes**

A list of issues resolved in this release can be found here:
https://lf-onap.atlassian.net/projects/OOM/versions/11501

**Known Issues**

* Components not working under ServiceMesh

  * SO Monitor UI
  * Policy UI

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
