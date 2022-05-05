.. This work is licensed under a Creative Commons Attribution 4.0 International
.. License.
.. http://creativecommons.org/licenses/by/4.0
.. Copyright 2017 Bell Canada & Amdocs Intellectual Property.  All rights
.. reserved.
.. _release_notes_beijing:

:orphan:

ONAP Operations Manager Release Notes
=====================================

Version 2.0.0 Beijing Release
-----------------------------

:Release Date: 2018-06-07

Previous Release Notes
**********************

- :ref:`Amsterdam <release_notes_amsterdam>`

Epic
****

* [`OOM-6 <https://jira.onap.org/browse/OOM-6>`_] - Automated platform deployment on Docker/Kubernetes
* [`OOM-7 <https://jira.onap.org/browse/OOM-7>`_] - Platform monitoring and auto-healing
* [`OOM-8 <https://jira.onap.org/browse/OOM-8>`_] - Automated platform scalability
* [`OOM-9 <https://jira.onap.org/browse/OOM-9>`_] - Platform upgradability & rollbacks
* [`OOM-10 <https://jira.onap.org/browse/OOM-10>`_] - Platform configuration management
* [`OOM-46 <https://jira.onap.org/browse/OOM-46>`_] - Platform infrastructure deployment with TOSCA
* [`OOM-109 <https://jira.onap.org/browse/OOM-109>`_] - Platform Centralized Logging
* [`OOM-138 <https://jira.onap.org/browse/OOM-138>`_] - Using Optimization framework
* [`OOM-346 <https://jira.onap.org/browse/OOM-346>`_] - Platform Resiliency (including Recoverability, High-Availability, Backup/Restore, Geo-Redundancy)
* [`OOM-376 <https://jira.onap.org/browse/OOM-376>`_] - ONAP deployment options standardization
* [`OOM-486 <https://jira.onap.org/browse/OOM-486>`_] - HELM upgrade from 2.3 to 2.8.0
* [`OOM-535 <https://jira.onap.org/browse/OOM-535>`_] - Upgrade Kubernetes from 1.8.6 to 1.9.2
* [`OOM-590 <https://jira.onap.org/browse/OOM-590>`_] - OOM Wiki documentation of deployment options

Story
*****

* [`OOM-11 <https://jira.onap.org/browse/OOM-11>`_] - Add AAF containers to ONAP Kubernetes
* [`OOM-13 <https://jira.onap.org/browse/OOM-13>`_] - Add CLI containers to ONAP Kubernetes
* [`OOM-15 <https://jira.onap.org/browse/OOM-15>`_] - Add DMAAP containers to ONAP Kubernetes
* [`OOM-20 <https://jira.onap.org/browse/OOM-20>`_] - State Monitoring: MSO/mso
* [`OOM-21 <https://jira.onap.org/browse/OOM-21>`_] - State Monitoring: A&AI/aai-service
* [`OOM-22 <https://jira.onap.org/browse/OOM-22>`_] - State Monitoring: SDNC/sdc-be
* [`OOM-24 <https://jira.onap.org/browse/OOM-24>`_] - State Monitoring: message-router
* [`OOM-25 <https://jira.onap.org/browse/OOM-25>`_] - State Monitoring: MSB
* [`OOM-29 <https://jira.onap.org/browse/OOM-29>`_] - State Monitoring: VID
* [`OOM-31 <https://jira.onap.org/browse/OOM-31>`_] - State Monitoring: APPC/dbhost
* [`OOM-32 <https://jira.onap.org/browse/OOM-32>`_] - State Monitoring: VFC
* [`OOM-33 <https://jira.onap.org/browse/OOM-33>`_] - State Monitoring: Multi-VIM
* [`OOM-34 <https://jira.onap.org/browse/OOM-34>`_] - Auto-Restart on failure: ...
* [`OOM-35 <https://jira.onap.org/browse/OOM-35>`_] - State Monitoring: A&AI/hbase
* [`OOM-36 <https://jira.onap.org/browse/OOM-36>`_] - State Monitoring: A&AI/model-loader-service
* [`OOM-37 <https://jira.onap.org/browse/OOM-37>`_] - State Monitoring: APPC/dgbuilder
* [`OOM-38 <https://jira.onap.org/browse/OOM-38>`_] - State Monitoring: APPC/sdnctldb01
* [`OOM-39 <https://jira.onap.org/browse/OOM-39>`_] - State Monitoring: APPC/sdnctldb02
* [`OOM-40 <https://jira.onap.org/browse/OOM-40>`_] - State Monitoring: APPC/sdnhost
* [`OOM-41 <https://jira.onap.org/browse/OOM-41>`_] - State Monitoring: MSO/mariadb
* [`OOM-42 <https://jira.onap.org/browse/OOM-42>`_] - State Monitoring: SDNC/dbhost
* [`OOM-43 <https://jira.onap.org/browse/OOM-43>`_] - State Monitoring: SDNC/sdnc-dgbuilder
* [`OOM-44 <https://jira.onap.org/browse/OOM-44>`_] - State Monitoring: SDNC/sdnc-portal
* [`OOM-45 <https://jira.onap.org/browse/OOM-45>`_] - State Monitoring: SDNC/sdnctldb01
* [`OOM-51 <https://jira.onap.org/browse/OOM-51>`_] - OOM ONAP Configuration Management - Externalize hardwired values
* [`OOM-52 <https://jira.onap.org/browse/OOM-52>`_] - OOM ONAP Configuration Management - Parameterization of docker images
* [`OOM-53 <https://jira.onap.org/browse/OOM-53>`_] - OOM ONAP Configuration Management - Parameterization for Sizing
* [`OOM-63 <https://jira.onap.org/browse/OOM-63>`_] - Kubernetes cluster created by TOSCA description
* [`OOM-85 <https://jira.onap.org/browse/OOM-85>`_] - Test the code in the "Lab" project environment
* [`OOM-86 <https://jira.onap.org/browse/OOM-86>`_] - Monitoring the health status of ONAP components
* [`OOM-87 <https://jira.onap.org/browse/OOM-87>`_] - Configure TOSCA description via dashboard
* [`OOM-88 <https://jira.onap.org/browse/OOM-88>`_] - Deploy Holmes on K8S cluster by TOSCA description
* [`OOM-89 <https://jira.onap.org/browse/OOM-89>`_] - Deploy CLAMP on K8S cluster by TOSCA description
* [`OOM-91 <https://jira.onap.org/browse/OOM-91>`_] - Deploy MSB on K8S cluster by TOSCA description
* [`OOM-92 <https://jira.onap.org/browse/OOM-92>`_] - Deploy AAF on K8S cluster by TOSCA description
* [`OOM-93 <https://jira.onap.org/browse/OOM-93>`_] - Deploy VF-C on K8S cluster by TOSCA description
* [`OOM-94 <https://jira.onap.org/browse/OOM-94>`_] - Deploy Multi-VIM on K8S cluster by TOSCA description
* [`OOM-95 <https://jira.onap.org/browse/OOM-95>`_] - Deploy DCAEGen2 on K8S cluster by TOSCA description
* [`OOM-96 <https://jira.onap.org/browse/OOM-96>`_] - Deploy AAI on K8S cluster by TOSCA description
* [`OOM-97 <https://jira.onap.org/browse/OOM-97>`_] - Deploy APPC on K8S cluster by TOSCA description
* [`OOM-98 <https://jira.onap.org/browse/OOM-98>`_] - Deploy MSO on K8S cluster by TOSCA description
* [`OOM-99 <https://jira.onap.org/browse/OOM-99>`_] - Deploy Policy on K8S cluster by TOSCA description
* [`OOM-100 <https://jira.onap.org/browse/OOM-100>`_] - Deploy SDC on K8S cluster by TOSCA description
* [`OOM-102 <https://jira.onap.org/browse/OOM-102>`_] - Deploy VID on K8S cluster by TOSCA description
* [`OOM-110 <https://jira.onap.org/browse/OOM-110>`_] - OOM ONAP Logging - Elastic Stack components deployment
* [`OOM-111 <https://jira.onap.org/browse/OOM-111>`_] - OOM ONAP Logging - FileBeat deployment aside ONAP components
* [`OOM-112 <https://jira.onap.org/browse/OOM-112>`_] - OOM ONAP Logging - Configuration of all ONAP components to emit canonical logs
* [`OOM-116 <https://jira.onap.org/browse/OOM-116>`_] - ignore intellj files
* [`OOM-145 <https://jira.onap.org/browse/OOM-145>`_] - update directory path from dockerdata-nfs to configured directory name (make it configurable)
* [`OOM-235 <https://jira.onap.org/browse/OOM-235>`_] - Service endpoint annotation for Usecase UI
* [`OOM-242 <https://jira.onap.org/browse/OOM-242>`_] - Modify DCAE seed for Helm
* [`OOM-262 <https://jira.onap.org/browse/OOM-262>`_] - Remove "oneclick" kubectl scripts.
* [`OOM-265 <https://jira.onap.org/browse/OOM-265>`_] - Top level helm chart for ONAP
* [`OOM-268 <https://jira.onap.org/browse/OOM-268>`_] - Persist and externalize database directories via persistent volumes
* [`OOM-271 <https://jira.onap.org/browse/OOM-271>`_] - Copy app config files from source
* [`OOM-272 <https://jira.onap.org/browse/OOM-272>`_] - Set application environment variables from source
* [`OOM-277 <https://jira.onap.org/browse/OOM-277>`_] - add automatic ONAP config parameter substitution
* [`OOM-280 <https://jira.onap.org/browse/OOM-280>`_] - MSB automatically re-synch service data on restart.
* [`OOM-292 <https://jira.onap.org/browse/OOM-292>`_] - Expose LOG Volume via /dockerdata-nfs
* [`OOM-293 <https://jira.onap.org/browse/OOM-293>`_] - OOM ONAP Configuration Management - Handling of Secrets
* [`OOM-298 <https://jira.onap.org/browse/OOM-298>`_] - Provide script to cleanup configuration data created by createConfig.sh
* [`OOM-322 <https://jira.onap.org/browse/OOM-322>`_] - Clean-up config files that are generated at system startup
* [`OOM-341 <https://jira.onap.org/browse/OOM-341>`_] - Provide an example of a partial deployment of ONAP components (e.g. no VFC)
* [`OOM-342 <https://jira.onap.org/browse/OOM-342>`_] - Add pointer to Wiki page on the readme file.
* [`OOM-344 <https://jira.onap.org/browse/OOM-344>`_] - Break the configuration tarball per appplication
* [`OOM-345 <https://jira.onap.org/browse/OOM-345>`_] - Re-validate # of containers and configuration for DCAEgen2
* [`OOM-356 <https://jira.onap.org/browse/OOM-356>`_] - Add 'Usecase UI' containers to ONAP Kubernetes
* [`OOM-359 <https://jira.onap.org/browse/OOM-359>`_] - SDC logback chef failure
* [`OOM-375 <https://jira.onap.org/browse/OOM-375>`_] - F2F: ONAP/OOM for Developers
* [`OOM-382 <https://jira.onap.org/browse/OOM-382>`_] - Robot Version 1.1 OpenO tests
* [`OOM-406 <https://jira.onap.org/browse/OOM-406>`_] - In Kubernetes 1.8, the annotations are no longer supported and must be converted to the PodSpec field.
* [`OOM-457 <https://jira.onap.org/browse/OOM-457>`_] - In Kubernetes 1.8, init-container annotations to be converted to PodSpec field for aaf, clamp and vfc
* [`OOM-460 <https://jira.onap.org/browse/OOM-460>`_] - Segregating configuration of ONAP components
* [`OOM-476 <https://jira.onap.org/browse/OOM-476>`_] - Parameterize values.yaml docker image repos into global config variables
* [`OOM-528 <https://jira.onap.org/browse/OOM-528>`_] - Confirm k8s context with a prompt for deleteAll.bash
* [`OOM-534 <https://jira.onap.org/browse/OOM-534>`_] - Need to provide support for creating different sized OOM deployments
* [`OOM-546 <https://jira.onap.org/browse/OOM-546>`_] - Provide option to collect ONAP env details for issue investigations
* [`OOM-569 <https://jira.onap.org/browse/OOM-569>`_] - Investigate containerizing Cloudify Manager
* [`OOM-579 <https://jira.onap.org/browse/OOM-579>`_] - Document a Cloudify deployment of OOM Beijing
* [`OOM-633 <https://jira.onap.org/browse/OOM-633>`_] - Provide direct access to ONAP Portal without the need to use VNC
* [`OOM-677 <https://jira.onap.org/browse/OOM-677>`_] - Update all source code files with the Apache 2 License header
* [`OOM-678 <https://jira.onap.org/browse/OOM-678>`_] - Enforce MSB dockers dependencies using init-container
* [`OOM-681 <https://jira.onap.org/browse/OOM-681>`_] - updating docker images/components to latest code
* [`OOM-682 <https://jira.onap.org/browse/OOM-682>`_] - deployment of sdc workflow designer
* [`OOM-695 <https://jira.onap.org/browse/OOM-695>`_] - Improve Readiness-check prob
* [`OOM-722 <https://jira.onap.org/browse/OOM-722>`_] - OOM - Run all ONAP components in one namespace
* [`OOM-725 <https://jira.onap.org/browse/OOM-725>`_] - Use Blueprint to install Helm and k8s dashboard while creating k8s cluster
* [`OOM-727 <https://jira.onap.org/browse/OOM-727>`_] - Add Standardized Configuration to SO
* [`OOM-728 <https://jira.onap.org/browse/OOM-728>`_] - Add Standardized Configuration to ROBOT
* [`OOM-729 <https://jira.onap.org/browse/OOM-729>`_] - Add Standardized Configuration to VID
* [`OOM-730 <https://jira.onap.org/browse/OOM-730>`_] - Add Standardized Configuration to Consul
* [`OOM-731 <https://jira.onap.org/browse/OOM-731>`_] - Add Standardized Configuration to DMaaP Message Router
* [`OOM-732 <https://jira.onap.org/browse/OOM-732>`_] - Add Standardized Configuration to AAF
* [`OOM-733 <https://jira.onap.org/browse/OOM-733>`_] - Add Standardized Configuration to APPC
* [`OOM-734 <https://jira.onap.org/browse/OOM-734>`_] - Add Standardized Configuration to AAI
* [`OOM-735 <https://jira.onap.org/browse/OOM-735>`_] - Add Standardized Configuration to CLAMP
* [`OOM-736 <https://jira.onap.org/browse/OOM-736>`_] - Add Standardized Configuration to CLI
* [`OOM-737 <https://jira.onap.org/browse/OOM-737>`_] - Add Standardized Configuration to DCAEGEN2
* [`OOM-738 <https://jira.onap.org/browse/OOM-738>`_] - Add Standardized Configuration to ESR
* [`OOM-739 <https://jira.onap.org/browse/OOM-739>`_] - Add Standardized Configuration to KUBE2MSB
* [`OOM-740 <https://jira.onap.org/browse/OOM-740>`_] - Add Standardized Configuration to LOG
* [`OOM-742 <https://jira.onap.org/browse/OOM-742>`_] - Add Standardized Configuration to MSB
* [`OOM-743 <https://jira.onap.org/browse/OOM-743>`_] - Replace deprecated MSO Helm Chart with Standardized SO Helm Chart
* [`OOM-744 <https://jira.onap.org/browse/OOM-744>`_] - Add Standardized Configuration to MULTICLOUD
* [`OOM-746 <https://jira.onap.org/browse/OOM-746>`_] - Add Standardized Configuration to PORTAL
* [`OOM-747 <https://jira.onap.org/browse/OOM-747>`_] - Add Standardized Configuration to SDC
* [`OOM-748 <https://jira.onap.org/browse/OOM-748>`_] - Add Standardized Configuration to SDNC
* [`OOM-749 <https://jira.onap.org/browse/OOM-749>`_] - Add Standardized Configuration to UUI
* [`OOM-750 <https://jira.onap.org/browse/OOM-750>`_] - Add Standardized Configuration to VFC
* [`OOM-751 <https://jira.onap.org/browse/OOM-751>`_] - Add Standardized Configuration to VNFSDK
* [`OOM-758 <https://jira.onap.org/browse/OOM-758>`_] - Common Mariadb Galera Helm Chart to be reused by many applications
* [`OOM-771 <https://jira.onap.org/browse/OOM-771>`_] - OOM - update master with new policy db deployment
* [`OOM-777 <https://jira.onap.org/browse/OOM-777>`_] - Add Standardized Configuration Helm Starter Chart
* [`OOM-779 <https://jira.onap.org/browse/OOM-779>`_] - OOM APPC ODL (MDSAL) persistent storage
* [`OOM-780 <https://jira.onap.org/browse/OOM-780>`_] - Update MSO to latest working version.
* [`OOM-786 <https://jira.onap.org/browse/OOM-786>`_] - Re-add support for multiple instances of ONAP
* [`OOM-788 <https://jira.onap.org/browse/OOM-788>`_] - Abstract docker secrets
* [`OOM-789 <https://jira.onap.org/browse/OOM-789>`_] - Abstract cluster role binding
* [`OOM-811 <https://jira.onap.org/browse/OOM-811>`_] - Make kube2msb use secret instead of passing token as environment variable
* [`OOM-822 <https://jira.onap.org/browse/OOM-822>`_] - Update Documentation for the Beijing Release
* [`OOM-823 <https://jira.onap.org/browse/OOM-823>`_] - Add CDT image to APPC chart
* [`OOM-827 <https://jira.onap.org/browse/OOM-827>`_] - Add quick start documentation README
* [`OOM-828 <https://jira.onap.org/browse/OOM-828>`_] - Remove oneclick scripts
* [`OOM-857 <https://jira.onap.org/browse/OOM-857>`_] - kube2msb fails to start
* [`OOM-914 <https://jira.onap.org/browse/OOM-914>`_] - Add LOG component robot healthcheck
* [`OOM-960 <https://jira.onap.org/browse/OOM-960>`_] - OOM Healthcheck lockdown - currently 32/39 : 20180421
* [`OOM-979 <https://jira.onap.org/browse/OOM-979>`_] - Enhance OOM TOSCA solution to support standardized Helm Chart
* [`OOM-1006 <https://jira.onap.org/browse/OOM-1006>`_] - VNFSDK healthcheck fails
* [`OOM-1073 <https://jira.onap.org/browse/OOM-1073>`_] - Change the Repository location in the image oomk8s/config-init:2.0.0-SNAPSHOT
* [`OOM-1078 <https://jira.onap.org/browse/OOM-1078>`_] - Update Kubectl, docker, helm version

Task
****

* [`OOM-57 <https://jira.onap.org/browse/OOM-57>`_] - Agree on configuration contract/YAML with each of the project teams
* [`OOM-105 <https://jira.onap.org/browse/OOM-105>`_] - TOSCA based orchestration demo
* [`OOM-257 <https://jira.onap.org/browse/OOM-257>`_] - DevOps: OOM config reset procedure for new /dockerdata-nfs content
* [`OOM-305 <https://jira.onap.org/browse/OOM-305>`_] - Rename MSO to SO in OOM
* [`OOM-332 <https://jira.onap.org/browse/OOM-332>`_] - Add AAI filebeat container - blocked by LOG-67
* [`OOM-428 <https://jira.onap.org/browse/OOM-428>`_] - Add log container healthcheck to mark failed creations - see OOM-427
* [`OOM-429 <https://jira.onap.org/browse/OOM-429>`_] - DOC: Document HELM server version 2.7.2 required for tpl usage
* [`OOM-489 <https://jira.onap.org/browse/OOM-489>`_] - Update values.yaml files for tag name changes for docker images and versions.
* [`OOM-543 <https://jira.onap.org/browse/OOM-543>`_] - SDNC adjust docker pullPolicy to IfNotPresent to speed up initial deployment slowdown introduced by SDNC-163
* [`OOM-604 <https://jira.onap.org/browse/OOM-604>`_] - Update OOM and HEAT AAI sparky master from v1.1.0 to v1.1.1 - match INT-288
* [`OOM-614 <https://jira.onap.org/browse/OOM-614>`_] - SDC, SDNC, AAI Healthcheck failures last 12 hours 20180124:1100EST
* [`OOM-624 <https://jira.onap.org/browse/OOM-624>`_] - CII security badging: cleartext password for keystone and docker repo creds
* [`OOM-726 <https://jira.onap.org/browse/OOM-726>`_] - Mirror AAI docker version changes into OOM from AAI-791
* [`OOM-772 <https://jira.onap.org/browse/OOM-772>`_] - Remove old DCAE from Release
* [`OOM-801 <https://jira.onap.org/browse/OOM-801>`_] - Policy docker images rename - key off new name in POLICY-674
* [`OOM-810 <https://jira.onap.org/browse/OOM-810>`_] - Improve emsdriver code
* [`OOM-819 <https://jira.onap.org/browse/OOM-819>`_] - expose log/logstash 5044 as nodeport for external log producers outside of the kubernetes cluster
* [`OOM-820 <https://jira.onap.org/browse/OOM-820>`_] - Bypass vnc-portal for ONAP portal access
* [`OOM-943 <https://jira.onap.org/browse/OOM-943>`_] - Upgrade prepull_docker.sh to work with new helm based master refactor - post OOM-328
* [`OOM-947 <https://jira.onap.org/browse/OOM-947>`_] - Update AAI to latest images
* [`OOM-975 <https://jira.onap.org/browse/OOM-975>`_] - Notes are missing in multicloud
* [`OOM-1031 <https://jira.onap.org/browse/OOM-1031>`_] - Config Changes for consul to make vid, so, log health checks pass
* [`OOM-1032 <https://jira.onap.org/browse/OOM-1032>`_] - Making consul Stateful
* [`OOM-1122 <https://jira.onap.org/browse/OOM-1122>`_] - Update APPC OOM chart to use Beijing release artifacts

Bug
***

* [`OOM-4 <https://jira.onap.org/browse/OOM-4>`_] - deleteAll.bash fails to properly delete services and ports
* [`OOM-153 <https://jira.onap.org/browse/OOM-153>`_] - test - Sample Bug
* [`OOM-212 <https://jira.onap.org/browse/OOM-212>`_] - deleteAll script does not have an option to delete the services
* [`OOM-215 <https://jira.onap.org/browse/OOM-215>`_] - configure_app for helm apps is not correct
* [`OOM-218 <https://jira.onap.org/browse/OOM-218>`_] - createConfig.sh needs a chmod 755 in release-1.0.0 only
* [`OOM-239 <https://jira.onap.org/browse/OOM-239>`_] - mso.tar created in dockerdatanfs
* [`OOM-258 <https://jira.onap.org/browse/OOM-258>`_] - AAI logs are not being written outside the pods
* [`OOM-282 <https://jira.onap.org/browse/OOM-282>`_] - vnc-portal requires /etc/hosts url fix for SDC sdc.ui should be sdc.api
* [`OOM-283 <https://jira.onap.org/browse/OOM-283>`_] - No longer able to deploy instances in specified namespace
* [`OOM-290 <https://jira.onap.org/browse/OOM-290>`_] - config_init pod fails when /dockerdata-nfs is nfs-mounted
* [`OOM-300 <https://jira.onap.org/browse/OOM-300>`_] - cat: /config-init/onap/mso/mso/encryption.key: No such file or directory
* [`OOM-333 <https://jira.onap.org/browse/OOM-333>`_] - vfc-workflow fails [VFC BUG] - fixed - 20180117 vfc-ztevnfmdriver has docker pull issue
* [`OOM-334 <https://jira.onap.org/browse/OOM-334>`_] - Change kubernetes startup user
* [`OOM-351 <https://jira.onap.org/browse/OOM-351>`_] - Apply standard convention across the "template deployment YML" file
* [`OOM-352 <https://jira.onap.org/browse/OOM-352>`_] - failed to start VFC containers
* [`OOM-363 <https://jira.onap.org/browse/OOM-363>`_] - DCAE tests NOK with Robot E2E tests
* [`OOM-366 <https://jira.onap.org/browse/OOM-366>`_] - certificates in consul agent config are not in the right directory
* [`OOM-389 <https://jira.onap.org/browse/OOM-389>`_] - sdc-be and sdc-fe do not initialize correctly on latest master
* [`OOM-409 <https://jira.onap.org/browse/OOM-409>`_] - Update Vid yaml file to point to the ONAPPORTAL URL
* [`OOM-413 <https://jira.onap.org/browse/OOM-413>`_] - In portal VNC pod refresh /etc/hosts entries
* [`OOM-414 <https://jira.onap.org/browse/OOM-414>`_] - MSB Healtcheck failure on $*_ENDPOINT variables
* [`OOM-424 <https://jira.onap.org/browse/OOM-424>`_] - DCAE installation is not possible today
* [`OOM-430 <https://jira.onap.org/browse/OOM-430>`_] - Portal healthcheck passing on vnc-portal down
* [`OOM-467 <https://jira.onap.org/browse/OOM-467>`_] - Optimize config-init process
* [`OOM-493 <https://jira.onap.org/browse/OOM-493>`_] - Kubernetes infrastructure for ESR
* [`OOM-496 <https://jira.onap.org/browse/OOM-496>`_] - Readiness check is marking full availability of some components like SDC and SDNC before they would pass healthcheck
* [`OOM-514 <https://jira.onap.org/browse/OOM-514>`_] - Readiness prob fails sometimes even though the relevant pods are running
* [`OOM-539 <https://jira.onap.org/browse/OOM-539>`_] - Kube2MSB registrator doesn't support https REST service registration
* [`OOM-570 <https://jira.onap.org/browse/OOM-570>`_] - Wrong value is assigned to kube2msb AUTH_TOKEN environment variable
* [`OOM-574 <https://jira.onap.org/browse/OOM-574>`_] - OOM configuration for robot does not copy heat templatese in dockerdata-nfs
* [`OOM-577 <https://jira.onap.org/browse/OOM-577>`_] - Incorrect evaluation of bash command in yaml template file (portal-vnc-dep.yaml)
* [`OOM-578 <https://jira.onap.org/browse/OOM-578>`_] - Hard coded token in oom/kubernetes/kube2msb/values.yaml file
* [`OOM-589 <https://jira.onap.org/browse/OOM-589>`_] - Can not acces CLI in vnc-portal
* [`OOM-598 <https://jira.onap.org/browse/OOM-598>`_] - createAll.bash base64: invalid option -- d
* [`OOM-600 <https://jira.onap.org/browse/OOM-600>`_] - Unable to open CLI by clicking CLI application icon
* [`OOM-630 <https://jira.onap.org/browse/OOM-630>`_] - Red herring config pod deletion error on deleteAll - after we started deleting onap-config automatically
* [`OOM-645 <https://jira.onap.org/browse/OOM-645>`_] - Kube2MSB RBAC security issues
* [`OOM-653 <https://jira.onap.org/browse/OOM-653>`_] - sdnc-dbhost-0 deletion failure
* [`OOM-657 <https://jira.onap.org/browse/OOM-657>`_] - Look into DCAEGEN2 failure on duplicate servicePort
* [`OOM-672 <https://jira.onap.org/browse/OOM-672>`_] - hardcoded clusterIP for aai breaks auto installation
* [`OOM-680 <https://jira.onap.org/browse/OOM-680>`_] - ONAP Failure install with kubernetes 1.8+
* [`OOM-687 <https://jira.onap.org/browse/OOM-687>`_] - Typo in README_HELM
* [`OOM-724 <https://jira.onap.org/browse/OOM-724>`_] - License Update in TOSCA
* [`OOM-767 <https://jira.onap.org/browse/OOM-767>`_] - data-router-logs and elasticsearch-data mapped to same folder
* [`OOM-768 <https://jira.onap.org/browse/OOM-768>`_] - Hardcoded onap in config files
* [`OOM-769 <https://jira.onap.org/browse/OOM-769>`_] - sdc-es data mapping in sdc-be and sdc-fe redundant
* [`OOM-783 <https://jira.onap.org/browse/OOM-783>`_] - UUI health check is failing
* [`OOM-784 <https://jira.onap.org/browse/OOM-784>`_] - make new so chart one namespace compatible
* [`OOM-791 <https://jira.onap.org/browse/OOM-791>`_] - After OOM-722 merge - docker pulls are timing out - switch to pullPolicy IfNotPresent
* [`OOM-794 <https://jira.onap.org/browse/OOM-794>`_] - demo-k8s.sh name not modified in the usage string
* [`OOM-795 <https://jira.onap.org/browse/OOM-795>`_] - HEAT templates for robot instantiateVFW missing
* [`OOM-796 <https://jira.onap.org/browse/OOM-796>`_] - robot asdc/sdngc interface in synch for Master
* [`OOM-797 <https://jira.onap.org/browse/OOM-797>`_] - GLOBAL_INJECTED_SCRIPT_VERSION missing from vm_properties.py
* [`OOM-804 <https://jira.onap.org/browse/OOM-804>`_] - VFC vfc-ztevnfmdriver container failure
* [`OOM-815 <https://jira.onap.org/browse/OOM-815>`_] - OOM Robot container helm failure after OOM-728 35909 merge
* [`OOM-829 <https://jira.onap.org/browse/OOM-829>`_] - Can not make multicloud helm chart
* [`OOM-830 <https://jira.onap.org/browse/OOM-830>`_] - Fix OOM build dependencies
* [`OOM-835 <https://jira.onap.org/browse/OOM-835>`_] - CLAMP mariadb pv is pointing to a wrong location
* [`OOM-836 <https://jira.onap.org/browse/OOM-836>`_] - champ and gizmo yaml validation issue
* [`OOM-845 <https://jira.onap.org/browse/OOM-845>`_] - Global repository should not be set by default
* [`OOM-846 <https://jira.onap.org/browse/OOM-846>`_] - Add liveness enabled fix to helm starter
* [`OOM-847 <https://jira.onap.org/browse/OOM-847>`_] - log-elasticsearch external ports are not externally accessible
* [`OOM-848 <https://jira.onap.org/browse/OOM-848>`_] - log-logstash logstash pipeline fails to start after oom standard config changes
* [`OOM-851 <https://jira.onap.org/browse/OOM-851>`_] - sdc chart validation error
* [`OOM-856 <https://jira.onap.org/browse/OOM-856>`_] - appc mysql fails deployment
* [`OOM-858 <https://jira.onap.org/browse/OOM-858>`_] - Fail to deploy onap chart due to config map size
* [`OOM-870 <https://jira.onap.org/browse/OOM-870>`_] - Missing CLAMP configuration
* [`OOM-871 <https://jira.onap.org/browse/OOM-871>`_] - log kibana container fails to start after oom standard config changes
* [`OOM-872 <https://jira.onap.org/browse/OOM-872>`_] - APPC-helm Still need config pod
* [`OOM-873 <https://jira.onap.org/browse/OOM-873>`_] - OOM doc typo
* [`OOM-874 <https://jira.onap.org/browse/OOM-874>`_] - Inconsistent repository references in ONAP charts
* [`OOM-875 <https://jira.onap.org/browse/OOM-875>`_] - Cannot retrieve robot logs
* [`OOM-876 <https://jira.onap.org/browse/OOM-876>`_] - Some containers ignore the repository setting
* [`OOM-878 <https://jira.onap.org/browse/OOM-878>`_] - MySQL slave nodes don't deploy when mysql.replicaCount > 1
* [`OOM-881 <https://jira.onap.org/browse/OOM-881>`_] - SDN-C Portal pod fails to come up
* [`OOM-882 <https://jira.onap.org/browse/OOM-882>`_] - Some SDNC service names should be prefixed with the helm release name
* [`OOM-884 <https://jira.onap.org/browse/OOM-884>`_] - VID-VID mariadb pv is pointing to a wrong location
* [`OOM-885 <https://jira.onap.org/browse/OOM-885>`_] - Beijing oom component log messages missing in Elasticsearch
* [`OOM-886 <https://jira.onap.org/browse/OOM-886>`_] - kube2msb not starting up
* [`OOM-887 <https://jira.onap.org/browse/OOM-887>`_] - SDN-C db schema and sdnctl db user not reliably being created
* [`OOM-888 <https://jira.onap.org/browse/OOM-888>`_] - aaf-cs mapping wrong
* [`OOM-889 <https://jira.onap.org/browse/OOM-889>`_] - restore pv&pvc for mysql when NFS provisioner is disabled
* [`OOM-898 <https://jira.onap.org/browse/OOM-898>`_] - Multicloud-framework config file is not volume-mounted
* [`OOM-899 <https://jira.onap.org/browse/OOM-899>`_] - SDNC main pod does not come up
* [`OOM-900 <https://jira.onap.org/browse/OOM-900>`_] - portal-cassandra missing pv and pvc
* [`OOM-904 <https://jira.onap.org/browse/OOM-904>`_] - OOM problems bringing up components and passing healthchecks
* [`OOM-905 <https://jira.onap.org/browse/OOM-905>`_] - Charts use nsPrefix instead of release namespace
* [`OOM-906 <https://jira.onap.org/browse/OOM-906>`_] - Make all services independent of helm Release.Name
* [`OOM-907 <https://jira.onap.org/browse/OOM-907>`_] - Make all persistent volume to be mapped to a location defined by helm Release.Name
* [`OOM-908 <https://jira.onap.org/browse/OOM-908>`_] - Job portal-db-config fails due to missing image config
* [`OOM-909 <https://jira.onap.org/browse/OOM-909>`_] - SO Health Check fails
* [`OOM-910 <https://jira.onap.org/browse/OOM-910>`_] - VID Health Check fails
* [`OOM-911 <https://jira.onap.org/browse/OOM-911>`_] - VFC Health Check fails for 9 components
* [`OOM-912 <https://jira.onap.org/browse/OOM-912>`_] - Multicloud Health Check fails for 1 of its components
* [`OOM-913 <https://jira.onap.org/browse/OOM-913>`_] - Consul agent pod is failing
* [`OOM-916 <https://jira.onap.org/browse/OOM-916>`_] - Used to fix testing issues related to usability
* [`OOM-918 <https://jira.onap.org/browse/OOM-918>`_] - Policy - incorrect configmap mount causes base.conf to disappear
* [`OOM-920 <https://jira.onap.org/browse/OOM-920>`_] - Issue with CLAMP configuration
* [`OOM-921 <https://jira.onap.org/browse/OOM-921>`_] - align onap/values.yaml and onap/resources/environments/dev.yaml - different /dockerdata-nfs
* [`OOM-926 <https://jira.onap.org/browse/OOM-926>`_] - Disable clustering for APP-C out-of-the-box
* [`OOM-927 <https://jira.onap.org/browse/OOM-927>`_] - Need a production grade configuration override file of ONAP deployment
* [`OOM-928 <https://jira.onap.org/browse/OOM-928>`_] - Some charts use /dockerdata-nfs by default
* [`OOM-929 <https://jira.onap.org/browse/OOM-929>`_] - DMaaP message router docker image fails to pull
* [`OOM-930 <https://jira.onap.org/browse/OOM-930>`_] - New AAF Helm Charts required
* [`OOM-931 <https://jira.onap.org/browse/OOM-931>`_] - Reintroduce VNC pod into OOM
* [`OOM-932 <https://jira.onap.org/browse/OOM-932>`_] - Unblock integration testing
* [`OOM-935 <https://jira.onap.org/browse/OOM-935>`_] - sdc-cassandra pod fails to delete using helm delete - forced kubectl delete
* [`OOM-936 <https://jira.onap.org/browse/OOM-936>`_] - Readiness-check prob version is inconsistent across components
* [`OOM-937 <https://jira.onap.org/browse/OOM-937>`_] - Portal Cassandra config map points to wrong directory
* [`OOM-938 <https://jira.onap.org/browse/OOM-938>`_] - Can't install aai alone using helm
* [`OOM-945 <https://jira.onap.org/browse/OOM-945>`_] - SDNC some bundles failing to start cleanly
* [`OOM-948 <https://jira.onap.org/browse/OOM-948>`_] - make vfc got an error
* [`OOM-951 <https://jira.onap.org/browse/OOM-951>`_] - Update APPC charts based on on changes for ccsdk and Nitrogen ODL
* [`OOM-953 <https://jira.onap.org/browse/OOM-953>`_] - switch aai haproxy/hbase repo from hub.docker.com to nexus3
* [`OOM-958 <https://jira.onap.org/browse/OOM-958>`_] - SDC-be deployment missing environment parameter
* [`OOM-964 <https://jira.onap.org/browse/OOM-964>`_] - SDC Healthcheck failure on sdc-be and sdc-kb containers down
* [`OOM-968 <https://jira.onap.org/browse/OOM-968>`_] - warning on default deployment values.yaml
* [`OOM-969 <https://jira.onap.org/browse/OOM-969>`_] - oomk8s images have no Dockerfile's
* [`OOM-971 <https://jira.onap.org/browse/OOM-971>`_] - Common service name template should allow for chart name override
* [`OOM-974 <https://jira.onap.org/browse/OOM-974>`_] - Cassandra bootstrap is done incorrectly
* [`OOM-977 <https://jira.onap.org/browse/OOM-977>`_] - The esr-gui annotations should include a "path" param when register to MSB
* [`OOM-985 <https://jira.onap.org/browse/OOM-985>`_] - DMAAP Redis fails to start
* [`OOM-986 <https://jira.onap.org/browse/OOM-986>`_] - SDC BE and FE logs are missing
* [`OOM-989 <https://jira.onap.org/browse/OOM-989>`_] - Sync ete-k8.sh and ete.sh for new log file numbering
* [`OOM-990 <https://jira.onap.org/browse/OOM-990>`_] - AUTO.json in SDC has unreachable addresses
* [`OOM-993 <https://jira.onap.org/browse/OOM-993>`_] - AAI model-loader.properties not in sync with project file
* [`OOM-994 <https://jira.onap.org/browse/OOM-994>`_] - DCAE cloudify controller docker image 1.1.0 N/A - use 1.2.0/1.3.0
* [`OOM-1003 <https://jira.onap.org/browse/OOM-1003>`_] - dcae-cloudify-manager chart references obsolete image version
* [`OOM-1004 <https://jira.onap.org/browse/OOM-1004>`_] - aai-resources constantly fails due to cassandra hostname
* [`OOM-1005 <https://jira.onap.org/browse/OOM-1005>`_] - AAI Widgets not loading due to duplicate volumes
* [`OOM-1007 <https://jira.onap.org/browse/OOM-1007>`_] - Update dcae robot health check config
* [`OOM-1008 <https://jira.onap.org/browse/OOM-1008>`_] - Set default consul server replica count to 1
* [`OOM-1010 <https://jira.onap.org/browse/OOM-1010>`_] - Fix broken property names in DCAE input files
* [`OOM-1011 <https://jira.onap.org/browse/OOM-1011>`_] - Policy config correction after Service Name changes because of OOM-906
* [`OOM-1013 <https://jira.onap.org/browse/OOM-1013>`_] - Update DCAE container versions
* [`OOM-1014 <https://jira.onap.org/browse/OOM-1014>`_] - Portal login not working due to inconsistent zookeeper naming
* [`OOM-1015 <https://jira.onap.org/browse/OOM-1015>`_] - Champ fails to start
* [`OOM-1016 <https://jira.onap.org/browse/OOM-1016>`_] - DOC-OPS Review: Helm install command is wrong on oom_user_guide - missing namespace
* [`OOM-1017 <https://jira.onap.org/browse/OOM-1017>`_] - DOC-OPS review: Docker/Kubernetes versions wrong for master in oom_cloud_setup_guide
* [`OOM-1018 <https://jira.onap.org/browse/OOM-1018>`_] - DOC-OPS review: global repo override does not match git in oom quick start guide
* [`OOM-1019 <https://jira.onap.org/browse/OOM-1019>`_] - DOC-OPS review: Add Ubuntu 16.04 reference to oom_user_guide to avoid 14/16 confusion
* [`OOM-1021 <https://jira.onap.org/browse/OOM-1021>`_] - Update APPC resources for Nitrogen ODL
* [`OOM-1022 <https://jira.onap.org/browse/OOM-1022>`_] - Fix SDC startup dependencies
* [`OOM-1023 <https://jira.onap.org/browse/OOM-1023>`_] - "spring.datasource.cldsdb.url" in clamp has wrong clampdb name
* [`OOM-1024 <https://jira.onap.org/browse/OOM-1024>`_] - Cassandra data not persisted
* [`OOM-1033 <https://jira.onap.org/browse/OOM-1033>`_] - helm error during deployment 20180501:1900 - all builds under 2.7.2
* [`OOM-1034 <https://jira.onap.org/browse/OOM-1034>`_] - VID Ports incorrect in deployment.yaml
* [`OOM-1037 <https://jira.onap.org/browse/OOM-1037>`_] - Enable CLI health check
* [`OOM-1039 <https://jira.onap.org/browse/OOM-1039>`_] - Service distribution to SO fails
* [`OOM-1041 <https://jira.onap.org/browse/OOM-1041>`_] - aai-service was renamed, but old references remain
* [`OOM-1042 <https://jira.onap.org/browse/OOM-1042>`_] - portalapps service was renamed, but old references remain
* [`OOM-1045 <https://jira.onap.org/browse/OOM-1045>`_] - top level values.yaml missing entry for dmaap chart
* [`OOM-1049 <https://jira.onap.org/browse/OOM-1049>`_] - SDNC_UEB_LISTENER db
* [`OOM-1050 <https://jira.onap.org/browse/OOM-1050>`_] - Impossible to deploy consul using cache docker registry
* [`OOM-1051 <https://jira.onap.org/browse/OOM-1051>`_] - Fix aaf deployment
* [`OOM-1052 <https://jira.onap.org/browse/OOM-1052>`_] - SO cloud config file points to Rackspace cloud
* [`OOM-1054 <https://jira.onap.org/browse/OOM-1054>`_] - Portal LoadBalancer Ingress IP is on the wrong network
* [`OOM-1060 <https://jira.onap.org/browse/OOM-1060>`_] - Incorrect MR Kafka references prevent aai champ from starting
* [`OOM-1061 <https://jira.onap.org/browse/OOM-1061>`_] - ConfigMap size limit exceeded
* [`OOM-1064 <https://jira.onap.org/browse/OOM-1064>`_] - Improve docker registry secret management
* [`OOM-1066 <https://jira.onap.org/browse/OOM-1066>`_] - Updating TOSCA blueprint to sync up with helm configuration changes (add dmaap and oof/delete message-router)
* [`OOM-1068 <https://jira.onap.org/browse/OOM-1068>`_] - Update SO with new AAI cert
* [`OOM-1076 <https://jira.onap.org/browse/OOM-1076>`_] - some charts still using readiness check image from amsterdam 1.x
* [`OOM-1077 <https://jira.onap.org/browse/OOM-1077>`_] - AAI resources and traversal deployment failure on non-rancher envs
* [`OOM-1079 <https://jira.onap.org/browse/OOM-1079>`_] - Robot charts do not allow over ride of pub_key, dcae_collector_ip and dcae_collector_port
* [`OOM-1081 <https://jira.onap.org/browse/OOM-1081>`_] - Remove component 'mock' from TOSCA deployment
* [`OOM-1082 <https://jira.onap.org/browse/OOM-1082>`_] - Wrong pv location of dcae postgres
* [`OOM-1085 <https://jira.onap.org/browse/OOM-1085>`_] - appc hostname is incorrect in url
* [`OOM-1086 <https://jira.onap.org/browse/OOM-1086>`_] - clamp deployment changes /dockerdata-nfs/ReleaseName dir permissions
* [`OOM-1088 <https://jira.onap.org/browse/OOM-1088>`_] - APPC returns error for vCPE restart message from Policy
* [`OOM-1089 <https://jira.onap.org/browse/OOM-1089>`_] - DCAE pods are not getting purged
* [`OOM-1093 <https://jira.onap.org/browse/OOM-1093>`_] - Line wrapping issue in redis-cluster-config.sh script
* [`OOM-1094 <https://jira.onap.org/browse/OOM-1094>`_] - Fix postgres startup
* [`OOM-1095 <https://jira.onap.org/browse/OOM-1095>`_] - common makefile builds out of order
* [`OOM-1096 <https://jira.onap.org/browse/OOM-1096>`_] - node port conflict SDNC (Geo enabled) & other charts
* [`OOM-1097 <https://jira.onap.org/browse/OOM-1097>`_] - Nbi needs dep-nbi - crash on make all
* [`OOM-1099 <https://jira.onap.org/browse/OOM-1099>`_] - Add External Interface NBI project into OOM TOSCA
* [`OOM-1102 <https://jira.onap.org/browse/OOM-1102>`_] - Incorrect AAI services
* [`OOM-1103 <https://jira.onap.org/browse/OOM-1103>`_] - Cannot disable NBI
* [`OOM-1104 <https://jira.onap.org/browse/OOM-1104>`_] - Policy DROOLS configuration across container restarts
* [`OOM-1110 <https://jira.onap.org/browse/OOM-1110>`_] - Clamp issue when connecting Policy
* [`OOM-1111 <https://jira.onap.org/browse/OOM-1111>`_] - Please revert to using VNFSDK Postgres container
* [`OOM-1114 <https://jira.onap.org/browse/OOM-1114>`_] - APPC is broken in latest helm chart
* [`OOM-1115 <https://jira.onap.org/browse/OOM-1115>`_] - SDNC DGBuilder cant operate on DGs in database - need NodePort
* [`OOM-1116 <https://jira.onap.org/browse/OOM-1116>`_] - Correct values needed by NBI chart
* [`OOM-1124 <https://jira.onap.org/browse/OOM-1124>`_] - Update OOM APPC chart to enhance AAF support
* [`OOM-1126 <https://jira.onap.org/browse/OOM-1126>`_] - Incorrect Port mapping between CDT Application and APPC main application
* [`OOM-1127 <https://jira.onap.org/browse/OOM-1127>`_] - SO fails healthcheck
* [`OOM-1128 <https://jira.onap.org/browse/OOM-1128>`_] - AAF CS fails to start in OpenLab

Sub-task
********

* [`OOM-304 <https://jira.onap.org/browse/OOM-304>`_] - Service endpoint annotation for Data Router
* [`OOM-306 <https://jira.onap.org/browse/OOM-306>`_] - Handle mariadb secrets
* [`OOM-510 <https://jira.onap.org/browse/OOM-510>`_] - Increase vm.max_map_count to 262144 when running Rancher 1.6.11+ via helm 2.6+ - for elasticsearch log mem failure
* [`OOM-512 <https://jira.onap.org/browse/OOM-512>`_] - Push the reviewed and merged ReadMe content to RTD
* [`OOM-641 <https://jira.onap.org/browse/OOM-641>`_] - Segregating of configuration for SDNC-UEB component
* [`OOM-655 <https://jira.onap.org/browse/OOM-655>`_] - Create alternate prepull script which provides more user feedback and logging
* [`OOM-753 <https://jira.onap.org/browse/OOM-753>`_] - Create Helm Sub-Chart for SO's embedded mariadb
* [`OOM-754 <https://jira.onap.org/browse/OOM-754>`_] - Create Helm Chart for SO
* [`OOM-774 <https://jira.onap.org/browse/OOM-774>`_] - Create Helm Sub-Chart for APPC's embedded mySQL database
* [`OOM-775 <https://jira.onap.org/browse/OOM-775>`_] - Create Helm Chart for APPC
* [`OOM-778 <https://jira.onap.org/browse/OOM-778>`_] - Replace NFS Provisioner with configurable PV storage solution
* [`OOM-825 <https://jira.onap.org/browse/OOM-825>`_] - Apache 2 License updation for All sqls and .js file
* [`OOM-849 <https://jira.onap.org/browse/OOM-849>`_] - Policy Nexus component needs persistent volume for /sonatype-work
* [`OOM-991 <https://jira.onap.org/browse/OOM-991>`_] - Adjust SDC-BE init job timing from 10 to 30s to avoid restarts on single node systems
* [`OOM-1036 <https://jira.onap.org/browse/OOM-1036>`_] - update helm from 2.7.2 to 2.8.2 wiki/rtd
* [`OOM-1063 <https://jira.onap.org/browse/OOM-1063>`_] - Document Portal LoadBalancer Ingress IP Settings

**Security Notes**

OOM code has been formally scanned during build time using NexusIQ and no
Critical vulnerability was found.

Quick Links:
  - `OOM project page <https://wiki.onap.org/display/DW/ONAP+Operations+Manager+Project>`_

  - `Passing Badge information for OOM <https://bestpractices.coreinfrastructure.org/en/projects/1631>`_



End of Release Notes
