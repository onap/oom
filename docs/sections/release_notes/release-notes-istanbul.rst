.. This work is licensed under a Creative Commons Attribution 4.0
   International License.
.. http://creativecommons.org/licenses/by/4.0
.. (c) ONAP Project and its contributors
.. _release_notes_istanbul:

:orphan:

*************************************
ONAP Operations Manager Release Notes
*************************************

Previous Release Notes
======================

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

This document provides the release notes for the Istanbul release.

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
| **Release designation**              | Istanbul                             |
|                                      |                                      |
+--------------------------------------+--------------------------------------+
| **Release date**                     | 2021/11/04                           |
|                                      |                                      |
+--------------------------------------+--------------------------------------+

New features
------------


**Bug fixes**

A list of issues resolved in this release can be found here:
https://jira.onap.org/projects/OOM/versions/11074


**Known Issues**


Deliverables
------------

Software Deliverables
~~~~~~~~~~~~~~~~~~~~~

OOM provides `Helm charts <https://nexus3.onap.org/service/rest/repository/browse/onap-helm-release/>`_


Documentation Deliverables
~~~~~~~~~~~~~~~~~~~~~~~~~~

Known Limitations, Issues and Workarounds
=========================================

Known Vulnerabilities
---------------------


Workarounds
-----------

- `OOM-2754 <https://jira.onap.org/browse/OOM-2754>`_
  Because of *updateEndpoint* property added to *cmpv2issuer* CRD
  it is impossible to upgrade platform component from Honolulu to Istanbul
  release without manual steps. Actions that should be performed:

  #. Update the CRD definition::

     > kubectl -n onap apply -f oom/kubernetes/platform/components/cmpv2-cert-provider/crds/cmpv2issuer.yaml
  #. Upgrade the component::

     > helm -n onap upgrade dev-platform oom/kubernetes/platform
  #. Make sure that *cmpv2issuer* contains correct value for
     *spec.updateEndpoint*. The value should be: *v1/certificate-update*.
     If it's not, edit the resource::

     > kubectl -n onap edit cmpv2issuer cmpv2-issuer-onap


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
