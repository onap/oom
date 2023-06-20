.. This work is licensed under a Creative Commons Attribution 4.0
.. International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright (C) 2022 Nordix Foundation

.. Links
.. _helm deploy: https://github.com/onap/oom/blob/master/kubernetes/helm/plugins/deploy/deploy.sh

.. _oom_customize_overrides:

OOM Custom Overrides
####################

The OOM `helm deploy`_ plugin requires deployment configuration as input, usually in the form of override yaml files.
These input files determine what ONAP components get deployed, and the configuration of the OOM deployment.

Other helm config options like `--set log.enabled=true|false` are available.

See the `helm deploy`_ plugin usage section for more detail, or it the plugin has already been installed, execute the following::

    > helm deploy --help

Users can customize the override files to suit their required deployment.

.. note::
  Standard and example override files (e.g. `onap-all.yaml`, `onap-all-ingress-istio.yaml`)
  can be found in the `oom/kubernetes/onap/resources/overrides/` directory.

 * Users can selectively enable or disable ONAP components by changing the ``enabled: true/false`` flags.

 * Add to the command line a value for the global master password (ie. --set global.masterPassword=My_superPassw0rd).


Enabling/Disabling Components
=============================

Here is an example of the nominal entries that need to be provided.
Different values files are available for different contexts.

.. collapse:: Default ONAP values.yaml

    .. include:: ../../../../kubernetes/onap/values.yaml
       :code: yaml

|

ONAP "Production" Setup
=======================

The production setup deploys ONAP components exposing its external services
via Ingress with TLS termination.
Internal traffic encryption will be ensured by using Istio ServiceMesh.

For external access we start to establish Authentication via Oauth2-proxy
and Keycloak, which will be completed in the coming release.

To enable both "ServiceMesh" and "Ingress" configuration entries need
to be set before deployment.

Service Mesh and Ingress configuration
--------------------------------------

Global settings relevant for ServiceMesh and Ingress:

.. code-block:: yaml

  global:
    ingress:
      # generally enable ingress for ONAP components
      enabled: true
      # enable all component's Ingress interfaces
      enable_all: false
      # default Ingress base URL
      # All http requests via ingress will be redirected
      virtualhost:
        # Default Ingress base URL
        # can be overwritten in component by setting ingress.baseurlOverride
        baseurl: "simpledemo.onap.org"
        # prefix for baseaddr
        # can be overwritten in component by setting ingress.preaddrOverride
        preaddr: ""
        # postfix for baseaddr
        # can be overwritten in component by setting ingress.postaddrOverride
        postaddr: ""
      # All http requests via ingress will be redirected on Ingress controller
      # only valid for Istio Gateway (ServiceMesh enabled)
      config:
        ssl: "redirect"
      # you can set an own Secret containing a certificate
      # only valid for Istio Gateway (ServiceMesh enabled)
      #  tls:
      #    secret: 'my-ingress-cert'
      # optional: Namespace of the Istio IngressGateway
      # only valid for Istio Gateway (ServiceMesh enabled)
      namespace: istio-ingress
  ...
    serviceMesh:
      enabled: true
      tls: true
      # be aware that linkerd is not well tested
      engine: "istio" # valid value: istio or linkerd
  ...
    aafEnabled: false
    cmpv2Enabled: false
    tlsEnabled: false
    msbEnabled: false

ServiceMesh settings:

- enabled: true → enables ServiceMesh functionality in the ONAP Namespace (Istio: enables Sidecar deployment)
- tls: true → enables mTLS encryption in Sidecar communication
- engine: istio → sets the SM engine (currently only Istio is supported)
- aafEnabled: false → disables AAF usage for TLS interfaces
- tlsEnabled: false → disables creation of TLS in component services
- cmpv2Enabled: false → disable cmpv2 feature
- msbEnabled: false → MSB is not used in Istio setup (Open, if all components are MSB independend)

Ingress settings:

- enabled: true → enables Ingress using: Nginx (when SM disabled), Istio IngressGateway (when SM enabled)
- enable_all: true → enables Ingress configuration in each component
- virtualhost.baseurl: "simpledemo.onap.org" → sets globally the URL for all Interfaces set by the components,
    resulting in e.g. "aai-api.simpledemo.onap.org", can be overwritten in the component via: ingress.baseurlOverride
- virtualhost.preaddr: "pre-" → sets globally a prefix for the Application name for all Interfaces set by the components,
    resulting in e.g. "pre-aai-api.simpledemo.onap.org", can be overwritten in the component via: ingress.preaddrOverride
- virtualhost.postaddr: "-post" → sets globally a postfix for the Application name for all Interfaces set by the components,
    resulting in e.g. "aai-api-post.simpledemo.onap.org", can be overwritten in the component via: ingress.postaddrOverride
- config.ssl: redirect → sets in the Ingress globally the redirection of all Interfaces from http (port 80) to https (port 443)
- config.tls.secret: "..." → (optional) overrides the default selfsigned SSL certificate with a certificate stored in the specified secret
- namespace: istio-ingress → (optional) overrides the namespace of the ingress gateway which is used for the created SSL certificate

.. note::
  For the Ingress setup an example override file (`onap-all-ingress-istio.yaml`)
  can be found in the `oom/kubernetes/onap/resources/overrides/` directory.

External Authentication configuration
-------------------------------------

For enabling of external authentication via Oauth2-Proxy and Keycloak
the following settings have to be done in the ONAP values override.
It will enable the deployment of the ONAP Realm to Keycloak and
installation and integration of the Oauth2-Proxy as external Auth-Provider.

.. code-block:: yaml

  platform:
    enabled: true
    cmpv2-cert-service:
      enabled: false
    keycloak-init:
      enabled: true
    oauth2-proxy:
      enabled: true