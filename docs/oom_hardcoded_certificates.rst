.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada

.. Links
.. _hardcoded-certiticates-label:

ONAP Hardcoded certificates
###########################

ONAP current installation have hardcoded certificates.
Here's the list of these certificates:

 +-----------------------------------------------------------------------------------------------------------------------------+
 | Project    | ONAP Certificate | Own Certificate  | Path                                                                     |
 +============+==================+==================+==========================================================================+
 | VID        | No               | Yes              | kubernetes/vid/resources/cert                                            |
 +------------+------------------+------------------+--------------------------------------------------------------------------+
 | AAI        | Yes              | No               | aai/oom/resources/config/haproxy/aai.pem                                 |
 +------------+------------------+------------------+--------------------------------------------------------------------------+
 | AAI        | Yes              | No               | aai/oom/resources/config/aai/aai_keystore                                |
 +------------+------------------+------------------+--------------------------------------------------------------------------+
 | AAI        | Yes              | No               | aai/oom/components/aai-search-data/resources/config/auth/tomcat_keystore |
 +------------+------------------+------------------+--------------------------------------------------------------------------+
 | AAI        | No               | Yes              | aai/oom/components/aai-babel/resources/config/auth/tomcat_keystore       |
 +------------+------------------+------------------+--------------------------------------------------------------------------+
 | AAI        | Yes              | Yes              | aai/oom/components/aai-model-loaderresources/config/auth/tomcat_keystore |
 +------------+------------------+------------------+--------------------------------------------------------------------------+
 | SDC        | Yes              | No               | kubernetes/sdc/resources/cert                                            |
 +------------+------------------+------------------+--------------------------------------------------------------------------+