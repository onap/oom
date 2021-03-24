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
| **Release date**                     | 2020/12/03                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------

* Kubernetes support for version up to 1.20
* Helm support for version up to 3.5
* Limits are set for most of the components

**Bug fixes**

A list of issues resolved in this release can be found here:
https://jira.onap.org/projects/OOM/versions/10826

**Known Issues**

- `<https://github.com/bitnami/bitnami-docker-mariadb-galera/issues/35>`_
  bitnami mariadb galera image doesn't support single quote in password.



Deliverables
------------

Software Deliverables
~~~~~~~~~~~~~~~~~~~~~

OOM provides `Helm charts <https://git.onap.org/oom/>`_ that needs to be
"compiled" into Helm package. see step 6 in
:doc:`quickstart guide <oom_quickstart_guide>`.

Documentation Deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~

- :doc:`Project Description <oom_project_description>`
- :doc:`Cloud Setup Guide <oom_cloud_setup_guide>`
- :doc:`Quick Start Guide <oom_quickstart_guide>`
- :doc:`Setup Ingress Controller <oom_setup_ingress_controller>`
- :doc:`Developer Guide <oom_developer_guide>`
- :doc:`Hardcoded Certificates <oom_hardcoded_certificates>`

Known Limitations, Issues and Workarounds
=========================================

Known Vulnerabilities
---------------------

- Hard coded password used for all OOM deployments
  [`OJSI-188 <https://jira.onap.org/browse/OJSI-188>`_]
- :doc:`Hard coded certificates <oom_hardcoded_certificates>` in Helm packages

Workarounds
-----------

- `<https://github.com/bitnami/bitnami-docker-mariadb-galera/issues/35>`_
  Workaround is to generate a password with "short" strenght or pregenerate
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
