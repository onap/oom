.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 Bell Canada & Amdocs Intellectual Property.  All rights
.. reserved.
.. _release_notes_amsterdam:

:orphan:

ONAP Operations Manager Release Notes
=====================================

Version: 1.1.0
--------------

:Release Date: 2017-11-16

**New Features**

The Amsterdam release is the first release of the ONAP Operations Manager
(OOM).

The main goal of the Amsterdam release was to:

    - Support Flexible Platform Deployment via Kubernetes of fully
      containerized ONAP components - on any type of environment.
    - Support State Management of ONAP platform components.
    - Support full production ONAP deployment and any variation of component
      level deployment for development.
    - Platform Operations Orchestration / Control Loop Actions.
    - Platform centralized logging with ELK stack.

**Bug Fixes**

    The full list of implemented user stories and epics is available on
    `JIRA <https://jira.onap.org/secure/RapidBoard.jspa?rapidView=41&view=planning.nodetail&epics=visible>`_
    This is the first release of OOM, the defects fixed in this release were
    raised during the course of the release.
    Anything not closed is captured below under Known Issues. If you want to
    review the defects fixed in the Amsterdam release, refer to Jira link
    above.

**Known Issues**
    - `OOM-6 <https://jira.onap.org/browse/OOM-6>`_ Automated platform deployment on Docker/Kubernetes

        VFC, AAF, MSB minor issues.

        Workaround: Manual configuration changes - however the reference
        vFirewall use case does not currently require these components.

    - `OOM-10 <https://jira.onap.org/browse/OOM-10>`_ Platform configuration management.

        OOM ONAP Configuration Management - Handling of Secrets.

        Workaround: Automated workaround to be able to pull from protected
        docker repositories.


**Security Issues**
    N/A


**Upgrade Notes**

    N/A

**Deprecation Notes**

    N/A

**Other**

    N/A

End of Release Notes
