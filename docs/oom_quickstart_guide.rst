.. This work is licensed under a Creative Commons Attribution 4.0 International License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2018 Amdocs, Bell Canada

.. _quick-start-label:

OOM Quick Start Guide
#####################

.. figure:: oomLogoV2-medium.png
   :align: right

Once a kubernetes environment is available (follow the instructions in
:ref:`cloud-setup-guide-label` if you don't have a cloud environment
available), follow the following instructions to deploy ONAP.

**Step 1.** Clone the OOM repository from ONAP gerrit::

  > git clone http://gerrit.onap.org/r/oom
  > cd kubernetes


**Step 2.** Customize the onap/values.yaml file to suit your deployment. You
may want to selectively enable or disable ONAP components by changing the
`enabled: true/false` flags as shown below:

.. code-block:: yaml

  #################################################################
  # Global configuration overrides.
  #
  # These overrides will affect all helm charts (ie. applications)
  # that are listed below and are 'enabled'.
  #################################################################
  global:
    # Change to an unused port prefix range to prevent port conflicts
    # with other instances running within the same k8s cluster
    nodePortPrefix: 302

    # image repositories
    repository: nexus3.onap.org:10001
    repositorySecret: eyJuZXh1czMub25hcC5vcmc6MTAwMDEiOnsidXNlcm5hbWUiOiJkb2NrZXIiLCJwYXNzd29yZCI6ImRvY2tlciIsImVtYWlsIjoiQCIsImF1dGgiOiJaRzlqYTJWeU9tUnZZMnRsY2c9PSJ9fQ==
    # readiness check
    readinessRepository: oomk8s
    # logging agent
    loggingRepository: docker.elastic.co

    # image pull policy
    pullPolicy: Always

    # default mount path root directory referenced
    # by persistent volumes and log files
    persistence:
      mountPath: /dockerdata-nfs

    # flag to enable debugging - application support required
    debugEnabled: false

  #################################################################
  # Enable/disable and configure helm charts (ie. applications)
  # to customize the ONAP deployment.
  #################################################################
  aaf:
    enabled: false
  aai:
    enabled: false
  appc:
    enabled: false
  clamp:
    enabled: false
  cli:
    enabled: false
  consul: # Consul Health Check Monitoring
    enabled: false
  dcaegen2:
    enabled: false
  esr:
    enabled: false
  log:
    enabled: false
  message-router:
    enabled: false
  mock:
    enabled: false
  msb:
    enabled: false
  multicloud:
    enabled: false
  policy:
    enabled: false
  portal:
    enabled: false
  robot: # Robot Health Check
    enabled: true
  sdc:
    enabled: false
  sdnc:
    enabled: false
  so: # Service Orchestrator
    enabled: true

    replicaCount: 1

    liveness:
      # necessary to disable liveness probe when setting breakpoints
      # in debugger so K8s doesn't restart unresponsive container
      enabled: true

    # so server configuration
    config:
      # message router configuration
      dmaapTopic: "AUTO"
      # openstack configuration
      openStackUserName: "vnf_user"
      openStackRegion: "RegionOne"
      openStackKeyStoneUrl: "http://1.2.3.4:5000"
      openStackServiceTenantName: "service"
      openStackEncryptedPasswordHere: "c124921a3a0efbe579782cde8227681e"

    # configure embedded mariadb
    mariadb:
      config:
        mariadbRootPassword: password
  uui:
    enabled: false
  vfc:
    enabled: false
  vid:
    enabled: false
  vnfsdk:
    enabled: false

**Step 3.** Build a local Helm repository (from the kubernetes directory)::

  > make all

**Step 4.** To setup a local Helm server to server up the ONAP charts::

  > helm serve &

Note the port number that is listed and use it in the Helm repo add as
follows::

  > helm repo add local http://127.0.0.1:8879

**Step 5.** Verify your Helm repository setup with::

  > helm repo list
  NAME   URL
  local  http://127.0.0.1:8879

**Step 6.** Display the charts that available to be deployed::

  > helm search -l
  NAME                    VERSION    DESCRIPTION
  local/appc              2.0.0      Application Controller
  local/clamp             2.0.0      ONAP Clamp
  local/common            2.0.0      Common templates for inclusion in other charts
  local/onap              2.0.0      Open Network Automation Platform (ONAP)
  local/robot             2.0.0      A helm Chart for kubernetes-ONAP Robot
  local/so                2.0.0      ONAP Service Orchestrator

.. note::
  The of this Helm repository setup is a one time activity. If you make changes to your deployment charts or values be sure to use `make` to update your local Helm repository.

**Step 7.** Once the repo is setup, installation of ONAP can be done with a
single command::

  > helm install local/onap -name development

Use the following to monitor your deployment and determine when ONAP is ready for use::

  > kubectl get pods --all-namespaces -o=wide
