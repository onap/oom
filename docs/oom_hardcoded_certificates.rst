.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada

.. Links
.. _hardcoded-certiticates-label:

ONAP Hardcoded certificates
###########################

ONAP current installation have hardcoded certificates.
Here's the list of these certificates:

 +-----------------------------------------------------------------------+----------------------------------------------+
 | Project       | ONAP Certificate | Own Certificate  | MSB Certificate | Path                                         |
 +===============+==================+==================+=================+==============================================+
 | VID           | No               | Yes              | No              | kubernetes/vid/resources/cert                |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO            | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/BPMN       | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/Catalog    | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/Monitoring | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/OpenStack  | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/RequestDb  | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/SDC        | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/SDNC       | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/VE/VNFM    | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/VFC        | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
 | SO/VNFM       | Yes              | No?              | Yes              | kubernetes/so/resources/config/certificates |
 +---------------+------------------+------------------+-----------------+----------------------------------------------+
