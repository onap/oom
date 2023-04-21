.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_kohn:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

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

This document provides the release notes for the Kohn release.

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
| **Release designation**              | Kohn                                 |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2022/12/05                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Kubernetes support for version up to 1.23.8
* Helm support for version up to Helm: 3.8.2
* Kubespray version used for automated deployment 2.19 (used for automated deployment)
* Initial Setup for "ONAP on ServiceMesh" deployment

  * using Istio 1.14.1 as SM platform
  * including Istio Ingress Gateway for external access
  * modify 90% of ONAP component charts to support SeviceMesh

**Bug fixes**

A list of issues resolved in this release can be found here:
https://jira.onap.org/projects/OOM/versions/11499


**Known Issues**


Deliverables
------------

Software Deliverables
~~~~~~~~~~~~~~~~~~~~~

OOM provides `Helm charts <https://nexus3.onap.org/service/rest/repository/browse/onap-helm-release/>`_

Documentation Deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~

- :ref:`Project Description <oom_project_description>` - a guide for developers of OOM
- :ref:`oom_dev_guide` - a guide for developers of OOM
- :ref:`oom_infra_guide` - a guide for those setting up the environments that OOM will use
- :ref:`oom_deploy_guide` - a guide for those deploying OOM on an existing cloud
- :ref:`oom_user_guide` - a guide for operators of an OOM instance
- :ref:`oom_access_info_guide` - a guide for operators who require access to OOM applications

Known Limitations, Issues and Workarounds
=========================================

Known Vulnerabilities
---------------------

* Cassandra version needs to be updated to support new Python version
  see `OOM-2900 <https://jira.onap.org/browse/OOM-2900>`_

Workarounds
-----------


Security Notes
--------------

**Fixed Security Issues**

* Fixed vulnerabilities for oom-platform-cert-service
  see `Fixes <https://wiki.onap.org/pages/viewpage.action?spaceKey=SV&title=Kohn+OOM>`_

References
==========

For more information on the ONAP Istanbul release, please see:

#. `ONAP Home Page`_
#. `ONAP Documentation`_
#. `ONAP Release Downloads`_
#. `ONAP Wiki Page`_


.. _`ONAP Home Page`: https://www.onap.org
.. _`ONAP Wiki Page`: https://wiki.onap.org
.. _`ONAP Documentation`: https://docs.onap.org
.. _`ONAP Release Downloads`: https://git.onap.org
