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

This document provides the release notes for the London release.

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
| **Release designation**              | London                               |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2023/06/29                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Introduction of "Production" ONAP setup, including:

  * Istio Service Mesh based deployment
  * Ingress (Istio-Gateway) deployment and usage as standard external access method
  * Internal Security provided by ServiceMesh and Component2Component AuthorizationPolicies
  * External Security by introducing AuthN/Z using Keycloak and OAuth2Proxy for Ingress Access

* Removal of unsupported components (AAF, Portal, Contrib,...)
* Update of Helmcharts to use common templates and practices
* Optional support for Cassandra 4.x using k8ssandra-operator

* `REQ-1349 <https://jira.onap.org/browse/REQ-1349>`_ Removal of AAF.
  Internal communication encryption and authorization is offered by ServiceMesh

* `REQ-1350 <https://jira.onap.org/browse/REQ-1350>`_ All component must be
  able to run without MSB. Component helm charts modified to use MSB optionally
  and test the components during Daily and Gating with and without MSB

* `REQ-1351 <https://jira.onap.org/browse/REQ-1351>`_ External secure
  communication only via Ingress.
  Ingress resources created by templates and Ingress installation is described
  in the OOM documents

**Bug fixes**

A list of issues resolved in this release can be found here:
https://jira.onap.org/projects/OOM/versions/11500

**Known Issues**

* Components not working under ServiceMesh

  * CDS UI
  * SO Monitor UI
  * CLI

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
  In London supported as option (using k8ssandra-operator), see :ref:`oom_base_optional_addons`

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
.. _`ONAP Wiki Page`: https://wiki.onap.org
.. _`ONAP Documentation`: https://docs.onap.org
.. _`ONAP Release Downloads`: https://git.onap.org
